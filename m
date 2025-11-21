Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 69C842E92B0;
	Fri, 21 Nov 2025 13:53:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763733189; cv=none; b=c2NblYxKFH6lwxEbLrkvb1+yBJ5pnxDC02FQLa7nFcWlKfHxVwiVk5c7FtnIi/uSIK0+TpcJqP0kMAID2++BGz8w9/OoRcReTSZV+JM+EbXQIqxvUaEm8JCrFLrV6wWnDtsVeo9QsWry7j9siRBC83zg0SvezkVpcyF84N5ij1k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763733189; c=relaxed/simple;
	bh=2SpawXRoT0nIpVC6cZ+k8/a5L5s6yXHbxAKoODSeo/0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=F/iLKZU4sM1Kkt/Dkg4G+MDfOCuVmO5+EsYVkENbMhERHSVnrqRI2DGtu3wQJ52wVRl4nssDHtY5Avh3Tfy9tJo76qIU/NsVujKOIyFFYh4ID6FYAN/bC843Ojl7ZdAY/yrLIdNnZbmaUsiLi0rR6lzHBhsmUV/q+jjXwGEdOVA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=VQgbBKlq; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="VQgbBKlq"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E9112C4CEF1;
	Fri, 21 Nov 2025 13:53:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1763733189;
	bh=2SpawXRoT0nIpVC6cZ+k8/a5L5s6yXHbxAKoODSeo/0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=VQgbBKlqrxlyCWEFIVDHjwrcLCSthU27Y8eU4xLxTpZzbqmG6UENDUpzD+4OkAUIx
	 B4AJqWyc0Ag9OH3x5j+sIqYulGtPgKW0hkA8S/n1JBo/hCDTM+E8WDXYKcyl9jxr5s
	 Wu87Io2D6zuikMOxpHUkudv47tOm75xDGHorxBxM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mario Limonciello <mario.limonciello@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 381/529] drm/amd: Fix suspend failure with secure display TA
Date: Fri, 21 Nov 2025 14:11:20 +0100
Message-ID: <20251121130244.581117611@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251121130230.985163914@linuxfoundation.org>
References: <20251121130230.985163914@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
index d358a08b5e006..08886e0ee6428 100644
--- a/drivers/gpu/drm/amd/amdgpu/amdgpu_psp.c
+++ b/drivers/gpu/drm/amd/amdgpu/amdgpu_psp.c
@@ -2015,8 +2015,11 @@ static int psp_securedisplay_initialize(struct psp_context *psp)
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



