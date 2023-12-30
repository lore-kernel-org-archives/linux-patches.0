Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3C56E8813;
	Sat, 30 Dec 2023 12:04:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="HGSudJY+"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BADC4C433C7;
	Sat, 30 Dec 2023 12:04:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1703937847;
	bh=vcN/Ser6Ie6Lmx628/gPDqhxM4/RMGcnmvyNy52d5Vk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=HGSudJY+4vtnrOZw31mcti1yNky0IkRBMRsr2GKtI24y2rApi6WHSaD4ZdHcGHHkI
	 FzS++R5FjeElfqlJhxNG+Kp2f/5/iIbCo14GPCkZp4XlzBW3O7K4DDsFNs6OU08Ia+
	 Fr6nkJSd8Bk8jJ8/819k3vs8U5kxTe0BYSIpLj6w=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Luiz Augusto von Dentz <luiz.von.dentz@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 051/156] Bluetooth: Fix not notifying when connection encryption changes
Date: Sat, 30 Dec 2023 11:58:25 +0000
Message-ID: <20231230115814.011019333@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20231230115812.333117904@linuxfoundation.org>
References: <20231230115812.333117904@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Luiz Augusto von Dentz <luiz.von.dentz@intel.com>

[ Upstream commit f67eabffb57d0bee379994a18ec5f462b2cbdf86 ]

Some layers such as SMP depend on getting notified about encryption
changes immediately as they only allow certain PDU to be transmitted
over an encrypted link which may cause SMP implementation to reject
valid PDUs received thus causing pairing to fail when it shouldn't.

Fixes: 7aca0ac4792e ("Bluetooth: Wait for HCI_OP_WRITE_AUTH_PAYLOAD_TO to complete")
Signed-off-by: Luiz Augusto von Dentz <luiz.von.dentz@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/bluetooth/hci_event.c | 8 +-------
 1 file changed, 1 insertion(+), 7 deletions(-)

diff --git a/net/bluetooth/hci_event.c b/net/bluetooth/hci_event.c
index f6d3150bcbb03..da756cbf62206 100644
--- a/net/bluetooth/hci_event.c
+++ b/net/bluetooth/hci_event.c
@@ -820,8 +820,6 @@ static u8 hci_cc_write_auth_payload_timeout(struct hci_dev *hdev, void *data,
 	if (!rp->status)
 		conn->auth_payload_timeout = get_unaligned_le16(sent + 2);
 
-	hci_encrypt_cfm(conn, 0);
-
 unlock:
 	hci_dev_unlock(hdev);
 
@@ -3683,12 +3681,8 @@ static void hci_encrypt_change_evt(struct hci_dev *hdev, void *data,
 		cp.handle = cpu_to_le16(conn->handle);
 		cp.timeout = cpu_to_le16(hdev->auth_payload_timeout);
 		if (hci_send_cmd(conn->hdev, HCI_OP_WRITE_AUTH_PAYLOAD_TO,
-				 sizeof(cp), &cp)) {
+				 sizeof(cp), &cp))
 			bt_dev_err(hdev, "write auth payload timeout failed");
-			goto notify;
-		}
-
-		goto unlock;
 	}
 
 notify:
-- 
2.43.0



