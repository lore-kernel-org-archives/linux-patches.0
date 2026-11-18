Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795062172;
	b=VmmH9t1XsU81tqc8+DxCUV2SzK38RX+0/Q7Exozm9pT+xDLcol6PKhRA1os/GjyEItAv
	 nZsCQOiAhzOI+K47cxwFlmnj5g3g6uvXqnmYlHOBX1kZZz5H6GoU9dQSUTvgfL8NE06wK
	 2XobBHrbHIEESlth/BM6fKw6/Br3Gn0Js87SRDOqNqQGIjYE940es10sIcE4mavSYWV+W
	 ef1OygAXbKSeIszRRfY4SQZd1OCLzeK/UObIIOd6+3krXvM5SwM4uAh98wkS6oVNK2KaE
	 F/vduySG4fwru5+n1zuSCjfksse5+hsIry8ERpL/5qyossschP2RoSZNdaFcklZZ4gA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795062172;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=F9QRhu9mLReF6L3ZHOpaEGZ9+m2jHY5B2IST/Ty3+68=;
	b=iKQIGRqH0lwyuCQJhL2TYvfwcV3KsDGbjgdF+BaZNbZvCR7F1G4Ry1CnIgYAJvy0pNwU
	 qmtRWahfz9nz+m81GLA63+eiVey0eqnrqPv24vXO/qRqIpVOTfnJfdEL+Se3zd5fNB+zZ
	 wHtjr4X7Wk2rF77I9bsBhKGLBpGCyjcCDFLe30Lm0brc7nP0p+TsR1Rzgp0lape+YHzY+
	 eJToKKH9JdSX1g1swRnwklEzseqi+esENdvsaQ5KOdJvcjAhTqqmXLSjVO370ZZx5Cyht
	 ndOa4PIB6xtz32iTvef8ys0y9fbbp3G3FdJ5hObPghOzXqZVjOCqjZEZxaSlnAWMzKA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=iHk9KdUU;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 115E760A2602;
	Thu, 19 Nov 2026 04:22:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=iHk9KdUU
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2E25F1F000C8;
	Thu, 19 Nov 2026 04:22:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795062171;
	bh=F9QRhu9mLReF6L3ZHOpaEGZ9+m2jHY5B2IST/Ty3+68=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=iHk9KdUUeBYnHT6xlfZe3M4D+azIFAAMMkt9aNnyotE5aCIQAbZKGUSdb+yjv/J89
	 3NTOnsWDLXRaaqduDZAYqFM2vI73Z5YkO1flYSZYNyYhUEMU5jr+nYJTbNxO00ymeJ
	 tDU/dUO3JCmvIex7Lo2PMiHs4vdTbn2MPlPP3SRw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Josef Bacik <josef@toxicpanda.com>,
	Jens Axboe <axboe@kernel.dk>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 1813/1848] block: partitions/mac: compute the sectors in 64 bits
Date: Wed, 18 Nov 2026 16:04:11 +0100
Message-ID: <20261118150035.358468043@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118145911.150052362@linuxfoundation.org>
References: <20261118145911.150052362@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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
index ca619d8527572..47a16839f3ce4 100644
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



