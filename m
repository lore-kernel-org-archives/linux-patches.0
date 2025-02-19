Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C2D141EB1BC;
	Wed, 19 Feb 2025 08:39:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739954340; cv=none; b=bOd1AwBOVbJmxdHhzjMkCHOAJ5THvZyleladHbuB7bbLIWdQQA99PTBwZA7FK/b0rcytPkSHofe06U7MeBUaYBFlB+bXkrn6SyKsMYLgQW7suYuNn0hmzyRUymPXBQpuHx8U+2KyddEWyAp35marbqJ+MYL6/QOf4VyCVwdy+m4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739954340; c=relaxed/simple;
	bh=5z83v8M6q5hiad2K+IwuFG1mcRaXz2/HwG2+LHreHpY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=L0Pu2UaTy/jmPDhzrP1jL+TpLtjuBjoF41lsx2GLMGasporcqAhZ5s21/MYSJ65CMR+ApOqgIyLF230R9t7yjLXztt3UBTkhGzAibaWXCs1l0MCEdz9LHM9aphL1tAWJnM7A97f3UytSwtq70GUIj36yeii3Fv04DiuzPGtJh74=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ToihVm2i; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ToihVm2i"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D147DC4CEE6;
	Wed, 19 Feb 2025 08:38:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1739954340;
	bh=5z83v8M6q5hiad2K+IwuFG1mcRaXz2/HwG2+LHreHpY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ToihVm2imMcdTCnInCSE1nVgebSFNaR9x0i5jI7O55Aj0+IEzXzVBUkrN9SptkEDp
	 a0wpGGMulc3TjM7/3qyLaHr7ZBYHPn13of6j859O6FjrmdeH02IsDubUeMocw85hlT
	 9Jikh8CbQeEhbnIFtVa+bbwn6g4LnY93DE5O+mn4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	stable <stable@kernel.org>,
	Jann Horn <jannh@google.com>
Subject: [PATCH 6.13 142/274] usb: cdc-acm: Check control transfer buffer size before access
Date: Wed, 19 Feb 2025 09:26:36 +0100
Message-ID: <20250219082615.159158639@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250219082609.533585153@linuxfoundation.org>
References: <20250219082609.533585153@linuxfoundation.org>
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

6.13-stable review patch.  If anyone has any objections, please let me know.

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
@@ -371,7 +371,7 @@ static void acm_process_notification(str
 static void acm_ctrl_irq(struct urb *urb)
 {
 	struct acm *acm = urb->context;
-	struct usb_cdc_notification *dr = urb->transfer_buffer;
+	struct usb_cdc_notification *dr;
 	unsigned int current_size = urb->actual_length;
 	unsigned int expected_size, copy_size, alloc_size;
 	int retval;
@@ -398,9 +398,20 @@ static void acm_ctrl_irq(struct urb *urb
 
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


