Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B375C5172DD;
	Thu, 17 Sep 2026 16:57:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789664277; cv=none; b=Cao2FtleZhCb8ezO+xsPexdja96NCdFr0axeUEytTP311B7DT3Xt+9PvWSVigPElH3A2Ire50KVtVAApqsiVw9TPrldUXcYcA0ksrEZ028FDqUR8KUiRL6QmpBqbZOhnmIFUbIgHfMwEZV3Y2893fm/V/Lam1GUEk6OD5qa+xEg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789664277; c=relaxed/simple;
	bh=OwRi8/OXTWkAY5Q0OXMsCNluoYLAnmMINlET6cJt/nM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=aYLb38ZW+17WYFM4pLB7l2j0Y6LTzrdDbW3135qpf3ZLpuAfUjzftAa3ovA1G50+TDxtHdCUVwNJJs832gXCk21ndyHyv6qywAdVWOKJJJif41KYb0g8IVMDvTmoTJyb++rCNOug6ABZbx2FzZdCm22CGjSvg21iEuCltbdVaCY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=DTo3Rgz5; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="DTo3Rgz5"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 038A01F000FF;
	Thu, 17 Sep 2026 16:57:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789664276;
	bh=8JxjTAd6GZndKhKBQetrEFhmqq3/kte0s21QftgFFDk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=DTo3Rgz5powWdhXCTwdfbByS8ASWvkltZt9h/zIc/Qcacrxx9rUNp7vCJAOBmnE7W
	 tNqZ/2L0TJmsLL3dvcKhiaMk/aDmM6SLrGS37q5Ch75FI25PeZg9ARlu6vnvC7FtLV
	 rzTMmm7NZ6NcSqX/ojw8L4z0MYZtmywkb5BuGP20=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Candice Li <candice.li@amd.com>,
	Hawking Zhang <Hawking.Zhang@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0318/1250] drm/amdgpu/pm: fix SmartShift bias sysfs store PM refcount on parse error
Date: Thu, 17 Sep 2026 16:01:53 +0100
Message-ID: <20260917151600.721275602@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260917151551.901433442@linuxfoundation.org>
References: <20260917151551.901433442@linuxfoundation.org>
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

From: Candice Li <candice.li@amd.com>

[ Upstream commit a4b0c3f5d2287997876d8f711a40d3c0418458d8 ]

Return the parse error before acquiring PM access.

Signed-off-by: Candice Li <candice.li@amd.com>
Reviewed-by: Hawking Zhang <Hawking.Zhang@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/amd/pm/amdgpu_pm.c | 8 +++-----
 1 file changed, 3 insertions(+), 5 deletions(-)

diff --git a/drivers/gpu/drm/amd/pm/amdgpu_pm.c b/drivers/gpu/drm/amd/pm/amdgpu_pm.c
index db7296567c85f..6cdb8dda97e0f 100644
--- a/drivers/gpu/drm/amd/pm/amdgpu_pm.c
+++ b/drivers/gpu/drm/amd/pm/amdgpu_pm.c
@@ -1853,12 +1853,12 @@ static ssize_t amdgpu_set_smartshift_bias(struct device *dev,
 {
 	struct drm_device *ddev = dev_get_drvdata(dev);
 	struct amdgpu_device *adev = drm_to_adev(ddev);
-	int r = 0;
+	int r;
 	int bias = 0;
 
 	r = kstrtoint(buf, 10, &bias);
 	if (r)
-		goto out;
+		return r;
 
 	r = amdgpu_pm_get_access(adev);
 	if (r < 0)
@@ -1870,14 +1870,12 @@ static ssize_t amdgpu_set_smartshift_bias(struct device *dev,
 		bias = AMDGPU_SMARTSHIFT_MIN_BIAS;
 
 	amdgpu_smartshift_bias = bias;
-	r = count;
 
 	/* TODO: update bias level with SMU message */
 
-out:
 	amdgpu_pm_put_access(adev);
 
-	return r;
+	return count;
 }
 
 static int ss_power_attr_update(struct amdgpu_device *adev, struct amdgpu_device_attr *attr,
-- 
2.53.0



