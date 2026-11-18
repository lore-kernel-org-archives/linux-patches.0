Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795028145;
	b=sGR7VFRwt2AI+oa5pbVaJ7qPAHyWDK5gODSO/wvP2Sm8e39RKMErvTt5vD5k9LJwS05B
	 XBThYJky5GYQdaULyyc8csqGTB9zcp02wong2SyGgbbcPH0nXyq0NyRKDyqr86UjkJgEJ
	 4inXY5cqzlUdZvA9nd524+d1d+11f0ol9sfip7MygeY+rpM2lLd9BksAi0EJMQaM0TA3g
	 HgsyXvKvUihUINzetkKKB4CJC9yTrcZM7QnwLxO6neYNfUQ8Yz8IVZuk3P+yNJ5fvlAak
	 tm/Ko7C+xJwYbt5MftnrGYtR8efIbGcr3br5k9MMfqWddNZsEyrjmKZZFSjL529V/nA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795028145;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=65pSAh5tVFelRsfn9yRU+5Corir30a4McnuRBqpaaXE=;
	b=evxAID84V+sz/wTjl82KYRbse9MBLZaJ8pVP+ID3w0ckL5Zd7wJ131vkNYJDP7FXWa6j
	 N5KB2Vc2EewrerII1T6AQJpltGkQm9GPDG7wOVZAJR1Ka4a7UHAi8zROV/ybMQx9kiIb+
	 cct+PrExX8P+rIKrRilKwbuQD+6nrgjzqfqLReduxS8LajPOg/2eYLMSuUucVGVOcG7me
	 KHYkko8uiyqWCebkHCq6kiJ7i1HiBl1Y0fEx1VwSRhc/dI1qgrwwjSYN0eDfYj30lqDR6
	 41gyydAZGCfJMg8ZhA2dvGP/tLSdTcv1b0/6hjCH9ISpG0ZMhr67rY7mJUgtNTDZSGA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=irqhOuYX;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0DCCD606A31C;
	Wed, 18 Nov 2026 18:55:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=irqhOuYX
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5E3521F000C4;
	Wed, 18 Nov 2026 18:55:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795028144;
	bh=65pSAh5tVFelRsfn9yRU+5Corir30a4McnuRBqpaaXE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=irqhOuYX+tOZ0PMHIzxf/YABOOG7lBfDR4Y3UwYUv7Ny1+5jF5TthqeuYIdcQ2HM+
	 OYpDh90xb2+8cuySShhnjSuugs8QnKBlqTHbqJWy4AK+OMRklR93/nbJiH4BzbL8G+
	 AhAQcAWeKm9NOd6giFyiRW8xfH7ktL++0hoIK7uI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Tejun Heo <tj@kernel.org>,
	Josef Bacik <josef@toxicpanda.com>,
	Jens Axboe <axboe@kernel.dk>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 2039/2151] blk-cgroup: fix root io.stat byte counts on 32-bit
Date: Wed, 18 Nov 2026 16:02:54 +0100
Message-ID: <20261118150236.006220977@linuxfoundation.org>
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

[ Upstream commit e335b853d919f2c6246ca0993115285742a2acc1 ]

blkcg_fill_root_iostats() shifts the unsigned long sector counts by 9
before adding them to the u64 byte counts, so on 32-bit the contribution
of a CPU wraps every 4GB. Widen before the shift.

Fixes: ef45fe470e1e ("blk-cgroup: show global disk stats in root cgroup io.stat")
Cc: Tejun Heo <tj@kernel.org>
Signed-off-by: Josef Bacik <josef@toxicpanda.com>
Acked-by: Tejun Heo <tj@kernel.org>
Link: https://patch.msgid.link/20261028164415.1262013-14-axboe@kernel.dk
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 block/blk-cgroup.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/block/blk-cgroup.c b/block/blk-cgroup.c
index 171efbbd3c8a8..ec52f9eff4069 100644
--- a/block/blk-cgroup.c
+++ b/block/blk-cgroup.c
@@ -1165,11 +1165,11 @@ static void blkcg_fill_root_iostats(void)
 				cpu_dkstats->ios[STAT_DISCARD];
 			// convert sectors to bytes
 			tmp.bytes[BLKG_IOSTAT_READ] +=
-				cpu_dkstats->sectors[STAT_READ] << 9;
+				(u64)cpu_dkstats->sectors[STAT_READ] << 9;
 			tmp.bytes[BLKG_IOSTAT_WRITE] +=
-				cpu_dkstats->sectors[STAT_WRITE] << 9;
+				(u64)cpu_dkstats->sectors[STAT_WRITE] << 9;
 			tmp.bytes[BLKG_IOSTAT_DISCARD] +=
-				cpu_dkstats->sectors[STAT_DISCARD] << 9;
+				(u64)cpu_dkstats->sectors[STAT_DISCARD] << 9;
 		}
 
 		flags = u64_stats_update_begin_irqsave(&blkg->iostat.sync);
-- 
2.53.0



