Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B13F143E06C;
	Thu, 17 Sep 2026 19:01:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789671682; cv=none; b=ucp4RNAzPWpVCq75gHhNp57Cv9TmZIOW+OxW2minFgs886zvbafDVKM/Jsbhy/lGpMaG2ktmWRUmTIJktvpVSMcxnCf9CvPYHHmae1/pBqJoY8dVARrL8/glQ/VzTJtw7cHqIRw7gWDkcUXrmq1hs43KW9MDHd4g/v5lGuj2L/U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789671682; c=relaxed/simple;
	bh=rZcjuOs1a5UM8A7aRIOEPodJIf2lgk20wHgn4wFWI+I=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=g6gDAIbGAPkAcm5x4D7LC3Ws2MttaiL4ME2yC/+LiQYMuMxXXHWHa4Roc1zgcB88argH9rUhN24deceQSfrFQFMDSYWV7A6x48yh/Sl5irzlJ0yUkkpjdItgmH9+RA++KfczGetwW+y1TO9Ii6WL7cwMwfyuo6NIhT44uwMneU0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=NGkJkKjR; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="NGkJkKjR"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 05B111F0089A;
	Thu, 17 Sep 2026 19:00:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789671657;
	bh=WCdLykQrQHR/YYnxwcZQguRUfUW8DWzwDiX6KSa7XTg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=NGkJkKjR0cW//bOwDItMPqnjmHF6ijy2mr4Qr1p/49esc3flXLruJik5X70r8uFjD
	 xxcrYK2Dw4Fvrg0TJmH08jene9uq7X5uIrhX6DsZddcYMy2QQ56StqFUZDbB706epH
	 UHAwke5So56TJlcPpsPA8XuA/20T/BZwbLGk52jI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Xingyu Jin <xingyuj@google.com>,
	Neill Kapron <nkapron@google.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 1010/1102] usb: gadget: f_fs: Fix Use-After-Free in AIO error path
Date: Thu, 17 Sep 2026 16:15:53 +0100
Message-ID: <20260917151606.103196188@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260917151539.408551884@linuxfoundation.org>
References: <20260917151539.408551884@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Neill Kapron <nkapron@google.com>

[ Upstream commit e78dcb1f7ec271449c54984dc90c62a5ba272de7 ]

In ffs_epfile_write_iter() and ffs_epfile_read_iter(), when ffs_epfile_io()
fails with an error other than -EIOCBQUEUED, the io_data structure (`p`) is
freed. However, for AIO operations, the kiocb cancel function was already
armed and kiocb->private was set to `p`.

If a concurrent cancel operation (such as sys_io_cancel()) executes after
ffs_epfile_io() fails but before the function frees `p`, a Use-After-Free
can occur when the cancellation handler accesses the freed pointer.

To securely fix this race condition, we must properly un-arm the
cancellation. Invoking `kiocb->ki_complete()` does exactly this by
acquiring `ctx->ctx_lock` and safely removing the kiocb from the active
sequence. In doing so, it ensures that a parallel io_cancel can no longer
discover the kiocb, effectively closing the race window.

We then return -EIOCBQUEUED to notify the VFS layer that the kiocb has been
consumed and it should avoid attempting to complete the request again or
triggering subsequent completion handlers.

Fixes: de2080d41b5d ("gadget/function/f_fs.c: close leaks")
Cc: stable@vger.kernel.org
Reported-by: Xingyu Jin <xingyuj@google.com>
Assisted-by: Antigravity:gemini-3.1-pro
Signed-off-by: Neill Kapron <nkapron@google.com>
Link: https://patch.msgid.link/20260724235100.106011-1-nkapron@google.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/usb/gadget/function/f_fs.c |    4 ++++
 1 file changed, 4 insertions(+)

--- a/drivers/usb/gadget/function/f_fs.c
+++ b/drivers/usb/gadget/function/f_fs.c
@@ -1273,8 +1273,10 @@ static ssize_t ffs_epfile_write_iter(str
 	if (res == -EIOCBQUEUED)
 		return res;
 	if (p->aio) {
+		kiocb->ki_complete(kiocb, res);
 		mmdrop(p->mm);
 		kfree(p);
+		return -EIOCBQUEUED;
 	} else {
 		*from = p->data;
 	}
@@ -1322,9 +1324,11 @@ static ssize_t ffs_epfile_read_iter(stru
 		return res;
 
 	if (p->aio) {
+		kiocb->ki_complete(kiocb, res);
 		mmdrop(p->mm);
 		kfree(p->to_free);
 		kfree(p);
+		return -EIOCBQUEUED;
 	} else {
 		*to = p->data;
 	}


