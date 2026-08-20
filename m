Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E5AC9360745;
	Thu, 20 Aug 2026 15:12:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787238752; cv=none; b=LEi7/8UzTgv2JCAyyGYv3JpTV9vjMQ9iMmzFDT9fpqhpEEJzwEa3eKL81NFyUgLBKiUdpEFsclUwM1s4vIsoj9rBswYMEbmsQrSHN/9VqfcYolFhbkORarnBvRGQMUElpbloe9nYzLUotVPGKi+rZGMiav7FRHLpsAe+cq69cs8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787238752; c=relaxed/simple;
	bh=KRz1T9jEaPl7fLttF4HFa+MBw/PrbLo/3l0uCBpUJnA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=LHJSp2jKCBkfSqsrP1w2b8wL7I5qcZ4SrBx3Ei6UJpBCEs1G+8+dBYXU/FfrAAqK4T4S97gvrRCNPVR8fmg4hunDNRSNtZER08HDnpe8WTRzd1sf5nmT7kELgpaDOtP7fYKHsFa3cms9rssCDhj82kBNGEnZxZF7gMp2Ual15m4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=wDUH1LHL; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="wDUH1LHL"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4ACE31F000E9;
	Thu, 20 Aug 2026 15:12:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1787238750;
	bh=5qXgtZoKNclEM6KlpcLDz7oAaAKta2zg0RVoaAXOmno=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=wDUH1LHLXKUEwgsQDeio0V5lvl/H/noL8cURhGN+vDLMaoooGp9rCfNRwgy4DU+D3
	 olbucoLYCdRE+3ThKjD/9wSunbsONGayvS0FehctHfmm950kRdGJj1yl3orTSrtdkr
	 ykZXrwiGfakNY0433ejLRMvPQoK3kiLH3mu/gq3k=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Alex Deucher <alexander.deucher@amd.com>,
	Jesse Zhang <Jesse.Zhang@amd.com>
Subject: [PATCH 6.18 028/217] drm/amdgpu: fix JPEG v5.0.0 queue reset failure in DPG mode
Date: Thu, 20 Aug 2026 16:53:16 +0200
Message-ID: <20260820145238.466648267@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260820145237.531699751@linuxfoundation.org>
References: <20260820145237.531699751@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jesse Zhang <Jesse.Zhang@amd.com>

commit c87801f545dac9fcbb84c96f280706572be00a85 upstream.

In DPG mode jpeg_v5_0_0_ring_reset() takes the DPG stop path, which only
clears the JPEG_PG_MODE bit and never resets the JRBC. A hung ring is not
recovered: the post-reset ring test times out and the driver falls back to
a full MODE1 reset.

Temporarily force the static power-gating path during the reset so the
stop/start sequence power-cycles the JPEG block (JMI soft reset + power
off/on), matching the jpeg_v4_0 reset which has no DPG path.

Acked-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Jesse Zhang <Jesse.Zhang@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
(cherry picked from commit 79b3612827d1adcd2008cd585961fa35a6ff20f2)
Cc: stable@vger.kernel.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/amd/amdgpu/jpeg_v5_0_0.c |   21 +++++++++++++++++----
 1 file changed, 17 insertions(+), 4 deletions(-)

--- a/drivers/gpu/drm/amd/amdgpu/jpeg_v5_0_0.c
+++ b/drivers/gpu/drm/amd/amdgpu/jpeg_v5_0_0.c
@@ -648,15 +648,28 @@ static int jpeg_v5_0_0_ring_reset(struct
 				  unsigned int vmid,
 				  struct amdgpu_fence *timedout_fence)
 {
+	struct amdgpu_device *adev = ring->adev;
+	u32 pg_flags = adev->pg_flags;
 	int r;
 
 	amdgpu_ring_reset_helper_begin(ring, timedout_fence);
-	r = jpeg_v5_0_0_stop(ring->adev);
-	if (r)
-		return r;
-	r = jpeg_v5_0_0_start(ring->adev);
+
+	/*
+	 * The DPG stop path only clears the JPEG_PG_MODE bit and never resets a
+	 * hung JRBC, so the post-reset ring test times out and the driver falls
+	 * back to a full MODE1 reset. Temporarily force the static power-gating
+	 * path so the stop/start sequence actually power-cycles the JPEG block
+	 * (JMI soft reset + ONO1 power off/on), matching the working jpeg_v4_0
+	 * reset.
+	 */
+	adev->pg_flags &= ~AMD_PG_SUPPORT_JPEG_DPG;
+	r = jpeg_v5_0_0_stop(adev);
+	if (!r)
+		r = jpeg_v5_0_0_start(adev);
+	adev->pg_flags = pg_flags;
 	if (r)
 		return r;
+
 	return amdgpu_ring_reset_helper_end(ring, timedout_fence);
 }
 


