Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 98BB4312803;
	Tue, 26 Aug 2025 13:08:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756213702; cv=none; b=JpyTA5laQROc5ZHFt/ZvHdvedDsyCpMmlWgC2Zw4tBMn7ODlxv6rY16dQN7hzRVfI5yifMneKXbzCDE3lYp99XDAHaNaDq8YFvSsesJcyMJSHagmH3mWoQN/sADQnfFb9427TdT/T27BmwW5CRZPOQn3jnF1jj/j6fGusFe3aig=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756213702; c=relaxed/simple;
	bh=RxOaIXi3YX73eoQOtzFnSo+vLF20Wx1UUNz1Zj2OP+I=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ijKtSvzMHRPMH4rRzE4uLspPLfxNHalI0jOLjonaspgo8roZipTyfUvsWSq0NHpVz3XY5xeU9fYYAp3hqx9OFs1Tkfuzizti/I12Pto49M79KfWCN7DKkrEYvz8LsSxpGHNc0UsRTjtMDAMyfGira5sO2r1yYFYBULBfFNDNSg0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=y/vdfvN4; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="y/vdfvN4"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CF59FC4CEF1;
	Tue, 26 Aug 2025 13:08:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1756213702;
	bh=RxOaIXi3YX73eoQOtzFnSo+vLF20Wx1UUNz1Zj2OP+I=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=y/vdfvN4Wu9ZMTMwz9MnJ9eZnRiy7R+h5VtbjR3G+HiKp1CYI1PIY6CyzfJPyLuuK
	 DobGGHWED5jcV1OVhvokklGS7DRfCCNv7vFgbpFG+nBrROCnDUUenk3tPt1GZlxJbD
	 yzDxrBKedIXbFXwJMlaRIoe31TQyWZlpA4Wzz2cI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Alex Deucher <alexander.deucher@amd.com>,
	Mario Limonciello <mario.limonciello@amd.com>
Subject: [PATCH 6.6 417/587] drm/amd: Restore cached power limit during resume
Date: Tue, 26 Aug 2025 13:09:26 +0200
Message-ID: <20250826111003.546273451@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250826110952.942403671@linuxfoundation.org>
References: <20250826110952.942403671@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Mario Limonciello <mario.limonciello@amd.com>

commit ed4efe426a49729952b3dc05d20e33b94409bdd1 upstream.

The power limit will be cached in smu->current_power_limit but
if the ASIC goes into S3 this value won't be restored.

Restore the value during SMU resume.

Acked-by: Alex Deucher <alexander.deucher@amd.com>
Link: https://lore.kernel.org/r/20250725031222.3015095-2-superm1@kernel.org
Signed-off-by: Mario Limonciello <mario.limonciello@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
(cherry picked from commit 26a609e053a6fc494403e95403bc6a2470383bec)
Cc: stable@vger.kernel.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/amd/pm/swsmu/amdgpu_smu.c |    6 ++++++
 1 file changed, 6 insertions(+)

--- a/drivers/gpu/drm/amd/pm/swsmu/amdgpu_smu.c
+++ b/drivers/gpu/drm/amd/pm/swsmu/amdgpu_smu.c
@@ -1757,6 +1757,12 @@ static int smu_resume(void *handle)
 
 	adev->pm.dpm_enabled = true;
 
+	if (smu->current_power_limit) {
+		ret = smu_set_power_limit(smu, smu->current_power_limit);
+		if (ret && ret != -EOPNOTSUPP)
+			return ret;
+	}
+
 	dev_info(adev->dev, "SMU is resumed successfully!\n");
 
 	return 0;


