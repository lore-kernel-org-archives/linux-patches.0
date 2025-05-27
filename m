Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7507B27EC73;
	Tue, 27 May 2025 17:24:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748366665; cv=none; b=pWsnFnqS9a1mSFkOAqoiowocfN4kc/wnVL8ncKMlCaGUcM7gdeTJL8X32tguYotLHhC+rbSXYO/zHiLdSBC8hDBJlPKmP4BA2O2TxnOyxfwJ95VcGxq1GM94+8zbQ5I6IPacmsjYhrM5wEnlHD+C8wD88FqmYXDJ8zV87tKDRRk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748366665; c=relaxed/simple;
	bh=X7InmAU7jQWHi+ShgAgzu+SV0qZMVscLHmHaxHHm0+4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=X5K0w+sFU+7nUjJw4t4Ef1fs/WP5bQW0R2K4IMgjjfkocsu5qReJPzWHfaFfyAmZp7CY7ZJzwaLaOrMBIo1f+eom+zgIqeVXgvYe0XhMxjteRWqNqYZpU1ALSfrV5MsdIa3vCbp/3kp7itU5MyoCkQyJTJumBpXiVVEqqcKn2A8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=F+O2JyMB; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="F+O2JyMB"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7A7DEC4CEEA;
	Tue, 27 May 2025 17:24:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1748366665;
	bh=X7InmAU7jQWHi+ShgAgzu+SV0qZMVscLHmHaxHHm0+4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=F+O2JyMBlFxQ+ruynOpMVyzwn4hOHRWjaUSsKM7e32DGMX4/2DZg4iOrfpNzXL2C6
	 Tjths29eqBosIYe3QJoQvnDoTi//jpr4Fw8i60/DRs1yO50LiERt7JHiFMtmEZcb3n
	 uMqnPUESOuiH+2Fg0n8LJl6lCj2z9qxxtM7WOMa8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Lijo Lazar <lijo.lazar@amd.com>,
	Flora Cui <flora.cui@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.14 141/783] drm/amdgpu: release xcp_mgr on exit
Date: Tue, 27 May 2025 18:18:58 +0200
Message-ID: <20250527162518.901200801@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250527162513.035720581@linuxfoundation.org>
References: <20250527162513.035720581@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.14-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Flora Cui <flora.cui@amd.com>

[ Upstream commit b5aaa82e2b12feaaa6958f7fa0917ddcc03c24ee ]

Free on driver cleanup.

Reviewed-by: Lijo Lazar <lijo.lazar@amd.com>
Signed-off-by: Flora Cui <flora.cui@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/amd/amdgpu/amdgpu_device.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/gpu/drm/amd/amdgpu/amdgpu_device.c b/drivers/gpu/drm/amd/amdgpu/amdgpu_device.c
index c00a01c62724a..ea50f82b547d9 100644
--- a/drivers/gpu/drm/amd/amdgpu/amdgpu_device.c
+++ b/drivers/gpu/drm/amd/amdgpu/amdgpu_device.c
@@ -4778,6 +4778,9 @@ void amdgpu_device_fini_sw(struct amdgpu_device *adev)
 	kfree(adev->fru_info);
 	adev->fru_info = NULL;
 
+	kfree(adev->xcp_mgr);
+	adev->xcp_mgr = NULL;
+
 	px = amdgpu_device_supports_px(adev_to_drm(adev));
 
 	if (px || (!dev_is_removable(&adev->pdev->dev) &&
-- 
2.39.5



