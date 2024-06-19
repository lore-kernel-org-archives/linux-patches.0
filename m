Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8459B14B96E;
	Wed, 19 Jun 2024 13:27:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718803636; cv=none; b=bVi+TnSUH03sLv+IlrfqdOop9HyNmXsAAg9g4PaOeDQpyGlc759gz9kPiscXzCrYrecgrLwVFFvwi7LXkc73+NI7POHlh3e8mWV0aMqIYNao1gmcdF6ZGDX+4yzWvn4gtgYWgySDkLA9B0dIFH5KH9YeywULLPr9p9SdQsscsZ0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718803636; c=relaxed/simple;
	bh=NiCnGM3KY6Zsgxlz1VJ4afgcE1yFaGOp7sIX4hrTS6A=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=iOkxXl6YpwtJAYPhQXq0Mx10R/+aAe+KsK3q9l7E0JMM5rYJYnAxA1Kz4wLncGOxGet76HxSZ6havwxRZXYE+4o14b0+GLpkos67XWrRfIayWSkYr37OKpHbz4mT36/ZPpgs0AtUUIitM1syaGS9anRuD4l7s+Fr1JGyjkXw/j4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=VCSwJ8+Y; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="VCSwJ8+Y"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0B586C2BBFC;
	Wed, 19 Jun 2024 13:27:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1718803636;
	bh=NiCnGM3KY6Zsgxlz1VJ4afgcE1yFaGOp7sIX4hrTS6A=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=VCSwJ8+Y8wd4KMdm7PgMPDoV7BVIsWBLyfp6JKE4+03PsvpOv8xiuHkNOHxSgsOfG
	 fUZcLEFtHa9gFvMSSlhaFGBRGXg7EMGVsFqZeFFfZcLcTKazT9UnsoSOTeLDUHZt91
	 wglpQ7QB/SyGuhGmRfGadd+kom9TUPTG+YPs9tjw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Linyu Yuan <quic_linyyuan@quicinc.com>,
	John Keeping <john@metanate.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 052/217] usb: gadget: f_fs: use io_data->status consistently
Date: Wed, 19 Jun 2024 14:54:55 +0200
Message-ID: <20240619125558.673853428@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240619125556.491243678@linuxfoundation.org>
References: <20240619125556.491243678@linuxfoundation.org>
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

From: John Keeping <john@metanate.com>

[ Upstream commit b566d38857fcb6777f25b674b90a831eec0817a2 ]

Commit fb1f16d74e26 ("usb: gadget: f_fs: change ep->status safe in
ffs_epfile_io()") added a new ffs_io_data::status field to fix lifetime
issues in synchronous requests.

While there are no similar lifetime issues for asynchronous requests
(the separate ep member in ffs_io_data avoids them) using the status
field means the USB request can be freed earlier and that there is more
consistency between the synchronous and asynchronous I/O paths.

Cc: Linyu Yuan <quic_linyyuan@quicinc.com>
Signed-off-by: John Keeping <john@metanate.com>
Reviewed-by: Linyu Yuan <quic_linyyuan@quicinc.com>
Link: https://lore.kernel.org/r/20221124170430.3998755-1-john@metanate.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Stable-dep-of: 24729b307eef ("usb: gadget: f_fs: Fix race between aio_cancel() and AIO request complete")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/usb/gadget/function/f_fs.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/usb/gadget/function/f_fs.c b/drivers/usb/gadget/function/f_fs.c
index b2da74bb107af..d32e1ece3e0a1 100644
--- a/drivers/usb/gadget/function/f_fs.c
+++ b/drivers/usb/gadget/function/f_fs.c
@@ -830,8 +830,7 @@ static void ffs_user_copy_worker(struct work_struct *work)
 {
 	struct ffs_io_data *io_data = container_of(work, struct ffs_io_data,
 						   work);
-	int ret = io_data->req->status ? io_data->req->status :
-					 io_data->req->actual;
+	int ret = io_data->status;
 	bool kiocb_has_eventfd = io_data->kiocb->ki_flags & IOCB_EVENTFD;
 
 	if (io_data->read && ret > 0) {
@@ -845,8 +844,6 @@ static void ffs_user_copy_worker(struct work_struct *work)
 	if (io_data->ffs->ffs_eventfd && !kiocb_has_eventfd)
 		eventfd_signal(io_data->ffs->ffs_eventfd, 1);
 
-	usb_ep_free_request(io_data->ep, io_data->req);
-
 	if (io_data->read)
 		kfree(io_data->to_free);
 	ffs_free_buffer(io_data);
@@ -861,6 +858,9 @@ static void ffs_epfile_async_io_complete(struct usb_ep *_ep,
 
 	ENTER();
 
+	io_data->status = req->status ? req->status : req->actual;
+	usb_ep_free_request(_ep, req);
+
 	INIT_WORK(&io_data->work, ffs_user_copy_worker);
 	queue_work(ffs->io_completion_wq, &io_data->work);
 }
-- 
2.43.0



