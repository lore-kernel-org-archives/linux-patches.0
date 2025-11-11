Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A66564C97;
	Tue, 11 Nov 2025 00:53:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762822423; cv=none; b=tyPYiC69jBfhj9kT5PAPCb7pAgV4V/HugPeDr0ZznRA0c7yVrWOHmWIdFqc3St6HXq5ok2wNbx5sm0QO6YrDL829qc/kNi+BUqfakr9k80hz/iBP2Vy8VXUwfRBYSHE9FKWw5dBaR1VmOkSKucPQK0SKV9DWy59eomgle/Ks0X0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762822423; c=relaxed/simple;
	bh=xw3gy5sa+WsY81Hp7Sgo9JXKpJ/rxLzUNKHBlk7Nr3o=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Tj9ciZKpi+F+e+v1dVGTLyENh7tzblz9zNiH5Bhkox7Mh7Ww8xh+nuiCrLVPLU4i0dAIuKQp9hVnyxW8G8K8EhlChmCwYo7P/nwRUCQ1eT9lRIF2l+CEMrMQEuBmGeltW0DHt4mWTADo8MNgcuQVM4M4MB4XK7jH47ipevXOouQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=k4ZhDUZv; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="k4ZhDUZv"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4308BC16AAE;
	Tue, 11 Nov 2025 00:53:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1762822423;
	bh=xw3gy5sa+WsY81Hp7Sgo9JXKpJ/rxLzUNKHBlk7Nr3o=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=k4ZhDUZvAtxwU1hQpCB6N9U4OXrNj31fS4ro4MSs6f/K/RNMdd2/dqBqyx1WV02l1
	 ybfuEoXI/aAHasVD0sGu+oXwRQSDbHG+xW/Nx5Y7viCyXiybD8RaAOTB+poa2Xf+Yb
	 NqxCOCsTtOcQzQzshqZmV/nH6g2MOJ+NcyYfgnJY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Luiz Augusto von Dentz <luiz.von.dentz@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 047/565] Bluetooth: hci_core: Fix tracking of periodic advertisement
Date: Tue, 11 Nov 2025 09:38:23 +0900
Message-ID: <20251111004527.964473033@linuxfoundation.org>
X-Mailer: git-send-email 2.51.2
In-Reply-To: <20251111004526.816196597@linuxfoundation.org>
References: <20251111004526.816196597@linuxfoundation.org>
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

From: Luiz Augusto von Dentz <luiz.von.dentz@intel.com>

[ Upstream commit 751463ceefc3397566d03c8b64ef4a77f5fd88ac ]

Periodic advertising enabled flag cannot be tracked by the enabled
flag since advertising and periodic advertising each can be
enabled/disabled separately from one another causing the states to be
inconsistent when for example an advertising set is disabled its
enabled flag is set to false which is then used for periodic which has
not being disabled.

Fixes: eca0ae4aea66 ("Bluetooth: Add initial implementation of BIS connections")
Signed-off-by: Luiz Augusto von Dentz <luiz.von.dentz@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/net/bluetooth/hci_core.h | 1 +
 net/bluetooth/hci_event.c        | 7 +++++--
 net/bluetooth/hci_sync.c         | 4 ++--
 3 files changed, 8 insertions(+), 4 deletions(-)

diff --git a/include/net/bluetooth/hci_core.h b/include/net/bluetooth/hci_core.h
index ca75c71b58588..35b5f58b562cb 100644
--- a/include/net/bluetooth/hci_core.h
+++ b/include/net/bluetooth/hci_core.h
@@ -240,6 +240,7 @@ struct adv_info {
 	bool	enabled;
 	bool	pending;
 	bool	periodic;
+	bool	periodic_enabled;
 	__u8	mesh;
 	__u8	instance;
 	__u8	handle;
diff --git a/net/bluetooth/hci_event.c b/net/bluetooth/hci_event.c
index 176565ef47c63..ccc73742de356 100644
--- a/net/bluetooth/hci_event.c
+++ b/net/bluetooth/hci_event.c
@@ -1598,7 +1598,7 @@ static u8 hci_cc_le_set_ext_adv_enable(struct hci_dev *hdev, void *data,
 
 		hci_dev_set_flag(hdev, HCI_LE_ADV);
 
-		if (adv && !adv->periodic)
+		if (adv)
 			adv->enabled = true;
 		else if (!set->handle)
 			hci_dev_set_flag(hdev, HCI_LE_ADV_0);
@@ -3955,8 +3955,11 @@ static u8 hci_cc_le_set_per_adv_enable(struct hci_dev *hdev, void *data,
 		hci_dev_set_flag(hdev, HCI_LE_PER_ADV);
 
 		if (adv)
-			adv->enabled = true;
+			adv->periodic_enabled = true;
 	} else {
+		if (adv)
+			adv->periodic_enabled = false;
+
 		/* If just one instance was disabled check if there are
 		 * any other instance enabled before clearing HCI_LE_PER_ADV.
 		 * The current periodic adv instance will be marked as
diff --git a/net/bluetooth/hci_sync.c b/net/bluetooth/hci_sync.c
index 06d8ab997bd85..f79b38603205c 100644
--- a/net/bluetooth/hci_sync.c
+++ b/net/bluetooth/hci_sync.c
@@ -1605,7 +1605,7 @@ int hci_disable_per_advertising_sync(struct hci_dev *hdev, u8 instance)
 
 	/* If periodic advertising already disabled there is nothing to do. */
 	adv = hci_find_adv_instance(hdev, instance);
-	if (!adv || !adv->periodic || !adv->enabled)
+	if (!adv || !adv->periodic_enabled)
 		return 0;
 
 	memset(&cp, 0, sizeof(cp));
@@ -1670,7 +1670,7 @@ static int hci_enable_per_advertising_sync(struct hci_dev *hdev, u8 instance)
 
 	/* If periodic advertising already enabled there is nothing to do. */
 	adv = hci_find_adv_instance(hdev, instance);
-	if (adv && adv->periodic && adv->enabled)
+	if (adv && adv->periodic_enabled)
 		return 0;
 
 	memset(&cp, 0, sizeof(cp));
-- 
2.51.0



