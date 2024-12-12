Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EE5F2213E97;
	Thu, 12 Dec 2024 15:12:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734016363; cv=none; b=WbZ/qMv0Et2VM2HmhlmgCHokuC99HQSBKzoXPt+0DqqN7cXIs79xomoZufvD6qsLqyZ5Z4JXZbbBo/ldPNbzWgCFPhhM696tNdpIXeYg7U8aD1p7h0xAfE0jS+HP4q9raxret5PBRy2F9Xh7io9qdZ6luVDDwetMXTIyVRDEG+I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734016363; c=relaxed/simple;
	bh=pKSpoCrS8aJzhhpyWUL8tnuxBB9cl68GTndBHXZt8Uk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=gxbhO9tqbfs86g5cO4yAJ+R//UqnQpDikrdDq/dNJO/mX4ydjuywUedtTxi2aswmGnNDUVIqG8X+zjI5rHxYUTiVRqLN+OgBS0NHCHMAUFdz8ttt4b4uK3RT63V6avfm+vcYEEzGrUmA5DfyVoy84ZDGzaRDHkCmwEr2AmLu2OM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=vIBpMnWJ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="vIBpMnWJ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 33150C4CED7;
	Thu, 12 Dec 2024 15:12:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1734016362;
	bh=pKSpoCrS8aJzhhpyWUL8tnuxBB9cl68GTndBHXZt8Uk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=vIBpMnWJs3obPhBu/OfduDEkTvq5AVinIYun/eH4iUbeIZVb75BGymxbna1bE2Kjq
	 QE13q8itIG8onXRL6zTrezVT3prNC+LgrhfYo3i9Qx9/q63YBnsA/tbgD2GjlqhEih
	 dsJdj7hgb4l7Ducv4/yQhYSZy3Fah4KGl41W48Ow=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	David Belanger <david.belanger@amd.com>,
	Frank Min <frank.min@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>
Subject: [PATCH 6.12 177/466] drm/amdgpu/hdp6.0: do a posting read when flushing HDP
Date: Thu, 12 Dec 2024 15:55:46 +0100
Message-ID: <20241212144313.788191107@linuxfoundation.org>
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

commit abe1cbaec6cfe9fde609a15cd6a12c812282ce77 upstream.

Need to read back to make sure the write goes through.

Cc: David Belanger <david.belanger@amd.com>
Reviewed-by: Frank Min <frank.min@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Cc: stable@vger.kernel.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/amd/amdgpu/hdp_v6_0.c |    6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

--- a/drivers/gpu/drm/amd/amdgpu/hdp_v6_0.c
+++ b/drivers/gpu/drm/amd/amdgpu/hdp_v6_0.c
@@ -34,10 +34,12 @@
 static void hdp_v6_0_flush_hdp(struct amdgpu_device *adev,
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
 
 static void hdp_v6_0_update_clock_gating(struct amdgpu_device *adev,


