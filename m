Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2CF2E1F8920;
	Tue,  3 Dec 2024 15:08:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733238509; cv=none; b=uRbNU8E+ZpKc6+Vx87l0IcsX113ZQDPRgllzBorFrZ0wXJpyfhtKEhwiGeHAl4HiOXXupAsNrTCvD4N2nJuPLlameYVKe04trLgibJKa4FEG5a43qaSY40gd4sNeu+pdSNAxTenRjIpIXyue20IOFzOr1SOQs2XmnQ1b0/Umm5o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733238509; c=relaxed/simple;
	bh=/us5a+khO6mpRbXwPwe9iMHglI0MIWEErdpKN1wMZuo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=bNsiDLntCVRgkaHvMrLSee9I3VAqVLVnnDY5+kYr5erVvSzmqd5w9pQbVDJRIRD9/jG8yqxGUwo8znWmUMOjpS53S+kTHUoqfhUXxAs8H0e0ZiD9jiHHd1srHDa6v7Aj+NsslcR15AFE50QIXupAeYeCq9RqzsYzQaeTksAmB3k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=dwqydjVT; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="dwqydjVT"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 58F79C4CED6;
	Tue,  3 Dec 2024 15:08:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1733238508;
	bh=/us5a+khO6mpRbXwPwe9iMHglI0MIWEErdpKN1wMZuo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=dwqydjVTCyQV35cKE+0PlSz9vKp8tMaC7P2n6OGPvJYAAwbrFL2SnUiIpTmoWFixR
	 cWhCmtX1Gurld24PGDoY4S/zJWpnGwO0ai/F9VuJYqjZzmdv0IhYaxmSH19EB5lhcH
	 H2YSbdPzCsmrUb7BOIwTGZNxSSQR6bkZjXMTf9A4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Christian Gmeiner <cgmeiner@igalia.com>,
	Lucas Stach <l.stach@pengutronix.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.11 300/817] drm/etnaviv: hold GPU lock across perfmon sampling
Date: Tue,  3 Dec 2024 15:37:52 +0100
Message-ID: <20241203144007.527278701@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241203143955.605130076@linuxfoundation.org>
References: <20241203143955.605130076@linuxfoundation.org>
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

6.11-stable review patch.  If anyone has any objections, please let me know.

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



