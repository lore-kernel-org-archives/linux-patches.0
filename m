Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D07D82FB2;
	Tue, 27 Aug 2024 15:00:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724770847; cv=none; b=n5YekJ3KQ+qoNXsnukU3oumZkciFn62HkaconVUAoQGp/ivHSJm2jtW16vGX4jK/+R0T8k218ZPNavjw5WZ9/YjprfxrtYc17QPlhguLrhH//HDigKYR3Lv1vpCI6016ebLwzowACWYCKxtRRXmff2B95ufZIqJGZnnWEpIEwu4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724770847; c=relaxed/simple;
	bh=XoJp75bxmGB7Wi/Ky5L7qDzH2jpS3HseFetJ5H00vHM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=njVCMDa8lgTH7ocGuShjpYmZLcqlnB7tP6INTD4ftLejD5SKubErFUrocpIlVFN9d500k2j/f331zxgDNAyOXlfraV8zvdbae9NXyy2oVWyOaGXT4/zELNO50KiRmDLRhwKUoKNHdTBwipHTw0YGuNwQNPOgVrsvdJyvZE/+bWY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=aU/OaYt8; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="aU/OaYt8"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 425D8C4AF1C;
	Tue, 27 Aug 2024 15:00:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1724770847;
	bh=XoJp75bxmGB7Wi/Ky5L7qDzH2jpS3HseFetJ5H00vHM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=aU/OaYt8OSxz/wB0KHNd2qxhchFi0DP1VGBIgawo4BNHbbRANJ9xLB0Ims8iHrGBN
	 TMTb9n/18sNAMxClOWritEqWrGB1X+cuVSHtLjkX/8o774K9IpbB22rV/6D9ZSqRGp
	 iEQKry6THxTqgPA5xHOashGDwVHjiatJas1FWUGs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	syzbot+91dbdfecdd3287734d8e@syzkaller.appspotmail.com,
	stable <stable@kernel.org>,
	Eli Billauer <eli.billauer@gmail.com>
Subject: [PATCH 6.10 011/273] char: xillybus: Dont destroy workqueue from work item running on it
Date: Tue, 27 Aug 2024 16:35:35 +0200
Message-ID: <20240827143833.814327663@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240827143833.371588371@linuxfoundation.org>
References: <20240827143833.371588371@linuxfoundation.org>
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

From: Eli Billauer <eli.billauer@gmail.com>

commit ccbde4b128ef9c73d14d0d7817d68ef795f6d131 upstream.

Triggered by a kref decrement, destroy_workqueue() may be called from
within a work item for destroying its own workqueue. This illegal
situation is averted by adding a module-global workqueue for exclusive
use of the offending work item. Other work items continue to be queued
on per-device workqueues to ensure performance.

Reported-by: syzbot+91dbdfecdd3287734d8e@syzkaller.appspotmail.com
Cc: stable <stable@kernel.org>
Closes: https://lore.kernel.org/lkml/0000000000000ab25a061e1dfe9f@google.com/
Signed-off-by: Eli Billauer <eli.billauer@gmail.com>
Link: https://lore.kernel.org/r/20240801121126.60183-1-eli.billauer@gmail.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/char/xillybus/xillyusb.c |   16 +++++++++++-----
 1 file changed, 11 insertions(+), 5 deletions(-)

--- a/drivers/char/xillybus/xillyusb.c
+++ b/drivers/char/xillybus/xillyusb.c
@@ -50,6 +50,7 @@ MODULE_LICENSE("GPL v2");
 static const char xillyname[] = "xillyusb";
 
 static unsigned int fifo_buf_order;
+static struct workqueue_struct *wakeup_wq;
 
 #define USB_VENDOR_ID_XILINX		0x03fd
 #define USB_VENDOR_ID_ALTERA		0x09fb
@@ -569,10 +570,6 @@ static void cleanup_dev(struct kref *kre
  * errors if executed. The mechanism relies on that xdev->error is assigned
  * a non-zero value by report_io_error() prior to queueing wakeup_all(),
  * which prevents bulk_in_work() from calling process_bulk_in().
- *
- * The fact that wakeup_all() and bulk_in_work() are queued on the same
- * workqueue makes their concurrent execution very unlikely, however the
- * kernel's API doesn't seem to ensure this strictly.
  */
 
 static void wakeup_all(struct work_struct *work)
@@ -627,7 +624,7 @@ static void report_io_error(struct xilly
 
 	if (do_once) {
 		kref_get(&xdev->kref); /* xdev is used by work item */
-		queue_work(xdev->workq, &xdev->wakeup_workitem);
+		queue_work(wakeup_wq, &xdev->wakeup_workitem);
 	}
 }
 
@@ -2258,6 +2255,10 @@ static int __init xillyusb_init(void)
 {
 	int rc = 0;
 
+	wakeup_wq = alloc_workqueue(xillyname, 0, 0);
+	if (!wakeup_wq)
+		return -ENOMEM;
+
 	if (LOG2_INITIAL_FIFO_BUF_SIZE > PAGE_SHIFT)
 		fifo_buf_order = LOG2_INITIAL_FIFO_BUF_SIZE - PAGE_SHIFT;
 	else
@@ -2265,11 +2266,16 @@ static int __init xillyusb_init(void)
 
 	rc = usb_register(&xillyusb_driver);
 
+	if (rc)
+		destroy_workqueue(wakeup_wq);
+
 	return rc;
 }
 
 static void __exit xillyusb_exit(void)
 {
+	destroy_workqueue(wakeup_wq);
+
 	usb_deregister(&xillyusb_driver);
 }
 


