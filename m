Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1C3121ACEDE;
	Tue, 17 Mar 2026 17:01:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773766898; cv=none; b=CbmH4NX6o1iGNUMNfX27ipZ4lGdyEag0836LIT4EkOe5+EZujm6vOsLxeBORCzR+Ss46LZIBd+UWN47LJsfeC+wbG0gFgJ9ZG29XqhYVYv6/jgW0armA/iMhRbBD1kfVgl9IxqkrPsA0GE0oVam9wX/Wols2ORlX8LIGg6fFszs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773766898; c=relaxed/simple;
	bh=qY4emrirqOfVNkuZaTnXRzz61eKbPkQLO+JZEG72gE4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=fe+Fi5olU4HJ1c4GaYcbEuoK65V3nzTbbLix2LZQpBQJ+Eypzya/j5bkKjNprDrPxely1wkXcQQ/hy/ceCaC4URNM1Sz+DOtYO2attTQ8Ck3CMvRbS/VjeQKfn+UzdRCPl2ICG4vo2evcdcLIhB2+2AH3iH8VUzeuprTccEKTDc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ESLrL4i5; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ESLrL4i5"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 54E60C4CEF7;
	Tue, 17 Mar 2026 17:01:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1773766898;
	bh=qY4emrirqOfVNkuZaTnXRzz61eKbPkQLO+JZEG72gE4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ESLrL4i5i+cMIToWA7JmleBGiKvrYN8KMfNYeqNUKnRld2bhyO0n+mtYzJYlwOJID
	 zcQljv2YJ2BV3W9bG8ymG4ZxTqbbWztszj5+L2mtVU/9Fg1Zuxh991BycMBvX6f/qz
	 wB4cXftK8rrc9kjjD0NuLPMk2TYktN6ZTNXxTozE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Lijo Lazar <lijo.lazar@amd.com>,
	Mario Limonciello <mario.limonciello@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>
Subject: [PATCH 6.19 302/378] drm/amd: Set num IP blocks to 0 if discovery fails
Date: Tue, 17 Mar 2026 17:34:19 +0100
Message-ID: <20260317163018.114888425@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260317163006.959177102@linuxfoundation.org>
References: <20260317163006.959177102@linuxfoundation.org>
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

6.19-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Mario Limonciello <mario.limonciello@amd.com>

commit 3646ff28780b4c52c5b5081443199e7a430110e5 upstream.

If discovery has failed for any reason (such as no support for a block)
then there is no need to unwind all the IP blocks in fini. In this
condition there can actually be failures during the unwind too.

Reset num_ip_blocks to zero during failure path and skip the unnecessary
cleanup path.

Suggested-by: Lijo Lazar <lijo.lazar@amd.com>
Reviewed-by: Lijo Lazar <lijo.lazar@amd.com>
Signed-off-by: Mario Limonciello <mario.limonciello@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
(cherry picked from commit fae5984296b981c8cc3acca35b701c1f332a6cd8)
Cc: stable@vger.kernel.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/amd/amdgpu/amdgpu_device.c |    4 +++-
 drivers/gpu/drm/amd/amdgpu/amdgpu_kms.c    |    2 +-
 2 files changed, 4 insertions(+), 2 deletions(-)

--- a/drivers/gpu/drm/amd/amdgpu/amdgpu_device.c
+++ b/drivers/gpu/drm/amd/amdgpu/amdgpu_device.c
@@ -2843,8 +2843,10 @@ static int amdgpu_device_ip_early_init(s
 		break;
 	default:
 		r = amdgpu_discovery_set_ip_blocks(adev);
-		if (r)
+		if (r) {
+			adev->num_ip_blocks = 0;
 			return r;
+		}
 		break;
 	}
 
--- a/drivers/gpu/drm/amd/amdgpu/amdgpu_kms.c
+++ b/drivers/gpu/drm/amd/amdgpu/amdgpu_kms.c
@@ -83,7 +83,7 @@ void amdgpu_driver_unload_kms(struct drm
 {
 	struct amdgpu_device *adev = drm_to_adev(dev);
 
-	if (adev == NULL)
+	if (adev == NULL || !adev->num_ip_blocks)
 		return;
 
 	amdgpu_unregister_gpu_instance(adev);


