Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AD9D22C80;
	Tue,  3 Dec 2024 15:49:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733240945; cv=none; b=dlXeCfBDAtvXvwvGW64a0EEianYARxoT1H3C8ZC6OfvTx9O8iG0/NHTDhfGnAML8ONoiW0jSKhD4I8CWOBWQ2AQnn3gdYNtX0OM75SU4yuY1G08K0g+DKB4ufEBmF1ar/D2BOEizpJ8qL6ouv7hpJrK5ctK3FbVPZmiY9zRh2Yk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733240945; c=relaxed/simple;
	bh=JAyEX4CSu2YbPJtkpNGYFrlhEHq5XGVtr6K/5eZdoS0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=jgnRm3OCwsixl1bQuu508/kF8XzfVui1UQ2DPjUVjKQD8akVd2y0giGi8R3G2UNrEShqzigxlSVFvT/mNxd45mbtYxAWU7Te0x6akktTsEsvLm0Q7rhuA/7rte2UA9U9jdboa4Jquzj8Ko3261exvNH7vljFdzrC/8JWxTiJnTY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=RKIcmHxo; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="RKIcmHxo"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EC167C4CECF;
	Tue,  3 Dec 2024 15:49:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1733240945;
	bh=JAyEX4CSu2YbPJtkpNGYFrlhEHq5XGVtr6K/5eZdoS0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=RKIcmHxobjKX83CSzhsefzhFXfL2Y5UFdtnmJI3P3MmZGdTnMhCWBIjs9QYlxrW3N
	 N0EZc24BSEgKRiXuHWkQ9L8qLqApfGsVURIxXp+JVzeUNx54uIBqkpeGsJEBdzHWu8
	 MaIjk0hUrIhzKl+/8nmgFeiGYPtDSeYU2nhZwwpU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Christian Gmeiner <cgmeiner@igalia.com>,
	Lucas Stach <l.stach@pengutronix.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 282/826] drm/etnaviv: hold GPU lock across perfmon sampling
Date: Tue,  3 Dec 2024 15:40:09 +0100
Message-ID: <20241203144754.771646477@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241203144743.428732212@linuxfoundation.org>
References: <20241203144743.428732212@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Lucas Stach <l.stach@pengutronix.de>

[ Upstream commit 37dc4737447a7667f8e9ec790dac251da057eb27 ]

The perfmon sampling mutates shared GPU state (e.g. VIVS_HI_CLOCK_CONTROL
to select the pipe for the perf counter reads). To avoid clashing with
other functions mutating the same state (e.g. etnaviv_gpu_update_clock)
the perfmon sampling needs to hold the GPU lock.

Fixes: 68dc0b295dcb ("drm/etnaviv: use 'sync points' for performance monitor requests")
Reviewed-by: Christian Gmeiner <cgmeiner@igalia.com>
Signed-off-by: Lucas Stach <l.stach@pengutronix.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/etnaviv/etnaviv_gpu.c | 20 ++++++++++++++------
 1 file changed, 14 insertions(+), 6 deletions(-)

diff --git a/drivers/gpu/drm/etnaviv/etnaviv_gpu.c b/drivers/gpu/drm/etnaviv/etnaviv_gpu.c
index 5e753dd42f721..df0bc828a2348 100644
--- a/drivers/gpu/drm/etnaviv/etnaviv_gpu.c
+++ b/drivers/gpu/drm/etnaviv/etnaviv_gpu.c
@@ -1322,6 +1322,8 @@ static void sync_point_perfmon_sample_pre(struct etnaviv_gpu *gpu,
 {
 	u32 val;
 
+	mutex_lock(&gpu->lock);
+
 	/* disable clock gating */
 	val = gpu_read_power(gpu, VIVS_PM_POWER_CONTROLS);
 	val &= ~VIVS_PM_POWER_CONTROLS_ENABLE_MODULE_CLOCK_GATING;
@@ -1333,6 +1335,8 @@ static void sync_point_perfmon_sample_pre(struct etnaviv_gpu *gpu,
 	gpu_write(gpu, VIVS_HI_CLOCK_CONTROL, val);
 
 	sync_point_perfmon_sample(gpu, event, ETNA_PM_PROCESS_PRE);
+
+	mutex_unlock(&gpu->lock);
 }
 
 static void sync_point_perfmon_sample_post(struct etnaviv_gpu *gpu,
@@ -1342,13 +1346,9 @@ static void sync_point_perfmon_sample_post(struct etnaviv_gpu *gpu,
 	unsigned int i;
 	u32 val;
 
-	sync_point_perfmon_sample(gpu, event, ETNA_PM_PROCESS_POST);
-
-	for (i = 0; i < submit->nr_pmrs; i++) {
-		const struct etnaviv_perfmon_request *pmr = submit->pmrs + i;
+	mutex_lock(&gpu->lock);
 
-		*pmr->bo_vma = pmr->sequence;
-	}
+	sync_point_perfmon_sample(gpu, event, ETNA_PM_PROCESS_POST);
 
 	/* disable debug register */
 	val = gpu_read(gpu, VIVS_HI_CLOCK_CONTROL);
@@ -1359,6 +1359,14 @@ static void sync_point_perfmon_sample_post(struct etnaviv_gpu *gpu,
 	val = gpu_read_power(gpu, VIVS_PM_POWER_CONTROLS);
 	val |= VIVS_PM_POWER_CONTROLS_ENABLE_MODULE_CLOCK_GATING;
 	gpu_write_power(gpu, VIVS_PM_POWER_CONTROLS, val);
+
+	mutex_unlock(&gpu->lock);
+
+	for (i = 0; i < submit->nr_pmrs; i++) {
+		const struct etnaviv_perfmon_request *pmr = submit->pmrs + i;
+
+		*pmr->bo_vma = pmr->sequence;
+	}
 }
 
 
-- 
2.43.0



