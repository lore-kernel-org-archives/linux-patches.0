Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DCDA7330B2A;
	Mon, 29 Dec 2025 16:20:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767025254; cv=none; b=ntGuQg9ADv5ZR8ZSIjeYrNF7BUmxBHKkviw46FLvSH9mBe1GEltLrZPSOpahqMENm4612Lp9bKnDtdn0p8hyIlzeFrUm8xFaXij3IUX9XIi4aFTJDxaEJ2gjUqtPZKimloixAKgoz/QWFF5khSvEccNIxtIupY/t1562CbUE9Xc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767025254; c=relaxed/simple;
	bh=5dOZBeFwcJMhLYEAgY9gjLBbSBuff4tXHx8Hf/dRXkM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=UG8i6Rv5pwlWhpSTddwKkDJzu5SudyuQkqj+XMAOzvl5LO2npgTKIOGbh/CpScK5ml66ddeunEsuKCvUOmk22E1mY3rTytoFozOEy8F8a7KoaKanjWZovOyGxwXtDj9JgpiYd8PxIL/BnBXkmQ1ac+JWEhiwomlT4Zv9pPT6O6s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Qqg7Yd02; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Qqg7Yd02"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6591EC4CEF7;
	Mon, 29 Dec 2025 16:20:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1767025253;
	bh=5dOZBeFwcJMhLYEAgY9gjLBbSBuff4tXHx8Hf/dRXkM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Qqg7Yd02lCPx77CcupYuhzNmWE2ZaEwXEsc3gpJInSoC4x+puFhwodkEJ2SOYftzY
	 UCGjbclyiOzO8Acze+JEuGhUrTPLz5ZsdImsXlNoftUN+QYl8q9Bw5ZhKXczTReOLq
	 6hqte7kTULY+gWbFVSAv8J+LG/0u2DeXIhmopxcg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	huang-jl <huang-jl@deepseek.com>,
	Ming Lei <ming.lei@redhat.com>,
	Jens Axboe <axboe@kernel.dk>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 131/430] io_uring: fix nr_segs calculation in io_import_kbuf
Date: Mon, 29 Dec 2025 17:08:53 +0100
Message-ID: <20251229160729.186370737@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251229160724.139406961@linuxfoundation.org>
References: <20251229160724.139406961@linuxfoundation.org>
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

From: huang-jl <huang-jl@deepseek.com>

[ Upstream commit 114ea9bbaf7681c4d363e13b7916e6fef6a4963a ]

io_import_kbuf() calculates nr_segs incorrectly when iov_offset is
non-zero after iov_iter_advance(). It doesn't account for the partial
consumption of the first bvec.

The problem comes when meet the following conditions:
1. Use UBLK_F_AUTO_BUF_REG feature of ublk.
2. The kernel will help to register the buffer, into the io uring.
3. Later, the ublk server try to send IO request using the registered
   buffer in the io uring, to read/write to fuse-based filesystem, with
O_DIRECT.

>From a userspace perspective, the ublk server thread is blocked in the
kernel, and will see "soft lockup" in the kernel dmesg.

When ublk registers a buffer with mixed-size bvecs like [4K]*6 + [12K]
and a request partially consumes a bvec, the next request's nr_segs
calculation uses bvec->bv_len instead of (bv_len - iov_offset).

This causes fuse_get_user_pages() to loop forever because nr_segs
indicates fewer pages than actually needed.

Specifically, the infinite loop happens at:
fuse_get_user_pages()
  -> iov_iter_extract_pages()
    -> iov_iter_extract_bvec_pages()
Since the nr_segs is miscalculated, the iov_iter_extract_bvec_pages
returns when finding that i->nr_segs is zero. Then
iov_iter_extract_pages returns zero. However, fuse_get_user_pages does
still not get enough data/pages, causing infinite loop.

Example:
  - Bvecs: [4K, 4K, 4K, 4K, 4K, 4K, 12K, ...]
  - Request 1: 32K at offset 0, uses 6*4K + 8K of the 12K bvec
  - Request 2: 32K at offset 32K
    - iov_offset = 8K (8K already consumed from 12K bvec)
    - Bug: calculates using 12K, not (12K - 8K) = 4K
    - Result: nr_segs too small, infinite loop in fuse_get_user_pages.

Fix by accounting for iov_offset when calculating the first segment's
available length.

Fixes: b419bed4f0a6 ("io_uring/rsrc: ensure segments counts are correct on kbuf buffers")
Signed-off-by: huang-jl <huang-jl@deepseek.com>
Reviewed-by: Ming Lei <ming.lei@redhat.com>
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 io_uring/rsrc.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/io_uring/rsrc.c b/io_uring/rsrc.c
index 0010c4992490..5b6b73c6a62b 100644
--- a/io_uring/rsrc.c
+++ b/io_uring/rsrc.c
@@ -1057,6 +1057,7 @@ static int io_import_kbuf(int ddir, struct iov_iter *iter,
 	if (count < imu->len) {
 		const struct bio_vec *bvec = iter->bvec;
 
+		len += iter->iov_offset;
 		while (len > bvec->bv_len) {
 			len -= bvec->bv_len;
 			bvec++;
-- 
2.51.0



