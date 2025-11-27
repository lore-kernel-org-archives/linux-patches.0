Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0267826159E;
	Thu, 27 Nov 2025 15:01:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764255662; cv=none; b=BAGioI9DmIfowwuK0zglOyZOIb9PIar5G0f3n0SsdKNrqI81lM63OEP/BVl8NPH5BsgmMeLX+XWsucAbF4bp2a0XE8tKT7wUA1iljXf2uQHTDqifpXFjSn/EHbY1dIK6uwTZyVMx6EijBk6lmRJn7Gvdei8XyneQlPuT7jPYGmg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764255662; c=relaxed/simple;
	bh=WLL1sQhyuqRF4AiLPmT3G4S6x5xlHksaXwmYBhilXTo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ksAHoWq44237of0xOA+YczRft+NtyaEac5cNJQSWcesQCjHY64etYqarPlPCzWcysnpnSDdGCX2QOiYbKdvUoc7ZEII+/q/Pjsd1KGKBUseer9nRB4lKBBSgAfh3PjfTIcwrMd7U+JP7F5w5eSKs3QHCXK66VPb7EsJ4LpfgLzo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=aBfTAXCY; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="aBfTAXCY"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 80479C4CEF8;
	Thu, 27 Nov 2025 15:01:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1764255661;
	bh=WLL1sQhyuqRF4AiLPmT3G4S6x5xlHksaXwmYBhilXTo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=aBfTAXCYvAkRUsZ0ko0N4B5u4efe0pBqJlN1Rz3Z+hRfd8qkYj6mLL1m2AUfhv30l
	 e6CjJiWbVssUASPsy9sKAbFkCrgkP1dMCijig6S9Wtma9DpfAvgUwUGXS9oAnF26zG
	 oUq0RH2elpGeC+mJ19S38CkBXNMF2TXdS0nKXwhc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Peyton.Lee@amd.com,
	Alex Deucher <alexander.deucher@amd.com>,
	Mario Limonciello <mario.limonciello@amd.com>
Subject: [PATCH 6.17 071/175] drm/amd: Skip power ungate during suspend for VPE
Date: Thu, 27 Nov 2025 15:45:24 +0100
Message-ID: <20251127144045.559397909@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251127144042.945669935@linuxfoundation.org>
References: <20251127144042.945669935@linuxfoundation.org>
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

6.17-stable review patch.  If anyone has any objections, please let me know.

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
@@ -3360,10 +3360,11 @@ int amdgpu_device_set_pg_state(struct am
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


