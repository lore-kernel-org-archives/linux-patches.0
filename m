Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E181F1CDFD6;
	Tue, 27 Aug 2024 15:17:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724771827; cv=none; b=Lf7NLv+txEoGwydCazJscIBFA6k1rRyvK9UG8VdGRcMYpuMFtlU4v2boNTbJV+XWIUFxlc0JTJrBG+xfSJJR6UNZNkTD6LEfDF8YQRXtOBmPy48zmVnQddcmT6Yh67FZHuweBx1A/s1yXNygMWvXlDqpg+8eIu4vm1V2+I+3FdY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724771827; c=relaxed/simple;
	bh=ZlrkKxMsOMK/w8jOEsTusLS1tjD6M0IvYRMz4GV48yk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=q52XiFwq7+qV4JvkQ3ErSz49VvleQEEPTiP5vipMp1EM9zCPRO2J2DdsQNoOmnvh8KJQ7nqXKvTporXFTGnGYYDgJhmYV7cmNEiGHsxTKAEtYZDrNdIzjYOwPwFZ2P3Ahgc1+Ry7cgGzCSRDEaFwN0GQ3lNr9RXH0zoWl/LRBDA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=1JZYdfIi; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="1JZYdfIi"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 504E9C4DE1E;
	Tue, 27 Aug 2024 15:17:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1724771826;
	bh=ZlrkKxMsOMK/w8jOEsTusLS1tjD6M0IvYRMz4GV48yk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=1JZYdfIiLCIqUt2CNu+PHAD/EepvPc84xRY7XKRY+11SU/KgEH8zs0KK33xhMtauM
	 4Sfjh013gPhArRGM7kPM2ViU87xulSgE/fF8KqFprnuKEaa3hYE9AGiGDJbqHU7/ge
	 jthpzZbxKuowVUHE2tKXNjbj8mxrxD7EeaXL+vSs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	stable <stable@kernel.org>,
	Eli Billauer <eli.billauer@gmail.com>
Subject: [PATCH 6.1 004/321] char: xillybus: Refine workqueue handling
Date: Tue, 27 Aug 2024 16:35:12 +0200
Message-ID: <20240827143838.364960914@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240827143838.192435816@linuxfoundation.org>
References: <20240827143838.192435816@linuxfoundation.org>
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

From: Eli Billauer <eli.billauer@gmail.com>

commit ad899c301c880766cc709aad277991b3ab671b66 upstream.

As the wakeup work item now runs on a separate workqueue, it needs to be
flushed separately along with flushing the device's workqueue.

Also, move the destroy_workqueue() call to the end of the exit method,
so that deinitialization is done in the opposite order of
initialization.

Fixes: ccbde4b128ef ("char: xillybus: Don't destroy workqueue from work item running on it")
Cc: stable <stable@kernel.org>
Signed-off-by: Eli Billauer <eli.billauer@gmail.com>
Link: https://lore.kernel.org/r/20240816070200.50695-1-eli.billauer@gmail.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/char/xillybus/xillyusb.c |    8 +++++---
 1 file changed, 5 insertions(+), 3 deletions(-)

--- a/drivers/char/xillybus/xillyusb.c
+++ b/drivers/char/xillybus/xillyusb.c
@@ -2079,9 +2079,11 @@ static int xillyusb_discovery(struct usb
 	 * just after responding with the IDT, there is no reason for any
 	 * work item to be running now. To be sure that xdev->channels
 	 * is updated on anything that might run in parallel, flush the
-	 * workqueue, which rarely does anything.
+	 * device's workqueue and the wakeup work item. This rarely
+	 * does anything.
 	 */
 	flush_workqueue(xdev->workq);
+	flush_work(&xdev->wakeup_workitem);
 
 	xdev->num_channels = num_channels;
 
@@ -2258,9 +2260,9 @@ static int __init xillyusb_init(void)
 
 static void __exit xillyusb_exit(void)
 {
-	destroy_workqueue(wakeup_wq);
-
 	usb_deregister(&xillyusb_driver);
+
+	destroy_workqueue(wakeup_wq);
 }
 
 module_init(xillyusb_init);


