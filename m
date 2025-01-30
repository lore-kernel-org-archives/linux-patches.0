Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 23BE91DDC22;
	Thu, 30 Jan 2025 14:25:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738247101; cv=none; b=gjyWJ/OU4aidjyfqXqU5Yarx5LSE12wmd9iTxNOi42UGI+vD3k5pP1y9GQljUXTjB+qBOm1BPugZMN5RZdiEwihHG97t8pqAsPW4CvSoiA9Wk5vlF9hljdlF801X0KprKgTZeEgjPy7wYVD8UUf5H8Rvzd6GdxuqtBSX62nhKjc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738247101; c=relaxed/simple;
	bh=nPfpUEhEMbgAeaadhogWbOXiIDD52axYu1AXQpHIEOU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=peR49Qr5o3RIN+rFdUx5PEnrYdsTWwU1B28hT+tsMk/08PQRQz4PMC+SC6xeSoEUY1jxXhq3bmupphHKt7kbWANvknGGxuW4KMdX9oYafcegaggALQuYLyzNHEL7eXEX7mY9/6uS7ypvjnAUCWl+vQlLqRsGKZ1ucXbRwhdctGs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=2LJctpbp; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="2LJctpbp"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A70BFC4CED2;
	Thu, 30 Jan 2025 14:25:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1738247101;
	bh=nPfpUEhEMbgAeaadhogWbOXiIDD52axYu1AXQpHIEOU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=2LJctpbpHhebXtx6eaDdHIC4v/Pvf9u8v+dWwsnpUdCxFDHcp8lPbTjx7yf4RBfW3
	 JgwRe7JLjJGdDed+CSy42Z0wGxQTxXnvycHgA02VBdZC1UPBFgnZFoLxsZvL+Rwint
	 4cn4BWfAuvaR86FnNER8O32xgwQajCC7/wlfOpWY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Ma=C3=ADra=20Canal?= <mcanal@igalia.com>,
	Jose Maria Casanova Crespo <jmcasanova@igalia.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 082/133] drm/v3d: Ensure job pointer is set to NULL after job completion
Date: Thu, 30 Jan 2025 15:01:11 +0100
Message-ID: <20250130140145.823285670@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250130140142.491490528@linuxfoundation.org>
References: <20250130140142.491490528@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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
index c88686489b888..22aa02d75c5cc 100644
--- a/drivers/gpu/drm/v3d/v3d_irq.c
+++ b/drivers/gpu/drm/v3d/v3d_irq.c
@@ -103,6 +103,7 @@ v3d_irq(int irq, void *arg)
 
 		trace_v3d_bcl_irq(&v3d->drm, fence->seqno);
 		dma_fence_signal(&fence->base);
+		v3d->bin_job = NULL;
 		status = IRQ_HANDLED;
 	}
 
@@ -112,6 +113,7 @@ v3d_irq(int irq, void *arg)
 
 		trace_v3d_rcl_irq(&v3d->drm, fence->seqno);
 		dma_fence_signal(&fence->base);
+		v3d->render_job = NULL;
 		status = IRQ_HANDLED;
 	}
 
@@ -121,6 +123,7 @@ v3d_irq(int irq, void *arg)
 
 		trace_v3d_csd_irq(&v3d->drm, fence->seqno);
 		dma_fence_signal(&fence->base);
+		v3d->csd_job = NULL;
 		status = IRQ_HANDLED;
 	}
 
@@ -157,6 +160,7 @@ v3d_hub_irq(int irq, void *arg)
 
 		trace_v3d_tfu_irq(&v3d->drm, fence->seqno);
 		dma_fence_signal(&fence->base);
+		v3d->tfu_job = NULL;
 		status = IRQ_HANDLED;
 	}
 
-- 
2.39.5



