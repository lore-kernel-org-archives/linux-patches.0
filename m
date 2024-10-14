Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DCBF5156256;
	Mon, 14 Oct 2024 15:28:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728919689; cv=none; b=md/X3sTcs5cVnxj3wY3+c2YmXHd9n+xgWgAiD3qzollEdajDUX7Oxw7ZWpWtTdTZGUHoRE+EfH4ORgSmh0O1BdzKdhvzsO5DvM5OzTVRU0ixr+8VgsZkFUQrjYfyDvlufZIWX5ACuTptvjJRBD/UruRzhieDcFLV9rEPdT5Vgtw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728919689; c=relaxed/simple;
	bh=MRAgylme8droz3dOhoWl1pJq6qvRoKI9gQtRPRDexAY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=XDbB/JEY9KAGJBK2mZY8sy3sAmE9W2z4qDiBRfvizunjKpUSJQPeS73IhF+lRujTEAvN8DXAVkYMIqkZzZggxC/sdoWD8zJNjTjrECvKFUkE0dzgWCMK9nR3drS+HfnoGPyGy/I8lZB1M4U1sivmokFB0QCAEsSsxsK8KKSFtuY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=sVv6CLcf; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="sVv6CLcf"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2E68BC4CECF;
	Mon, 14 Oct 2024 15:28:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1728919688;
	bh=MRAgylme8droz3dOhoWl1pJq6qvRoKI9gQtRPRDexAY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=sVv6CLcfn3ZMG+9+PdBWpNELr13/6TPsEUQH1M95Z2PZbdENwIndo7irpds2A01nH
	 upgcQlaaAn3QaIgmK2KvRYih44YSVP03sixl0oa3FwzlOle8IoBw+zaPbMEBBuasby
	 SI6WPZ3feRumxDMA9G0RP9UfTmiOXoU5QHuwQUks=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Pauli Virtanen <pav@iki.fi>,
	Luiz Augusto von Dentz <luiz.von.dentz@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 680/798] Bluetooth: Fix usage of __hci_cmd_sync_status
Date: Mon, 14 Oct 2024 16:20:34 +0200
Message-ID: <20241014141244.786133290@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241014141217.941104064@linuxfoundation.org>
References: <20241014141217.941104064@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
index dc19a0b1a2f6d..993b98257bc28 100644
--- a/net/bluetooth/hci_core.c
+++ b/net/bluetooth/hci_core.c
@@ -721,8 +721,8 @@ int hci_dev_cmd(unsigned int cmd, void __user *arg)
 
 	switch (cmd) {
 	case HCISETAUTH:
-		err = __hci_cmd_sync_status(hdev, HCI_OP_WRITE_AUTH_ENABLE,
-					    1, &dr.dev_opt, HCI_CMD_TIMEOUT);
+		err = hci_cmd_sync_status(hdev, HCI_OP_WRITE_AUTH_ENABLE,
+					  1, &dr.dev_opt, HCI_CMD_TIMEOUT);
 		break;
 
 	case HCISETENCRYPT:
@@ -733,23 +733,21 @@ int hci_dev_cmd(unsigned int cmd, void __user *arg)
 
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
@@ -761,9 +759,8 @@ int hci_dev_cmd(unsigned int cmd, void __user *arg)
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



