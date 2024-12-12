Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A136213CA93;
	Thu, 12 Dec 2024 17:17:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734023857; cv=none; b=EGRioiTLh6TN/lQ/mHPmXi1smhg6skv8AGvB18+KBc0WC+fv6Ew2If6K0SsKd0tJEvJ2nzTuS08JmQopSAii1jLAND7gIHNwgwrg52uRZVmUvMhOaR6o4P+IuaqpyHXb6/J7JY0zE1+ZI/NKh4VD/gwCTIeUtJpMYVpl6SPcx8E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734023857; c=relaxed/simple;
	bh=XwSK6Uo5KLjaWWZrMR14vIq2pRFtIB9Fi3x6Qb5q648=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=DezHvdvJb7UEPGpY+E2Xn09O6BLMoblVyWvW8k5It5XnklCeaiebKeNKPWsuncv7apM40Ud3D29xTtUqN5gpSODK3k+yj690rYzZYTRVwUWundPHL2M+BZdI7R/+CI0YmplKo3Dd3/YVt+2jHBUB5dvNZZISl3UwaozaLAL/VoY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=MV4a8P4n; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="MV4a8P4n"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 24D4EC4CECE;
	Thu, 12 Dec 2024 17:17:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1734023857;
	bh=XwSK6Uo5KLjaWWZrMR14vIq2pRFtIB9Fi3x6Qb5q648=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=MV4a8P4nSoFNUNbX3JpQKjVDG4BlvvLUMyNm00IYge7ZX0CbdSyj8L91+Zth4YmAC
	 Ehk+Bh3B4MOMjM7jzaNrhvoJaW1RuqjajYc1uQCTIwh1V6FOFbdu1cBmT6n1SxS409
	 UJB8/lTcG52Yr8fcGGDK0QYRoyKvFKH0zNFpTSqY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Ma=C3=ADra=20Canal?= <mcanal@igalia.com>,
	Iago Toral Quiroga <itoral@igalia.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 105/459] drm/v3d: Address race-condition in MMU flush
Date: Thu, 12 Dec 2024 15:57:23 +0100
Message-ID: <20241212144257.660005518@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241212144253.511169641@linuxfoundation.org>
References: <20241212144253.511169641@linuxfoundation.org>
User-Agent: quilt/0.67
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

[ Upstream commit cf1becb7f996a0a23ea2c270cf6bb0911ec3ca1a ]

We must first flush the MMU cache and then, flush the TLB, not the other
way around. Currently, we can see a race condition between the MMU cache
and the TLB when running multiple rendering processes at the same time.
This is evidenced by MMU errors triggered by the IRQ.

Fix the MMU flush order by flushing the MMU cache and then the TLB.
Also, in order to address the race condition, wait for the MMU cache flush
to finish before starting the TLB flush.

Fixes: 57692c94dcbe ("drm/v3d: Introduce a new DRM driver for Broadcom V3D V3.x+")
Signed-off-by: Maíra Canal <mcanal@igalia.com>
Reviewed-by: Iago Toral Quiroga <itoral@igalia.com>
Link: https://patchwork.freedesktop.org/patch/msgid/20240923141348.2422499-2-mcanal@igalia.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/v3d/v3d_mmu.c | 29 ++++++++++-------------------
 1 file changed, 10 insertions(+), 19 deletions(-)

diff --git a/drivers/gpu/drm/v3d/v3d_mmu.c b/drivers/gpu/drm/v3d/v3d_mmu.c
index 5a453532901f1..166d4a88daee5 100644
--- a/drivers/gpu/drm/v3d/v3d_mmu.c
+++ b/drivers/gpu/drm/v3d/v3d_mmu.c
@@ -34,32 +34,23 @@ static int v3d_mmu_flush_all(struct v3d_dev *v3d)
 {
 	int ret;
 
-	/* Make sure that another flush isn't already running when we
-	 * start this one.
-	 */
-	ret = wait_for(!(V3D_READ(V3D_MMU_CTL) &
-			 V3D_MMU_CTL_TLB_CLEARING), 100);
-	if (ret)
-		dev_err(v3d->drm.dev, "TLB clear wait idle pre-wait failed\n");
-
-	V3D_WRITE(V3D_MMU_CTL, V3D_READ(V3D_MMU_CTL) |
-		  V3D_MMU_CTL_TLB_CLEAR);
-
-	V3D_WRITE(V3D_MMUC_CONTROL,
-		  V3D_MMUC_CONTROL_FLUSH |
+	V3D_WRITE(V3D_MMUC_CONTROL, V3D_MMUC_CONTROL_FLUSH |
 		  V3D_MMUC_CONTROL_ENABLE);
 
-	ret = wait_for(!(V3D_READ(V3D_MMU_CTL) &
-			 V3D_MMU_CTL_TLB_CLEARING), 100);
+	ret = wait_for(!(V3D_READ(V3D_MMUC_CONTROL) &
+			 V3D_MMUC_CONTROL_FLUSHING), 100);
 	if (ret) {
-		dev_err(v3d->drm.dev, "TLB clear wait idle failed\n");
+		dev_err(v3d->drm.dev, "MMUC flush wait idle failed\n");
 		return ret;
 	}
 
-	ret = wait_for(!(V3D_READ(V3D_MMUC_CONTROL) &
-			 V3D_MMUC_CONTROL_FLUSHING), 100);
+	V3D_WRITE(V3D_MMU_CTL, V3D_READ(V3D_MMU_CTL) |
+		  V3D_MMU_CTL_TLB_CLEAR);
+
+	ret = wait_for(!(V3D_READ(V3D_MMU_CTL) &
+			 V3D_MMU_CTL_TLB_CLEARING), 100);
 	if (ret)
-		dev_err(v3d->drm.dev, "MMUC flush wait idle failed\n");
+		dev_err(v3d->drm.dev, "MMU TLB clear wait idle failed\n");
 
 	return ret;
 }
-- 
2.43.0



