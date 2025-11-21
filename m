Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B33CE45948;
	Fri, 21 Nov 2025 13:15:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763730956; cv=none; b=EENS23vwDtlsN+tzc8YUzl1HjWIhvkx85Hkvo181VEEoA+WpstTKpztqbsYLUJsv+ImrY+iajoGV3F60tUsMSeYNgOnM7Io34SmwBCbQfVh2GtSq00g4YpdDQ9dj5yVA2oTcJm9+9GJWGarQ/9BeGSZBZoBRNx7BKr+QF1PlMIM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763730956; c=relaxed/simple;
	bh=i0H1aM7tlb2fAP1eSVbMFpjD4i/sggnZjeGJ/Nc12vQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=dW5BOZNi5C9dH7ADJ2oiUPg+nU3wyFgP6tn0G3pir+1x9adlWIUCqFofh3u0PzC59YPy4ml9jENBbkCBNtOep9S88ZuuDrnWVZfMBYcFqkPrfAT7xFPSSkHvg3r899pYWBXFCEv35lxO73Is6gsJM55x5Io1rKnJ08/lFpx0hxU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=KJ2jTgqO; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="KJ2jTgqO"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D75F7C4CEF1;
	Fri, 21 Nov 2025 13:15:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1763730956;
	bh=i0H1aM7tlb2fAP1eSVbMFpjD4i/sggnZjeGJ/Nc12vQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=KJ2jTgqOHmgJHKk2QRpytdxz08GroSbXttsyKxiqWihxdDdSdVt2SSaxJmYR1j3nl
	 QDFwzU1TH6xmSiC7jhpSQB8dSyJRQcBjzXiy/iyy84f00Lhp3mrVZ/pAWBdx6uNFOi
	 Et0CJyIJtWqTwBvRF3KvTRArSK+45J1FStJCxvJ8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Pavel Begunkov <asml.silence@gmail.com>,
	Jens Axboe <axboe@kernel.dk>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.17 039/247] io_uring: fix unexpected placement on same size resizing
Date: Fri, 21 Nov 2025 14:09:46 +0100
Message-ID: <20251121130156.007069191@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251121130154.587656062@linuxfoundation.org>
References: <20251121130154.587656062@linuxfoundation.org>
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

6.17-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Pavel Begunkov <asml.silence@gmail.com>

[ Upstream commit 437c23357d897f5b5b7d297c477da44b56654d46 ]

There might be many reasons why a user is resizing a ring, e.g. moving
to huge pages or for some memory compaction using IORING_SETUP_NO_MMAP.
Don't bypass resizing, the user will definitely be surprised seeing 0
while the rings weren't actually moved to a new place.

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 io_uring/register.c | 7 -------
 1 file changed, 7 deletions(-)

diff --git a/io_uring/register.c b/io_uring/register.c
index b1772a470bf6e..dacbe8596b5c2 100644
--- a/io_uring/register.c
+++ b/io_uring/register.c
@@ -426,13 +426,6 @@ static int io_register_resize_rings(struct io_ring_ctx *ctx, void __user *arg)
 	if (unlikely(ret))
 		return ret;
 
-	/* nothing to do, but copy params back */
-	if (p.sq_entries == ctx->sq_entries && p.cq_entries == ctx->cq_entries) {
-		if (copy_to_user(arg, &p, sizeof(p)))
-			return -EFAULT;
-		return 0;
-	}
-
 	size = rings_size(p.flags, p.sq_entries, p.cq_entries,
 				&sq_array_offset);
 	if (size == SIZE_MAX)
-- 
2.51.0



