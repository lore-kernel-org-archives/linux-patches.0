Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3D2D882D89;
	Mon, 15 Apr 2024 14:37:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713191870; cv=none; b=sLCWS37fgGwmzi9im8stxjoNWxZpnzJ6ryyPVuKL4WHY/1maMRJlDpEgde+Z9vuCvLSeTxw6xVB4cfLrduyKJUFzkkcjYf9Q4LVJOVqISA0jJ/eqx7QKRhJT0XOdbmwbtTfImeDcS8fFC1kDRKwyuy9QDKltydL7jde3xcYvcao=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713191870; c=relaxed/simple;
	bh=71h40Ec7lN/hannH8ydydlfmZ+rCei8ivNKypI02d4M=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=eybNoLfVOlCFM2FoIxkrzzMQ6hyteltjzTL9FVqkAYb2fgCDJ+RmTlTPxO++9ks4EMEjk6wwCwMi9R9tlWn/Fa2oXPBD6f9+KDGAQEVJlPHgEWJSO06/JVhMyhK6udvWeeyR2kyDCdBRcYyGovABCUY/Q1zugrZtTqAKeMmhMW8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=CpgDLg1F; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="CpgDLg1F"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AB8F4C113CC;
	Mon, 15 Apr 2024 14:37:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1713191870;
	bh=71h40Ec7lN/hannH8ydydlfmZ+rCei8ivNKypI02d4M=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=CpgDLg1F8jbyklNDUkh4Ow0r20tb28A2ZpTGvVroNLf/Q/+PuUDLW22tbt4g03TuH
	 SeFWP4Ws4TG25O4IfIGzVmk/0bNNydeORFqQQJKrOjTQ0YXtfvOGHTADYjmif7CZdR
	 htcEsWmFIB8an7CIzMHG8r3leFdeN/SOEViqwWqo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Alexander Wetzel <Alexander@wetzel-home.de>,
	Sachin Sant <sachinp@linux.ibm.com>,
	Bart Van Assche <bvanassche@acm.org>,
	"Martin K. Petersen" <martin.petersen@oracle.com>
Subject: [PATCH 6.6 086/122] scsi: sg: Avoid race in error handling & drop bogus warn
Date: Mon, 15 Apr 2024 16:20:51 +0200
Message-ID: <20240415141955.956875443@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240415141953.365222063@linuxfoundation.org>
References: <20240415141953.365222063@linuxfoundation.org>
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

From: Alexander Wetzel <Alexander@wetzel-home.de>

commit d4e655c49f474deffaf5ed7e65034b8167ee39c8 upstream.

Commit 27f58c04a8f4 ("scsi: sg: Avoid sg device teardown race") introduced
an incorrect WARN_ON_ONCE() and missed a sequence where sg_device_destroy()
was used after scsi_device_put().

sg_device_destroy() is accessing the parent scsi_device request_queue which
will already be set to NULL when the preceding call to scsi_device_put()
removed the last reference to the parent scsi_device.

Drop the incorrect WARN_ON_ONCE() - allowing more than one concurrent
access to the sg device - and make sure sg_device_destroy() is not used
after scsi_device_put() in the error handling.

Link: https://lore.kernel.org/all/5375B275-D137-4D5F-BE25-6AF8ACAE41EF@linux.ibm.com
Fixes: 27f58c04a8f4 ("scsi: sg: Avoid sg device teardown race")
Cc: stable@vger.kernel.org
Signed-off-by: Alexander Wetzel <Alexander@wetzel-home.de>
Link: https://lore.kernel.org/r/20240401191038.18359-1-Alexander@wetzel-home.de
Tested-by: Sachin Sant <sachinp@linux.ibm.com>
Reviewed-by: Bart Van Assche <bvanassche@acm.org>
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/scsi/sg.c |   18 ++++++++++--------
 1 file changed, 10 insertions(+), 8 deletions(-)

--- a/drivers/scsi/sg.c
+++ b/drivers/scsi/sg.c
@@ -285,6 +285,7 @@ sg_open(struct inode *inode, struct file
 	int dev = iminor(inode);
 	int flags = filp->f_flags;
 	struct request_queue *q;
+	struct scsi_device *device;
 	Sg_device *sdp;
 	Sg_fd *sfp;
 	int retval;
@@ -301,11 +302,12 @@ sg_open(struct inode *inode, struct file
 
 	/* This driver's module count bumped by fops_get in <linux/fs.h> */
 	/* Prevent the device driver from vanishing while we sleep */
-	retval = scsi_device_get(sdp->device);
+	device = sdp->device;
+	retval = scsi_device_get(device);
 	if (retval)
 		goto sg_put;
 
-	retval = scsi_autopm_get_device(sdp->device);
+	retval = scsi_autopm_get_device(device);
 	if (retval)
 		goto sdp_put;
 
@@ -313,7 +315,7 @@ sg_open(struct inode *inode, struct file
 	 * check if O_NONBLOCK. Permits SCSI commands to be issued
 	 * during error recovery. Tread carefully. */
 	if (!((flags & O_NONBLOCK) ||
-	      scsi_block_when_processing_errors(sdp->device))) {
+	      scsi_block_when_processing_errors(device))) {
 		retval = -ENXIO;
 		/* we are in error recovery for this device */
 		goto error_out;
@@ -344,7 +346,7 @@ sg_open(struct inode *inode, struct file
 
 	if (sdp->open_cnt < 1) {  /* no existing opens */
 		sdp->sgdebug = 0;
-		q = sdp->device->request_queue;
+		q = device->request_queue;
 		sdp->sg_tablesize = queue_max_segments(q);
 	}
 	sfp = sg_add_sfp(sdp);
@@ -370,10 +372,11 @@ out_undo:
 error_mutex_locked:
 	mutex_unlock(&sdp->open_rel_lock);
 error_out:
-	scsi_autopm_put_device(sdp->device);
+	scsi_autopm_put_device(device);
 sdp_put:
-	scsi_device_put(sdp->device);
-	goto sg_put;
+	kref_put(&sdp->d_ref, sg_device_destroy);
+	scsi_device_put(device);
+	return retval;
 }
 
 /* Release resources associated with a successful sg_open()
@@ -2234,7 +2237,6 @@ sg_remove_sfp_usercontext(struct work_st
 			"sg_remove_sfp: sfp=0x%p\n", sfp));
 	kfree(sfp);
 
-	WARN_ON_ONCE(kref_read(&sdp->d_ref) != 1);
 	kref_put(&sdp->d_ref, sg_device_destroy);
 	scsi_device_put(device);
 	module_put(THIS_MODULE);


