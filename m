Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 27D72579836;
	Wed,  9 Sep 2026 14:35:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788964544; cv=none; b=CupMhoLlJg2qlbxODmtHWedKHBhq2CStJXqnjwX+YoKDhLdPKuFGCGmJpl6ICKc1nd3o72lX02A458XAhLGWH6Vx9ypiyMSwpN2mxOqCGluNvX/fzqLYP4CH8QZJPAVOBEpbXw1hY6XAuHd/YFuH25zA/bqCBjs5nUh2JuE2nKI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788964544; c=relaxed/simple;
	bh=53foHt4AbhgvpMXC7FKdH4yY6L0n81weh1BXmjHZq0Y=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Ywb41tnm//o1P2C8tcB4/4hit5W+BW6bKeeg1gqxQGkhwFpE9AMpNXtWicBSEHaeKLb5rkzeMJ55A/PKJSRKatSGUcMOAG6n94gaX5tACc5Lk80gQveRYSVZaXWDo0lSUP6nzm/w4ImlrIstRVOlvPcnegXvlkCfX1SW44ikW9g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=2QYq8LJc; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="2QYq8LJc"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 42FD01F00A3A;
	Wed,  9 Sep 2026 14:35:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1788964542;
	bh=i5IfihQe88Ko+31I6gqJ/Fm7YHYyxBOFa3Q73RjsxIc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=2QYq8LJcNH9d5Yub7fbwVhbNYDdnXRzXXmWheqVyx7seDK1YGwwYV64RJlu6MHA5a
	 vrvGj+vBZM99XJL0lZ6lHpdNfthoKBTl/Gkc8setXZWZN1g8iKZ96bjR3eCDvHXqCF
	 IaZjxhgXGAreidzA8NEAHBkN0N7agBp/A60tPW6M=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Gabriel Prostitis <prostitisgabriel@gmail.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 459/583] USB: gadget: ffs: fix mm lifetime handling
Date: Wed,  9 Sep 2026 15:42:24 +0200
Message-ID: <20260909134253.824626457@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260909134237.773280130@linuxfoundation.org>
References: <20260909134237.773280130@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Gabriel Prostitis <prostitisgabriel@gmail.com>

[ Upstream commit 5eb5c72c72fef76cb765ef1669b62b6a3ba1bfc8 ]

io_data stores a pointer to the submitting task's mm_struct,
but does not currently hold a reference to it while async
requests are pending.

This can result in a use-after-free if the task exits before
completion handling finishes.

Take a reference with mmgrab() when queuing the read request
and release it with mmdrop() on request completion.

Reported-by: Gabriel Prostitis <prostitisgabriel@gmail.com>
Signed-off-by: Gabriel Prostitis <prostitisgabriel@gmail.com>
Link: https://patch.msgid.link/20260601-mm-uaf-fix-v2-1-3c942a707bce@gmail.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Stable-dep-of: e78dcb1f7ec2 ("usb: gadget: f_fs: Fix Use-After-Free in AIO error path")
Signed-off-by: Sasha Levin <sashal@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/usb/gadget/function/f_fs.c |   27 ++++++++++++++++++++-------
 1 file changed, 20 insertions(+), 7 deletions(-)

--- a/drivers/usb/gadget/function/f_fs.c
+++ b/drivers/usb/gadget/function/f_fs.c
@@ -863,9 +863,15 @@ static void ffs_user_copy_worker(struct
 	bool kiocb_has_eventfd = io_data->kiocb->ki_flags & IOCB_EVENTFD;
 
 	if (io_data->read && ret > 0) {
-		kthread_use_mm(io_data->mm);
-		ret = ffs_copy_to_iter(io_data->buf, ret, &io_data->data);
-		kthread_unuse_mm(io_data->mm);
+		if (mmget_not_zero(io_data->mm)) {
+			kthread_use_mm(io_data->mm);
+			ret = ffs_copy_to_iter(io_data->buf, ret, &io_data->data);
+			kthread_unuse_mm(io_data->mm);
+			mmput(io_data->mm);
+		} else {
+			ret = -EFAULT;
+		}
+		mmdrop(io_data->mm);
 	}
 
 	io_data->kiocb->ki_complete(io_data->kiocb, ret);
@@ -1246,16 +1252,20 @@ static ssize_t ffs_epfile_write_iter(str
 
 	kiocb->private = p;
 
-	if (p->aio)
+	if (p->aio) {
+		mmgrab(p->mm);
 		kiocb_set_cancel_fn(kiocb, ffs_aio_cancel);
+	}
 
 	res = ffs_epfile_io(kiocb->ki_filp, p);
 	if (res == -EIOCBQUEUED)
 		return res;
-	if (p->aio)
+	if (p->aio) {
+		mmdrop(p->mm);
 		kfree(p);
-	else
+	} else {
 		*from = p->data;
+	}
 	return res;
 }
 
@@ -1290,14 +1300,17 @@ static ssize_t ffs_epfile_read_iter(stru
 
 	kiocb->private = p;
 
-	if (p->aio)
+	if (p->aio) {
+		mmgrab(p->mm);
 		kiocb_set_cancel_fn(kiocb, ffs_aio_cancel);
+	}
 
 	res = ffs_epfile_io(kiocb->ki_filp, p);
 	if (res == -EIOCBQUEUED)
 		return res;
 
 	if (p->aio) {
+		mmdrop(p->mm);
 		kfree(p->to_free);
 		kfree(p);
 	} else {


