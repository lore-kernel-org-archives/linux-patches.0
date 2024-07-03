Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D14671DFC7;
	Wed,  3 Jul 2024 10:42:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1720003340; cv=none; b=bN4ivWDaRRS/URlWF8IdxSrfgR+69u0hXKymksLzm8bf0vagVieC4szaoKxa3UpppZpr26VhH0rRFc+TJV9KSBySh/r4QzK1xXYaBkBFr71R65+k6DQAV9LR2wckQkY/8ussSZLI+GXVDPN3dq5eJRu3RmCa3TqM3bzrfvFjWP8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1720003340; c=relaxed/simple;
	bh=qNzulG/q5qdA8Km+p3RPkMv3W2F0AKrLYHZmdtk/ock=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=fpZU3oG2zGDxDtuVR0JRsPRgYAUh/K1h4OXAPZoT3qdJvHt7d4DDQ9osg5BySpRqrai3AGoAJCI0YyctMylQwoZyH5iiFcnvcjtU1u4myxgla5SS4QTMk4wkVpE77rGmK0s1Nu+U4u7+sKjb2BJWBbnie/AWkul4aKkzR3qodVA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ZO14p3M+; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ZO14p3M+"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 48418C2BD10;
	Wed,  3 Jul 2024 10:42:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1720003340;
	bh=qNzulG/q5qdA8Km+p3RPkMv3W2F0AKrLYHZmdtk/ock=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ZO14p3M+dNUic3myJZsjNA0A++/aNajwV3ZRQKSi/pJkmEHtYkA6SMqsLvR//9lZh
	 zmfTYcY2GHENzs9GN0ncjZ2wbYppekb6IT7BYmy48/PbFv8TYVSAimS0rBNFTyoeuk
	 X1xqc0kucSnCeLcrZPLc+oJ1q1tYD6o54MYgs82w=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Wesley Cheng <quic_wcheng@quicinc.com>,
	Sasha Levin <sashal@kernel.org>,
	stable <stable@kernel.org>
Subject: [PATCH 4.19 017/139] usb: gadget: f_fs: Fix race between aio_cancel() and AIO request complete
Date: Wed,  3 Jul 2024 12:38:34 +0200
Message-ID: <20240703102831.089275794@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240703102830.432293640@linuxfoundation.org>
References: <20240703102830.432293640@linuxfoundation.org>
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

4.19-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Wesley Cheng <quic_wcheng@quicinc.com>

[ Upstream commit 24729b307eefcd7c476065cd7351c1a018082c19 ]

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
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/usb/gadget/function/f_fs.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/drivers/usb/gadget/function/f_fs.c b/drivers/usb/gadget/function/f_fs.c
index 7294586b08dc0..0d8dae1797a97 100644
--- a/drivers/usb/gadget/function/f_fs.c
+++ b/drivers/usb/gadget/function/f_fs.c
@@ -761,6 +761,7 @@ static void ffs_user_copy_worker(struct work_struct *work)
 	int ret = io_data->req->status ? io_data->req->status :
 					 io_data->req->actual;
 	bool kiocb_has_eventfd = io_data->kiocb->ki_flags & IOCB_EVENTFD;
+	unsigned long flags;
 
 	if (io_data->read && ret > 0) {
 		mm_segment_t oldfs = get_fs();
@@ -777,7 +778,10 @@ static void ffs_user_copy_worker(struct work_struct *work)
 	if (io_data->ffs->ffs_eventfd && !kiocb_has_eventfd)
 		eventfd_signal(io_data->ffs->ffs_eventfd, 1);
 
+	spin_lock_irqsave(&io_data->ffs->eps_lock, flags);
 	usb_ep_free_request(io_data->ep, io_data->req);
+	io_data->req = NULL;
+	spin_unlock_irqrestore(&io_data->ffs->eps_lock, flags);
 
 	if (io_data->read)
 		kfree(io_data->to_free);
-- 
2.43.0



