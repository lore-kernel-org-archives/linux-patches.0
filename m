Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E30BB3FF1B5;
	Thu, 30 Jul 2026 14:40:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785422458; cv=none; b=mDgFV+ObnJxVtTmDFKticmPUqAbKg/f1h0C5qQI4Lhg9W9sXQ9WWrqBJazTJy9Jh8Hm7Eb3tLlJYyymONrvjFXFUT8M6PuXj2AL9OYEKtsPr0FO+gMrPlYP0Fss0eajKpIz1RGopENXr9lFsQpI0V/cB5mhQ54+sYhU01C1al3M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785422458; c=relaxed/simple;
	bh=n/LjL8GfBSdItqPg3cu7XfaJcjrHbReOjM2tXA4i1Bk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=S5n5yep3hVmR8Khtka/4gssg5513HrjUnvg+Xmg8M6hhIaXBEUB7cXvpYROoQ/CH8GM3/Op6c+EGwA5vLHQ6/ymvdm1RwTzgfXEjBvXO+oOO33PDprhz3nFQR966nIHvvgK8DabF0VfF3pg1VEfqRQjgjEINWeXjfAJisGUZRRY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=qiYgXJyU; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="qiYgXJyU"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4BC101F000E9;
	Thu, 30 Jul 2026 14:40:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1785422456;
	bh=eTtEU9RaFnCzqCogPfzTfCne3Up+0woWIADXUC7YHX0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=qiYgXJyUHAWLKlJARboQ+P1zwzPWJj1wzYlITCJpLKenbFWv1JNMe3z5vbdMjcWPa
	 53LpUoDQmD6qjz8pP09sL8duW6MR8cBIoDXK3DI1MTF5TQH5fiVNxCZTkaDaSm785n
	 sqAYv3ck/D6efASBRplG6/815YIgxPOa67zTBI+0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Timur=20Krist=C3=B3f?= <timur.kristof@gmail.com>,
	Alex Deucher <alexander.deucher@amd.com>
Subject: [PATCH 7.1 444/744] drm/gfx10: Program DB_RING_CONTROL
Date: Thu, 30 Jul 2026 16:11:57 +0200
Message-ID: <20260730141453.736531174@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260730141444.267951807@linuxfoundation.org>
References: <20260730141444.267951807@linuxfoundation.org>
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

7.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Alex Deucher <alexander.deucher@amd.com>

commit f0262c3a3f14d60140f6b826d40d44edf62c36d6 upstream.

This is needed to allocate occlusion counters across
both gfx pipes.

Fixes: b7a1a0ef12b8 ("drm/amd/amdgpu: add pipe1 hardware support")
Reviewed-by: Timur Kristóf <timur.kristof@gmail.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
(cherry picked from commit 6807352cbabb74b61ba42888769283af72191f66)
Cc: stable@vger.kernel.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/amd/amdgpu/gfx_v10_0.c |    9 +++++++++
 1 file changed, 9 insertions(+)

--- a/drivers/gpu/drm/amd/amdgpu/gfx_v10_0.c
+++ b/drivers/gpu/drm/amd/amdgpu/gfx_v10_0.c
@@ -5350,6 +5350,15 @@ static void gfx_v10_0_constants_init(str
 	gfx_v10_0_get_tcc_info(adev);
 	adev->gfx.config.pa_sc_tile_steering_override =
 		gfx_v10_0_init_pa_sc_tile_steering_override(adev);
+	/* Program DB_RING_CONTROL for multiple GFX pipes
+	 * Default power up value is 1.
+	 * Possible values:
+	 * 0 - split occlusion counters between gfx pipes
+	 * 1 - all occlusion counters to pipe 0
+	 * 2 - all occlusion counters to pipe 1
+	 */
+	WREG32_FIELD15(GC, 0, DB_RING_CONTROL, COUNTER_CONTROL,
+		       (adev->gfx.me.num_pipe_per_me > 1) ? 0 : 1);
 
 	/* XXX SH_MEM regs */
 	/* where to put LDS, scratch, GPUVM in FSA64 space */


