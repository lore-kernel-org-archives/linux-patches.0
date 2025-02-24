Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4502B2561CA;
	Mon, 24 Feb 2025 14:52:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1740408727; cv=none; b=rJuFzIUcZvhzGzruUMljaG0Vdr1GWs8m5NQwo55kXWx+86Gp6jlZsh4uvx2KpSFlKr8BwfapsDKGBxDZlNugnHIkPczKkHeP9f7T1xK5XCukBm28zDX+JGDihV7yiJGhW0BJ5P0L4HQwuYvBaQRIMz6sKfneDLBUvD3pjG1ZfUs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1740408727; c=relaxed/simple;
	bh=SmHojcD3nwPsgTlAzrB8XodbyFvYnIMZ94uDpiB8vgU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=sWSzAEPm+/tX08fy5Hq0exaX9J4eUsWxc4klORJi/hHr9hPJsFq2LbEyly3D3SKHAqOTPPtv1RCimT0nCKRPtBU3WjRLHaApOfvUHP+ML5KJcaPNmo7okBh/1bWvRUKcLq+6Uymf6pdGp/Ns2e9wgWwowe3Y6SDStBBRqbdh0Ug=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=JG1TBjXQ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="JG1TBjXQ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A7972C4CED6;
	Mon, 24 Feb 2025 14:52:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1740408727;
	bh=SmHojcD3nwPsgTlAzrB8XodbyFvYnIMZ94uDpiB8vgU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=JG1TBjXQ8Bxe2oYuynFbrdSdsp1SPv55ZV1Gvq1KWLxHk8eCuGZ9hikLfWzcLPBWv
	 4hC/jpiT2rst5y0h3gZJhIOojP6h7YBER++xgl1ukb1vWrTwFht3HKVsuLhaEa3V+a
	 P4jmlCuJiP/+edDpz1AsRmRQrELwGvyG62guIimI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Pavel Begunkov <asml.silence@gmail.com>,
	Jens Axboe <axboe@kernel.dk>,
	Al Viro <viro@zeniv.linux.org.uk>,
	Christian Brauner <brauner@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH 6.12 125/154] lib/iov_iter: fix import_iovec_ubuf iovec management
Date: Mon, 24 Feb 2025 15:35:24 +0100
Message-ID: <20250224142611.947834354@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250224142607.058226288@linuxfoundation.org>
References: <20250224142607.058226288@linuxfoundation.org>
User-Agent: quilt/0.68
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

From: Pavel Begunkov <asml.silence@gmail.com>

commit f4b78260fc678ccd7169f32dc9f3bfa3b93931c7 upstream.

import_iovec() says that it should always be fine to kfree the iovec
returned in @iovp regardless of the error code.  __import_iovec_ubuf()
never reallocates it and thus should clear the pointer even in cases when
copy_iovec_*() fail.

Link: https://lkml.kernel.org/r/378ae26923ffc20fd5e41b4360d673bf47b1775b.1738332461.git.asml.silence@gmail.com
Fixes: 3b2deb0e46da ("iov_iter: import single vector iovecs as ITER_UBUF")
Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
Reviewed-by: Jens Axboe <axboe@kernel.dk>
Cc: Al Viro <viro@zeniv.linux.org.uk>
Cc: Christian Brauner <brauner@kernel.org>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 lib/iov_iter.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/lib/iov_iter.c
+++ b/lib/iov_iter.c
@@ -1428,6 +1428,8 @@ static ssize_t __import_iovec_ubuf(int t
 	struct iovec *iov = *iovp;
 	ssize_t ret;
 
+	*iovp = NULL;
+
 	if (compat)
 		ret = copy_compat_iovec_from_user(iov, uvec, 1);
 	else
@@ -1438,7 +1440,6 @@ static ssize_t __import_iovec_ubuf(int t
 	ret = import_ubuf(type, iov->iov_base, iov->iov_len, i);
 	if (unlikely(ret))
 		return ret;
-	*iovp = NULL;
 	return i->count;
 }
 


