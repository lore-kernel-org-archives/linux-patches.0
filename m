Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B25334F88C;
	Tue, 14 May 2024 10:50:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1715683840; cv=none; b=KkdJWvmJe+NJDGuthrYwRAuBCuwH7m9tWFb5qO7hujwsjavhErQDXlwljDVZ4URcchUn/YsDnY0HvG8d9O7ha+SvNyEx7tY+w1VT+7q2tbKYCiBY7rmfWAvqs/KuGc21BrIMM2xklthEi2rYF/58nkIqMA7AhXOnxrS9MunLbtg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1715683840; c=relaxed/simple;
	bh=n4dptO+IOxl/glE+OwmG3ICSPYyWDPKnOsuav6T0sqY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=fnCHjQmGP2q/Ghi4Gr11ZPJbZLgrbExhu4585df8ATQtOP9ou5F1+EfX7ZxNFsQTBk5RESTVggS8FszQDswEJuTk1H4yrwIoocPhX4XCvVKb0CPxvoAJKQQrV+DJc+PXiR3bVlGK9jbptP1i/0pfPBU+28QoPXdF/MmoMvpATLk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=RccCgmcm; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="RccCgmcm"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 27511C2BD10;
	Tue, 14 May 2024 10:50:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1715683840;
	bh=n4dptO+IOxl/glE+OwmG3ICSPYyWDPKnOsuav6T0sqY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=RccCgmcmmxbRalRCwOUboCi2uXHzl21kmH+Ya3e8kaRqJ4o1oEqXRLR7/1UNjm16J
	 DT7vKEJwcFoAhsex2oQyk/v26NUcnW5A/GPRyS1XeCQSVGhYLKk/9/h6U7Sethu3KD
	 dQ1hnzf1pElOJsz/xXa/zJVTdfAha507fvJTf+Bs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Wesley Cheng <quic_wcheng@quicinc.com>,
	stable <stable@kernel.org>
Subject: [PATCH 6.8 252/336] usb: gadget: f_fs: Fix race between aio_cancel() and AIO request complete
Date: Tue, 14 May 2024 12:17:36 +0200
Message-ID: <20240514101048.131904981@linuxfoundation.org>
X-Mailer: git-send-email 2.45.0
In-Reply-To: <20240514101038.595152603@linuxfoundation.org>
References: <20240514101038.595152603@linuxfoundation.org>
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

6.8-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Wesley Cheng <quic_wcheng@quicinc.com>

commit 24729b307eefcd7c476065cd7351c1a018082c19 upstream.

FFS based applications can utilize the aio_cancel() callback to dequeue
pending USB requests submitted to the UDC.  There is a scenario where the
FFS application issues an AIO cancel call, while the UDC is handling a
soft disconnect.  For a DWC3 based implementation, the callstack looks
like the following:

    DWC3 Gadget                               FFS Application
dwc3_gadget_soft_disconnect()              ...
  --> dwc3_stop_active_transfers()
    --> dwc3_gadget_giveback(-ESHUTDOWN)
      --> ffs_epfile_async_io_complete()   ffs_aio_cancel()
        --> usb_ep_free_request()            --> usb_ep_dequeue()

There is currently no locking implemented between the AIO completion
handler and AIO cancel, so the issue occurs if the completion routine is
running in parallel to an AIO cancel call coming from the FFS application.
As the completion call frees the USB request (io_data->req) the FFS
application is also referencing it for the usb_ep_dequeue() call.  This can
lead to accessing a stale/hanging pointer.

commit b566d38857fc ("usb: gadget: f_fs: use io_data->status consistently")
relocated the usb_ep_free_request() into ffs_epfile_async_io_complete().
However, in order to properly implement locking to mitigate this issue, the
spinlock can't be added to ffs_epfile_async_io_complete(), as
usb_ep_dequeue() (if successfully dequeuing a USB request) will call the
function driver's completion handler in the same context.  Hence, leading
into a deadlock.

Fix this issue by moving the usb_ep_free_request() back to
ffs_user_copy_worker(), and ensuring that it explicitly sets io_data->req
to NULL after freeing it within the ffs->eps_lock.  This resolves the race
condition above, as the ffs_aio_cancel() routine will not continue
attempting to dequeue a request that has already been freed, or the
ffs_user_copy_work() not freeing the USB request until the AIO cancel is
done referencing it.

This fix depends on
  commit b566d38857fc ("usb: gadget: f_fs: use io_data->status
  consistently")

Fixes: 2e4c7553cd6f ("usb: gadget: f_fs: add aio support")
Cc: stable <stable@kernel.org>	# b566d38857fc ("usb: gadget: f_fs: use io_data->status consistently")
Signed-off-by: Wesley Cheng <quic_wcheng@quicinc.com>
Link: https://lore.kernel.org/r/20240409014059.6740-1-quic_wcheng@quicinc.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/usb/gadget/function/f_fs.c |    7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

--- a/drivers/usb/gadget/function/f_fs.c
+++ b/drivers/usb/gadget/function/f_fs.c
@@ -821,6 +821,7 @@ static void ffs_user_copy_worker(struct
 						   work);
 	int ret = io_data->status;
 	bool kiocb_has_eventfd = io_data->kiocb->ki_flags & IOCB_EVENTFD;
+	unsigned long flags;
 
 	if (io_data->read && ret > 0) {
 		kthread_use_mm(io_data->mm);
@@ -833,6 +834,11 @@ static void ffs_user_copy_worker(struct
 	if (io_data->ffs->ffs_eventfd && !kiocb_has_eventfd)
 		eventfd_signal(io_data->ffs->ffs_eventfd);
 
+	spin_lock_irqsave(&io_data->ffs->eps_lock, flags);
+	usb_ep_free_request(io_data->ep, io_data->req);
+	io_data->req = NULL;
+	spin_unlock_irqrestore(&io_data->ffs->eps_lock, flags);
+
 	if (io_data->read)
 		kfree(io_data->to_free);
 	ffs_free_buffer(io_data);
@@ -846,7 +852,6 @@ static void ffs_epfile_async_io_complete
 	struct ffs_data *ffs = io_data->ffs;
 
 	io_data->status = req->status ? req->status : req->actual;
-	usb_ep_free_request(_ep, req);
 
 	INIT_WORK(&io_data->work, ffs_user_copy_worker);
 	queue_work(ffs->io_completion_wq, &io_data->work);


