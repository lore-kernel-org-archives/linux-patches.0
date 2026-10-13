Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D22F34F4D14;
	Tue, 13 Oct 2026 11:59:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791892756; cv=none; b=Hbk6mZK7j+CbhRtGP6aDlZNFRpWW99etkmbzmEPXzi6PnEoA0AE2xL+JClivopI8FOIclRZIqIE3L20+y75JO+H0o6dOn4sy3g8OztMIW4h7Gk7fduCr30F/p90JQUKwCNJK/kbGx9AZgvtpYTMxgSVNeC9Bl2ZwbTZe7LGm93o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791892756; c=relaxed/simple;
	bh=w4SLJftnPtnGKoDtGbRgLVgskWwTNEiSDckgm1jvcD8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=g3+xfEoDLgwkJmGNByzsjK42dTu0TKjHUxSiLsgLY+7aRoZlduzCG7J5dVY2SlSTx4uWdqVBzVx/HPLMJTzb62OqjM0DQo2VJ91cADoW/DffFj+tqWdGtKwdDJrSWPqU8LcaSsXwdZBNgsMfY7c2kNV8vuyrRVJHZSkqmKmylXs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=S7VGG2gg; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="S7VGG2gg"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E4AF11F000FF;
	Tue, 13 Oct 2026 11:59:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1791892754;
	bh=mp3m+8WxFDcEOc6ouXd7b8xY8A1a+quWf3xXZX2qKW8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=S7VGG2gg46CAas/RglC2hqtEkFijdNQPNFysGIfXgfMheF/I8W0S5Bf8LiJ1B1Lk4
	 auVGwJCMpYkcFd6DWLuxyBdxnxSH/7hP++gGmDx9j8RTU4Ta4C9D0PNoyb0jXMRbyX
	 ikbIEdou1PFsZN28w0CO8AuPGw+kz1oyAfOejTBs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Hengyu Liang <hengyul@cs.unc.edu>,
	Jens Axboe <axboe@kernel.dk>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.2 280/281] io_uring/kbuf: dont charge provided buffer rings to RLIMIT_MEMLOCK
Date: Tue, 13 Oct 2026 13:39:56 +0200
Message-ID: <20261013112901.936147094@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261013112855.045212108@linuxfoundation.org>
References: <20261013112855.045212108@linuxfoundation.org>
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

7.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jens Axboe <axboe@kernel.dk>

[ Upstream commit cde56daf4b93f474dc256dbcc5205035223ae6f5 ]

Just like with the SQ and CQ rings, the provided buffer rings were also
not charged against the memlock limit prior to the below mentioned
commit. Restore that behavior.

Fixes: ef62de3c4ad5 ("io_uring/kbuf: use region api for pbuf rings")
Reported-by: Hengyu Liang <hengyul@cs.unc.edu>
Cc: stable@vger.kernel.org
Tested-by: Hengyu Liang <hengyul@cs.unc.edu>
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Sasha Levin <sashal@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
Depends on <20261012153857.1014795-1-sashal@kernel.org>

 io_uring/kbuf.c |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

--- a/io_uring/kbuf.c
+++ b/io_uring/kbuf.c
@@ -458,7 +458,7 @@ static int io_remove_buffers_legacy(stru
 static void io_put_bl(struct io_ring_ctx *ctx, struct io_buffer_list *bl)
 {
 	if (bl->flags & IOBL_BUF_RING)
-		io_free_region(ctx->user, &bl->region);
+		io_free_region(NULL, &bl->region);
 	else
 		io_remove_buffers_legacy(ctx, bl, -1U);
 
@@ -675,7 +675,7 @@ int io_register_pbuf_ring(struct io_ring
 		rd.user_addr = reg.ring_addr;
 		rd.flags |= IORING_MEM_REGION_TYPE_USER;
 	}
-	ret = io_create_region(ctx->user, &bl->region, &rd, mmap_offset);
+	ret = io_create_region(NULL, &bl->region, &rd, mmap_offset);
 	if (ret)
 		goto fail;
 	br = io_region_get_ptr(&bl->region);
@@ -708,7 +708,7 @@ int io_register_pbuf_ring(struct io_ring
 	if (!ret)
 		return 0;
 fail:
-	io_free_region(ctx->user, &bl->region);
+	io_free_region(NULL, &bl->region);
 	kfree(bl);
 	return ret;
 }


