Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795028255;
	b=BebIL82VYIeGGflvMONFr4W2oaM/nAFJK9Lu1+H5QjsZIln4mPyhwpuPhPK1aHS8eZZF
	 qVi7qJJFcJEtjX9x+nIpa8+fIX/RYd4LfrldMygVeqN6pAw6uhg7/+kHqatPr2jJui9YP
	 bWA8MJRenPfsC3TM9n0IjxAYRYsCnRE9caZIlZsb7bUcY+nXSYYo4yGv1XIJx126LJkGT
	 MfGIa2a5mSySZ218fbOViqsrNQAsMOCaFdcd7Bb86n9a5j3Ot9wm917kqX4RFhDh7BQck
	 PpC/nICtQL24lXaimRmFI75GQ26Mjz06ex7PkPb3Nn77C5aiyYGy382x1gmtVy84fXw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795028255;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=Ph4aVTfFZXU7GxmpoHvSmAvJYv/9yhFY4JyOyL1ZTLE=;
	b=D+CpoKaWwNTzebI10YvD/OiI0RNw2vffsPdz3wUJDnEaBHtCWWfBud6dMCeU1WQ2BEnT
	 lrSFhL97S8buTpF3SYzYjAu+sVG+/qlN9Y3b3B79xMAq4Ey+l7ljGojL9k5LTM0iqPp4p
	 IKZgS/pPNYQiFUCBfYA4GZsksnsceINJVW5fbkeY7m/BGjWelw5qIHXDJDHyhZjxtB2KW
	 oJmgZHZkwSPjr+ZdOfGhluTvVPpfi16peX7UhONd4b9lcf3dpKYX0NctZ/R5/y277EF0e
	 QGbhxkjBrrH39AIt1UY+idG1MUTJOBiyjyq3wTAsaDpVilcyFnbThfdEmD4xLB1yFkQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=uOoAoHLa;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A643F606A31C;
	Wed, 18 Nov 2026 18:57:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=uOoAoHLa
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F3EFA1F000C4;
	Wed, 18 Nov 2026 18:57:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795028255;
	bh=Ph4aVTfFZXU7GxmpoHvSmAvJYv/9yhFY4JyOyL1ZTLE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=uOoAoHLatDluqM3lR5RzLZ2+jMY4FxCNU7dw38pOKd2k8YrC6UnZ3F5MJgciVz5dd
	 KqvVoJDxu/ZzTl6q3mB5UHwvOGD/DlzC/M/pUJATsyKePW8OocWNC/hjwrjzDMYx//
	 5I63ZKw+dBE1BZnouUytBr5L6M+Str1zyYi/dsmc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Josef Bacik <josef@toxicpanda.com>,
	Jens Axboe <axboe@kernel.dk>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 2079/2151] block: partitions/mac: compute the sectors in 64 bits
Date: Wed, 18 Nov 2026 16:03:34 +0100
Message-ID: <20261118150237.445287168@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150121.603863898@linuxfoundation.org>
References: <20261118150121.603863898@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

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
index b02530d986297..f3bd95ee104f1 100644
--- a/block/partitions/mac.c
+++ b/block/partitions/mac.c
@@ -97,8 +97,8 @@ int mac_partition(struct parsed_partitions *state)
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



