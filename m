Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1927F2590
	for <patches@lists.linux.dev>; Sun, 22 Jan 2023 15:15:01 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 94DA9C433EF;
	Sun, 22 Jan 2023 15:15:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1674400500;
	bh=XcfdUFug/89buGjRJN0eFELeTVgSoPfqkRkmMRXLhTM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=PUV+BiyUOJg9ZIQGJ8QOxmZ3lQz83Poufl0r8hRRSThPYI143HoNrE7Q4C+310dEZ
	 g6DcOz+VlHfxec6vGAze479Tbgwutq23O6Cn97G4VPOu94XRJj9mznb8y8pjBCagVK
	 z4dVRnVBhWJC6Wwg051oVEtGVheGPtY4f/9V4tx8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Venkata Lakshmi Narayana Gubba <gubbaven@codeaurora.org>,
	Marcel Holtmann <marcel@holtmann.org>
Subject: [PATCH 5.10 98/98] Bluetooth: hci_qca: Fixed issue during suspend
Date: Sun, 22 Jan 2023 16:04:54 +0100
Message-Id: <20230122150233.521199526@linuxfoundation.org>
X-Mailer: git-send-email 2.39.1
In-Reply-To: <20230122150229.351631432@linuxfoundation.org>
References: <20230122150229.351631432@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Venkata Lakshmi Narayana Gubba <gubbaven@codeaurora.org>

commit 55c0bd77479b60ea29fd390faf4545cfb3a1d79e upstream.

If BT SoC is running with ROM FW then just return in
qca_suspend function as ROM FW does not support
in-band sleep.

Fixes: 2be43abac5a8 ("Bluetooth: hci_qca: Wait for timeout during suspend")
Signed-off-by: Venkata Lakshmi Narayana Gubba <gubbaven@codeaurora.org>
Signed-off-by: Marcel Holtmann <marcel@holtmann.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/bluetooth/hci_qca.c |   12 +++++++++++-
 1 file changed, 11 insertions(+), 1 deletion(-)

--- a/drivers/bluetooth/hci_qca.c
+++ b/drivers/bluetooth/hci_qca.c
@@ -77,7 +77,8 @@ enum qca_flags {
 	QCA_MEMDUMP_COLLECTION,
 	QCA_HW_ERROR_EVENT,
 	QCA_SSR_TRIGGERED,
-	QCA_BT_OFF
+	QCA_BT_OFF,
+	QCA_ROM_FW
 };
 
 enum qca_capabilities {
@@ -1664,6 +1665,7 @@ static int qca_setup(struct hci_uart *hu
 	if (ret)
 		return ret;
 
+	clear_bit(QCA_ROM_FW, &qca->flags);
 	/* Patch downloading has to be done without IBS mode */
 	set_bit(QCA_IBS_DISABLED, &qca->flags);
 
@@ -1722,12 +1724,14 @@ retry:
 		hu->hdev->cmd_timeout = qca_cmd_timeout;
 	} else if (ret == -ENOENT) {
 		/* No patch/nvm-config found, run with original fw/config */
+		set_bit(QCA_ROM_FW, &qca->flags);
 		ret = 0;
 	} else if (ret == -EAGAIN) {
 		/*
 		 * Userspace firmware loader will return -EAGAIN in case no
 		 * patch/nvm-config is found, so run with original fw/config.
 		 */
+		set_bit(QCA_ROM_FW, &qca->flags);
 		ret = 0;
 	} else {
 		if (retries < MAX_INIT_RETRIES) {
@@ -2112,6 +2116,12 @@ static int __maybe_unused qca_suspend(st
 
 	set_bit(QCA_SUSPENDING, &qca->flags);
 
+	/* if BT SoC is running with default firmware then it does not
+	 * support in-band sleep
+	 */
+	if (test_bit(QCA_ROM_FW, &qca->flags))
+		return 0;
+
 	/* During SSR after memory dump collection, controller will be
 	 * powered off and then powered on.If controller is powered off
 	 * during SSR then we should wait until SSR is completed.


