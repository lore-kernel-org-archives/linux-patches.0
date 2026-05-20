Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D4B443F6619;
	Wed, 20 May 2026 18:07:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779300468; cv=none; b=u2qf68UhgAuOOpBUvLOxyKTdMcwF35cmwadEs7R+D9E8ijlWGGqB/8XYjt2KZ9A7jXUyTiBpv4tYVweOEl69yYOHvvIZyGd9wzkqYwkRlrUXkDXnX/+L6fToP0TfuCO+jlq8GOIdHVamZ4RBZkRlHRayZPWbGlAgGZYFsH5/hT4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779300468; c=relaxed/simple;
	bh=mB480pCGpy2dLPGf8jhZVIx5Cl8vziqHaaPU58H2tbo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=QppCFvv+LUqKJJwT4xkoY33bK+P9crkt+WRaSsutuvH/mEzM/qz/p/Od98eTtEFQKCglLTZXoxYOag4iG4YG5khufBBuPPZmr4LZPAM9DRhIa/HkQVmFia5X924tuK+wVv1js4a5j7gy/v9VU6nt/kpqYLDFbyXlQULoUFHmhs4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=uOfankGb; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="uOfankGb"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EDA661F00893;
	Wed, 20 May 2026 18:07:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1779300467;
	bh=8xLt0iBOICE6vMX2gbI/sIFSEQyly6QXnVwU9msohhk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=uOfankGbWQd7FOLdYChq0MnPuKg4AslwsywJBJZ0owtUed0rYqGR2RemRqYaOyqnV
	 3hfKwTA2AVro3CRosxZ/tlxSbFTBBzLxpmhZsSqpTUNLqRXw8D1IhhUgL7xibi7Cbd
	 LaHMMvTrG7rEJNWQ8iuPUI+zyMJc8XOImLBboXRU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Timur=20Krist=C3=B3f?= <timur.kristof@gmail.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 186/666] drm/amdgpu/uvd4.2: Dont initialize UVD 4.2 when DPM is disabled
Date: Wed, 20 May 2026 18:16:37 +0200
Message-ID: <20260520162115.234086796@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260520162111.222830634@linuxfoundation.org>
References: <20260520162111.222830634@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
index 5c46174dabbf3..0d291c497eed7 100644
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



