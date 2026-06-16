Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9AF9E44103A;
	Tue, 16 Jun 2026 16:08:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781626099; cv=none; b=bYW3gfZoef/wpzOiSJLh4JhY2nSx/NFa9L+sVobtzYxDf/+f2Ki+y4+sWULNoyslZzMk/7GBh81EjvtbKHGZHfvgIJUpkgt/sl3XsAMaoekl19MVzLR5zredGs+YqZHw7U4e0EyYvfULVbBcFELiFIE9jt9EFDfrO6x9DredoM4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781626099; c=relaxed/simple;
	bh=bm2Mf4VGezLvobzsjQ7Mx3HujWOgixk4qwGunxy1ebU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=twRQYjDdG6FJFKDcX+ZhqxQ1Z8BAYfp9q8Pax9karjFgCw4QMF1mtw7NfBCAGg7KbdN+IWnq13P8cbZcLhVT2qBZsZpbuX9/kl4dhxMmujVY+wxd0jY9o8hJBLd7In96VZdyzAQoLgQ/vbbLAU5YkWjA/IK1qujiBZT7ymK7jNE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ixRbeeL2; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ixRbeeL2"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9D9B01F000E9;
	Tue, 16 Jun 2026 16:08:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1781626098;
	bh=PjfNfbv99boB2usWxH5VqpyFXS5vB3uQqh6zZGFJ2T0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ixRbeeL2Wtu+yEdPkcuoKP4M0wOIXojkRrcuaH9nmwpeFljCPLT4hj460NjPAhMTm
	 UvrjBv0wxLLkkijPLSXPUotQlb8z3/RKIM3VoPfCYy9f2S6vUN+U8/t0XpAVleynsX
	 dL4w0/HVYJ2Jcx2R/kIkdCM77vmEK/mo4yiQiDxU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Federico Brasili <federico.brasili@gmail.com>,
	Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 6.18 247/325] io_uring/kbuf: dont truncate end buffer for bundles
Date: Tue, 16 Jun 2026 20:30:43 +0530
Message-ID: <20260616145110.802349307@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260616145057.827196531@linuxfoundation.org>
References: <20260616145057.827196531@linuxfoundation.org>
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

From: Jens Axboe <axboe@kernel.dk>

Commit 70f4886bcbb929e88038c8807f1daf7fc587ae7c upstream.

If buffers have been peeked for a bundle receive, the kernel will
truncate the end buffer, if the available length is shorter than the
buffer itself. This is unnecessary, as applications iterating bundle
receives must always use the minimum size of the buffer length and the
remaining number of bytes in the bundle. The examples in liburing do
that as well, eg examples/proxy.c.

If the kernel does truncate this buffer AND the current transfer fails,
then the buffer will be left with a smaller size than what is otherwise
available.

Just remove the buffer truncation, as it's not necessary in the first
place.

Link: https://lore.kernel.org/io-uring/CAAEr8jbY60noGj1fw_k91UJRBkyiRVoS6=nLhZ7Svwidjn4CAA@mail.gmail.com/
Reported-by: Federico Brasili <federico.brasili@gmail.com>
Cc: stable@vger.kernel.org
Fixes: 35c8711c8fc4 ("io_uring/kbuf: add helpers for getting/peeking multiple buffers")
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 io_uring/kbuf.c |    1 -
 1 file changed, 1 deletion(-)

--- a/io_uring/kbuf.c
+++ b/io_uring/kbuf.c
@@ -305,7 +305,6 @@ static int io_ring_buffers_peek(struct i
 				arg->partial_map = 1;
 				if (iov != arg->iovs)
 					break;
-				buf->len = len;
 			}
 		}
 


