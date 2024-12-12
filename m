Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 65B742144C0;
	Thu, 12 Dec 2024 16:30:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734021034; cv=none; b=NYUZH6yDnL1K8PQQlSqeBWkDLp/klWIgB/MpG9G++JMQyybt4MVLdVQ43vOqBR2knvC0g5nl7Q5Bg6d1SqaYC6FWpvLqhYfQ9whgfOvH3oKEW0QDsr2fG1LXsFzhizfQWYG1jGP2xwX6zRV6YeTb4TRwa0F8AT8Yk13jaBpkbw0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734021034; c=relaxed/simple;
	bh=zN20qWO812ga7kalFoC91qFEVP4UiiRZiN/iKVPVBn0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=HQNH1/5qzX/pAY+aunB5J2QkttKW1lYZKgiXEcKUKypfuit1x9O8tGfg2WUGxiI1ubPn+tFeD1qZLJG6nvFPh8bw7GrtTJWgkMpdB/AoJHDb8N3LFfnIH+2rYsFx8axLCvA8HdoA5K/ZdW1vjqZwSrf+QxYL2HNlBkCWJ1/0wUU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=s+w8XF4C; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="s+w8XF4C"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C651EC4CECE;
	Thu, 12 Dec 2024 16:30:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1734021034;
	bh=zN20qWO812ga7kalFoC91qFEVP4UiiRZiN/iKVPVBn0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=s+w8XF4CKal0oUnl/kahRQ4B9qYeCLAVdIKBP0tTpBCOGqGso9wv4ydZFbxi7+mNh
	 fzkER4h905RzGnIKJMpTsPtQqujp6C4bcESNyimZgxaNpr7aColn6NoYZ++ni8hJG2
	 WKlqdCcecQE3B4RuG+pxp2zaYqKbjzz2ghmwFsMw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	David Belanger <david.belanger@amd.com>,
	Frank Min <frank.min@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>
Subject: [PATCH 6.1 628/772] drm/amdgpu/hdp5.2: do a posting read when flushing HDP
Date: Thu, 12 Dec 2024 15:59:33 +0100
Message-ID: <20241212144415.885385279@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241212144349.797589255@linuxfoundation.org>
References: <20241212144349.797589255@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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


