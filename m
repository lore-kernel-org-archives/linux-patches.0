Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793826900;
	b=prjLgt7X7P/2bD1FQCKsLSGB4fxWmxoE+K3WhzmjjSsIfjtwasb8WzN+xJKaOSXLP37C
	 Qdur6NZYjfZValeLqENoXKrtlAzcNcFeUnj0gsyU5vOJ5zl15Z786EWnhjoubsUZbmKmI
	 fV2TOOV08VNCiBWk5ZDOpYcbCnoZxjRX0sCRMFDjX3u0+UFvLkK7fNcVqczdUmC3ihf0k
	 L3vBMHcZO9w2Qki13k41ggwpDPvzavdXpJnFk2QTim0e/5wTfdd3jb7THzEYtFMRdXJlr
	 jNe9AaC/PuKjbAo6iW3YH9vlREum9qp+mmfhEbERIz9Yw4JLcx1iRviQs+QxSi1qS0A==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793826900;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=kQqMOZR1lPtTFvfMhhb12jXAMsGdJ17+6WBAGVyYTW0=;
	b=LrXfwh/nvJyjf3i0/ckb62VPZr6R6thFVhcMhJxYye9ky3sALnvv5Vbbxi6uNJiFzc9E
	 vw77FI4tVJNYlhLNE+wievoBFwelRGD1/l5UWfVURSCy7oCb3nmgFaANp/1IHA2ekuhb6
	 Cpu3Uv8lVXYPPhXVTidtywXnq92uMC+G2nEjPf8cOt8+X8M/28Li0dXITxu7vfR5wh6JW
	 F2kDGXuF5jEmUPkNhFXd7e3BoPhGBYDSt2KsgZxtLXZvpwS03/Uedt63c9q+me5ym7Dwj
	 sFAns3QYhZXDgbX/Rh0aX9BfpVq2M1C9gJOitwte/H5pdGSk/A7RVvRa7JnrH179bFg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=nVRAg74t;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BCC9E60B479F;
	Wed,  4 Nov 2026 21:14:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=nVRAg74t
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5CF691F00919;
	Wed,  4 Nov 2026 21:14:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793826899;
	bh=kQqMOZR1lPtTFvfMhhb12jXAMsGdJ17+6WBAGVyYTW0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=nVRAg74tBY1Tk/uJAFyg/pzqJpNIFuQPx5+Z4cVUxD1elEqiqkMPBktyUMdsiwes/
	 nn+vDdm8Hehi+6lZ+LXoCur+TDBBqf3kgTjCd/bWraeOFohn3S4sjrbdmpi2YlvFv2
	 q6lbtiyRIudueK7z6JczcawhCNBVu+oNWA7Reo44=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Weiming Shi <bestswngs@gmail.com>,
	Joanne Koong <joannelkoong@gmail.com>,
	Xiang Mei <xmei5@asu.edu>,
	Miklos Szeredi <mszeredi@redhat.com>
Subject: [PATCH 7.3 073/547] fuse: dont BUG when the copy buffer is exhausted
Date: Wed,  4 Nov 2026 16:04:17 -0500
Message-ID: <20261104211040.332888128@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261104211038.406938024@linuxfoundation.org>
References: <20261104211038.406938024@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

7.3-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Xiang Mei <xmei5@asu.edu>

commit c1338aae7b4054e26f322155423f6aba90aeea23 upstream.

fuse_copy_fill() hits BUG_ON(!err) once the iterator backing the copy
runs out of pages.  Over io-uring the amount copied is not bounded by the
payload buffer the server registered, so an unprivileged user can drain
the iterator and panic the host - mount a FUSE filesystem with small
payload buffers, then setxattr() a larger value:

  kernel BUG at fs/fuse/dev.c:1064!
  Oops: invalid opcode: 0000 [#1] SMP KASAN NOPTI
  CPU: 1 UID: 0 PID: 148 Comm: exploit Not tainted 7.3.0-rc1 #2
  RIP: 0010:fuse_copy_fill (fs/fuse/dev.c:1033)
  Call Trace:
   <TASK>
   fuse_copy_args (fs/fuse/dev.c:1354 fs/fuse/dev.c:1380)
   fuse_uring_args_to_ring (fs/fuse/dev_uring.c:891)
   fuse_uring_prepare_send (fs/fuse/dev_uring.c:940 fs/fuse/dev_uring.c:1057)
   fuse_uring_send_in_task (fs/fuse/dev_uring.c:1745)
   tctx_task_work_run (io_uring/tw.c:96)
   tctx_task_work (io_uring/tw.c:133)
   task_work_run (kernel/task_work.c:233)
   io_run_task_work (io_uring/tw.h:84)
   io_cqring_wait (io_uring/wait.c:278)
   __do_sys_io_uring_enter (io_uring/io_uring.c:2676)
   do_syscall_64 (arch/x86/entry/syscall_64.c:61)
   entry_SYSCALL_64_after_hwframe (arch/x86/entry/entry_64.S:121)

The reply path can drain it the same way, via the server-supplied
payload_sz in fuse_uring_copy_from_ring().

Return -EIO instead.  All three fuse_copy_fill() callers already
propagate the error.

Fixes: c090c8abae4b ("fuse: Add io-uring sqe commit and fetch support")
Cc: stable@vger.kernel.org
Reported-by: Weiming Shi <bestswngs@gmail.com>
Suggested-by: Joanne Koong <joannelkoong@gmail.com>
Assisted-by: Claude:claude-opus-4-8
Reviewed-by: Joanne Koong <joannelkoong@gmail.com>
Signed-off-by: Xiang Mei <xmei5@asu.edu>
Signed-off-by: Miklos Szeredi <mszeredi@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/fuse/dev.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/fs/fuse/dev.c
+++ b/fs/fuse/dev.c
@@ -1061,7 +1061,8 @@ static int fuse_copy_fill(struct fuse_co
 		err = iov_iter_get_pages2(cs->iter, &page, PAGE_SIZE, 1, &off);
 		if (err < 0)
 			return err;
-		BUG_ON(!err);
+		if (!err)
+			return -EIO;
 		cs->len = err;
 		cs->offset = off;
 		cs->pg = page;


