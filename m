Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 952FE248F73;
	Tue, 10 Mar 2026 11:11:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773141070; cv=none; b=faw4wZRyv/j+MJO1qD8vIxxRCEC2Qhjyi0EiQR5SpJNQ0cDtIsflV7eBjdk5HF4kVdgVVN3U+oEqenqfh4bAB3cDDMyF5U1XapMhM7acd7tYd57NuwgcehRcBHfqHljUbdUzdD3MVeKVJ+EMkI1iK0IbGUfGjlNE4gAq3VbwDT0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773141070; c=relaxed/simple;
	bh=I5V1k+7+xXznETCby5tKTSNKF4fYyqfm+aTc5/j+EEA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=cazRUrHIDogXnRq+Ub6LWbc3unKNhL7MUDYTwFJsS+8ssP5sOSn73rWafC1eZACuJkBmL5siM/1Dkd8EwbAlKDQa5SDVVDstkSvJh+nsIrrveqJ0X3VGZnOcXybyxAokkFR+7wEwaBsx+Tty2y5EHlMlIx/2s15vGqjYgnuigaI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=tiP7NLmv; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="tiP7NLmv"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 152C4C2BC86;
	Tue, 10 Mar 2026 11:11:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1773141070;
	bh=I5V1k+7+xXznETCby5tKTSNKF4fYyqfm+aTc5/j+EEA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=tiP7NLmvbTClJc2iAcMfTdXQ+u8XS3XwANY8V1+MiDxSNkUiofW36pf9so5f5BFFF
	 prTx2bvffWujILO86GSXYYdJf3vAmDGfUuKsIQ12sUHj6FRd1+JjaDP4Gi9sTDTrfl
	 I3jw8G/ozL7BIdmLpDwEWlIoBIuLLPJh6Wv15HOtnUl/lQOPyoujL/ZVehF9sTLe20
	 lj0FEGZKb0lUKchNX3aVKMMOTI8EP1UJl1HzGkJwongoTJGhUu2/G55VfrcoOtNV4j
	 K526ydF00t3T/MmlNo3CD7AQBJPFXTIg78JhLLq5s5RhSIZbxJwNZRG8j/I1vdcqKY
	 qQYtP43OYtwTA==
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
Subject: [PATCH 6.19 069/311] drm/amdgpu: Fix locking bugs in error paths
Date: Tue, 10 Mar 2026 07:01:56 -0400
Message-ID: <6d37385443d9f913c66e9997509dfffd9b84b7d1.1773140655.git.sashal@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <cover.1773140654.git.sashal@kernel.org>
References: <cover.1773140654.git.sashal@kernel.org>
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

