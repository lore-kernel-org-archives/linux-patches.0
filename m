Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AB4E58F5B;
	Tue,  8 Jul 2025 16:48:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751993281; cv=none; b=Bklh5zSrQPBWKC32h18CR2k1A+f1T2e86YdVdwdoGx69WK/a8iO4bSOg8kmpx34v06Y0vy8k5pJCvNq3AXCNYOayvUaJJvCWcFi39Itj0GLRS9OmOJdYTsSh4/MYP3s6T4tXK8KABKdSMBJO7Sc06x0BuX5VPKTjlqIopNfzM7M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751993281; c=relaxed/simple;
	bh=yErvVbc8WJ+sHVmkX12+KwtEjm3fPnWEeQm93X1p1Fk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=cQLb55mRugpf+GS41qaHNBEcgh0vvuVE4irX/JOIL5yolsXnVUtvEyoZrtQpJzJk8xUFTpzJVzfo2jC65i0iw84dTcqrOzWw47g8BB8bVZMtS88TnuwpsbBXQ1Qng5TPwFeheaHHgWXNSZKxNxrv9LzD7DIzQdcQEiOcdOJltS8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=mDDZqUOn; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="mDDZqUOn"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 34003C4CEED;
	Tue,  8 Jul 2025 16:48:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1751993281;
	bh=yErvVbc8WJ+sHVmkX12+KwtEjm3fPnWEeQm93X1p1Fk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=mDDZqUOn4wT8rtbsdOxDNi//uST8VKdSCu0ALSHUaT7mFzlqDv1HB9FPqMXF5gfgS
	 XH1yBiuspDvvgn5HVGijfbAtGwSz2Dvffnykc8DTlJxjYu8MgN4pIhwUVEI/ovw9Hq
	 CVezM2EbfjA5HsIjcFghfasWjzsVzPBhQB/q8lyI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Christian Eggers <ceggers@arri.de>,
	Luiz Augusto von Dentz <luiz.von.dentz@intel.com>
Subject: [PATCH 6.15 021/178] Bluetooth: hci_sync: revert some mesh modifications
Date: Tue,  8 Jul 2025 18:20:58 +0200
Message-ID: <20250708162237.103485542@linuxfoundation.org>
X-Mailer: git-send-email 2.50.0
In-Reply-To: <20250708162236.549307806@linuxfoundation.org>
References: <20250708162236.549307806@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Christian Eggers <ceggers@arri.de>

commit 46c0d947b64ac8efcf89dd754213dab5d1bd00aa upstream.

This reverts minor parts of the changes made in commit b338d91703fa
("Bluetooth: Implement support for Mesh"). It looks like these changes
were only made for development purposes but shouldn't have been part of
the commit.

Fixes: b338d91703fa ("Bluetooth: Implement support for Mesh")
Cc: stable@vger.kernel.org
Signed-off-by: Christian Eggers <ceggers@arri.de>
Signed-off-by: Luiz Augusto von Dentz <luiz.von.dentz@intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/bluetooth/hci_sync.c |   16 ++++------------
 1 file changed, 4 insertions(+), 12 deletions(-)

--- a/net/bluetooth/hci_sync.c
+++ b/net/bluetooth/hci_sync.c
@@ -2004,13 +2004,10 @@ static int hci_clear_adv_sets_sync(struc
 static int hci_clear_adv_sync(struct hci_dev *hdev, struct sock *sk, bool force)
 {
 	struct adv_info *adv, *n;
-	int err = 0;
 
 	if (ext_adv_capable(hdev))
 		/* Remove all existing sets */
-		err = hci_clear_adv_sets_sync(hdev, sk);
-	if (ext_adv_capable(hdev))
-		return err;
+		return hci_clear_adv_sets_sync(hdev, sk);
 
 	/* This is safe as long as there is no command send while the lock is
 	 * held.
@@ -2038,13 +2035,11 @@ static int hci_clear_adv_sync(struct hci
 static int hci_remove_adv_sync(struct hci_dev *hdev, u8 instance,
 			       struct sock *sk)
 {
-	int err = 0;
+	int err;
 
 	/* If we use extended advertising, instance has to be removed first. */
 	if (ext_adv_capable(hdev))
-		err = hci_remove_ext_adv_instance_sync(hdev, instance, sk);
-	if (ext_adv_capable(hdev))
-		return err;
+		return hci_remove_ext_adv_instance_sync(hdev, instance, sk);
 
 	/* This is safe as long as there is no command send while the lock is
 	 * held.
@@ -2143,16 +2138,13 @@ int hci_read_tx_power_sync(struct hci_de
 int hci_disable_advertising_sync(struct hci_dev *hdev)
 {
 	u8 enable = 0x00;
-	int err = 0;
 
 	/* If controller is not advertising we are done. */
 	if (!hci_dev_test_flag(hdev, HCI_LE_ADV))
 		return 0;
 
 	if (ext_adv_capable(hdev))
-		err = hci_disable_ext_adv_instance_sync(hdev, 0x00);
-	if (ext_adv_capable(hdev))
-		return err;
+		return hci_disable_ext_adv_instance_sync(hdev, 0x00);
 
 	return __hci_cmd_sync_status(hdev, HCI_OP_LE_SET_ADV_ENABLE,
 				     sizeof(enable), &enable, HCI_CMD_TIMEOUT);


