Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5AD3925E804;
	Tue, 11 Mar 2025 15:30:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741707049; cv=none; b=EFtPzC1WArZUAbB3VUZf9qgqwUE0HB0f/fOhNdQ0iJTaAGnY038KybFReoPcN0ttmSA9p0z0Yz1HJsaNk+muHlK2v57fN73l/+HKFmZoIR10vvd+TtrPfMgGZCuRku3QwgcmJdwVYWbmWhXeYMW1r/7JvlmxuJNQQYHar40v11E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741707049; c=relaxed/simple;
	bh=RFK+21v7atLJ87Zlu41gmFrSLCfmdX2oqXGiyf5tDu8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=kW1Jv2zSKvcGSV96TWc+piQKg21xNrJ7/VCpqaRg5lLyiNrEifqsXHAcxMdAQCCsIavqlgkeTZoTFXxP+WjS1AbklhqcIeXehBhUB178aKyGagjfILbFo83LVBx18eb4QTb/wQaQmFcMEoIdSkE5fnWMrPnR3FH5u+6L8t8QAIs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=x6bnwX8m; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="x6bnwX8m"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D3828C4CEE9;
	Tue, 11 Mar 2025 15:30:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1741707049;
	bh=RFK+21v7atLJ87Zlu41gmFrSLCfmdX2oqXGiyf5tDu8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=x6bnwX8mAC6KQRKRfuh3RKpTzGSiKqbNW+Ln85cR5G/UyDLoTiE+ZNs1rquqyiW4i
	 M7/sRYz0MtYbmeOv4P4pkZ9zlTYSFC6sM/xCduUw3zFtweWQAy9LLYvtj6xORFQTbf
	 bS9ARERt81osPdRcB3+b34oUekzsmd/Z8iIaKGvM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	stable <stable@kernel.org>,
	Jann Horn <jannh@google.com>
Subject: [PATCH 5.10 257/462] usb: cdc-acm: Check control transfer buffer size before access
Date: Tue, 11 Mar 2025 15:58:43 +0100
Message-ID: <20250311145808.514524237@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250311145758.343076290@linuxfoundation.org>
References: <20250311145758.343076290@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jann Horn <jannh@google.com>

commit e563b01208f4d1f609bcab13333b6c0e24ce6a01 upstream.

If the first fragment is shorter than struct usb_cdc_notification, we can't
calculate an expected_size. Log an error and discard the notification
instead of reading lengths from memory outside the received data, which can
lead to memory corruption when the expected_size decreases between
fragments, causing `expected_size - acm->nb_index` to wrap.

This issue has been present since the beginning of git history; however,
it only leads to memory corruption since commit ea2583529cd1
("cdc-acm: reassemble fragmented notifications").

A mitigating factor is that acm_ctrl_irq() can only execute after userspace
has opened /dev/ttyACM*; but if ModemManager is running, ModemManager will
do that automatically depending on the USB device's vendor/product IDs and
its other interfaces.

Cc: stable <stable@kernel.org>
Fixes: 1da177e4c3f4 ("Linux-2.6.12-rc2")
Signed-off-by: Jann Horn <jannh@google.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/usb/class/cdc-acm.c |   17 ++++++++++++++---
 1 file changed, 14 insertions(+), 3 deletions(-)

--- a/drivers/usb/class/cdc-acm.c
+++ b/drivers/usb/class/cdc-acm.c
@@ -360,7 +360,7 @@ static void acm_process_notification(str
 static void acm_ctrl_irq(struct urb *urb)
 {
 	struct acm *acm = urb->context;
-	struct usb_cdc_notification *dr = urb->transfer_buffer;
+	struct usb_cdc_notification *dr;
 	unsigned int current_size = urb->actual_length;
 	unsigned int expected_size, copy_size, alloc_size;
 	int retval;
@@ -387,9 +387,20 @@ static void acm_ctrl_irq(struct urb *urb
 
 	usb_mark_last_busy(acm->dev);
 
-	if (acm->nb_index)
+	if (acm->nb_index == 0) {
+		/*
+		 * The first chunk of a message must contain at least the
+		 * notification header with the length field, otherwise we
+		 * can't get an expected_size.
+		 */
+		if (current_size < sizeof(struct usb_cdc_notification)) {
+			dev_dbg(&acm->control->dev, "urb too short\n");
+			goto exit;
+		}
+		dr = urb->transfer_buffer;
+	} else {
 		dr = (struct usb_cdc_notification *)acm->notification_buffer;
-
+	}
 	/* size = notification-header + (optional) data */
 	expected_size = sizeof(struct usb_cdc_notification) +
 					le16_to_cpu(dr->wLength);


