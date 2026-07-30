Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 00147411689;
	Thu, 30 Jul 2026 15:41:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785426065; cv=none; b=auIoUTMCDz+SS6pTViYdrzH8rsYzYSq2USb6HgONpfxpfztIYuVOgELPQxt6SzzICetTo79lrGkj1oRsBDhBmpc+7IG2CqMkl0rCyuZq5lShAncvrWjGzbQC2GH/2S3zb6smN0jeMBFlxvNdQJyA47f+W1VtDdUPkdQOg8G11cA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785426065; c=relaxed/simple;
	bh=wCFBG/PWBj2APsJsdBHVYzGebyaRgliZg/fqrZ1bD4k=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=by5sBs4oANg8FIJRx3NzPUCN6wAzL943lYFOWwAt971CWDr8vD/nsRB3+EFg5AYNan4crEd3xJAsDWEmozbulnif+xXZGu4YslX9RnjxcCAx1199e7sQY2m40Q51VFRurJXApLWrceAT1g/tO1DB/WI+PHAtpY4/IE6xxIHLHi4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=cHVOl3as; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="cHVOl3as"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5A1551F000E9;
	Thu, 30 Jul 2026 15:41:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1785426063;
	bh=foYjXcDnVcC89XLjGDrLM8CGLdVFX8fOTeOVGcKGAQQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=cHVOl3as1QobcqCIFvoM0RWyzaQZQOCR5Ck1oUxeNB5JTxGAxbZWoeN09rQGtoQGe
	 BbTUm/Zk5S6xDEvakFo502p+DkfFj4nlqAzKZAU+vtv/THmENGzT5vKuRwa8/VXc2+
	 wCcc/xhrE9kJgRZwDnR/t1G3YSb1WIqlQIJInpb4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Timur=20Krist=C3=B3f?= <timur.kristof@gmail.com>,
	Alex Deucher <alexander.deucher@amd.com>
Subject: [PATCH 6.12 289/602] drm/gfx10: Program DB_RING_CONTROL
Date: Thu, 30 Jul 2026 16:11:21 +0200
Message-ID: <20260730141442.044704923@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260730141435.976815864@linuxfoundation.org>
References: <20260730141435.976815864@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
@@ -5195,6 +5195,15 @@ static void gfx_v10_0_constants_init(str
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


