Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D1B581F6696;
	Tue,  3 Dec 2024 15:07:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733238421; cv=none; b=XKI+Y+179m2ojAgYM06Pri/8xrfKKO6Vylpieztr0jiBovop+tpn0+GTFIDUGMu3gH7k7vgxjNQs5+YI1PczjtStbgQ7A8+ZpWqRhi1H666BSQEAB24A4OLydpC4bBxMF9toKgfpfElpk7Z/VZsKXy8oT6qesG/+bZF8X1fBCwA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733238421; c=relaxed/simple;
	bh=uydgzF2MRWGqM83i5H9eiQomqbpErSLMs8eDn3/Ls7c=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=Imo54cVA9KLnqswK3nLNvM45OXMdDglhhtH+Xy1ZVLW7RB6rAFYejRT8jtuN/k4rA6i44tYB4p44KzxUDq/LpkxZ3TtAa2rCFlTnchJcFqKxLuP6MuZzscPPdYOODC9oXFk2LtXMk4p88i/6DZ3MsPYhTfrTyQPSNk0uGyxa1dM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Md88ROnq; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Md88ROnq"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5493EC4CED6;
	Tue,  3 Dec 2024 15:07:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1733238421;
	bh=uydgzF2MRWGqM83i5H9eiQomqbpErSLMs8eDn3/Ls7c=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Md88ROnqXJJ2Nce62nioJUcQpiDUTAM3ZzJCfRr5GIAYJkRi+8tEaCZcqvTNK6ske
	 GnKTRcge2g9z4auZ/VAqUWTyCRP6AmZVCLsO5veNCQSTKQueOU6JL2GXXOdIwGStcZ
	 VDvtl3bi19uSes9xnzaFZB0vd7c3kPz8cPGpMXuo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Ma=C3=ADra=20Canal?= <mcanal@igalia.com>,
	Iago Toral Quiroga <itoral@igalia.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.11 240/817] drm/v3d: Address race-condition in MMU flush
Date: Tue,  3 Dec 2024 15:36:52 +0100
Message-ID: <20241203144005.126942864@linuxfoundation.org>
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
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

6.11-stable review patch.  If anyone has any objections, please let me know.

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
index 14f3af40d6f6d..e36ec3343b06e 100644
--- a/drivers/gpu/drm/v3d/v3d_mmu.c
+++ b/drivers/gpu/drm/v3d/v3d_mmu.c
@@ -32,32 +32,23 @@ static int v3d_mmu_flush_all(struct v3d_dev *v3d)
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



