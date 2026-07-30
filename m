Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4708341F35E;
	Thu, 30 Jul 2026 15:14:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785424490; cv=none; b=rd1n6qCGwOlupGWXsZZnGhdYXdPKRqZ47Aqhz9M/+RlW5/YI2Fc3Ks53Sgmt6FxlWsmrXwv+uHA6JLEZFHOXl9tIFUECHV+EbQt4ZcY4ktZnxha8dLGkrzLad6+7yPK2JbvYJFbuNLT/Dsl6UR6BORoEFkzl95JCPWrzB30/PmA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785424490; c=relaxed/simple;
	bh=61HKwBDoWuP5TyqAyljBJr//CGE/z6SsxCubyMGSaRY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=APH3hG+mhVW0xQhs6DLoSzsYox0hGKSQ3kgcPIW9XAxng7iu9Q3IUjiCzVsP46AHOryB17/7UNsiiMmp2WRmAmPYLKxp4zBS8sljiLCmrbcUjmfVIN1nPeiZY06zCWu778tZVPr2n7d4GU5Ksh8Oh8kSqxs6SD69jFhTZIrIEQc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=IynRle7p; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="IynRle7p"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A391A1F000E9;
	Thu, 30 Jul 2026 15:14:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1785424489;
	bh=tesPeXa+/J2co/ngvwapc+8f1DPdK3QxG1H+lWkV8iA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=IynRle7pXU8xoQo4B5FozkG1Gg7AO+lVQcMOV8wWtuQuSlU+on4MV0/dZpo/45glH
	 Mwufa/Xz54QrkiKIv0A1xDJ72mWQyCPbgcrDVdQf+oNuLJ5Ko/0ZoteWPwBz8XMfc1
	 eI3W9fiJTHZR2+0EK0JPzM/8JQyXOqeVgeiG1N38=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Kenneth Feng <kenneth.feng@amd.com>,
	Yang Wang <kevinyang.wang@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>
Subject: [PATCH 6.18 367/675] drm/amd/amdgpu: disable ASPM on VI if pcie dpm is disabled
Date: Thu, 30 Jul 2026 16:11:37 +0200
Message-ID: <20260730141452.928877875@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260730141445.110192266@linuxfoundation.org>
References: <20260730141445.110192266@linuxfoundation.org>
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

From: Kenneth Feng <kenneth.feng@amd.com>

commit 18a7826aea6fd09f2d371c02cec70c7234fc4879 upstream.

Disable ASPM on VI if PCIE dpm is disabled.

Fixes: bb00bf17328d ("drm/amd/amdgpu: decouple ASPM with pcie dpm")
Closes: https://gitlab.freedesktop.org/drm/amd/-/work_items/5370
Signed-off-by: Kenneth Feng <kenneth.feng@amd.com>
Reviewed-by: Yang Wang <kevinyang.wang@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
(cherry picked from commit 873a8d6b3c0a386408c891e4ff1c684fa11783e1)
Cc: stable@vger.kernel.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/amd/amdgpu/amdgpu_device.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/drivers/gpu/drm/amd/amdgpu/amdgpu_device.c
+++ b/drivers/gpu/drm/amd/amdgpu/amdgpu_device.c
@@ -1888,7 +1888,8 @@ static bool amdgpu_device_aspm_support_q
 	 * It's unclear if this is a platform-specific or GPU-specific issue.
 	 * Disable ASPM on SI for the time being.
 	 */
-	if (adev->family == AMDGPU_FAMILY_SI)
+	if (adev->family == AMDGPU_FAMILY_SI ||
+		(!(adev->pm.pp_feature & PP_PCIE_DPM_MASK) && adev->family == AMDGPU_FAMILY_VI))
 		return true;
 
 #if IS_ENABLED(CONFIG_X86)


