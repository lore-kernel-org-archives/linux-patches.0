Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7797336A357;
	Wed, 20 May 2026 16:41:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779295262; cv=none; b=HG8wOakqiPBcpPFS7UiUEAEvSADaYox6k/F++f0K2FKCsJ4y6qvFS6nRCFRnjXwtHWGrOvuNyTOiou/kDDxM3iYDWLPMB19emzh0hjE9r5CHs5bcneZrEz6iY3D13I9QiwtNI3YeX1kf52Qo5QoKBPapjP4nmgZzglUaDyxWUXo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779295262; c=relaxed/simple;
	bh=GtR+tyU5gU4rM2AgkakyGNNx0X1JqilACxWDBqIegtg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=uj4rKS7Cxw+ocooDHwuS2pHJon4p7FHIoELbyQNMmlBvYQzEZIW98ufoc+6CUvALOwoZUL89J6yPIPPNRdnbYBoGUS7oRLYUE226VXf4jumf70gnoxZJqW3QhU1daLyzVGjijLRD4MiTvddWY+xl6ELH2m+wF3mJ5Ig6RxO9URU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=YDkTHOyl; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="YDkTHOyl"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DB9C71F000E9;
	Wed, 20 May 2026 16:41:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1779295261;
	bh=AocsUpdHOGPep7RItUqQ+H79gkswHBqCaa4z9X03ykY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=YDkTHOylc/ueBoloYlXHJ49bWNvyJfyAlzqScImeKVX4vCrNgQAqmjCVCm0YBykc8
	 5VBXFH0+x8GvA6TabM16jkmFMUi8AHy6ocUrM2ySK8dDqIu3rO8HF6eFu/HkQrYfrg
	 XFVW7wdWvjHVFjCjRn+G4lmkr5hvJxB2J7BiEfEk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Rob Clark <robin.clark@oss.qualcomm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.0 0353/1146] drm/msm: Reject fb creation from _NO_SHARE objs
Date: Wed, 20 May 2026 18:10:03 +0200
Message-ID: <20260520162156.188851634@linuxfoundation.org>
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
Content-Transfer-Encoding: 8bit

7.0-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Rob Clark <robin.clark@oss.qualcomm.com>

[ Upstream commit cf50ccdb765b3a6f1cd8e75642b0439fea0263a5 ]

It would be an error to map these into kms->vm.  So reject this as early
as possible, when creating an fb.

Fixes: b58e12a66e47 ("drm/msm: Add _NO_SHARE flag")
Signed-off-by: Rob Clark <robin.clark@oss.qualcomm.com>
Patchwork: https://patchwork.freedesktop.org/patch/714264/
Message-ID: <20260325185926.1265661-1-robin.clark@oss.qualcomm.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/msm/msm_fb.c | 7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

diff --git a/drivers/gpu/drm/msm/msm_fb.c b/drivers/gpu/drm/msm/msm_fb.c
index b3fdb83202ab8..9b681e144c07a 100644
--- a/drivers/gpu/drm/msm/msm_fb.c
+++ b/drivers/gpu/drm/msm/msm_fb.c
@@ -219,7 +219,12 @@ static struct drm_framebuffer *msm_framebuffer_init(struct drm_device *dev,
 			 + mode_cmd->offsets[i];
 
 		if (bos[i]->size < min_size) {
-			ret = -EINVAL;
+			ret = UERR(EINVAL, dev, "plane %d too small", i);
+			goto fail;
+		}
+
+		if (to_msm_bo(bos[i])->flags & MSM_BO_NO_SHARE) {
+			ret = UERR(EINVAL, dev, "Cannot map _NO_SHARE to kms vm");
 			goto fail;
 		}
 
-- 
2.53.0



