Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 57B6813FD94;
	Thu, 11 Apr 2024 10:26:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712831211; cv=none; b=JRfPI1mY0wLXu9C1R9XVtOB/zFLGjqvv+ExS0wGbzX/Gm2kj/dnNMsa5x+yaWzKuPt+nnRQ+6dhmG2NHRNd9UQ6C1GknTgV55ErHykm0RAhFalvNLkZrELGjep0Ym3VfB0g616WuKH581EsoorSfGQvuPktQth/6qTwfFBz3Qf4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712831211; c=relaxed/simple;
	bh=yVSzrilAZd0l8tZLcvDqEH70Fs5cZ78KSfEHVORbalU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Rk5iHp1ByAPxBPkW+1EFZrcNProF3bkyBqk1n9oMBuOnRSOHb8WHUGmzVS3HvkwstQNDp7Ko8+1mnK7lw9axty+PQvRBDuQeD/74rjDGYfmpkETBMa1Bgq6+upqAwNxtSzgEL/yluCFPyUVamlBradMNqsfQlItH7Tp6pkMahiM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=y6rEYy4c; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="y6rEYy4c"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8C055C433C7;
	Thu, 11 Apr 2024 10:26:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1712831210;
	bh=yVSzrilAZd0l8tZLcvDqEH70Fs5cZ78KSfEHVORbalU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=y6rEYy4cGaKqdLlhgNcvVnV3kJsq7+goup+zMS7ij/7yRUmTfJrSIJDJJn15Zr2fc
	 D2cs8UhbhessVWeh6NIu4V3c6sZPaY1pxuCZrHIrqyFupaLkoW5qG9pZnVJzCw3/My
	 uEtfjtuv45lwG/d93NYLpKYNS+SDqHcbWsnrye7k=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Vinicius Peixoto <nukelet64@gmail.com>,
	Luiz Augusto von Dentz <luiz.von.dentz@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 045/114] Bluetooth: Add new quirk for broken read key length on ATS2851
Date: Thu, 11 Apr 2024 11:56:12 +0200
Message-ID: <20240411095418.242150039@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240411095416.853744210@linuxfoundation.org>
References: <20240411095416.853744210@linuxfoundation.org>
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

From: Vinicius Peixoto <nukelet64@gmail.com>

[ Upstream commit 48201a3b3f398be6a01f78a14b18bd5d31c47458 ]

The ATS2851 controller erroneously reports support for the "Read
Encryption Key Length" HCI command. This makes it unable to connect
to any devices, since this command is issued by the kernel during the
connection process in response to an "Encryption Change" HCI event.

Add a new quirk (HCI_QUIRK_BROKEN_ENC_KEY_SIZE) to hint that the command
is unsupported, preventing it from interrupting the connection process.

This is the error log from btmon before this patch:

> HCI Event: Encryption Change (0x08) plen 4
        Status: Success (0x00)
        Handle: 2048 Address: ...
        Encryption: Enabled with E0 (0x01)
< HCI Command: Read Encryption Key Size (0x05|0x0008) plen 2
        Handle: 2048 Address: ...
> HCI Event: Command Status (0x0f) plen 4
      Read Encryption Key Size (0x05|0x0008) ncmd 1
        Status: Unknown HCI Command (0x01)

Signed-off-by: Vinicius Peixoto <nukelet64@gmail.com>
Signed-off-by: Luiz Augusto von Dentz <luiz.von.dentz@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/bluetooth/btusb.c   | 1 +
 include/net/bluetooth/hci.h | 8 ++++++++
 net/bluetooth/hci_event.c   | 3 ++-
 3 files changed, 11 insertions(+), 1 deletion(-)

diff --git a/drivers/bluetooth/btusb.c b/drivers/bluetooth/btusb.c
index 8dbdc51976e7b..1976593bc804e 100644
--- a/drivers/bluetooth/btusb.c
+++ b/drivers/bluetooth/btusb.c
@@ -4477,6 +4477,7 @@ static int btusb_probe(struct usb_interface *intf,
 		set_bit(HCI_QUIRK_BROKEN_READ_TRANSMIT_POWER, &hdev->quirks);
 		set_bit(HCI_QUIRK_BROKEN_SET_RPA_TIMEOUT, &hdev->quirks);
 		set_bit(HCI_QUIRK_BROKEN_EXT_SCAN, &hdev->quirks);
+		set_bit(HCI_QUIRK_BROKEN_READ_ENC_KEY_SIZE, &hdev->quirks);
 	}
 
 	if (!reset)
diff --git a/include/net/bluetooth/hci.h b/include/net/bluetooth/hci.h
index 03e68a8e229f5..35c5f75a3a5ee 100644
--- a/include/net/bluetooth/hci.h
+++ b/include/net/bluetooth/hci.h
@@ -339,6 +339,14 @@ enum {
 	 * during the hdev->setup vendor callback.
 	 */
 	HCI_QUIRK_BROKEN_LE_CODED,
+
+	/*
+	 * When this quirk is set, the HCI_OP_READ_ENC_KEY_SIZE command is
+	 * skipped during an HCI_EV_ENCRYPT_CHANGE event. This is required
+	 * for Actions Semiconductor ATS2851 based controllers, which erroneously
+	 * claim to support it.
+	 */
+	HCI_QUIRK_BROKEN_READ_ENC_KEY_SIZE,
 };
 
 /* HCI device flags */
diff --git a/net/bluetooth/hci_event.c b/net/bluetooth/hci_event.c
index bb0e5902a3e60..80e71ce32f09f 100644
--- a/net/bluetooth/hci_event.c
+++ b/net/bluetooth/hci_event.c
@@ -3679,7 +3679,8 @@ static void hci_encrypt_change_evt(struct hci_dev *hdev, void *data,
 		 * controller really supports it. If it doesn't, assume
 		 * the default size (16).
 		 */
-		if (!(hdev->commands[20] & 0x10)) {
+		if (!(hdev->commands[20] & 0x10) ||
+		    test_bit(HCI_QUIRK_BROKEN_READ_ENC_KEY_SIZE, &hdev->quirks)) {
 			conn->enc_key_size = HCI_LINK_KEY_SIZE;
 			goto notify;
 		}
-- 
2.43.0



