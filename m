Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B47911F8EFB;
	Tue, 21 Jan 2025 17:56:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1737482172; cv=none; b=nW730j4BijV2u1shh/0w56D3A4B3zflbBBOwGh+OCOLaj0BTvwz/f3jolQ5mFNFXE5IJm1wE9Cm9g1EtTWJnZoeIHGoQbS7I6hWrb20MYmLg8uC20QdkN4TK6xbp7GqwdRX3Twi00JTde3WmTbimhsTAHP1V+UUgUo3VOeRiM80=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1737482172; c=relaxed/simple;
	bh=2fZ0zs0fvlydzVFjrJsl1AVbHrZp7fEshKQTFgo4Snw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=bwNzIVH5bMP5SiuXZh/yvPQqS/GFmUAUlteyn6Ey0B9/mpGR1qT8bbyTxfQuhP4m6LVGqtT23h5fIO6dwMlgGoBfnZ9WiZuyIvnNOBgEG9MoTdUtGqwKhmI9MjtL0DAQVvwiYaGTcTdhGY1FHP8P5343PUwlwpTE5tbaO/vsOlc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=o+f/f+cr; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="o+f/f+cr"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D9FA5C4CEDF;
	Tue, 21 Jan 2025 17:56:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1737482172;
	bh=2fZ0zs0fvlydzVFjrJsl1AVbHrZp7fEshKQTFgo4Snw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=o+f/f+crP/A8JpAuzC7kgG3Z06pyEuUND0xe4qx+IiTzhCsHKnL0b3BhzIaRHH3+F
	 1m1d7W5TvBKQVaD39DAd7144m8Z2C5XO/XALHYlcXXGBDdBmRDFEXlBjOMUcQBVhbG
	 mbd2CHnkcLGZ+9xQpLCoBf58DbWC/Jy2gtxItM58=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Ma=C3=ADra=20Canal?= <mcanal@igalia.com>,
	Jose Maria Casanova Crespo <jmcasanova@igalia.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 18/72] drm/v3d: Ensure job pointer is set to NULL after job completion
Date: Tue, 21 Jan 2025 18:51:44 +0100
Message-ID: <20250121174524.129586426@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250121174523.429119852@linuxfoundation.org>
References: <20250121174523.429119852@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
index e714d5318f309..76806039691a2 100644
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



