Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 79E051E871;
	Fri,  6 Dec 2024 15:01:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733497290; cv=none; b=pfo4kpdq7qUdIQcbQy6F5V5pMrroFytY50JSPbgCvqmAuwnXLXyaZlz4Bps/L51AqytEWyqV2TFIRDI9clK17i+bmZJSJtO8Ovpw4lFw34tAWmUhcj0GG0WKbLbMVKfNj/zzNa2LHHeqH1CYAGCF0c7ZCCsKHZJHCVd0re4o02Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733497290; c=relaxed/simple;
	bh=RcuuvOUFA/B96MhW4Earx6SOs3pmM0BE6oWKW3pCWAg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=C1thxU0XtFZKjBU4tbugsqRwn8U8jL0AkMrdfB8vHqREo21kC9zyCBZdbQNPZcrtH/ELHH9CAGDB+7ItMUJeh+2PdLX5MJADzYTlkSaEaQj4ePCYrz7PrFzKwZr2hC3fiN4B2sW0kjaWft//fl0GnzEofI+ZMM1nVls5Mwz65+8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=1FE5sMbA; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="1FE5sMbA"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DC2FBC4CED1;
	Fri,  6 Dec 2024 15:01:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1733497290;
	bh=RcuuvOUFA/B96MhW4Earx6SOs3pmM0BE6oWKW3pCWAg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=1FE5sMbAAWPXyvj5nbHcQpW6EkKEbB+8752Bi7WZrsxVU40XNpZPERQP6LKinszYm
	 QkG25v7Fc9FAWwBEo+wftEcY7VtHczVBcps/7mJHJ1yxYuTmDP96rjgGSZ/9LJTCbP
	 Hb+w7W9JvA5biKA6pv9b4WXtMF3ou1W9sRWffP4c=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Christian Gmeiner <cgmeiner@igalia.com>,
	Lucas Stach <l.stach@pengutronix.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 218/676] drm/etnaviv: hold GPU lock across perfmon sampling
Date: Fri,  6 Dec 2024 15:30:37 +0100
Message-ID: <20241206143701.854258877@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241206143653.344873888@linuxfoundation.org>
References: <20241206143653.344873888@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
index 92d786f208979..ad543a7cbf073 100644
--- a/drivers/gpu/drm/etnaviv/etnaviv_gpu.c
+++ b/drivers/gpu/drm/etnaviv/etnaviv_gpu.c
@@ -1300,6 +1300,8 @@ static void sync_point_perfmon_sample_pre(struct etnaviv_gpu *gpu,
 {
 	u32 val;
 
+	mutex_lock(&gpu->lock);
+
 	/* disable clock gating */
 	val = gpu_read_power(gpu, VIVS_PM_POWER_CONTROLS);
 	val &= ~VIVS_PM_POWER_CONTROLS_ENABLE_MODULE_CLOCK_GATING;
@@ -1311,6 +1313,8 @@ static void sync_point_perfmon_sample_pre(struct etnaviv_gpu *gpu,
 	gpu_write(gpu, VIVS_HI_CLOCK_CONTROL, val);
 
 	sync_point_perfmon_sample(gpu, event, ETNA_PM_PROCESS_PRE);
+
+	mutex_unlock(&gpu->lock);
 }
 
 static void sync_point_perfmon_sample_post(struct etnaviv_gpu *gpu,
@@ -1320,13 +1324,9 @@ static void sync_point_perfmon_sample_post(struct etnaviv_gpu *gpu,
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
@@ -1337,6 +1337,14 @@ static void sync_point_perfmon_sample_post(struct etnaviv_gpu *gpu,
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



