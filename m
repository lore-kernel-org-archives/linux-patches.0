Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 21622346A04;
	Sat, 30 May 2026 16:23:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780158188; cv=none; b=ibJko6dycqWVDDOg51h73muR+0mKb/8qR+amRYxkTzHEIMFHX+/fEaj6GVUBQlSZfS8lmaeIMJNXI1yGQccu3wZh2aDE9nuHPq1kLFNzTuvuDNCHQJIb3YdWUDx1yS78q2bNLrmMmi5jyzu55L+lSjFhH6tEzVNzRgU673w4soo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780158188; c=relaxed/simple;
	bh=+ty/wum97ixxbKvHMiWJduhSGNx8wqlr+oI5jXukA+c=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=dhEFFlp8E4ePFsMMzKnjQKcljQL51UwFRyDjcPg/Y8Y7At18fC8sdSoUz8Doz0aBpWoL5WEuBsibgGPkfx0550L964eZMVgeyHbtm9Etcj8YrMMoiBa37BN3jMEIALc3vYigLDNNe2Q3/KozEJ+ZGwOegzms0ZtP7Efakap6gY0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=HcPyE7bZ; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="HcPyE7bZ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 400B61F00893;
	Sat, 30 May 2026 16:23:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1780158185;
	bh=zn7d+N0Cp3w+Bzc9uEpNbSunRpxwrgzWC77jPo976H8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=HcPyE7bZ92sZEDGi3VvjZLbRPZIeqkXItRFNM7zVXUHwNLQFhkn7nlCSdpIVagWcH
	 x5mM4eNNs2hw6HiIXEO2jB1Ly0uMSc1ulafqfzO692q34Uxd2DeJd8aBBnRHVTxB3X
	 kX6IBHSE7MaMDvxyvX73iUFl1pOH/PCmvW1vRyoo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Melissa Wen <mwen@igalia.com>,
	=?UTF-8?q?Ma=C3=ADra=20Canal?= <mcanal@igalia.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 029/969] drm/vc4: Fix a memory leak in hang state error path
Date: Sat, 30 May 2026 17:52:33 +0200
Message-ID: <20260530160301.244641264@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260530160300.485627683@linuxfoundation.org>
References: <20260530160300.485627683@linuxfoundation.org>
User-Agent: quilt/0.69
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

[ Upstream commit 9525d169e5fd481538cf8c663cc5839e54f2e481 ]

When vc4_save_hang_state() encounters an early return condition, it
returns without freeing the previously allocated `kernel_state`,
leaking memory.

Add the missing kfree() calls by consolidating the early return paths
into a single place.

Fixes: 214613656b51 ("drm/vc4: Add an interface for capturing the GPU state after a hang.")
Reviewed-by: Melissa Wen <mwen@igalia.com>
Link: https://patch.msgid.link/20260330-vc4-misc-fixes-v1-3-92defc940a29@igalia.com
Signed-off-by: Maíra Canal <mcanal@igalia.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/vc4/vc4_gem.c | 18 ++++++++++--------
 1 file changed, 10 insertions(+), 8 deletions(-)

diff --git a/drivers/gpu/drm/vc4/vc4_gem.c b/drivers/gpu/drm/vc4/vc4_gem.c
index c446684a72183..0d88226b17deb 100644
--- a/drivers/gpu/drm/vc4/vc4_gem.c
+++ b/drivers/gpu/drm/vc4/vc4_gem.c
@@ -169,10 +169,8 @@ vc4_save_hang_state(struct drm_device *dev)
 	spin_lock_irqsave(&vc4->job_lock, irqflags);
 	exec[0] = vc4_first_bin_job(vc4);
 	exec[1] = vc4_first_render_job(vc4);
-	if (!exec[0] && !exec[1]) {
-		spin_unlock_irqrestore(&vc4->job_lock, irqflags);
-		return;
-	}
+	if (!exec[0] && !exec[1])
+		goto err_free_state;
 
 	/* Get the bos from both binner and renderer into hang state. */
 	state->bo_count = 0;
@@ -189,10 +187,8 @@ vc4_save_hang_state(struct drm_device *dev)
 	kernel_state->bo = kcalloc(state->bo_count,
 				   sizeof(*kernel_state->bo), GFP_ATOMIC);
 
-	if (!kernel_state->bo) {
-		spin_unlock_irqrestore(&vc4->job_lock, irqflags);
-		return;
-	}
+	if (!kernel_state->bo)
+		goto err_free_state;
 
 	k = 0;
 	for (i = 0; i < 2; i++) {
@@ -284,6 +280,12 @@ vc4_save_hang_state(struct drm_device *dev)
 		vc4->hang_state = kernel_state;
 		spin_unlock_irqrestore(&vc4->job_lock, irqflags);
 	}
+
+	return;
+
+err_free_state:
+	spin_unlock_irqrestore(&vc4->job_lock, irqflags);
+	kfree(kernel_state);
 }
 
 static void
-- 
2.53.0



