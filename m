Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EE2D721504F;
	Thu, 12 Dec 2024 15:12:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734016370; cv=none; b=V6E6HcmAvHnoF5gPJPdH55NIonXHiivkKtzQP4pBf4LIhkpkN9SMJgUIvvKuqON2Tw/zA+n3Z4UQeLC4/8REvvOGe2vAyMEjfjAFw5lOx1SSfBHZRdlmBvCms5zsrwoqgG4TPF5dSjgYF+h1Y6JXmUxzwWQiOk61fuDqtWo4VMk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734016370; c=relaxed/simple;
	bh=Gp2U2Mgs9G4/ZeF81ZxLucwyvW78lkakZdcYYlgrriE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=iBPx2tu+hl+j5Yhk5C9Gna+umfByxPlCD82sy2j38IDurVZ5KvevD5h7RWHHtO6pKxi/34YATzqCqO6GXWS5QnxoXrW7ok2R3GeZr0E88Bteze6lEt2XiJRH5roY1OdTgdRMeM7tfMLiXwLbaDeCq3qvyIDfqSLTCHThOZmsVVM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=NLcaZxvw; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="NLcaZxvw"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 165C3C4CED0;
	Thu, 12 Dec 2024 15:12:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1734016369;
	bh=Gp2U2Mgs9G4/ZeF81ZxLucwyvW78lkakZdcYYlgrriE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=NLcaZxvwZxS/xB0al2QnJ92NVb4MG2a/B0vePjYZqO8gI0tzWHgxpeQ2S6sz0O1Qh
	 mzEsewu4d+J4UZrgfJdTq6W/3tgqKsDhDiVpVrUonAsJlraJm8Aq+W04TqrqflHf9P
	 Grir29tRL23CnGFbO1JcnuEcaaHmreXFRCWTt6Ww=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	David Belanger <david.belanger@amd.com>,
	Frank Min <frank.min@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>
Subject: [PATCH 6.12 179/466] drm/amdgpu/hdp5.0: do a posting read when flushing HDP
Date: Thu, 12 Dec 2024 15:55:48 +0100
Message-ID: <20241212144313.864600664@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241212144306.641051666@linuxfoundation.org>
References: <20241212144306.641051666@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Alex Deucher <alexander.deucher@amd.com>

commit cf424020e040be35df05b682b546b255e74a420f upstream.

Need to read back to make sure the write goes through.

Cc: David Belanger <david.belanger@amd.com>
Reviewed-by: Frank Min <frank.min@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Cc: stable@vger.kernel.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/amd/amdgpu/hdp_v5_0.c |    7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)

--- a/drivers/gpu/drm/amd/amdgpu/hdp_v5_0.c
+++ b/drivers/gpu/drm/amd/amdgpu/hdp_v5_0.c
@@ -31,10 +31,12 @@
 static void hdp_v5_0_flush_hdp(struct amdgpu_device *adev,
 				struct amdgpu_ring *ring)
 {
-	if (!ring || !ring->funcs->emit_wreg)
+	if (!ring || !ring->funcs->emit_wreg) {
 		WREG32((adev->rmmio_remap.reg_offset + KFD_MMIO_REMAP_HDP_MEM_FLUSH_CNTL) >> 2, 0);
-	else
+		RREG32((adev->rmmio_remap.reg_offset + KFD_MMIO_REMAP_HDP_MEM_FLUSH_CNTL) >> 2);
+	} else {
 		amdgpu_ring_emit_wreg(ring, (adev->rmmio_remap.reg_offset + KFD_MMIO_REMAP_HDP_MEM_FLUSH_CNTL) >> 2, 0);
+	}
 }
 
 static void hdp_v5_0_invalidate_hdp(struct amdgpu_device *adev,
@@ -42,6 +44,7 @@ static void hdp_v5_0_invalidate_hdp(stru
 {
 	if (!ring || !ring->funcs->emit_wreg) {
 		WREG32_SOC15_NO_KIQ(HDP, 0, mmHDP_READ_CACHE_INVALIDATE, 1);
+		RREG32_SOC15_NO_KIQ(HDP, 0, mmHDP_READ_CACHE_INVALIDATE);
 	} else {
 		amdgpu_ring_emit_wreg(ring, SOC15_REG_OFFSET(
 					HDP, 0, mmHDP_READ_CACHE_INVALIDATE), 1);


