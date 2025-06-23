Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B692E225417;
	Mon, 23 Jun 2025 22:14:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750716891; cv=none; b=lWJoXwSE+HRBzg5rA27ecajhBlMeOwYL2BgEAKjjHnKIZ6kq08K8EitzQNalKBc2MzmQXhmVTMGZadblhn4WB39YxscQz+Tt3xJTJLqZSs3K9jWXqlLF28KfJzjDW1laxUPHDlT7SgAGJP3S5cd1drsev/H46Unzaz784u9W9bQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750716891; c=relaxed/simple;
	bh=Kg9C1XcyZah9fl3gNzFSftLgK1fLrYvm3qdu3JcpK5U=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=QV5XN7Zi2o7vXPGswVnorXXZVJGs6l3eC7z0UvPDjQaz/0pplUoeIKZfmwVj575NF5peQrXettlNHSe1zPRhGzKMcKvq5FIQy6g34JsS57fxNZ0o4ttwF+qH3dd73VtOupbNFvsVYNK9Pn21v4nA9xMTFcE+DvDk1Fr2Q0mo+Jg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=kCGHNbQz; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="kCGHNbQz"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4DA74C4CEEA;
	Mon, 23 Jun 2025 22:14:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1750716891;
	bh=Kg9C1XcyZah9fl3gNzFSftLgK1fLrYvm3qdu3JcpK5U=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=kCGHNbQzcC/MBnfpM1ComQF/lczvIxO4rl5yj0l1Fm0tSr7VcUEGvMEKSHDjFv9Sa
	 EZbhsHFxMGYNuI2rdQ/TVkEni8s1KKLW2evi1l/kWVlr59bmOfqWXGDYkg4+Zuin84
	 4QsAZIje/ivSczhx/LykfMfcdfTFI0xrxmVtiOls=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Christian Mazakas <christian.mazakas@gmail.com>,
	Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 6.12 295/414] io_uring/kbuf: dont truncate end buffer for multiple buffer peeks
Date: Mon, 23 Jun 2025 15:07:12 +0200
Message-ID: <20250623130649.384133557@linuxfoundation.org>
X-Mailer: git-send-email 2.50.0
In-Reply-To: <20250623130642.015559452@linuxfoundation.org>
References: <20250623130642.015559452@linuxfoundation.org>
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

From: Jens Axboe <axboe@kernel.dk>

commit 26ec15e4b0c1d7b25214d9c0be1d50492e2f006c upstream.

If peeking a bunch of buffers, normally io_ring_buffers_peek() will
truncate the end buffer. This isn't optimal as presumably more data will
be arriving later, and hence it's better to stop with the last full
buffer rather than truncate the end buffer.

Cc: stable@vger.kernel.org
Fixes: 35c8711c8fc4 ("io_uring/kbuf: add helpers for getting/peeking multiple buffers")
Reported-by: Christian Mazakas <christian.mazakas@gmail.com>
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 io_uring/kbuf.c |    5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

--- a/io_uring/kbuf.c
+++ b/io_uring/kbuf.c
@@ -262,8 +262,11 @@ static int io_ring_buffers_peek(struct i
 		/* truncate end piece, if needed, for non partial buffers */
 		if (len > arg->max_len) {
 			len = arg->max_len;
-			if (!(bl->flags & IOBL_INC))
+			if (!(bl->flags & IOBL_INC)) {
+				if (iov != arg->iovs)
+					break;
 				buf->len = len;
+			}
 		}
 
 		iov->iov_base = u64_to_user_ptr(buf->addr);


