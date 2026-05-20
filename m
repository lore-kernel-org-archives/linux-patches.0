Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F082429D26E;
	Wed, 20 May 2026 17:29:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779298172; cv=none; b=fE/fySeY6++K2Y0wCqP7Ypw59pYjblsYCjuAa4beQ3PPGwGPxFpttn1h2MpSNGWHxBsluvHDs3ggI0raHtUE3dFP2Xoqs5wW3WfduEvclRVImwQJ/8PY3qwZ2YOIVdJZzpy1ShLaddFn2qzZR4XNbZGH3Xoz6416MLKvjQ5Lwes=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779298172; c=relaxed/simple;
	bh=zdFr8MnMs5DJXCpbsw+wCZolHluhWPUJOP48kX1kapM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=j6WNL+lHNRq9IqBBZyOPZN9GUKDdWS2rmKrNQEoWdBdHLYQBHWJgBQhOntpTkmbcPxh+1018NNGmvHS6TXWRJRaN8DAQU/GeNcBxk2S/Sj4AT6CVHnw+61N+AvLywpAAjPpP87iFlg82jQsLMjCMgGYpjHc01Aj/Ey9xd6gnYm0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=uORChccl; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="uORChccl"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 00F661F000E9;
	Wed, 20 May 2026 17:29:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1779298170;
	bh=rhQIWOjSjFwC5wvFcZ2T36a66n5huZ2IFXPDvGmlIQc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=uORChcclLcxgvEiclIGvvUw6pVYv5Jp7F/21cwj8bK6ftbSHEq5XpHjfCPlbSyBYr
	 7PL0a2Z7nTnshVU1vwsMM1VGo19279ldJiADxp9lqHBIWaexnqbjX9fJEetk9OUmiq
	 7kdc7FMf0lvNb5S719TupoGUWjhv2OKQ+opJooAA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Timur=20Krist=C3=B3f?= <timur.kristof@gmail.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 267/957] drm/amdgpu/uvd4.2: Dont initialize UVD 4.2 when DPM is disabled
Date: Wed, 20 May 2026 18:12:30 +0200
Message-ID: <20260520162140.334063418@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260520162134.554764788@linuxfoundation.org>
References: <20260520162134.554764788@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Timur Kristóf <timur.kristof@gmail.com>

[ Upstream commit 8b3e8fa6d7bdab292447a43f70532db437d5d4f5 ]

UVD 4.2 doesn't work at all when DPM is disabled because
the SMU is responsible for ungating it. So, Linux fails
to boot with CIK GPUs when using the amdgpu.dpm=0 parameter.

Fix this by returning -ENOENT from uvd_v4_2_early_init()
when amdgpu_dpm isn't enabled.

Note: amdgpu.dpm=0 is often suggested as a workaround
for issues and is useful for debugging.

Fixes: a2e73f56fa62 ("drm/amdgpu: Add support for CIK parts")
Signed-off-by: Timur Kristóf <timur.kristof@gmail.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/amd/amdgpu/uvd_v4_2.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/drivers/gpu/drm/amd/amdgpu/uvd_v4_2.c b/drivers/gpu/drm/amd/amdgpu/uvd_v4_2.c
index 4b96fd5837720..d7302938e6662 100644
--- a/drivers/gpu/drm/amd/amdgpu/uvd_v4_2.c
+++ b/drivers/gpu/drm/amd/amdgpu/uvd_v4_2.c
@@ -93,6 +93,11 @@ static void uvd_v4_2_ring_set_wptr(struct amdgpu_ring *ring)
 static int uvd_v4_2_early_init(struct amdgpu_ip_block *ip_block)
 {
 	struct amdgpu_device *adev = ip_block->adev;
+
+	/* UVD doesn't work without DPM, it needs DPM to ungate it. */
+	if (!amdgpu_dpm)
+		return -ENOENT;
+
 	adev->uvd.num_uvd_inst = 1;
 
 	uvd_v4_2_set_ring_funcs(adev);
-- 
2.53.0



