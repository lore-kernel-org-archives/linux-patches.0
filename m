Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B8DBB478E25;
	Sat, 12 Sep 2026 16:32:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789230727; cv=none; b=WQXTgMH0iOiwZGFnQTNt+h0Xi6Hb2o43K/RaifwahHEtMsrnL7vEI3zkLvPvFbQ0/Ierv5QjhUHuJIzg9GiOO8JRRT6YimU1mnBstnSoHFxeucRItKf+3JGyf8XXzsxP7CNELtrt7ofIA8+73RiZIAJbKueR/7YvCGbpfShdgIw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789230727; c=relaxed/simple;
	bh=EJk7Nb9QKO/J9GVi2UTssvsBet/f83/wez6+cGw62M0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=KE95OOIc79mlYu9ajst35RXvWB+abizg1UMImVRusp9iEM0J56jUU850NQf1RSdAzdz7DWS+WePNioD6kwyjtSFRb76KmqirL1SUWPfUJpFVADaiUTpgLBZDOTwvoF8I3QBA862+P8ITZixmvRehUiECBq/VqA72J2ecsgR+1j8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=xLMuPWzp; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="xLMuPWzp"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0D8A71F000FF;
	Sat, 12 Sep 2026 16:32:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789230725;
	bh=9sCoxdcU/z0QfZs39GIkNdXvyb5QI6I9dD4NXZ2wH/Q=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=xLMuPWzpGYc/ViHwGGB+Hv4oR1WLNv/qdZFHw0pARJosopdQsE1WKNgq91HvzFYXs
	 CikYekJ0jRFaAfsP9uRCtBXcZbQpWVYhk9oGb6/PWyieE3D0/NyDzu3ADELPzoLsJw
	 bogpDaCINrH1kFgep7ST59GPtKZL2uYHTkOhMng0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Tao Cui <cuitao@kylinos.cn>,
	Yu Kuai <yukuai@fygo.io>,
	Jens Axboe <axboe@kernel.dk>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 0853/1191] block/blk-iocost: collect per-cpu latency stats over possible CPUs
Date: Sat, 12 Sep 2026 08:59:41 +0200
Message-ID: <20260912065607.413783053@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065548.086904252@linuxfoundation.org>
References: <20260912065548.086904252@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Tao Cui <cuitao@kylinos.cn>

[ Upstream commit 4e050c5b92c1600415b2cd452583e543036f3d73 ]

ioc_lat_stat() walks ioc->pcpu_stat with for_each_online_cpu() to
compute missed-ppm and rq_wait deltas.  An offlined CPU is skipped, so
its delta is dropped from the period and its last_* watermark is not
advanced; on re-online the next collection sees a delta spanning the
whole offline interval, corrupting the latency/vrate picture.

Fixes: 7caa47151ab2 ("blkcg: implement blk-iocost")
Signed-off-by: Tao Cui <cuitao@kylinos.cn>
Reviewed-by: Yu Kuai <yukuai@fygo.io>
Link: https://patch.msgid.link/20260720093726.28965-4-cui.tao@linux.dev
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 block/blk-iocost.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/block/blk-iocost.c b/block/blk-iocost.c
index 20993d79d5ccf..93482cc420c97 100644
--- a/block/blk-iocost.c
+++ b/block/blk-iocost.c
@@ -1587,7 +1587,7 @@ static void ioc_lat_stat(struct ioc *ioc, u32 *missed_ppm_ar, u32 *rq_wait_pct_p
 	u64 rq_wait_ns = 0;
 	int cpu, rw;
 
-	for_each_online_cpu(cpu) {
+	for_each_possible_cpu(cpu) {
 		struct ioc_pcpu_stat *stat = per_cpu_ptr(ioc->pcpu_stat, cpu);
 		u64 this_rq_wait_ns;
 
-- 
2.53.0



