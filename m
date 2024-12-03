Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 330661FA16B;
	Tue,  3 Dec 2024 15:46:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733240783; cv=none; b=aw4YzgfwxdLU7Tn4bWiEarfL72gWd6Bh0w+XIhxQzpXNCdFZ+6E/vSZVwnDTnYGfGlugpptM1mFFYZTvO7fmder7ouTz2f9qAVr3EsPvVxr8A3P4m4MkDTXi1Hr7elgBoRTr1LXZwZXGtplt3zuUz+As7qa51QTQEH5cXABH760=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733240783; c=relaxed/simple;
	bh=YIBhCdDrgmdKkMDg2oUr/PUrlsmErNaTF+tdNuRJVHQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=h9+gnpptyDej6ayOIONUVQ+CxGQ1+dPUxur8LxUTGmPqSsarjwnEJh+W2GzQhYug24jsxFIVFyF1xVzRAwoH6otYZ6Zu+1l068FhwBDDgXBNTn921fCpLavPyNLf43RQ4ZKmpCnTU8uhOHEUfxx54tZO4oZBU2jdb9mNlwR5b7I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=G/RsWcrZ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="G/RsWcrZ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 93DF1C4CED8;
	Tue,  3 Dec 2024 15:46:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1733240783;
	bh=YIBhCdDrgmdKkMDg2oUr/PUrlsmErNaTF+tdNuRJVHQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=G/RsWcrZ2AQQ3mqAMY7jFVJ7a0blR5LVXww7UzxpTxzFi8N224RxOOjWFQUnN/7HC
	 7i71Sn9b/kk1VcVuQymimKb1TV129l9d5GcZnqcfWS+tp8UJJFyutSTX8uQik31jXk
	 VQyaFqtrU+YEV+ytNf8GhiF073BG9iGQMEhIAOq0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Ma=C3=ADra=20Canal?= <mcanal@igalia.com>,
	Iago Toral Quiroga <itoral@igalia.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 206/826] drm/v3d: Address race-condition in MMU flush
Date: Tue,  3 Dec 2024 15:38:53 +0100
Message-ID: <20241203144751.783464594@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241203144743.428732212@linuxfoundation.org>
References: <20241203144743.428732212@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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



