Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4306B154C05;
	Tue, 23 Jan 2024 00:23:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1705969402; cv=none; b=ca7CqUONvyU9TzuU9pkIFGWIpJgvPbSd+dJ5wKibVB7DDAz/0MHtBjFsEadx7KimRg/gBVxWTG56TWCyPloaorUzTU1ePcfUPXA0EFWDgn+HafpGhzxYCf9/DBuNQZCsfGgfoU5AAnGl2/7rG70U/K6Zon+LVtH12kyhwWPdiuQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1705969402; c=relaxed/simple;
	bh=ADI5yBecFqxfYQXriDoIuw/GTxeAORpuVpZhT5V1GJo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=lRH7cFVDfqnofSgGNiyJL4BzE8O6nXHNSDhqdFC0Qgs7VIjuXY1KFNTZyeS7ksqySz9NqFtfpu6fXFtkowc8qAmzzMP1JqwkrQPrSh584gLI5sKg8bXn/cOW8faEA85wpTx8qqERF6knpIkiUPlPmZaojEy95cbPv1+wjRK8s8w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=AzJI8TJ4; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="AzJI8TJ4"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F21E2C433F1;
	Tue, 23 Jan 2024 00:23:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1705969402;
	bh=ADI5yBecFqxfYQXriDoIuw/GTxeAORpuVpZhT5V1GJo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=AzJI8TJ4AHgTWHHHmFk3u7ZdyTuIwro56titfRPsFK8FYMOIRZmhulZJmccCQfHa3
	 VBEtz/IDsx/UFsFzSIrpz7cgJokwmQWCiMKd2WwDYTk89PnFOstl3ktW+1vh0Sbqgi
	 AN9hzm/GgeQ+a+/0TkvB/HhSZ2pmoR+Ea5jboq9o=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Luiz Augusto von Dentz <luiz.von.dentz@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.7 223/641] Bluetooth: Fix bogus check for re-auth no supported with non-ssp
Date: Mon, 22 Jan 2024 15:52:07 -0800
Message-ID: <20240122235824.921620329@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240122235818.091081209@linuxfoundation.org>
References: <20240122235818.091081209@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.7-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Luiz Augusto von Dentz <luiz.von.dentz@intel.com>

[ Upstream commit d03376c185926098cb4d668d6458801eb785c0a5 ]

This reverts 19f8def031bfa50c579149b200bfeeb919727b27
"Bluetooth: Fix auth_complete_evt for legacy units" which seems to be
working around a bug on a broken controller rather then any limitation
imposed by the Bluetooth spec, in fact if there ws not possible to
re-auth the command shall fail not succeed.

Fixes: 19f8def031bf ("Bluetooth: Fix auth_complete_evt for legacy units")
Signed-off-by: Luiz Augusto von Dentz <luiz.von.dentz@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/net/bluetooth/hci_core.h |  1 -
 net/bluetooth/hci_conn.c         |  8 +++-----
 net/bluetooth/hci_event.c        | 11 ++---------
 3 files changed, 5 insertions(+), 15 deletions(-)

diff --git a/include/net/bluetooth/hci_core.h b/include/net/bluetooth/hci_core.h
index a3a1ea2696a8..65dd28669352 100644
--- a/include/net/bluetooth/hci_core.h
+++ b/include/net/bluetooth/hci_core.h
@@ -957,7 +957,6 @@ void hci_inquiry_cache_flush(struct hci_dev *hdev);
 /* ----- HCI Connections ----- */
 enum {
 	HCI_CONN_AUTH_PEND,
-	HCI_CONN_REAUTH_PEND,
 	HCI_CONN_ENCRYPT_PEND,
 	HCI_CONN_RSWITCH_PEND,
 	HCI_CONN_MODE_CHANGE_PEND,
diff --git a/net/bluetooth/hci_conn.c b/net/bluetooth/hci_conn.c
index 2cee330188ce..d01db89fcb46 100644
--- a/net/bluetooth/hci_conn.c
+++ b/net/bluetooth/hci_conn.c
@@ -2421,12 +2421,10 @@ static int hci_conn_auth(struct hci_conn *conn, __u8 sec_level, __u8 auth_type)
 		hci_send_cmd(conn->hdev, HCI_OP_AUTH_REQUESTED,
 			     sizeof(cp), &cp);
 
-		/* If we're already encrypted set the REAUTH_PEND flag,
-		 * otherwise set the ENCRYPT_PEND.
+		/* Set the ENCRYPT_PEND to trigger encryption after
+		 * authentication.
 		 */
-		if (test_bit(HCI_CONN_ENCRYPT, &conn->flags))
-			set_bit(HCI_CONN_REAUTH_PEND, &conn->flags);
-		else
+		if (!test_bit(HCI_CONN_ENCRYPT, &conn->flags))
 			set_bit(HCI_CONN_ENCRYPT_PEND, &conn->flags);
 	}
 
diff --git a/net/bluetooth/hci_event.c b/net/bluetooth/hci_event.c
index ebf17b51072f..ef8c3bed7361 100644
--- a/net/bluetooth/hci_event.c
+++ b/net/bluetooth/hci_event.c
@@ -3500,14 +3500,8 @@ static void hci_auth_complete_evt(struct hci_dev *hdev, void *data,
 
 	if (!ev->status) {
 		clear_bit(HCI_CONN_AUTH_FAILURE, &conn->flags);
-
-		if (!hci_conn_ssp_enabled(conn) &&
-		    test_bit(HCI_CONN_REAUTH_PEND, &conn->flags)) {
-			bt_dev_info(hdev, "re-auth of legacy device is not possible.");
-		} else {
-			set_bit(HCI_CONN_AUTH, &conn->flags);
-			conn->sec_level = conn->pending_sec_level;
-		}
+		set_bit(HCI_CONN_AUTH, &conn->flags);
+		conn->sec_level = conn->pending_sec_level;
 	} else {
 		if (ev->status == HCI_ERROR_PIN_OR_KEY_MISSING)
 			set_bit(HCI_CONN_AUTH_FAILURE, &conn->flags);
@@ -3516,7 +3510,6 @@ static void hci_auth_complete_evt(struct hci_dev *hdev, void *data,
 	}
 
 	clear_bit(HCI_CONN_AUTH_PEND, &conn->flags);
-	clear_bit(HCI_CONN_REAUTH_PEND, &conn->flags);
 
 	if (conn->state == BT_CONFIG) {
 		if (!ev->status && hci_conn_ssp_enabled(conn)) {
-- 
2.43.0



