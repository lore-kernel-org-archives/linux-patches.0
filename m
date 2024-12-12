Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1CC4C21171A;
	Thu, 12 Dec 2024 15:12:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734016373; cv=none; b=NxLmtGRq6wt14gx8YDb/7HwOgSAtFaiFX627l3DQdrvnHhQ4TdoheBg8hw510F9ZBg7UH63foYlWc4r0yc09iyk7oIrDz7bJsRO35mr/06ZMusuzYrJcalb986Se0QWTh39q67naOYgZcIpPBTriHyPNZ8DGKM1dbhHgtBgVdFU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734016373; c=relaxed/simple;
	bh=Tfg6cvE+SvrnJk2GvIatK26XzFbMv6RzkJsWoHR1zJM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Mn0913/Oz+MFn8M3Kk+qzOMk3iDB0EKjVLxwqpNQk3RTewd3e9DqjAobJpcjC75qaCslb/GxtgyS1Tb3zKvwHxpi+ksZo8vkdj8eyMz7JTPxIy6QGCNumkp9f8nb/Ix4ntx62PsCRJakQkBucV18KMRxd5fzHvBRafVoPA8mNtE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Emo5wddl; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Emo5wddl"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 95A13C4CED0;
	Thu, 12 Dec 2024 15:12:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1734016373;
	bh=Tfg6cvE+SvrnJk2GvIatK26XzFbMv6RzkJsWoHR1zJM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Emo5wddlU3RIGpLdSUW4orsunqiWE/XnEnfaaiuFZM1JX5nUjSvXyE/VZBntz5Wjh
	 SiSorw0KrRiZ/3OkshHIsYwLZTmutvDXX2Nex+I3jRswLilH5TfwTm0kFr+rh0qQzh
	 8V89Qd7tIrdMHzGFKARVijNl30XtmFokDJf+5Zo8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	David Belanger <david.belanger@amd.com>,
	Frank Min <frank.min@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>
Subject: [PATCH 6.12 180/466] drm/amdgpu/hdp7.0: do a posting read when flushing HDP
Date: Thu, 12 Dec 2024 15:55:49 +0100
Message-ID: <20241212144313.904386972@linuxfoundation.org>
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

commit 689275140cb8e9f8ae59e545086fce51fb0b994a upstream.

Need to read back to make sure the write goes through.

Cc: David Belanger <david.belanger@amd.com>
Reviewed-by: Frank Min <frank.min@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Cc: stable@vger.kernel.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/amd/amdgpu/hdp_v7_0.c |    6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

--- a/drivers/gpu/drm/amd/amdgpu/hdp_v7_0.c
+++ b/drivers/gpu/drm/amd/amdgpu/hdp_v7_0.c
@@ -31,10 +31,12 @@
 static void hdp_v7_0_flush_hdp(struct amdgpu_device *adev,
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
 
 static void hdp_v7_0_update_clock_gating(struct amdgpu_device *adev,


