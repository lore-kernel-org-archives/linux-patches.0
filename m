Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4D034373155;
	Sat, 28 Feb 2026 17:58:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772301515; cv=none; b=a792vuZ+UUzqq/zHSQgbgt/kohENNygKzIp2phvOVq+nVZ09pNBKdScDpb5XrPGwK670rDQc+GmEOuXTYqRCApJAPKeWydMEVAT0VXWFj2GdJraNm1OiFzP9Tk6m/t4uKaWvxLnu5Dl+6hi+TISgfB3nILpTdAZzk9+wtBOTnVU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772301515; c=relaxed/simple;
	bh=LNzFhU9XfZhjf8xxOub6ucNaRuUyk/B2S4O+7kveyFs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=LyaSzllXtrrddHgVLR5ceo/KMMeHBA/eCxl5XVR9+Skjk5EsILwnMXxHgGlbwQ85T5HbdiSLe0Po6qOZsOcQPhFUu+J+CbqXh4sD0g8Gs75LISI36MxiQhhg4o1OI/3WUOIRysuq1Woopwfx+25WB+6tUM0RzWt8Nio3ifU+M4g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Wzp4syla; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Wzp4syla"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AF996C116D0;
	Sat, 28 Feb 2026 17:58:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772301515;
	bh=LNzFhU9XfZhjf8xxOub6ucNaRuUyk/B2S4O+7kveyFs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Wzp4sylaz7RK6SE8A4Or0PanMqbdKWv7P1s07W6xybnhJ7sglqGz3kpD+t4Gv5zus
	 eIAh3/TYMALxoOyyFBAqHMhv8TlIzBgOU29HPf3dnICcHSPzwYRJWvOyx1XvGuo0ep
	 QcExmbw1yZRYZTcpoFg5QRpcIJenpNPrSsiaLaOsJu4Q37wVj5eTsF+VTchZWVgVTI
	 oUPMJHCiSdwxqEtgkCt12oYI/K+9NxHLuLqjg5h3gP2Y+/H320JWd55Lvu1lf78uGD
	 L1/opAoV0Zhwopmbt155XnJIRhTwo7kTYwgZMMQAP4t/7hm7Uu41B4TUtOJ77EqAnC
	 AfNriG9Cik4Mw==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev
Cc: Jens Axboe <axboe@kernel.dk>,
	stable@vger.kernel.org,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 701/752] io_uring/filetable: clamp alloc_hint to the configured alloc range
Date: Sat, 28 Feb 2026 12:46:52 -0500
Message-ID: <20260228174750.1542406-701-sashal@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20260228174750.1542406-1-sashal@kernel.org>
References: <20260228174750.1542406-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit

From: Jens Axboe <axboe@kernel.dk>

[ Upstream commit a6bded921ed35f21b3f6bd8e629bf488499ca442 ]

Explicit fixed file install/remove operations on slots outside the
configured alloc range can corrupt alloc_hint via io_file_bitmap_set()
and io_file_bitmap_clear(), which unconditionally update alloc_hint to
the bit position. This causes subsequent auto-allocations to fall
outside the configured range.

For example, if the alloc range is [10, 20) and a file is removed at
slot 2, alloc_hint gets set to 2. The next auto-alloc then starts
searching from slot 2, potentially returning a slot below the range.

Fix this by clamping alloc_hint to [file_alloc_start, file_alloc_end)
at the top of io_file_bitmap_get() before starting the search.

Cc: stable@vger.kernel.org
Fixes: 6e73dffbb93c ("io_uring: let to set a range for file slot allocation")
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 io_uring/filetable.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/io_uring/filetable.c b/io_uring/filetable.c
index 794ef95df293c..cb1838c9fc377 100644
--- a/io_uring/filetable.c
+++ b/io_uring/filetable.c
@@ -22,6 +22,10 @@ static int io_file_bitmap_get(struct io_ring_ctx *ctx)
 	if (!table->bitmap)
 		return -ENFILE;
 
+	if (table->alloc_hint < ctx->file_alloc_start ||
+	    table->alloc_hint >= ctx->file_alloc_end)
+		table->alloc_hint = ctx->file_alloc_start;
+
 	do {
 		ret = find_next_zero_bit(table->bitmap, nr, table->alloc_hint);
 		if (ret != nr)
-- 
2.51.0

