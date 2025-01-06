Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6831F44C7C;
	Mon,  6 Jan 2025 15:34:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736177656; cv=none; b=GN/BC6tqPSqBVAaD2cnNAWUvHk7iGwi2Srh+ln2FZA5GMCycm2drpNWLoymyvm4e/efnW8dWrQcx62+8iIGTIP5KAabNXt+kxCoDpFJ3XarwBi1VWyUP+KuuDmPsj8GL/gD8beikSTtDKgM/jlRalYelrZPxKWhHt4LhfyZonhk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736177656; c=relaxed/simple;
	bh=QlwIHDf548P4Y8mumSyYfg/S6Fq18/KrJzpBAUWluwQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=NvnwloBivwbd0qPWkxHFqdVEc+k/azBhVjkU0QPVZ4JCA78ChNITp+3sjb0HxKHi+hpvZpzV6KSK8yc0rpJ2hyU+VFHPBS24OZ5dCvNpc2sLN5EiLXzfBUzXqvYmKrbrR+b8iKwffbXwuspwUJGx8ux2LwROWq5rNoFGMYBA5uo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=IcVhu4p4; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="IcVhu4p4"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 97F4EC4CED2;
	Mon,  6 Jan 2025 15:34:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1736177656;
	bh=QlwIHDf548P4Y8mumSyYfg/S6Fq18/KrJzpBAUWluwQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=IcVhu4p4TMw71KbLNU+u5p3+jQDHRNoh72J3GlQtrQF9doiVugKY0YsRuROCIc1jV
	 XAAeo22pBdMGj9dgf5A8kvk2TPdBigAGw9rKg45yDkVNl1/S6GA+cV2zLTWDlxGRyy
	 wFBfL4Y8v83ALbX4LNhKtNgdOXIIP7WE5Jzovho8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Alex Deucher <alexander.deucher@amd.com>
Subject: [PATCH 6.12 002/156] drm/amdgpu: fix backport of commit 73dae652dcac
Date: Mon,  6 Jan 2025 16:14:48 +0100
Message-ID: <20250106151141.833307383@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20250106151141.738050441@linuxfoundation.org>
References: <20250106151141.738050441@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Alex Deucher <alexander.deucher@amd.com>

Commit 73dae652dcac ("drm/amdgpu: rework resume handling for display (v2)")
missed a small code change when it was backported resulting in an automatic
backlight control breakage.  Fix the backport.

Note that this patch is not in Linus' tree as it is not required there;
the bug was introduced in the backport.

Fixes: 99a02eab8251 ("drm/amdgpu: rework resume handling for display (v2)")
Closes: https://gitlab.freedesktop.org/drm/amd/-/issues/3853
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Cc: stable@vger.kernel.org # 6.11.x
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/amd/amdgpu/amdgpu_device.c |    6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

--- a/drivers/gpu/drm/amd/amdgpu/amdgpu_device.c
+++ b/drivers/gpu/drm/amd/amdgpu/amdgpu_device.c
@@ -3721,8 +3721,12 @@ static int amdgpu_device_ip_resume_phase
 			continue;
 		if (adev->ip_blocks[i].version->type == AMD_IP_BLOCK_TYPE_DCE) {
 			r = adev->ip_blocks[i].version->funcs->resume(adev);
-			if (r)
+			if (r) {
+				DRM_ERROR("resume of IP block <%s> failed %d\n",
+					  adev->ip_blocks[i].version->funcs->name, r);
 				return r;
+			}
+			adev->ip_blocks[i].status.hw = true;
 		}
 	}
 


