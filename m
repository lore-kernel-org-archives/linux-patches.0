Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795042594;
	b=J+WqHqymE9dgXMA0hwchskp6bubTgZAG/s5tP6wN7zbyEb3EFg4OH3bpHyfgNiCU+sCV
	 GWAORKe2XgAnqef38mpjPjN88B9/KTHF4HIb2BD5ZlLKb5LnDP4r28CDf3cnc4tPMMhiF
	 Ha2KCA+M2Ht8PHmm4+R51mMPeJKLahHzfOwdr7mItX/XtKgjonSHz60Zp1MFDmvyJxO6Q
	 P99FptioFRAoOnxrKUJsSpBLMHWk6D75GMPT8tlXYYADH9jC5bO9CA03jdT1BEcUbzDSG
	 LIZtdi71vDcQIpy2KPSupX/4kx1VHxqzCWhssloGPpxPD3XNEBKg+Fd8sXLptIRg33w==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795042594;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=U9hEJK9UrntJbQpWzlwbub3SpMDfuTBea9kJzt2pcLc=;
	b=HPwoMTpFk+GM9u3f/wsF3leuKFWabrVfh/sUXckuawKDqmFmm3jSnZZlNpcnSsSAHIPV
	 ktRHGKa+QY7cNE0AZ22khBoAis6s7UWuoJ0fovc/hpcDaaEwN/IxzRGtZeBCetGkQ59Ec
	 b5Kk8qe7BlTcqk0NNMEA7ZTpQV/GbOatBnJokUc1u9uwJ0OfupU7xttxRuCq1AcW5vWU+
	 xaEJjBN2JPM98Pe8ivMZcH4x201JVPjnO2yxzhN0yPNs4Nee/D0KSFW74Y9VGtt7UCtaL
	 S3EjmNuH8k8K4zAQw+6hImYHr31l7W9+RKoTxJ9ZOrGDOWfS1o/dSuBPhANlw/Ww1dA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b="rH/vnt0i";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 08B9D606A31C;
	Wed, 18 Nov 2026 22:56:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=rH/vnt0i
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 569C31F000C4;
	Wed, 18 Nov 2026 22:56:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795042593;
	bh=U9hEJK9UrntJbQpWzlwbub3SpMDfuTBea9kJzt2pcLc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=rH/vnt0izonp9Df36LuRbttAfgEMTv8UZAZw9/b94SBpYrhlwnsJMVtpNhpANDUhN
	 T0VqDPy7p1F7nqbJbKUe7nF242H4StXPwm4rdURylDvbXhr3bsZpsLKSBMUC3cGgwN
	 G3mSffKMt8I2DDMSQcQOp5D9Z7uA0W9bNlagCRnM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Tejun Heo <tj@kernel.org>,
	Josef Bacik <josef@toxicpanda.com>,
	Jens Axboe <axboe@kernel.dk>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 3226/3318] blk-cgroup: fix root io.stat byte counts on 32-bit
Date: Wed, 18 Nov 2026 16:04:08 +0100
Message-ID: <20261118150456.497909809@linuxfoundation.org>
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
index 83bbc0c5448f3..c8183e384e894 100644
--- a/block/blk-cgroup.c
+++ b/block/blk-cgroup.c
@@ -1125,11 +1125,11 @@ static void blkcg_fill_root_iostats(void)
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



