Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BD0A842EEB8;
	Tue, 31 Mar 2026 16:39:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774975179; cv=none; b=ZSxMOoHcCdJsS/lVwoh+RS1QQrmDsnGAm17U/RBNSZcSeRGmi/OxBbjvW7E5geEKrqEoVh7tj82AY6aDTrYxTXjdt9BHQE9yHtBFX49wUtPs6VoGagCEr+IypbqL2BDSIOZBKilppyoX0dJ2KKmwVLSsweWOix8auhqWh2kZQ4k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774975179; c=relaxed/simple;
	bh=Ya910JVZYBoxOBBBSRAjWMzN7EKNDSEOOBMsCK06gfI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=UizWaGXX/aByxkeyriiMBD6r6GbTBbKqYB+xesdp62xslO6Wi8QzMkikBRMlGHzeH2uoBbu1atuqwBD6qOVvAWp9ie0eTzlXGOHmKeN49lRDdPr2m1K1T7uZkOGWkblXyE590yht23V0Ww/1LA2+5GUw+nAz8l1Nn+lHfqBtw4Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=wB45YcbW; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="wB45YcbW"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4BD39C19423;
	Tue, 31 Mar 2026 16:39:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1774975179;
	bh=Ya910JVZYBoxOBBBSRAjWMzN7EKNDSEOOBMsCK06gfI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=wB45YcbW3zcMsnM/Uk4hj+1fu2LEh6Wek5StWLFDZUtLcb4i7DF0zTsMF1nNq7ezL
	 jef+E0mBr3fOogUDWRNDPj/oeHXIC6mOmsgYXrdHXydHn2wEot9EcPx2QdH8q6h+ls
	 PgF0kUenBkZiCnxKnQFvwNYjqDsb8AB3pqZMwfyY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Nicholas Carlini <nicholas@carlini.com>,
	Jens Axboe <axboe@kernel.dk>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.19 193/342] io_uring/fdinfo: fix OOB read in SQE_MIXED wrap check
Date: Tue, 31 Mar 2026 18:20:26 +0200
Message-ID: <20260331161806.096460844@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260331161758.909578033@linuxfoundation.org>
References: <20260331161758.909578033@linuxfoundation.org>
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

6.19-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Nicholas Carlini <nicholas@carlini.com>

[ Upstream commit 5170efd9c344c68a8075dcb8ed38d3f8a60e7ed4 ]

__io_uring_show_fdinfo() iterates over pending SQEs and, for 128-byte
SQEs on an IORING_SETUP_SQE_MIXED ring, needs to detect when the second
half of the SQE would be past the end of the sq_sqes array. The current
check tests (++sq_head & sq_mask) == 0, but sq_head is only incremented
when a 128-byte SQE is encountered, not on every iteration. The actual
array index is sq_idx = (i + sq_head) & sq_mask, which can be sq_mask
(the last slot) while the wrap check passes.

Fix by checking sq_idx directly. Keep the sq_head increment so the loop
still skips the second half of the 128-byte SQE on the next iteration.

Fixes: 1cba30bf9fdd ("io_uring: add support for IORING_SETUP_SQE_MIXED")
Signed-off-by: Nicholas Carlini <nicholas@carlini.com>
Link: https://patch.msgid.link/20260327021823.3138396-1-nicholas@carlini.com
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 io_uring/fdinfo.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/io_uring/fdinfo.c b/io_uring/fdinfo.c
index 25c92ace18bd1..c2d3e45544bb4 100644
--- a/io_uring/fdinfo.c
+++ b/io_uring/fdinfo.c
@@ -119,12 +119,13 @@ static void __io_uring_show_fdinfo(struct io_ring_ctx *ctx, struct seq_file *m)
 					sq_idx);
 				break;
 			}
-			if ((++sq_head & sq_mask) == 0) {
+			if (sq_idx == sq_mask) {
 				seq_printf(m,
 					"%5u: corrupted sqe, wrapping 128B entry\n",
 					sq_idx);
 				break;
 			}
+			sq_head++;
 			i++;
 			sqe128 = true;
 		}
-- 
2.53.0



