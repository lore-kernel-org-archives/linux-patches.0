Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 460A42D0C94;
	Sat, 12 Sep 2026 10:53:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789210381; cv=none; b=gzip2ud2Vn42HWaTX6P42SNIzq9aWYa5NKSxJJ6uG8WTUfmlKCDR01mivGmckuvv0QHnZYjVjvZSuSpjDztOOl2X7QuqXS0I1yrkey2+OHMD4cA5ehjykYEFLqgVMlt1gOU6RjjQU/KCsaiNEPqHkZPqT4iP1TuPzu+2H0EZlP8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789210381; c=relaxed/simple;
	bh=1INwCyBO0IhD8/k8NLBbvAaoMkhiw99RYrbf9gPX8B8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=VLiZACDQ7m49OsuGGfomJtqzYcOnyNQyebT57JbSGyN2dpJkKL2OIufJZ4i9fwXZLKsV2g8yGb0bw13pXRpVu0l0NNJl0eq1j18tVYfJvBhrhe1irr2FDUn3uB+/Vy1Cq6MSyiUg7dw60MnLOsZ5OUdq/uJBDxxcs3HnhpaK31E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=r4Ght54T; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="r4Ght54T"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F41231F000FF;
	Sat, 12 Sep 2026 10:52:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789210380;
	bh=Hg2pGMWzBIE9ibfrwLT1/kErnsWe7FTIaiqUDHh035Q=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=r4Ght54TfpBsAw5XSlXFdfH8+HA9p4aT80fDoaF4lZRQFRSY40IIdHl/4l/JWB/cY
	 zXaFDPEpyyx2JCYc7Dl5HWBzbMcSVhfs8bsNadX/5Dt4eOKKMvk6y4bHb8zZY1zu/w
	 OiDT0IPUmUa1A8DrEJzOdKLKjuDC+VaEzCclHzIE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jie Gan <jie.gan@oss.qualcomm.com>,
	Leo Yan <leo.yan@arm.com>,
	Yeoreum Yun <yeoreum.yun@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0971/1518] coresight: etm4x: fix leaked trace id
Date: Sat, 12 Sep 2026 08:52:20 +0200
Message-ID: <20260912065645.424524559@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065623.398859879@linuxfoundation.org>
References: <20260912065623.398859879@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Yeoreum Yun <yeoreum.yun@arm.com>

[ Upstream commit 467e5862ccb0eed907002f4c6d3badfe34360940 ]

If etm4_enable_sysfs() fails in cscfg_csdev_enable_active_config(),
the trace ID may be leaked because it is not released.

To address this, call etm4_release_trace_id() when etm4_enable_sysfs()
fails in cscfg_csdev_enable_active_config().

Fixes: 7ebd0ec6cf94 ("coresight: configfs: Allow configfs to activate configuration")
Reviewed-by: Jie Gan <jie.gan@oss.qualcomm.com>
Reviewed-by: Leo Yan <leo.yan@arm.com>
Signed-off-by: Yeoreum Yun <yeoreum.yun@arm.com>
Signed-off-by: Suzuki K Poulose <suzuki.poulose@arm.com>
Link: https://lore.kernel.org/r/20260725113645.57519-4-yeoreum.yun@arm.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/hwtracing/coresight/coresight-etm4x-core.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/hwtracing/coresight/coresight-etm4x-core.c b/drivers/hwtracing/coresight/coresight-etm4x-core.c
index a265586020ac8..ac0908a347132 100644
--- a/drivers/hwtracing/coresight/coresight-etm4x-core.c
+++ b/drivers/hwtracing/coresight/coresight-etm4x-core.c
@@ -880,8 +880,10 @@ static int etm4_enable_sysfs(struct coresight_device *csdev, struct coresight_pa
 	cscfg_config_sysfs_get_active_cfg(&cfg_hash, &preset);
 	if (cfg_hash) {
 		ret = cscfg_csdev_enable_active_config(csdev, cfg_hash, preset);
-		if (ret)
+		if (ret) {
+			etm4_release_trace_id(drvdata);
 			return ret;
+		}
 	}
 
 	raw_spin_lock(&drvdata->spinlock);
-- 
2.53.0



