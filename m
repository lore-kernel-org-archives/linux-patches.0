Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 04F9820A5EE;
	Thu, 12 Dec 2024 17:40:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734025241; cv=none; b=O5O2AdBxoNYWpKHKU7feMo89WBnTyH1RsWYoyqIKtgUUyCXfXsLPzD8k/lgKBLIvfPtD158RckIwbYazwbnnmHyCDJGS0cJ2akUJKRqEaaYJC+rumBfiuhnwWjztSB3L+6ILPNvcfpSobBHMhl+YVcahzqs6Xl6orhju6ebM1Yg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734025241; c=relaxed/simple;
	bh=oPTTpPzd9F7sWdEkUcJLu72/+DS3KSS1mm28xOaLCpM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=HbHH/RHtRDuw8D8H9JxZugP3OVwKwZtA5imAi4YcfNRkCGzeEbKYy2BCawXsIjV8CL86WkhoJ5Q3YiJ0bvWSU9Xou9CMnTrjEQ6LpKQOt8MewZ1GWqqtbdx8BWw4poGGfuCBE+sc7cytWBHsf5z/ECNAsPPnlT724yR84AA9Xzg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=gk93dhzV; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="gk93dhzV"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 800D1C4CED0;
	Thu, 12 Dec 2024 17:40:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1734025240;
	bh=oPTTpPzd9F7sWdEkUcJLu72/+DS3KSS1mm28xOaLCpM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=gk93dhzVdi4JZvjy12dTQg+m9IHDVF+7H34orMtNVqplLCbGGJ7nYqoYB8Fr9SKRJ
	 KS7jScJzx3ZFN355so4ZnkenjvMJ/w5HorFNLwEK6UQqwKdUxm4xtRRxi/rzUDwk7y
	 3c2r0dXLgVnrpAqdvry8AzxFbVLE2XqqGLxLT9QY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Christian Gmeiner <cgmeiner@igalia.com>,
	Lucas Stach <l.stach@pengutronix.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 076/321] drm/etnaviv: hold GPU lock across perfmon sampling
Date: Thu, 12 Dec 2024 15:59:54 +0100
Message-ID: <20241212144232.991368892@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241212144229.291682835@linuxfoundation.org>
References: <20241212144229.291682835@linuxfoundation.org>
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

5.4-stable review patch.  If anyone has any objections, please let me know.

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
index 7b49d3b0840fe..f8e5994bf8161 100644
--- a/drivers/gpu/drm/etnaviv/etnaviv_gpu.c
+++ b/drivers/gpu/drm/etnaviv/etnaviv_gpu.c
@@ -1236,6 +1236,8 @@ static void sync_point_perfmon_sample_pre(struct etnaviv_gpu *gpu,
 {
 	u32 val;
 
+	mutex_lock(&gpu->lock);
+
 	/* disable clock gating */
 	val = gpu_read_power(gpu, VIVS_PM_POWER_CONTROLS);
 	val &= ~VIVS_PM_POWER_CONTROLS_ENABLE_MODULE_CLOCK_GATING;
@@ -1247,6 +1249,8 @@ static void sync_point_perfmon_sample_pre(struct etnaviv_gpu *gpu,
 	gpu_write(gpu, VIVS_HI_CLOCK_CONTROL, val);
 
 	sync_point_perfmon_sample(gpu, event, ETNA_PM_PROCESS_PRE);
+
+	mutex_unlock(&gpu->lock);
 }
 
 static void sync_point_perfmon_sample_post(struct etnaviv_gpu *gpu,
@@ -1256,13 +1260,9 @@ static void sync_point_perfmon_sample_post(struct etnaviv_gpu *gpu,
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
@@ -1273,6 +1273,14 @@ static void sync_point_perfmon_sample_post(struct etnaviv_gpu *gpu,
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



