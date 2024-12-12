Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 01866217F28;
	Thu, 12 Dec 2024 15:39:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734017998; cv=none; b=RTHVZYZFoCiDf5wOM0/B2IhHtxdnZFSo5wvYakl88HgtV1Q/d4E8A8KleeD6Rar8qDCdAS8eMD+ukdHk8qfJBVqK4PzgpoNbnVVtStITYBAAwYFPN/C5QmfmOveI46Fr+Gj9xg544nCwaJriSArCI0yx3sRn7ZgUr2QQ+1F244k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734017998; c=relaxed/simple;
	bh=oVKW0QxO0eMnLIsmh706IwHp87GKmKOpn308ITeF1IU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=FBSz86bsoYZg5X/GTaiuHQHtVKNWkBvgMvkCsX719LZdi7LiIia90XM49jASoMMD7QrIFcZR+ZtqBOfyokgrief+NRHt7Uys4ycSL3PUbb1vCHkOPaNg0zfCnrSYIrQ+ztIXd35tffEgSD9skZEcFC/cpOKYrbmAlL6coa42E+4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=F6RgFQ7D; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="F6RgFQ7D"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 64CC9C4CED0;
	Thu, 12 Dec 2024 15:39:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1734017997;
	bh=oVKW0QxO0eMnLIsmh706IwHp87GKmKOpn308ITeF1IU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=F6RgFQ7DUTEoQvMrtsymX1JzXICFno+hzBZsJo//5nC5qkeH3IGxiOgB85Yt6ElHJ
	 4RW5Fej0ocaA2irdwbnClQjyVHZyyxcq73xj/hTrodr+4ZVmn5gzqF5aIpxLDZP9Y7
	 oDGZWr9JDu59t/U62sI8bAFb6NEJ8R40364Kg+yg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	David Belanger <david.belanger@amd.com>,
	Frank Min <frank.min@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>
Subject: [PATCH 6.6 169/356] drm/amdgpu/hdp5.2: do a posting read when flushing HDP
Date: Thu, 12 Dec 2024 15:58:08 +0100
Message-ID: <20241212144251.311316549@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241212144244.601729511@linuxfoundation.org>
References: <20241212144244.601729511@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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


