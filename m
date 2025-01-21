Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2D2AE1F543F;
	Tue, 21 Jan 2025 18:00:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1737482408; cv=none; b=K1l/Zr3uODLP2pzfvB7YNwDjfhStywX475fp/BGsyfdz4Fg83hlNN9lK0ozSAUvTRU8Dyl2pb+Ece2s9sPybTBCy8mjN8LCPqtG9fgo4AbvOI7sWaE9H/1JH79pqLoiIwo9/SqN8ZXaNgFYoFjOJyQ35FXrqzVzUCZxBIqshAoI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1737482408; c=relaxed/simple;
	bh=LlLsbX51iGabUdBiX5/0Qaf0ofJSS+0u2jl9/N4NmRM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=hfR7mN6aCrAJt3JO9zkm3Ve7FZB2mWNBmVHBZ2bIruar/OL/CjqTrEsU9jX1wP/Y9ZXltfaz0ucLu4RWX145GGI3Tdlp/DVBtjDsyPzh9EumyKNkJJbFh5fP98GKKND9PNBfectmmXVFxTvffgKBXPreoaq4cHVQs7EfA5cZwME=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=XEjzhCEw; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="XEjzhCEw"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AA1B9C4CEE0;
	Tue, 21 Jan 2025 18:00:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1737482408;
	bh=LlLsbX51iGabUdBiX5/0Qaf0ofJSS+0u2jl9/N4NmRM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=XEjzhCEwed3sdEPs4hC5xgc/aW5xIfufUNVnEPULzq9EQRUlM8iRz497ayF46dY/H
	 T6Qtccia+NO35PY8V4LV0pq95d6aznx9Jy9zjS7lrJCeQiUCMvs6LVSMkYoB5lqh4t
	 oaUWwNBmF7KIarHwMWhFUgoHuWdzwtK+K9UvK4IQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Ma=C3=ADra=20Canal?= <mcanal@igalia.com>,
	Jose Maria Casanova Crespo <jmcasanova@igalia.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 036/122] drm/v3d: Ensure job pointer is set to NULL after job completion
Date: Tue, 21 Jan 2025 18:51:24 +0100
Message-ID: <20250121174534.379364190@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250121174532.991109301@linuxfoundation.org>
References: <20250121174532.991109301@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Maíra Canal <mcanal@igalia.com>

[ Upstream commit e4b5ccd392b92300a2b341705cc4805681094e49 ]

After a job completes, the corresponding pointer in the device must
be set to NULL. Failing to do so triggers a warning when unloading
the driver, as it appears the job is still active. To prevent this,
assign the job pointer to NULL after completing the job, indicating
the job has finished.

Fixes: 14d1d1908696 ("drm/v3d: Remove the bad signaled() implementation.")
Signed-off-by: Maíra Canal <mcanal@igalia.com>
Reviewed-by: Jose Maria Casanova Crespo <jmcasanova@igalia.com>
Link: https://patchwork.freedesktop.org/patch/msgid/20250113154741.67520-1-mcanal@igalia.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/v3d/v3d_irq.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/drivers/gpu/drm/v3d/v3d_irq.c b/drivers/gpu/drm/v3d/v3d_irq.c
index 20bf33702c3c4..da203045df9be 100644
--- a/drivers/gpu/drm/v3d/v3d_irq.c
+++ b/drivers/gpu/drm/v3d/v3d_irq.c
@@ -108,6 +108,7 @@ v3d_irq(int irq, void *arg)
 		v3d_job_update_stats(&v3d->bin_job->base, V3D_BIN);
 		trace_v3d_bcl_irq(&v3d->drm, fence->seqno);
 		dma_fence_signal(&fence->base);
+		v3d->bin_job = NULL;
 		status = IRQ_HANDLED;
 	}
 
@@ -118,6 +119,7 @@ v3d_irq(int irq, void *arg)
 		v3d_job_update_stats(&v3d->render_job->base, V3D_RENDER);
 		trace_v3d_rcl_irq(&v3d->drm, fence->seqno);
 		dma_fence_signal(&fence->base);
+		v3d->render_job = NULL;
 		status = IRQ_HANDLED;
 	}
 
@@ -128,6 +130,7 @@ v3d_irq(int irq, void *arg)
 		v3d_job_update_stats(&v3d->csd_job->base, V3D_CSD);
 		trace_v3d_csd_irq(&v3d->drm, fence->seqno);
 		dma_fence_signal(&fence->base);
+		v3d->csd_job = NULL;
 		status = IRQ_HANDLED;
 	}
 
@@ -165,6 +168,7 @@ v3d_hub_irq(int irq, void *arg)
 		v3d_job_update_stats(&v3d->tfu_job->base, V3D_TFU);
 		trace_v3d_tfu_irq(&v3d->drm, fence->seqno);
 		dma_fence_signal(&fence->base);
+		v3d->tfu_job = NULL;
 		status = IRQ_HANDLED;
 	}
 
-- 
2.39.5



