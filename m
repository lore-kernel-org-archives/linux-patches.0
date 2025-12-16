Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 24C54358D38;
	Tue, 16 Dec 2025 12:29:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765888159; cv=none; b=RxR/IGw1lCgIyEtBDQqkXb8sU/TSfyL0cI88gCUbsQJe81RA01yLO7EFnlyhwdyLTjjn4/TFcyfwj0lxaWHdFQDyb6jtH13r8lp5vPbUXrQqbYnZ+YsFAC541AOMdt7DwgAqnI6KwOKb7moHeFBp/zCvvOZXn4kx4kISoGOgHLU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765888159; c=relaxed/simple;
	bh=TaRDtmoi91IKI+dVjVCezzXpzhM1kLhNjgtI9PPnsa0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=OJZh5o3VqUEZQHfOOA37lua9v1cp/9FNqjzeLkF6umBWU9IU2buGYf8u/2dSqI4VkCF04twgzXOIXjH9KVzhhhAodFfWXUJ2YxDgSsPJ9rDSVONQ+BrOspcP+iQI8CGA+DZVKv6J0DGgw78c0gIhIGO40sFcef/H/oP9zVU3s1o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=UvAAT7So; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="UvAAT7So"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9B6DAC4CEF5;
	Tue, 16 Dec 2025 12:29:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1765888159;
	bh=TaRDtmoi91IKI+dVjVCezzXpzhM1kLhNjgtI9PPnsa0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=UvAAT7SovkJmBebWvilg9UQ3k60cQbqBxXxk4c01NVkJMGaM/xQBuRakfDDl2kWfn
	 VCvq3lxEUq4TtkgZlSK1o8kACe/I7mM2pmkxAPkYAnaKZV3Pjx4VLPdA0zMWjbhA4k
	 7W72r0XhAkXEsfh/7cN0H9Mq0MAf99y3r2uaUG6A=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Eric Huang <jinhuieric.huang@amd.com>,
	Harish Kasiviswanathan <Harish.Kasiviswanathan@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 449/614] drm/amdkfd: assign AID to uuid in topology for SPX mode
Date: Tue, 16 Dec 2025 12:13:36 +0100
Message-ID: <20251216111417.638619314@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251216111401.280873349@linuxfoundation.org>
References: <20251216111401.280873349@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Eric Huang <jinhuieric.huang@amd.com>

[ Upstream commit 089702632f1dd38fadc9af13816485d6aa518dbb ]

XCD id is assigned to uuid, which causes some performance
drop in SPX mode, assigning AID back will resolve the
issue.

Fixes: 3a75edf93aae ("drm/amdkfd: set uuid for each partition in topology")
Signed-off-by: Eric Huang <jinhuieric.huang@amd.com>
Reviewed-by: Harish Kasiviswanathan <Harish.Kasiviswanathan@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/amd/amdkfd/kfd_topology.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/gpu/drm/amd/amdkfd/kfd_topology.c b/drivers/gpu/drm/amd/amdkfd/kfd_topology.c
index 5c98746eb72df..811636af14eaa 100644
--- a/drivers/gpu/drm/amd/amdkfd/kfd_topology.c
+++ b/drivers/gpu/drm/amd/amdkfd/kfd_topology.c
@@ -530,7 +530,9 @@ static ssize_t node_show(struct kobject *kobj, struct attribute *attr,
 		sysfs_show_32bit_prop(buffer, offs, "sdma_fw_version",
 				      dev->gpu->kfd->sdma_fw_version);
 		sysfs_show_64bit_prop(buffer, offs, "unique_id",
-				      dev->gpu->xcp ?
+				      dev->gpu->xcp &&
+				      (dev->gpu->xcp->xcp_mgr->mode !=
+				       AMDGPU_SPX_PARTITION_MODE) ?
 				      dev->gpu->xcp->unique_id :
 				      dev->gpu->adev->unique_id);
 		sysfs_show_32bit_prop(buffer, offs, "num_xcc",
-- 
2.51.0



