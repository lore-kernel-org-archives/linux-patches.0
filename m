Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DD35D2590
	for <patches@lists.linux.dev>; Sun, 22 Jan 2023 15:21:33 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 62770C433D2;
	Sun, 22 Jan 2023 15:21:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1674400893;
	bh=C9CRQlUgKOBXV4wn7C5g1t1x7Rz9pAyvauqhyX0fmKk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=VGj5K864ocJuIzD4qWAQ3573UuP0uaFyhHxDFqhdp0RX2mJ8TOHGAvEpvg+DNxlry
	 6ywW5I2DlaHRMVIMUhKX+vjWQwcFPr6taT/oL8jH/xEbTWeyo0H6nLGE6sj/5Px0oO
	 vXoTOqvP8x8R8q3MyfWKXv+j9trB1OzjEvcFvHYc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Luiz Augusto von Dentz <luiz.von.dentz@intel.com>
Subject: [PATCH 6.1 030/193] Bluetooth: hci_sync: Fix use HCI_OP_LE_READ_BUFFER_SIZE_V2
Date: Sun, 22 Jan 2023 16:02:39 +0100
Message-Id: <20230122150247.777899467@linuxfoundation.org>
X-Mailer: git-send-email 2.39.1
In-Reply-To: <20230122150246.321043584@linuxfoundation.org>
References: <20230122150246.321043584@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Luiz Augusto von Dentz <luiz.von.dentz@intel.com>

commit 3a4d29b6d631bb00236a98887e1039bbfc1b6ab5 upstream.

Don't try to use HCI_OP_LE_READ_BUFFER_SIZE_V2 if controller don't
support ISO channels, but in order to check if ISO channels are
supported HCI_OP_LE_READ_LOCAL_FEATURES needs to be done earlier so the
features bits can be checked on hci_le_read_buffer_size_sync.

Link: https://bugzilla.kernel.org/show_bug.cgi?id=216817
Fixes: c1631dbc00c1 ("Bluetooth: hci_sync: Fix hci_read_buffer_size_sync")
Cc: stable@vger.kernel.org # 6.1
Signed-off-by: Luiz Augusto von Dentz <luiz.von.dentz@intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/bluetooth/hci_sync.c |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

--- a/net/bluetooth/hci_sync.c
+++ b/net/bluetooth/hci_sync.c
@@ -3554,7 +3554,7 @@ static const struct hci_init_stage hci_i
 static int hci_le_read_buffer_size_sync(struct hci_dev *hdev)
 {
 	/* Use Read LE Buffer Size V2 if supported */
-	if (hdev->commands[41] & 0x20)
+	if (iso_capable(hdev) && hdev->commands[41] & 0x20)
 		return __hci_cmd_sync_status(hdev,
 					     HCI_OP_LE_READ_BUFFER_SIZE_V2,
 					     0, NULL, HCI_CMD_TIMEOUT);
@@ -3579,10 +3579,10 @@ static int hci_le_read_supported_states_
 
 /* LE Controller init stage 2 command sequence */
 static const struct hci_init_stage le_init2[] = {
-	/* HCI_OP_LE_READ_BUFFER_SIZE */
-	HCI_INIT(hci_le_read_buffer_size_sync),
 	/* HCI_OP_LE_READ_LOCAL_FEATURES */
 	HCI_INIT(hci_le_read_local_features_sync),
+	/* HCI_OP_LE_READ_BUFFER_SIZE */
+	HCI_INIT(hci_le_read_buffer_size_sync),
 	/* HCI_OP_LE_READ_SUPPORTED_STATES */
 	HCI_INIT(hci_le_read_supported_states_sync),
 	{}


