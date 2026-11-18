Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795033086;
	b=FkBCIsgDHs/OjcgTpuRRNry6Az1ZEq2EL7VnNX6l38K+99xtaeRp/oq5HbHMljqr+rWh
	 TqvG0pcy8PTgiSbBOVlpvgEtI/8S5MgCCtGoHawIorxLuOe9bjdIp2koykp4/tJBn6i2q
	 cfG1kwfHR20oMS64xjhF2efPIbChCmjw8KvM996MWR9OIFVtYoQTajxqVJnrm0qa/Gk0l
	 Wp5vQu+RdrH+WgfI/UIf2BoIdO9RVukFepA1mXtT9tQpdJlfzhqFJ0R0OhXrP5oNXkb64
	 8QWRNT0TAc8ROCQwypn+tUSZQm0/gIHYV9e8UzGvqjSd047iqKycHQT4m/xkJgsKBvA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795033086;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=+FwOh0/907D/yQlani6S6qtxjLKG0/jSazcWiEYR8jU=;
	b=Szcy/m3juRGt84bAJV8RKZKxz40PA7L9KlCQ7n2Yj4SF2Q3ZM7oi6IrmA4VISMcmQway
	 DL275T7XhiFRO60aiLRDk73sjFFvw3+Bw4ys0EjuIWrzkPHY+zzJVBeWjpFEKpNOZ8YW0
	 XK29twMo9jGY/uVQhaizTunHqzKbaP9aK8bNbl0ntsY3DPOVGAI2SJ2fmajrqQnFt9O9r
	 HuyhoPXmrB4/MjIUJsUjpUIHUwo4mNq85FjPDgsAjhbSxPayHFdwBFpSyt8ypywShRjEP
	 J+TJxKuBVTEwu1wskkGnPt6Q7TncZeWywI2qiy35f8kBzRz0CqsvqC4XDBQP9fP4+oA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=ZqDyW79b;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EF8BF606A31C;
	Wed, 18 Nov 2026 20:18:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=ZqDyW79b
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4FD451F000C4;
	Wed, 18 Nov 2026 20:18:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795033085;
	bh=+FwOh0/907D/yQlani6S6qtxjLKG0/jSazcWiEYR8jU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ZqDyW79bt/38990VMAI29xBmKaDpJo4GMfOv/7uGe1U0z/VDC5NNt4+ih80OcMwwP
	 zj/0WyJd19YdBeZPDsHWvD530veWTwc+hvRSK1xa85lA8XkEyUbb1jMVFtBEaTNdHH
	 wnobViOm7fhvjAhFKCDmJ98vogLZjsJrnsqfUBVY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Tejun Heo <tj@kernel.org>,
	Josef Bacik <josef@toxicpanda.com>,
	Jens Axboe <axboe@kernel.dk>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 1640/1756] blk-cgroup: fix root io.stat byte counts on 32-bit
Date: Wed, 18 Nov 2026 16:02:47 +0100
Message-ID: <20261118150115.053972458@linuxfoundation.org>
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
index 06de4024a9a25..18b52ece07e82 100644
--- a/block/blk-cgroup.c
+++ b/block/blk-cgroup.c
@@ -1118,11 +1118,11 @@ static void blkcg_fill_root_iostats(void)
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



