Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 029C21A285;
	Wed,  8 Apr 2026 18:42:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1775673772; cv=none; b=KxfaJAvvRCqa9Luk8nUG5hCrVVAS3klJp0C5Fo+e4fwdYr0Ff6F8/3gHGbUqwDwi+zb35mOcwaSHbdyCveGGqRrk+LntE31kyX0rxyTXz9/GzvapYPlLytQgO9rd89kchHrcNdrlFomJC+di1EBdnEOu9HSGGruxrWWNZbm3RJY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1775673772; c=relaxed/simple;
	bh=dPS7+NNo3bKGkJEG1xeg0J44yxAlrucjh4tGIKGsOWs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=IxvWGUnKXxGNOfsVXVCBhwchlyT/zBRtpsOJ7g0/rjoAz0cVwQruWDA1VLphYkg1fPJMjqY33f14dKZsfiQ7y+xXW4BtUjPPSM4JlMhXmgfAnbhxyjU9XAkMi6hqo0/WtEoe5FAFgt8xBhxNEBi5WbhqH0y854A7ezfG6X8x8yo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ToxX/nBd; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ToxX/nBd"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8CAB0C19421;
	Wed,  8 Apr 2026 18:42:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1775673771;
	bh=dPS7+NNo3bKGkJEG1xeg0J44yxAlrucjh4tGIKGsOWs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ToxX/nBd4Wugve19uYR9gSRSj5efHqcbInDsVhGv+QIcrJ6ynQ6DM/wN+xQntPqhi
	 3DnHjvU+geffsn37YpYD9LUEX3d6MldYkVxCnG/nCkPirURfiu+BWq/xWUUQA+8neX
	 EapOUR75FBy26dlwKmhGNcqfIf936mugIoZtAXHw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Pauli Virtanen <pav@iki.fi>,
	Luiz Augusto von Dentz <luiz.von.dentz@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 084/242] Bluetooth: hci_event: fix potential UAF in hci_le_remote_conn_param_req_evt
Date: Wed,  8 Apr 2026 20:02:04 +0200
Message-ID: <20260408175930.225701897@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260408175927.064985309@linuxfoundation.org>
References: <20260408175927.064985309@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Pauli Virtanen <pav@iki.fi>

[ Upstream commit b255531b27da336571411248c2a72a350662bd09 ]

hci_conn lookup and field access must be covered by hdev lock in
hci_le_remote_conn_param_req_evt, otherwise it's possible it is freed
concurrently.

Extend the hci_dev_lock critical section to cover all conn usage.

Fixes: 95118dd4edfec ("Bluetooth: hci_event: Use of a function table to handle LE subevents")
Signed-off-by: Pauli Virtanen <pav@iki.fi>
Signed-off-by: Luiz Augusto von Dentz <luiz.von.dentz@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/bluetooth/hci_event.c | 33 ++++++++++++++++++++-------------
 1 file changed, 20 insertions(+), 13 deletions(-)

diff --git a/net/bluetooth/hci_event.c b/net/bluetooth/hci_event.c
index 498b7e4c76d59..0dd021c881cc4 100644
--- a/net/bluetooth/hci_event.c
+++ b/net/bluetooth/hci_event.c
@@ -6616,25 +6616,31 @@ static void hci_le_remote_conn_param_req_evt(struct hci_dev *hdev, void *data,
 	latency = le16_to_cpu(ev->latency);
 	timeout = le16_to_cpu(ev->timeout);
 
+	hci_dev_lock(hdev);
+
 	hcon = hci_conn_hash_lookup_handle(hdev, handle);
-	if (!hcon || hcon->state != BT_CONNECTED)
-		return send_conn_param_neg_reply(hdev, handle,
-						 HCI_ERROR_UNKNOWN_CONN_ID);
+	if (!hcon || hcon->state != BT_CONNECTED) {
+		send_conn_param_neg_reply(hdev, handle,
+					  HCI_ERROR_UNKNOWN_CONN_ID);
+		goto unlock;
+	}
 
-	if (max > hcon->le_conn_max_interval)
-		return send_conn_param_neg_reply(hdev, handle,
-						 HCI_ERROR_INVALID_LL_PARAMS);
+	if (max > hcon->le_conn_max_interval) {
+		send_conn_param_neg_reply(hdev, handle,
+					  HCI_ERROR_INVALID_LL_PARAMS);
+		goto unlock;
+	}
 
-	if (hci_check_conn_params(min, max, latency, timeout))
-		return send_conn_param_neg_reply(hdev, handle,
-						 HCI_ERROR_INVALID_LL_PARAMS);
+	if (hci_check_conn_params(min, max, latency, timeout)) {
+		send_conn_param_neg_reply(hdev, handle,
+					  HCI_ERROR_INVALID_LL_PARAMS);
+		goto unlock;
+	}
 
 	if (hcon->role == HCI_ROLE_MASTER) {
 		struct hci_conn_params *params;
 		u8 store_hint;
 
-		hci_dev_lock(hdev);
-
 		params = hci_conn_params_lookup(hdev, &hcon->dst,
 						hcon->dst_type);
 		if (params) {
@@ -6647,8 +6653,6 @@ static void hci_le_remote_conn_param_req_evt(struct hci_dev *hdev, void *data,
 			store_hint = 0x00;
 		}
 
-		hci_dev_unlock(hdev);
-
 		mgmt_new_conn_param(hdev, &hcon->dst, hcon->dst_type,
 				    store_hint, min, max, latency, timeout);
 	}
@@ -6662,6 +6666,9 @@ static void hci_le_remote_conn_param_req_evt(struct hci_dev *hdev, void *data,
 	cp.max_ce_len = 0;
 
 	hci_send_cmd(hdev, HCI_OP_LE_CONN_PARAM_REQ_REPLY, sizeof(cp), &cp);
+
+unlock:
+	hci_dev_unlock(hdev);
 }
 
 static void hci_le_direct_adv_report_evt(struct hci_dev *hdev, void *data,
-- 
2.53.0



