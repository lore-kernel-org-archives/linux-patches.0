Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B019D1A6192;
	Tue, 30 Jul 2024 16:40:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722357646; cv=none; b=Zn2sCCFJzemovyhkHE3M1boE1UiqK38nVHSXPucTdIrBLwkytlQ0Lg5n057DbLh0P9WMlR2qVQhajrW6DMvdv4mV+ICbqxgaPbaWPRa7mkCkqGM6f8dzntPo81jdpFvOeSGXcaZyLRc5heyGJ0csu1P2coqyarPfoJIUXBkkwZw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722357646; c=relaxed/simple;
	bh=VljxlKQdyEKvkzSbOn7hCT5RI++9UxE29+KbJRFlNYo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=u6dWB+b8Bqgkr/BhXcuoeA3vjokc2+Grfe8Ku/J0jRn0dGyof7jSKcFtjmsD+12CdcudlY3+WBsDelhTfGEmh+YZ3VEEUO2hwe9madjNA66t/p+rVggytHAZfEr66qB+HTggKCMqqLEntinuj3zzGQxrThEDpiI5K2Kb03nunRg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=cdz2yv0s; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="cdz2yv0s"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B5127C4AF0C;
	Tue, 30 Jul 2024 16:40:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1722357646;
	bh=VljxlKQdyEKvkzSbOn7hCT5RI++9UxE29+KbJRFlNYo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=cdz2yv0s+PhxXpbG6hWyO+IcjmF8Bckm/4Umf+BuXZN5EyJojKnzCDijcGX0nG7QB
	 U9asWKdNgvOwL2WmSG4xamf+JIoWnZMiP0uuMifEc46zRb3nre6bQ6N53B9RiyVauE
	 908Li96jSHrmfczB9Gl7si3pEWWKWeBoui2wc4FM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Pauli Virtanen <pav@iki.fi>,
	Luiz Augusto von Dentz <luiz.von.dentz@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.10 263/809] Bluetooth: Fix usage of __hci_cmd_sync_status
Date: Tue, 30 Jul 2024 17:42:19 +0200
Message-ID: <20240730151734.979429257@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240730151724.637682316@linuxfoundation.org>
References: <20240730151724.637682316@linuxfoundation.org>
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

6.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Luiz Augusto von Dentz <luiz.von.dentz@intel.com>

[ Upstream commit 87be7b189b2c50d4b51512f59e4e97db4eedee8a ]

__hci_cmd_sync_status shall only be used if hci_req_sync_lock is _not_
required which is not the case of hci_dev_cmd so it needs to use
hci_cmd_sync_status which uses hci_req_sync_lock internally.

Fixes: f1a8f402f13f ("Bluetooth: L2CAP: Fix deadlock")
Reported-by: Pauli Virtanen <pav@iki.fi>
Signed-off-by: Luiz Augusto von Dentz <luiz.von.dentz@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/bluetooth/hci_core.c | 27 ++++++++++++---------------
 1 file changed, 12 insertions(+), 15 deletions(-)

diff --git a/net/bluetooth/hci_core.c b/net/bluetooth/hci_core.c
index c644b30977bd8..7ae118a6d947b 100644
--- a/net/bluetooth/hci_core.c
+++ b/net/bluetooth/hci_core.c
@@ -718,8 +718,8 @@ int hci_dev_cmd(unsigned int cmd, void __user *arg)
 
 	switch (cmd) {
 	case HCISETAUTH:
-		err = __hci_cmd_sync_status(hdev, HCI_OP_WRITE_AUTH_ENABLE,
-					    1, &dr.dev_opt, HCI_CMD_TIMEOUT);
+		err = hci_cmd_sync_status(hdev, HCI_OP_WRITE_AUTH_ENABLE,
+					  1, &dr.dev_opt, HCI_CMD_TIMEOUT);
 		break;
 
 	case HCISETENCRYPT:
@@ -730,23 +730,21 @@ int hci_dev_cmd(unsigned int cmd, void __user *arg)
 
 		if (!test_bit(HCI_AUTH, &hdev->flags)) {
 			/* Auth must be enabled first */
-			err = __hci_cmd_sync_status(hdev,
-						    HCI_OP_WRITE_AUTH_ENABLE,
-						    1, &dr.dev_opt,
-						    HCI_CMD_TIMEOUT);
+			err = hci_cmd_sync_status(hdev,
+						  HCI_OP_WRITE_AUTH_ENABLE,
+						  1, &dr.dev_opt,
+						  HCI_CMD_TIMEOUT);
 			if (err)
 				break;
 		}
 
-		err = __hci_cmd_sync_status(hdev, HCI_OP_WRITE_ENCRYPT_MODE,
-					    1, &dr.dev_opt,
-					    HCI_CMD_TIMEOUT);
+		err = hci_cmd_sync_status(hdev, HCI_OP_WRITE_ENCRYPT_MODE,
+					  1, &dr.dev_opt, HCI_CMD_TIMEOUT);
 		break;
 
 	case HCISETSCAN:
-		err = __hci_cmd_sync_status(hdev, HCI_OP_WRITE_SCAN_ENABLE,
-					    1, &dr.dev_opt,
-					    HCI_CMD_TIMEOUT);
+		err = hci_cmd_sync_status(hdev, HCI_OP_WRITE_SCAN_ENABLE,
+					  1, &dr.dev_opt, HCI_CMD_TIMEOUT);
 
 		/* Ensure that the connectable and discoverable states
 		 * get correctly modified as this was a non-mgmt change.
@@ -758,9 +756,8 @@ int hci_dev_cmd(unsigned int cmd, void __user *arg)
 	case HCISETLINKPOL:
 		policy = cpu_to_le16(dr.dev_opt);
 
-		err = __hci_cmd_sync_status(hdev, HCI_OP_WRITE_DEF_LINK_POLICY,
-					    2, &policy,
-					    HCI_CMD_TIMEOUT);
+		err = hci_cmd_sync_status(hdev, HCI_OP_WRITE_DEF_LINK_POLICY,
+					  2, &policy, HCI_CMD_TIMEOUT);
 		break;
 
 	case HCISETLINKMODE:
-- 
2.43.0



