Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7E67F21171A;
	Thu, 12 Dec 2024 15:12:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734016376; cv=none; b=NzCKTarcFDSxNkrk4xu88t/U9vy1KlHTFA2I2Xc6IHlXZskmJl2KjMVB9NJNwaBVPvPzaHvPkw2cOfIoa6NJxbsCxZqjY9St2g4ig0iTXxaOyXJytMwJqoUggpY/yC9XsBOnhEhkNq49SM0w4lLqoErPw832sPsNF2NQ3dt9URw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734016376; c=relaxed/simple;
	bh=cO47pyqaWym4Ef55F/95+K3BxeH5YDPQI08Ae39D1ZM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=AGg12ty3ygPf8i+H+NVtg53MsAANoSkdwL5W528CfQ9ugzA0MeUoTgy66JmzIQWaEkm39+Ms9GjI5B6/Kc+XvKQ1wRTNRhz0ppZ+jFGoeV6iXy60XQRI6we3myjkNDEM+NxErTGdnefN4lFfN7xRihz+LK1NnZ8E19HXFsIdWMM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=BOjjkmBK; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="BOjjkmBK"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F21F5C4CED0;
	Thu, 12 Dec 2024 15:12:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1734016376;
	bh=cO47pyqaWym4Ef55F/95+K3BxeH5YDPQI08Ae39D1ZM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=BOjjkmBKcquNBn1gMaRYc2VXooSBw+JwxKfQ963EA96H64H1jwpjKsUmalool7d3+
	 ayxBpdq5tMDVET4bobRhaC6sMuEgDNz5MrgY+pE+dLwj2S7WZp46vQPRi8DxgBE5x/
	 KofkbngWYJmoQu1KjqOUl0jlGzwNIj1foQuGe7+0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	David Belanger <david.belanger@amd.com>,
	Frank Min <frank.min@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>
Subject: [PATCH 6.12 181/466] drm/amdgpu/hdp5.2: do a posting read when flushing HDP
Date: Thu, 12 Dec 2024 15:55:50 +0100
Message-ID: <20241212144313.943157847@linuxfoundation.org>
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

commit f756dbac1ce1d5f9a2b35e3b55fa429cf6336437 upstream.

Need to read back to make sure the write goes through.

Cc: David Belanger <david.belanger@amd.com>
Reviewed-by: Frank Min <frank.min@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Cc: stable@vger.kernel.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/amd/amdgpu/hdp_v5_2.c |    6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

--- a/drivers/gpu/drm/amd/amdgpu/hdp_v5_2.c
+++ b/drivers/gpu/drm/amd/amdgpu/hdp_v5_2.c
@@ -31,13 +31,15 @@
 static void hdp_v5_2_flush_hdp(struct amdgpu_device *adev,
 				struct amdgpu_ring *ring)
 {
-	if (!ring || !ring->funcs->emit_wreg)
+	if (!ring || !ring->funcs->emit_wreg) {
 		WREG32_NO_KIQ((adev->rmmio_remap.reg_offset + KFD_MMIO_REMAP_HDP_MEM_FLUSH_CNTL) >> 2,
 			0);
-	else
+		RREG32_NO_KIQ((adev->rmmio_remap.reg_offset + KFD_MMIO_REMAP_HDP_MEM_FLUSH_CNTL) >> 2);
+	} else {
 		amdgpu_ring_emit_wreg(ring,
 			(adev->rmmio_remap.reg_offset + KFD_MMIO_REMAP_HDP_MEM_FLUSH_CNTL) >> 2,
 			0);
+	}
 }
 
 static void hdp_v5_2_update_mem_power_gating(struct amdgpu_device *adev,


