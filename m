Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2AFA72701C4;
	Wed, 20 May 2026 17:27:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779298074; cv=none; b=CA3chMtHDzhPikXynYZdzwams9ygGKFQP6V1DSqK6of9DWahStr2q6fBlZiu8xGKWDy4sjQq+CiBsHiI1g4d24oQy/qDlUkZt5hUdrQcUayqb/cGWaHoDrbv1d/bjHH0mhaQc0hvPC/LWBJ9/MyKeBDadtM3QkPS8RCGM2yDhiE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779298074; c=relaxed/simple;
	bh=SClD+vf7EKZwe3afFgp5ihuDmJz/NgCWzOMgZncBMzM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=rUmffUC+T5SWnP+RsEdKfCNvy8/AADu5C5A687Xs8RqvGLKNtOZTJp7qtObOHiQlq3G1JjDZklijYYiSRnHeYbZXVSbTRldk3t/zzhbsfa9i8GjFB1A7lah8wvxfxlyMf7JvvUvuOh+rH/uwBuTIDlncTka97Mm9NddlwwPliW8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=zTdSqPIR; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="zTdSqPIR"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 86FA21F000E9;
	Wed, 20 May 2026 17:27:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1779298073;
	bh=nMA5n2yQYgxFLIKEta3GBkm357KjwGnkH4Kl7VIO/dY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=zTdSqPIRfpI3dhGm6A/wtKDgo2GwBkXznzAwRAUyRJYnl37FfDVMUa+3qXmdOE+eB
	 /HPsx8yx46pQfHmYa8UTuYgagRx59Iw68QgMn5ZdBAPBdOfPaekJ5hWcsvEI40L7NN
	 MJhIIElcNp+tlNNBZKhQPw2FjD91cKEW/VfB/mTg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Rob Clark <robin.clark@oss.qualcomm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 273/957] drm/msm: Reject fb creation from _NO_SHARE objs
Date: Wed, 20 May 2026 18:12:36 +0200
Message-ID: <20260520162140.463246214@linuxfoundation.org>
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
Content-Transfer-Encoding: 8bit

6.18-stable review patch.  If anyone has any objections, please let me know.

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
index 1eff615ff9bff..ce1725990a48d 100644
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



