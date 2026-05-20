Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 06BE5367B8D;
	Wed, 20 May 2026 16:42:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779295352; cv=none; b=Zdbsn9AINnlg6kPtFqbXWe9ubvVZnZnRfzbvHnNFf1FBuGwXFKvf9lLwWNJeqHECMeEdITnx4fx05S/BDDd5Y7CEYI+prb46Pb/lhAcJTVuPbZ4HdbText54OrZcdR1x1vnYhrWdZPJljfYiK8pc6K25BVobq3IEPrLTGoOs/q0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779295352; c=relaxed/simple;
	bh=WsdjYOPaECQDkSS9U+QCdvtdsCivPo08ZwxDn/h0YQA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=V7eJKi6oDZBVI42DUOPYANL+YVnRntAl5UnV9R1o1Yv4UV7vVLKC25bF2iYpHvu8+GjPwtCM1/FAxhjK+NJHSWq+BpX+URkyELZp/xDr5NS4XZGsI4zWfgd3CLbOI7MO6lhBzY1RVdwuzB3ff3zAIcO2ticLP+rDLHVRykyX+RQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=cnTuJbMP; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="cnTuJbMP"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6D55D1F000E9;
	Wed, 20 May 2026 16:42:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1779295350;
	bh=eL887zRX4baw/UiaLNG0vCHFmkqhHdbQ6l0ovVjgQHI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=cnTuJbMPDU3CdY7rz1/avoeRpZ6yv9YNiF9HTM65KTQcnrem/XpHK+edsmfFgMeNm
	 p1S74lSpQqRr/sWS869mwuKJe0YaGoXmRJ1HZ6N3GWQsB26uaZMpmHD3VOzd88vyDL
	 B7IPunXs4M6fja0yj3wUZ8Y9cgo2pW1wmy7NDJ1E=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Timur=20Krist=C3=B3f?= <timur.kristof@gmail.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.0 0345/1146] drm/amdgpu/uvd4.2: Dont initialize UVD 4.2 when DPM is disabled
Date: Wed, 20 May 2026 18:09:55 +0200
Message-ID: <20260520162156.008921826@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260520162148.390695140@linuxfoundation.org>
References: <20260520162148.390695140@linuxfoundation.org>
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

7.0-stable review patch.  If anyone has any objections, please let me know.

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
index 73ce3d211ed64..8a9ba2276275c 100644
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



