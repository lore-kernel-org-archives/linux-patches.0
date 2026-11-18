Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795050820;
	b=KaNKDxG+7848lT1ymcQ+w2uCp66mkdBd6b66/xGhzUdrb98qp5Ry1++KQS33LbBvZiGp
	 qSwu0fCWhdkSbnyBOFwlV8Z/VxYsKNTtT5P4mB+/y08UTT1VHC1lc5IonkBQPog3zD7pm
	 lYgh3obhKXGJVJWTcD4LDq+Aa/P/hpFcPwVQ+H3zEpKlhwKatRKYM2XI2sUgvp/MxeFHm
	 FB07EhuYEqBX5Tj4ieye1jSM15tsYQtnb1JKuDLjobszxnLnujlRm3Sq/+BQ471IfFghC
	 15oq//nUtBgQ71zL0CjsPUji51gQ4aw4b9nBJ2TFTBTnNTt3rr56NgKy4313QgcuzCg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795050820;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=+CSzk/cIP6+haQsyPR0fnBHAZHgLHviw4fVjMrgo1HM=;
	b=XPHPhwyP14U0FFIxX9ZMBUdv3FLc1k7l8L5gu7Y67h5WeACh2Wx8ziKnwlNw4dpi4RQ8
	 0NZz2UB/Ei/wRZIZC8VDuIX42L2aKwVQxqehwLq4HttZhaqdBikeulVwK9bWKg5ZFbClJ
	 5mU4P6QDPysfUQiWMNAio/0VnmChQMA3JFQoBszHnLxoPqDHhhJGRvNYxIy8kTGSojSbS
	 Vef886gLJc4DkGG4sKcNS9cw9uO9e1p5CU1W6A5Ns66M2Yg2+uuAvSfW1M74PTeyru8ug
	 IQkPgZ4WyXHhsUPocHN0/elT6fYf0mAxouDW+VX00AktqvcQvyZ0njNiurLJHs3BF1w==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=gPeiVal1;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 80B84606A320;
	Thu, 19 Nov 2026 01:13:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=gPeiVal1
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CC78B1F000C4;
	Thu, 19 Nov 2026 01:13:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795050820;
	bh=+CSzk/cIP6+haQsyPR0fnBHAZHgLHviw4fVjMrgo1HM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=gPeiVal1EMDm0PLiwfVmRX4LSLDzaP0nLfwNOJNOhH7m+hfQzghr8GrdMC4Rhhr2S
	 pycqa/2X5cCtazRs+mLjqxJ4m7J20fSp4qs68agGti64/zXvFiT1fB90tYIcoKCcrV
	 Fl65E4sgWlRuuPtHArB3HrnKHA7LgRPvQ1+HnZkc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Josef Bacik <josef@toxicpanda.com>,
	Jens Axboe <axboe@kernel.dk>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 2804/2857] block: partitions/mac: compute the sectors in 64 bits
Date: Wed, 18 Nov 2026 16:03:58 +0100
Message-ID: <20261118150342.553837419@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150201.293410965@linuxfoundation.org>
References: <20261118150201.293410965@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Josef Bacik <josef@toxicpanda.com>

[ Upstream commit 6c55f94317249bc195e197f6a8730c843e72ea8c ]

start_block and block_count are converted to 512 byte sectors in 32-bit
arithmetic, although put_partition() takes a sector_t. With a block size
above 512 bytes anything beyond 2TiB wraps and the partition lands on
top of another one.

Fixes: 1da177e4c3f4 ("Linux-2.6.12-rc2")
Signed-off-by: Josef Bacik <josef@toxicpanda.com>
Link: https://patch.msgid.link/20261028164415.1262013-43-axboe@kernel.dk
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 block/partitions/mac.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/block/partitions/mac.c b/block/partitions/mac.c
index 6415213cd184e..f07f01dfe6287 100644
--- a/block/partitions/mac.c
+++ b/block/partitions/mac.c
@@ -95,8 +95,8 @@ int mac_partition(struct parsed_partitions *state)
 		if (be16_to_cpu(part->signature) != MAC_PARTITION_MAGIC)
 			break;
 		put_partition(state, slot,
-			be32_to_cpu(part->start_block) * (secsize/512),
-			be32_to_cpu(part->block_count) * (secsize/512));
+			(sector_t)be32_to_cpu(part->start_block) * (secsize/512),
+			(sector_t)be32_to_cpu(part->block_count) * (secsize/512));
 
 		if (!strncasecmp(part->type, "Linux_RAID", 10))
 			state->parts[slot].flags = ADDPART_FLAG_RAID;
-- 
2.53.0



