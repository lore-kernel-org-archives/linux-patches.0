Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 997F52882C9;
	Thu, 27 Nov 2025 14:53:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764255214; cv=none; b=uwXb1PHdrBwZNPNqH6Tw7Vt4H1DhADgLSjBnCFx3yMRY4W1bvy52tQ/nZiPgpH6C3sZJ1oM5De+kmzQhBrtYvVrDj4f/g7m95ntY/T63vE82Xqr+mGOZ9QTaoQLQIe/rWf94Gyr1skLUQRR8fxji3PYsR+kAk85hT8xl9jZPTvk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764255214; c=relaxed/simple;
	bh=J0urZKtwvFXI5U+KM6CtG0CCBUun85a9YhlylMDkHpM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=d8o35xG7R0lPI44yP521j/OkThq7Dh7Ck5W9k4dGakV8SpiBltNFoYXAjjYFYzQBdPSArcsIRtdEsF46gwEoq9HfiIRIdF64tdnMnxU2dysigZMQH46BcDai87C7pVctCclTttKxCzFZYswKMQZDL4rmzSEeBiYax1mo7VmA4FU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=RjLWASYp; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="RjLWASYp"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1ECF9C4CEF8;
	Thu, 27 Nov 2025 14:53:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1764255214;
	bh=J0urZKtwvFXI5U+KM6CtG0CCBUun85a9YhlylMDkHpM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=RjLWASYpoegoV+S2ejWHV+yyE73pid3spy/v2pxWAtccnAa7E2tnpuVWuAXBqnY8Y
	 7rcmQwKZTgD+x1+9+y3fEjaaiBKZ/EIRIY6H930hbGHMCU/Ozxg0haSFKKUa4y3OL/
	 bTw9I3/crdzlsMB1UhpjSFeeJXt42mGSF7RoP/iI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Peyton.Lee@amd.com,
	Alex Deucher <alexander.deucher@amd.com>,
	Mario Limonciello <mario.limonciello@amd.com>
Subject: [PATCH 6.12 047/112] drm/amd: Skip power ungate during suspend for VPE
Date: Thu, 27 Nov 2025 15:45:49 +0100
Message-ID: <20251127144034.563794926@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251127144032.705323598@linuxfoundation.org>
References: <20251127144032.705323598@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Mario Limonciello <mario.limonciello@amd.com>

commit 31ab31433c9bd2f255c48dc6cb9a99845c58b1e4 upstream.

During the suspend sequence VPE is already going to be power gated
as part of vpe_suspend().  It's unnecessary to call during calls to
amdgpu_device_set_pg_state().

It actually can expose a race condition with the firmware if s0i3
sequence starts as well.  Drop these calls.

Cc: Peyton.Lee@amd.com
Reviewed-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Mario Limonciello <mario.limonciello@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
(cherry picked from commit 2a6c826cfeedd7714611ac115371a959ead55bda)
Cc: stable@vger.kernel.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/amd/amdgpu/amdgpu_device.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/drivers/gpu/drm/amd/amdgpu/amdgpu_device.c
+++ b/drivers/gpu/drm/amd/amdgpu/amdgpu_device.c
@@ -3090,10 +3090,11 @@ int amdgpu_device_set_pg_state(struct am
 		    (adev->ip_blocks[i].version->type == AMD_IP_BLOCK_TYPE_GFX ||
 		     adev->ip_blocks[i].version->type == AMD_IP_BLOCK_TYPE_SDMA))
 			continue;
-		/* skip CG for VCE/UVD, it's handled specially */
+		/* skip CG for VCE/UVD/VPE, it's handled specially */
 		if (adev->ip_blocks[i].version->type != AMD_IP_BLOCK_TYPE_UVD &&
 		    adev->ip_blocks[i].version->type != AMD_IP_BLOCK_TYPE_VCE &&
 		    adev->ip_blocks[i].version->type != AMD_IP_BLOCK_TYPE_VCN &&
+		    adev->ip_blocks[i].version->type != AMD_IP_BLOCK_TYPE_VPE &&
 		    adev->ip_blocks[i].version->type != AMD_IP_BLOCK_TYPE_JPEG &&
 		    adev->ip_blocks[i].version->funcs->set_powergating_state) {
 			/* enable powergating to save power */


