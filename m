Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9ADD9399350;
	Thu, 30 Jul 2026 15:11:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785424271; cv=none; b=T9MkjaF/ilugzlQsRSvScdpf0GKkRzpfmyuM0qbZuroDEDk3JUfAtq6TsASVe++shpgb1A+a3qB6JYEL1z5/Uy6Yi4aXnqLKyO30OxcDR/i32H0SUrGMD7IlBCy1R59cUG3V3qP8O3LP9csSOgDvyISuQTPYsgWHcAwho0MTAIQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785424271; c=relaxed/simple;
	bh=j3Bwi7r3xbxQGDHfa/afd4ZaFdA4FRo6zqoXT6OtFII=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=J2DzSwDJplPXtvIex2b3mqaZi6amdHODqnmwJV0H/aDDPgH3pYBInxdfwhZMrLdQ2rebjVrWli8zTz7lKANC/MVExp7mEXuSxodwFq+lgexlCsr4GQCth2M8lt8Hs1LVj4DX0r++kmt9AM9oUfBFet5sGn3BEClCpzFkPcbb5Ps=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=JMK/JNpw; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="JMK/JNpw"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EB60A1F00A3A;
	Thu, 30 Jul 2026 15:11:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1785424270;
	bh=4TDgzMqFVJmRO/iTJAYh/ow9L+qTR6H6lMQrVX32GxE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=JMK/JNpwwk2Igkq39CQPfdQIitxXs6viXt6v/3u1DfY0/czPU/quh3W4JUXinPqMn
	 P8AkywG1Vca5JQLHpC5zYhOMJgJBDqg1OPx0ATWw6E9jAdqmHtR+nAcp4SqzMfc71N
	 qE+TmGWCiozffzjDXNpkCcNgEMP1MS4oA8/GWYuU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jiqian Chen <Jiqian.Chen@amd.com>,
	Huang Rui <ray.huang@amd.com>,
	=?UTF-8?q?Timur=20Krist=C3=B3f?= <timur.kristof@gmail.com>,
	Alex Deucher <alexander.deucher@amd.com>
Subject: [PATCH 6.18 335/675] drm/amdgpu/gfx9: Fix Ring and IB test fail after mode2
Date: Thu, 30 Jul 2026 16:11:05 +0200
Message-ID: <20260730141452.249786805@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260730141445.110192266@linuxfoundation.org>
References: <20260730141445.110192266@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jiqian Chen <Jiqian.Chen@amd.com>

commit 85ed06d990ff73212b5a91a406671cabd962e521 upstream.

For Renior APU with gfx9, in some test scenarios with disabling
ring_reset, like accessing an unmapped invalid address, it can
trigger a gpu job timeout event, then driver uses Mode2 reset
to reset GPU, but after Mode2 compute Ring test and IB test fail
randomly. It because the HQDs of MECs are always active before or
after Mode2, that causes MECs use stale HQDs when MECs are unhalted
before driver restore MQDs, and causes CPC and CPF are still stuck
after Mode2, then causes compute Ring and IB tests fail.

So, add sequences to deactivate HQDs of MECs in suspend IP function
of the resetting process.

v2: Move all sequences into a new function gfx_v9_0_cp_mode2_clear_state (Ray Huang)
    To check reset Mode2 method in the if condition (Ray Huang)
v3: Move all sequences before Mode2 instead of after Mode2 (Timur Kristóf)
v4: Call amdgpu_gfx_rlc_enter/exit_safe_mode int the begin and end of
    gfx_v9_0_deactivate_kcq_hqd (Alex Deucher)

Signed-off-by: Jiqian Chen <Jiqian.Chen@amd.com>
Reviewed-by: Huang Rui <ray.huang@amd.com>
Reviewed-by: Timur Kristóf <timur.kristof@gmail.com>
Reviewed-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
(cherry picked from commit c3988a7ad4799514447294f04f063b422e0551df)
Cc: stable@vger.kernel.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/amd/amdgpu/gfx_v9_0.c |   39 ++++++++++++++++++++++++++++++++++
 1 file changed, 39 insertions(+)

--- a/drivers/gpu/drm/amd/amdgpu/gfx_v9_0.c
+++ b/drivers/gpu/drm/amd/amdgpu/gfx_v9_0.c
@@ -4045,6 +4045,41 @@ static int gfx_v9_0_hw_init(struct amdgp
 	return r;
 }
 
+static void gfx_v9_0_deactivate_kcq_hqd(struct amdgpu_device *adev)
+{
+	amdgpu_gfx_rlc_enter_safe_mode(adev, 0);
+	for (int i = 0; i < adev->gfx.num_compute_rings; i++) {
+		u32 tmp;
+		struct amdgpu_ring *ring = &adev->gfx.compute_ring[i];
+
+		mutex_lock(&adev->srbm_mutex);
+		soc15_grbm_select(adev, ring->me, ring->pipe, ring->queue, 0, 0);
+		tmp = RREG32_SOC15(GC, 0, mmCP_HQD_ACTIVE);
+		/* disable the queue if it's active */
+		if (tmp & CP_HQD_ACTIVE__ACTIVE_MASK) {
+			int j;
+
+			WREG32_SOC15(GC, 0, mmCP_HQD_DEQUEUE_REQUEST, 1);
+			for (j = 0; j < adev->usec_timeout; j++) {
+				tmp = RREG32_SOC15(GC, 0, mmCP_HQD_ACTIVE);
+				if (!(tmp & CP_HQD_ACTIVE__ACTIVE_MASK))
+					break;
+				udelay(1);
+			}
+			if (j == AMDGPU_MAX_USEC_TIMEOUT) {
+				DRM_DEBUG("comp_%u_%u_%u dequeue request failed.\n",
+							ring->me, ring->pipe, ring->queue);
+				/* Manual disable if dequeue request times out */
+				WREG32_SOC15(GC, 0, mmCP_HQD_ACTIVE, 0);
+			}
+			WREG32_SOC15(GC, 0, mmCP_HQD_DEQUEUE_REQUEST, 0);
+		}
+		soc15_grbm_select(adev, 0, 0, 0, 0, 0);
+		mutex_unlock(&adev->srbm_mutex);
+	}
+	amdgpu_gfx_rlc_exit_safe_mode(adev, 0);
+}
+
 static int gfx_v9_0_hw_fini(struct amdgpu_ip_block *ip_block)
 {
 	struct amdgpu_device *adev = ip_block->adev;
@@ -4071,6 +4106,10 @@ static int gfx_v9_0_hw_fini(struct amdgp
 		return 0;
 	}
 
+	if ((adev->flags & AMD_IS_APU) && amdgpu_in_reset(adev) &&
+		amdgpu_asic_reset_method(adev) == AMD_RESET_METHOD_MODE2)
+		gfx_v9_0_deactivate_kcq_hqd(adev);
+
 	/* Use deinitialize sequence from CAIL when unbinding device from driver,
 	 * otherwise KIQ is hanging when binding back
 	 */


