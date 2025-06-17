Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7C7392EE29D;
	Tue, 17 Jun 2025 16:31:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750177909; cv=none; b=QtNDk+zZon+aIBWgjYQOAE9Muu3BePFejNSWAxP2NH+soiXJsphFUGp97iP48uRpZx5PsWrZrzNT3bXxbB6Adw3TgqLiMZQCmcR3X/u9LYWyiqXIxMB2nB7DChXJ52dSUJLCUZQjbeRlYTaPheA/VrgYglP4QUQYFAg8MT30bnk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750177909; c=relaxed/simple;
	bh=NqDxoLVhvg5NBOGeghX1X3pbqq2/eD5rcWamWGP46dE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=WQtsXEkwn8AQus58n3LFPRCF52Z8XmvYB88JGjDXyKq2Yddv0H23iRjAF2VVbqDAicZmGGmVvBriUdG2yZmDOm6X+m3QcUa/kjqWdhpwh10IOCFOYGXYERm1uGWay7bA25UcnldoIV+op5mNVurpRzxhNddNM4WH8FZvKTXv48Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=o4ufJA/o; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="o4ufJA/o"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E250AC4CEE3;
	Tue, 17 Jun 2025 16:31:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1750177909;
	bh=NqDxoLVhvg5NBOGeghX1X3pbqq2/eD5rcWamWGP46dE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=o4ufJA/o9ZgLo/wyirbcgk1RGLWZhak/W7vDVnjg1970xs8KGenVty0pK+n98cB7c
	 FcwPV51Pm7EcjvUlIjMPQz3PmgW6bhQ9AT49DFJJC0PzqUMNQuMCCcowDyxgkNZw+3
	 qucrTUCntpIzpxnYq/OE9gQzfCMresbqRM98XU8o=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jens Axboe <axboe@kernel.dk>,
	Anuj Gupta <anuj20.g@samsung.com>,
	Nitesh Shetty <nj.shetty@samsung.com>,
	Al Viro <viro@zeniv.linux.org.uk>,
	Christian Brauner <brauner@kernel.org>,
	Keith Busch <kbusch@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 392/512] iov_iter: use iov_offset for length calculation in iov_iter_aligned_bvec
Date: Tue, 17 Jun 2025 17:25:58 +0200
Message-ID: <20250617152435.470995678@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250617152419.512865572@linuxfoundation.org>
References: <20250617152419.512865572@linuxfoundation.org>
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

From: Nitesh Shetty <nj.shetty@samsung.com>

[ Upstream commit 334d7c4fb60cf21e0abac134d92fe49e9b04377e ]

If iov_offset is non-zero, then we need to consider iov_offset in length
calculation, otherwise we might pass smaller IOs such as 512 bytes, in
below scenario [1].

This issue is reproducible using lib-uring test/fixed-seg.c application
with fixed buffer on a 512 LBA formatted device.

[1]

At present we pass the alignment check, for 512 LBA formatted devices,
len_mask = 511 when IO is smaller, i->count = 512 has an offset,
i->io_offset = 3584 with bvec values, bvec->bv_offset = 256,
bvec->bv_len = 3840.  In short, the first 256 bytes are in the current
page, next 256 bytes are in the another page.  Ideally we expect to
fail the IO.

I can think of 2 userspace scenarios where we experience this.

a: From userspace, we observe a different behaviour when device LBA
   size is 512 vs 4096 bytes.  For 4096 LBA formatted device, I see the
   same liburing test [2] failing, whereas 512 the test passes without
   this.  This is reproducible everytime.

   [2] https://github.com/axboe/liburing/

b: Although I was not able to reproduce the below condition, but I
   suspect below case should be possible from user space for devices
   with 512 LBA formatted device.  Lets say from userspace while
   allocating a virtually single chunk of memory, if we get 2 physical
   chunk of memory, and IO happens to be at the boundary of first
   physical chunk with length crossing first chunk, then we allow IOs
   to proceed and hence we might map wrong physical address length and
   proceed with IO rather than failing.

: --- a/test/fixed-seg.c
: +++ b/test/fixed-seg.c
: @@ -64,7 +64,7 @@ static int test(struct io_uring *ring, int fd, int
: vec_off)
: 		return T_EXIT_FAIL;
: 	}
:
: -       ret = read_it(ring, fd, 4096, vec_off);
: +       ret = read_it(ring, fd, 4096, 7*512 + 256);
: 	if (ret) {
: 		fprintf(stderr, "4096 0 failed\n");
: 		return T_EXIT_FAIL;

Effectively this is a write crossing the page boundary.

Link: https://lkml.kernel.org/r/20250428095849.11709-1-nj.shetty@samsung.com
Fixes: 2263639f96f2 ("iov_iter: streamline iovec/bvec alignment iteration")
Reviewed-by: Jens Axboe <axboe@kernel.dk>
Reviewed-by: Anuj Gupta <anuj20.g@samsung.com>
Signed-off-by: Nitesh Shetty <nj.shetty@samsung.com>
Cc: Al Viro <viro@zeniv.linux.org.uk>
Cc: Christian Brauner <brauner@kernel.org>
Cc: Keith Busch <kbusch@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 lib/iov_iter.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/lib/iov_iter.c b/lib/iov_iter.c
index bdb37d572e97c..8ede6be556a96 100644
--- a/lib/iov_iter.c
+++ b/lib/iov_iter.c
@@ -820,7 +820,7 @@ static bool iov_iter_aligned_bvec(const struct iov_iter *i, unsigned addr_mask,
 	size_t size = i->count;
 
 	do {
-		size_t len = bvec->bv_len;
+		size_t len = bvec->bv_len - skip;
 
 		if (len > size)
 			len = size;
-- 
2.39.5



