Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795033183;
	b=my0ooadpOuS6xjWGQ7bZvYL9c6d3YQfSOLWfOs6JtYd0APT5uYUtIXJh+UklrlQs+9Uz
	 1FLcGN8zoKNCQnruhTHTIiLK0TAqHuzOVZWaYsAHY/SkvUTuRSkHOhJzSo1+tlY2jKrBw
	 WYEjSXD5TKnqi+nOnAjsYfOTtC86aJXeIYvOe0ljBW6GVWwPJ9n+qSwnx/VhLmI0E6nTb
	 T0/IuVAGwSDMgTkKar/0xG6J0o5Emjp8gZ/8AALqYdXzKC6V+5OJ5xiixlhTU+9y1qWu5
	 hVhglYokVgRBeI3t12Vy3cABSV1rF2mimHv1cZOahF++fGxWypOSx2t0wKofM+MS4xA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795033183;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=/XFlPtSCBtq9womdAcpBz2kf8/rCjP2tMIt+55eNoos=;
	b=o0ULMChX9KkaWEuq2v5xmDA1bTKLzmw3xa3K76TVqP4OCsa1daciAehmKkgTTSwp4vqG
	 EsAn3iU7PlE+TAgUKKN7Qpxa6Ykc3YS5HkXd5Lg4kVzLD0uMzj/PTyunBNsPIEYds0kSW
	 rLRsKr+AQMzV/SdvidLPYYBtnFT/j2nv7PrnWTxXD7g0iY1dmUVxL0bWlF5oGH7UPnmKw
	 DC5YUnADnsaFcv2QNep7kGxHhcSmZU8vccEqQKfAn6koMuGW9SLk7Idcq1c2X/a+JLgtb
	 reQ5F8n8VWRrbqVsfcExS5oRcmDCWvrHF6BqUxbmqVpmp1WZBXkZ/x1/U+o438+6qBg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=qPSXk+Iu;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 296CE606A337;
	Wed, 18 Nov 2026 20:19:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=qPSXk+Iu
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 821341F000C5;
	Wed, 18 Nov 2026 20:19:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795033183;
	bh=/XFlPtSCBtq9womdAcpBz2kf8/rCjP2tMIt+55eNoos=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=qPSXk+Iu95032SNuNT6C4RD8aOYeWe5wr3R1PlR9r4s7P+4FstG5oal8WyFZy+Mcj
	 J3tR7OPvLRXJgnR+TuC4fXuUxWFVjeEAj1vD12BoGTcG1c2yDUnpwy4Lhg59OJMYxk
	 iozU88iUp//m8pyiXehOAmlQgyqDK3V8QNRxrOuA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Josef Bacik <josef@toxicpanda.com>,
	Jens Axboe <axboe@kernel.dk>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 1676/1756] block: partitions/mac: compute the sectors in 64 bits
Date: Wed, 18 Nov 2026 16:03:23 +0100
Message-ID: <20261118150116.393876835@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150007.957976754@linuxfoundation.org>
References: <20261118150007.957976754@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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



