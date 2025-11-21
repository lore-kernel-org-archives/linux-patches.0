Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 83E412DEA7E;
	Fri, 21 Nov 2025 13:26:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763731595; cv=none; b=X/xjjaebjvhlGGz2SnZjDNVF0othOJXPMbmAJWmIWQwLW4cxEFQneKbDxo/VmKrD6ETzyNdro4ieofxQjGPEXNmbDqhnkvp7tyMoBawgf9R3h91kaV3oy45XSIeqJiSvrespkxRCU9pt6+gp5NXkbWwsMoXQrS/QMHgayb4t2ds=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763731595; c=relaxed/simple;
	bh=BVd4YJaXaBu6huSevF2TXd2W4pComrNkeToByOJKouI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=V/vfmDrwLgaU+m7vQGGqFJXMKQ6Sva2rC8713dEHedVkljr0zw/rbZJ7mcQCogllzESmYGu/y8OgScsqrAzZKJG+eGeDVoJzM8Zzu1HpedFjK5Rdx/dlqJnDDpXle33YiGCFuSTXG6TNsL1e3NOWUPs1/XfI2H1YnHGJt9Sj8Tk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=OT+Ok64d; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="OT+Ok64d"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 02D75C4CEF1;
	Fri, 21 Nov 2025 13:26:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1763731595;
	bh=BVd4YJaXaBu6huSevF2TXd2W4pComrNkeToByOJKouI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=OT+Ok64dsC9BNY1BzJmLl/4IEOiB9dX0p6Gfivh7BWwuiBf6YfcWrzRNlY9Bz6pFu
	 a0hI4pqxUIOllt9wRMcmz7ou72D9rmz/KpqfoYQ/2N0zEoppmhJVdMRd/LuJEFLDHv
	 4/GRtMXvHDNSCmKpOk2cQndOUqJeiOlqoQ4uuEw0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mario Limonciello <mario.limonciello@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 006/185] drm/amd: Fix suspend failure with secure display TA
Date: Fri, 21 Nov 2025 14:10:33 +0100
Message-ID: <20251121130144.097359965@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251121130143.857798067@linuxfoundation.org>
References: <20251121130143.857798067@linuxfoundation.org>
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

[ Upstream commit b09cb2996cdf50cd1ab4020e002c95d742c81313 ]

commit c760bcda83571 ("drm/amd: Check whether secure display TA loaded
successfully") attempted to fix extra messages, but failed to port the
cleanup that was in commit 5c6d52ff4b61e ("drm/amd: Don't try to enable
secure display TA multiple times") to prevent multiple tries.

Add that to the failure handling path even on a quick failure.

Closes: https://gitlab.freedesktop.org/drm/amd/-/issues/4679
Fixes: c760bcda8357 ("drm/amd: Check whether secure display TA loaded successfully")
Signed-off-by: Mario Limonciello <mario.limonciello@amd.com>
Reviewed-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
(cherry picked from commit 4104c0a454f6a4d1e0d14895d03c0e7bdd0c8240)
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/amd/amdgpu/amdgpu_psp.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/drivers/gpu/drm/amd/amdgpu/amdgpu_psp.c b/drivers/gpu/drm/amd/amdgpu/amdgpu_psp.c
index a8358d1d1acbc..fa84208eed18e 100644
--- a/drivers/gpu/drm/amd/amdgpu/amdgpu_psp.c
+++ b/drivers/gpu/drm/amd/amdgpu/amdgpu_psp.c
@@ -2174,8 +2174,11 @@ static int psp_securedisplay_initialize(struct psp_context *psp)
 	if (!ret && !psp->securedisplay_context.context.resp_status) {
 		psp->securedisplay_context.context.initialized = true;
 		mutex_init(&psp->securedisplay_context.mutex);
-	} else
+	} else {
+		/* don't try again */
+		psp->securedisplay_context.context.bin_desc.size_bytes = 0;
 		return ret;
+	}
 
 	mutex_lock(&psp->securedisplay_context.mutex);
 
-- 
2.51.0



