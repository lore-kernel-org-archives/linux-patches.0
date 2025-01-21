Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 00EA91F3FFE;
	Tue, 21 Jan 2025 18:03:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1737482610; cv=none; b=OU4gbF6LPeetXQCMVzJtgtWzGfU77mNfiR7xZ+WCxblWnOLszmYbbUs9OjYTfEwUwwknDFXEdHTUD7fmsnHyiublBKJgIab5IOSz9RpkDgcfYXstJ3neL+SoXvSK3h3aFKFok81stCyH4Oaw/uTh79ZDFiSmokVUvxsdIggmM9s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1737482610; c=relaxed/simple;
	bh=fH76gxSMNDMeIszm1ksHI7vefpF97Cy0KiPmMZFLxrY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=WxEWaNXQLuUkMIV/8gY1H6EPlWGpYjwWZPA0O5TEZlg0SuGwVRop6rWkDR3HmOItl1X40XWGfoSlhjKI3W2/C3HoxOe4rzlKItcDXnGXSi1f4MAN+r41wdFQkW3NYA6vKvJ6GIQk7VKYQOU3zj5Otg3r65bmLiHDX+G3tglLwZE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ZwbKU4OT; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ZwbKU4OT"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7A1D7C4CEDF;
	Tue, 21 Jan 2025 18:03:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1737482609;
	bh=fH76gxSMNDMeIszm1ksHI7vefpF97Cy0KiPmMZFLxrY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ZwbKU4OTHydzOLwliQrPC7a9ZP0INsZYcK3bC13P3fhvsyGObHZdfFe6Ygi6TSd8X
	 Ju7KNdkBCkeQO68GBLVqBDV1Mib3WtU9kEZiBY0ebm0BcaW60yhrg0JvsIhXLAqemi
	 SrgC2EHg/hQOLBvqRNxSazH/8zN5XcyiaqfkO9HA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Ma=C3=ADra=20Canal?= <mcanal@igalia.com>,
	Jose Maria Casanova Crespo <jmcasanova@igalia.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 13/64] drm/v3d: Ensure job pointer is set to NULL after job completion
Date: Tue, 21 Jan 2025 18:52:12 +0100
Message-ID: <20250121174522.069175809@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250121174521.568417761@linuxfoundation.org>
References: <20250121174521.568417761@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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



