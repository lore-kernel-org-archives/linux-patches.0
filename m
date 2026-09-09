Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DE6815632A0;
	Wed,  9 Sep 2026 13:53:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788962037; cv=none; b=AKnZ5otB+8u+N24fV4j735XW2KXNLA4TsixXWNTk1jIFcW95ruGuk5C/ahvx1iP/KR1nAOW+czwKzmst+w6o97M3gvwXh+iME9BpUp0qOWTxhAoLxT0aaN+WjIQnayJaMYg99HQmul7CidSvLeYH1RTpFw/vKX9/DkAELGJPcKg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788962037; c=relaxed/simple;
	bh=aziBpxfavHT5QF16c0zdZQXsDjT77I6vOy69dL40ul0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=ZkdDloncefyo4gCLFI7NhuEsocEqPm//IDguhabgGHQMclKNjx+MPJhKQ/IDYBC4NZWwo3+ZiQvqKb6cqaakwCL/XHlslH/CA7TV+lrDF1DL3hSOTG6vjwJzhqlA3dbtK/Uq6vM6ZF4k6zaQ9DP1IY+fcU8iL0JZIq47hlmof7k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=dzHhLQzi; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="dzHhLQzi"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4390B1F00A3A;
	Wed,  9 Sep 2026 13:53:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1788962035;
	bh=cXLCHh8kmxd8l/39L/5tux18h14J4e6t18USnASa16g=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=dzHhLQzi5n7ZgsnSOdEsf9ZDUoxmdbk4FXF3enJm6+ixLFEQ8biByZpyB4krUDnMn
	 BsMtUSgwTKtG1wpkEG1NoYALeqUzfrNORmayKhuEQ7Yh3YlKmVaXTU1VTC7xtG9Zb8
	 lzkNcU+QZO+ZXDY6uyqvVaiCHfHw4bk6OYyGgJ1c=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Christian=20K=C3=B6nig?= <christian.koenig@amd.com>,
	Sumit Semwal <sumit.semwal@linaro.org>,
	Baineng Shou <shoubaineng@gmail.com>
Subject: [PATCH 7.2 124/556] misc: fastrpc: dont publish fd before copy_to_user() succeeds
Date: Wed,  9 Sep 2026 15:36:44 +0200
Message-ID: <20260909134234.823061790@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260909134230.441546314@linuxfoundation.org>
References: <20260909134230.441546314@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

7.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Baineng Shou <shoubaineng@gmail.com>

commit a4a1a2bfcb29785292d634d7787edc6fb550714d upstream.

fastrpc_ioctl_alloc_dmabuf() calls dma_buf_fd() which installs the fd
into the caller's fd table before copy_to_user() copies the fd number
back to userspace.  If copy_to_user() fails, the fd is already visible
to other threads in the same process but the ioctl returns -EFAULT.
The existing comment in the code even acknowledges the problem:

  "The usercopy failed, but we can't do much about it, as dma_buf_fd()
   already called fd_install()..."

Now that dma_buf_fd_install() is available (introduced to fix the same
issue in dma-heap), apply the same pattern here: reserve the fd with
get_unused_fd_flags(), attempt copy_to_user(), and only on success call
dma_buf_fd_install() to publish it atomically with the tracepoint.  On
copy_to_user() failure, put_unused_fd() and dma_buf_put() cleanly
unwind without any user-visible side effects.

Fixes: 6cffd79504ce ("misc: fastrpc: Add support for dmabuf exporter")
Cc: stable@vger.kernel.org
Acked-by: Christian König <christian.koenig@amd.com>
Acked-by: Sumit Semwal <sumit.semwal@linaro.org>
Signed-off-by: Baineng Shou <shoubaineng@gmail.com>
Link: https://lore.kernel.org/r/20260817050457.1005285-3-shoubaineng@gmail.com
Signed-off-by: Christian König <christian.koenig@amd.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/misc/fastrpc.c |   16 ++++++----------
 1 file changed, 6 insertions(+), 10 deletions(-)

--- a/drivers/misc/fastrpc.c
+++ b/drivers/misc/fastrpc.c
@@ -1712,24 +1712,20 @@ static int fastrpc_dmabuf_alloc(struct f
 		return err;
 	}
 
-	bp.fd = dma_buf_fd(buf->dmabuf, O_ACCMODE);
+	bp.fd = get_unused_fd_flags(O_ACCMODE);
 	if (bp.fd < 0) {
 		dma_buf_put(buf->dmabuf);
-		return -EINVAL;
+		return bp.fd;
 	}
 
 	if (copy_to_user(argp, &bp, sizeof(bp))) {
-		/*
-		 * The usercopy failed, but we can't do much about it, as
-		 * dma_buf_fd() already called fd_install() and made the
-		 * file descriptor accessible for the current process. It
-		 * might already be closed and dmabuf no longer valid when
-		 * we reach this point. Therefore "leak" the fd and rely on
-		 * the process exit path to do any required cleanup.
-		 */
+		put_unused_fd(bp.fd);
+		dma_buf_put(buf->dmabuf);
 		return -EFAULT;
 	}
 
+	dma_buf_fd_install(buf->dmabuf, bp.fd);
+
 	return 0;
 }
 


