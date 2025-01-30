Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 598051E98F3;
	Thu, 30 Jan 2025 14:19:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738246768; cv=none; b=QoBJCkjgFYnUl6WqZATuvbTPo8Zh1Gznfc4h8M+Ub/ZOwxQVBl+eA023TxNe51a/Kc/lKQ0eUqnzgTKFC4vzmHadPM9jPhoRnYEjJt4LnSeYIgb8UzNbssSiCYeMPwjmXAtehoU1Zavu/q8U3upwluL3XBt4+7ghz8PudcJmJ/I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738246768; c=relaxed/simple;
	bh=wcaOjBWqis6DlC5mbWXnJU7tK+QPgamDkIgpUR7m85Q=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=jNP7204USooG32AJ2rvob/KeC5nUQFgQCgjZLZQzW71AR7RCJUBp+dyBaaCIws9DlZGeBsS2pDW9uVjugPk0iJ9+Rt9rzNSti372rwN/mdThIrb7Tdl+11Jxk0m+uBUgXkk4oce8K9t4HrEsI9UuhNR4ZKyT9FwbdAclOZ7hFYI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=rzXG4xdH; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="rzXG4xdH"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DA0C2C4CED2;
	Thu, 30 Jan 2025 14:19:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1738246768;
	bh=wcaOjBWqis6DlC5mbWXnJU7tK+QPgamDkIgpUR7m85Q=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=rzXG4xdHU3KvmjHLUmVOUGPM0hYFVIH/G4sUguWErfcgUw4gNV/qjnNiAVRIUN+ly
	 xKkE5t+Rr0kdWwewHuGLoGBALgV/9UPy80jLLO2q4jyMzWpwNn5o3KdnPBHTABDHHl
	 kqUoWpy7Q2fzE0FhrxoCEjg5Yawp39utDRbQSoKk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Ma=C3=ADra=20Canal?= <mcanal@igalia.com>,
	Jose Maria Casanova Crespo <jmcasanova@igalia.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 61/91] drm/v3d: Ensure job pointer is set to NULL after job completion
Date: Thu, 30 Jan 2025 15:01:20 +0100
Message-ID: <20250130140136.123058408@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250130140133.662535583@linuxfoundation.org>
References: <20250130140133.662535583@linuxfoundation.org>
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

5.4-stable review patch.  If anyone has any objections, please let me know.

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
index 662e67279a7bb..aa27b7654dee5 100644
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



