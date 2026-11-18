Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795042685;
	b=Rp2TKGvgsodhJRVzJLQYmtAUtCuYGWNXcLjFFZrw6l8qe9YtJimrwD5mMaWfVPB4nZuK
	 oaP73nHryEYJ5yuCWerWVO0RbXNtQbLjHsv3EpTaVWPpYCtenmxWK1oq3XiZt8C3+M+jN
	 xzpy1AmGaQuA/CEzoCrcBA/KrVgEExNOOJgLvUlQxr/AQ25ESmp6cxMACIcD50eADZPG5
	 IJnXWk5xTqEIOjQNe0LrltVRLPis3MxR0g12CtoNPwY4s+eJ4OtXOEt1Xierw8nmWRgIm
	 Kkj6rwILhj32CJklONGUOFWU63DY0G2Ty38AloClWjf4gUYBffMIQjjFv3W1BBBtqSg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795042685;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=uDzdxzwwMaxHm2Rip0yL5JTHyU/IXFUtHs5H4dAwRNw=;
	b=R+wNGYEACTdxI04Dl+5DVE8E19qBJe8tJMe7yN0MAUcZDxe9VZCD9P+oCzea3bLTmaZs
	 BLfAInA771cyFcwdHjSMnYPhYi2LCbF4P1dJ6WCTpmuExFx6EMd5Qpa1vHTyo9pwyfNNW
	 LIyO9Ufw5G3hs5K9TBUK1z+WxtoVOWcQJV5Fb8onkKdTLvrs71w3T06A32uvHwRU9rS3v
	 Ozbl4bhtC700f5xFDtFph4yTco0rO7FpnBcS1wJ9yNHyqjyRdiU0KvJACxx5eGK/uQU1Z
	 4j+4B41ZJ/DQRyRv5dwVSg9tvVpZQvvbj6iOWucPp9G3W5Jj/Ya5HKm39Bc0U4H40nw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=05zr9pNj;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AC7DB606A320;
	Wed, 18 Nov 2026 22:58:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=05zr9pNj
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 035B51F000C4;
	Wed, 18 Nov 2026 22:58:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795042685;
	bh=uDzdxzwwMaxHm2Rip0yL5JTHyU/IXFUtHs5H4dAwRNw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=05zr9pNjeVt9i1VNUfAI5QvsmVerZ7OygjE/VBWSzr9q5sRgMjo4cEkbT+mhGTNkL
	 n8jn1OzjKDIr6SpExZgn3hINrsmWR2e7Sso2UuDrm9u63uR2ts6iGB/dkU5MrfvhrO
	 yHX8RTn2rwL2rgO686M90qisYFprIWwkGSKyd8xs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Josef Bacik <josef@toxicpanda.com>,
	Jens Axboe <axboe@kernel.dk>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 3260/3318] block: partitions/mac: compute the sectors in 64 bits
Date: Wed, 18 Nov 2026 16:04:42 +0100
Message-ID: <20261118150457.420569355@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150313.527275416@linuxfoundation.org>
References: <20261118150313.527275416@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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



