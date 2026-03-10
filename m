Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 10045387562;
	Tue, 10 Mar 2026 11:25:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773141927; cv=none; b=OF+EQSBmU+y0KhvFYDrXR0DDpjvfPg1EYPsRyFlU4IGvB+hiKVFCPD7kizzG0GrrinsGXAhG3mhbBY80MRc7VwXtBpzuMz+wCGi2bLSgsGF0ts1aa0Yv+/LXs8Yr7Z30r09Pf/yEIZ2O2540JeiMZ7WrzJbRvFZG5rwWVJe7pNo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773141927; c=relaxed/simple;
	bh=I5V1k+7+xXznETCby5tKTSNKF4fYyqfm+aTc5/j+EEA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=IriGzmvvWz4Tz+xNt6euEuoLvJ9BiTTYJMgm1rRHd3mxT1tKcleHcYgrc0SEBfQobMLGPi7qADhWt3W9+RvAUdHEF6Ar/8ZiC263rbEGQMErueZ1YotOV3jRgC9F1EGP+ozkQEDCQw/lVQtj3a+UI4s4HCVcDrnblEpw4khTayo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=fZlBmWkS; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="fZlBmWkS"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 00F40C2BC86;
	Tue, 10 Mar 2026 11:25:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1773141926;
	bh=I5V1k+7+xXznETCby5tKTSNKF4fYyqfm+aTc5/j+EEA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=fZlBmWkSzImSTL/8HR7qjU30c7zRV+yYOCyJLCVWS+fEUCg8/lts7f611sLNeqHvA
	 oFl6Vz7kuZtKDhOkMsetqXDPhejXVz9mdgJ8/ax7xcCGa8TnktnLy9jo0wh5tjyrU2
	 sf7gcWTi6huXbEcJHU/tZ3V9lES5IWazN+a7JnxzL/2kXTMewnrUROo753PIqZUqWH
	 GZ6HCmdK6WuRwftDfQdKyrIHFnPKs3GIYRehmhP6uxlFpzhWMCgjUBULj0m+IHQ5LR
	 AvuNxcgK4rxd0MWPg0l7CCnlRtmmzHex7ODnvmsj3mGecmSB3vC+XDVvTuy8ztoEjP
	 jCK+1vKEFbxAA==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Bart Van Assche <bvanassche@acm.org>,
	Alex Deucher <alexander.deucher@amd.com>,
	=?UTF-8?q?Christian=20K=C3=B6nig?= <christian.koenig@amd.com>,
	YiPeng Chai <YiPeng.Chai@amd.com>,
	Hawking Zhang <Hawking.Zhang@amd.com>,
	amd-gfx@lists.freedesktop.org,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 050/314] drm/amdgpu: Fix locking bugs in error paths
Date: Tue, 10 Mar 2026 07:15:09 -0400
Message-ID: <214ec1a25f783a510ee9d39c4fb7c1af76a96094.1773141555.git.sashal@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <cover.1773141554.git.sashal@kernel.org>
References: <cover.1773141554.git.sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit

From: Bart Van Assche <bvanassche@acm.org>

[ Upstream commit 480ad5f6ead4a47b969aab6618573cd6822bb6a4 ]

Do not unlock psp->ras_context.mutex if it has not been locked. This has
been detected by the Clang thread-safety analyzer.

Cc: Alex Deucher <alexander.deucher@amd.com>
Cc: Christian König <christian.koenig@amd.com>
Cc: YiPeng Chai <YiPeng.Chai@amd.com>
Cc: Hawking Zhang <Hawking.Zhang@amd.com>
Cc: amd-gfx@lists.freedesktop.org
Fixes: b3fb79cda568 ("drm/amdgpu: add mutex to protect ras shared memory")
Acked-by: Christian König <christian.koenig@amd.com>
Signed-off-by: Bart Van Assche <bvanassche@acm.org>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
(cherry picked from commit 6fa01b4335978051d2cd80841728fd63cc597970)
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/amd/amdgpu/amdgpu_psp_ta.c | 12 +++++++-----
 1 file changed, 7 insertions(+), 5 deletions(-)

diff --git a/drivers/gpu/drm/amd/amdgpu/amdgpu_psp_ta.c b/drivers/gpu/drm/amd/amdgpu/amdgpu_psp_ta.c
index 6e8aad91bcd30..0d3c18f04ac36 100644
--- a/drivers/gpu/drm/amd/amdgpu/amdgpu_psp_ta.c
+++ b/drivers/gpu/drm/amd/amdgpu/amdgpu_psp_ta.c
@@ -332,13 +332,13 @@ static ssize_t ta_if_invoke_debugfs_write(struct file *fp, const char *buf, size
 	if (!context || !context->initialized) {
 		dev_err(adev->dev, "TA is not initialized\n");
 		ret = -EINVAL;
-		goto err_free_shared_buf;
+		goto free_shared_buf;
 	}
 
 	if (!psp->ta_funcs || !psp->ta_funcs->fn_ta_invoke) {
 		dev_err(adev->dev, "Unsupported function to invoke TA\n");
 		ret = -EOPNOTSUPP;
-		goto err_free_shared_buf;
+		goto free_shared_buf;
 	}
 
 	context->session_id = ta_id;
@@ -346,7 +346,7 @@ static ssize_t ta_if_invoke_debugfs_write(struct file *fp, const char *buf, size
 	mutex_lock(&psp->ras_context.mutex);
 	ret = prep_ta_mem_context(&context->mem_context, shared_buf, shared_buf_len);
 	if (ret)
-		goto err_free_shared_buf;
+		goto unlock;
 
 	ret = psp_fn_ta_invoke(psp, cmd_id);
 	if (ret || context->resp_status) {
@@ -354,15 +354,17 @@ static ssize_t ta_if_invoke_debugfs_write(struct file *fp, const char *buf, size
 			ret, context->resp_status);
 		if (!ret) {
 			ret = -EINVAL;
-			goto err_free_shared_buf;
+			goto unlock;
 		}
 	}
 
 	if (copy_to_user((char *)&buf[copy_pos], context->mem_context.shared_buf, shared_buf_len))
 		ret = -EFAULT;
 
-err_free_shared_buf:
+unlock:
 	mutex_unlock(&psp->ras_context.mutex);
+
+free_shared_buf:
 	kfree(shared_buf);
 
 	return ret;
-- 
2.51.0

