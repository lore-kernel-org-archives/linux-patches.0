Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6DD383B9D9D;
	Mon, 23 Mar 2026 16:24:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774283082; cv=none; b=LiqsCTcLj5th2ddL6OeMgHTulAlx6x8+bh8plQUqfDDbEh5UVFA5gA6g5/swT6kUUyFozmRgQ5vE3rzTadAJyXk61jHk4XUC7cbGbPndb0lIZYxAfm0URHL/Z/mrLpUbWQ0U4wkR8fnyOluhnoUtaWD+pT8Wme3vRZo1tEss/mE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774283082; c=relaxed/simple;
	bh=eFT5O31XSEYpBtvTHr99jWzeoljrsYKtlOBOxtlLEFw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=CR+NSTbc81gKQGyag9TOOFxZIgKOztJoV+tkEBi2GdBcCfbzkmdXLF5IKbKn7p5kKgsNm2NtVI7zn7h6FgnZclUSlnwkF2HFGE6K81hUln9w5DC0tm5tBHlo3R0eVGmHs1Eag3TLAO7af8BaCThJyWHe/QpwweHlsihF/8QlW3k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=XpIPygF0; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="XpIPygF0"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F3DE6C4CEF7;
	Mon, 23 Mar 2026 16:24:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1774283082;
	bh=eFT5O31XSEYpBtvTHr99jWzeoljrsYKtlOBOxtlLEFw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=XpIPygF0cNBIzf6QMHh3mS0D3nRLkwvLb/O9Drf6cAiKpVEKlSIuaQwMMr7ElClDL
	 HHLagf0ZbySxU2rfqfkDHCDkT78rNfrSllBUOVoar6ytKJlNb41EQML0i1jSeStceX
	 Y2JYS3UkSDRJTNAaQLQgltKa2iCHaALV9h5JDlgg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Guchun Chen <guchun.chen@amd.com>,
	=?UTF-8?q?Christian=20K=C3=B6nig?= <christian.koenig@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Alva Lan <alvalan9@foxmail.com>
Subject: [PATCH 6.1 395/481] drm/amdgpu: drop redundant sched job cleanup when cs is aborted
Date: Mon, 23 Mar 2026 14:46:17 +0100
Message-ID: <20260323134534.788681530@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260323134525.256603107@linuxfoundation.org>
References: <20260323134525.256603107@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Guchun Chen <guchun.chen@amd.com>

[ Upstream commit 1253685f0d3eb3eab0bfc4bf15ab341a5f3da0c8 ]

Once command submission failed due to userptr invalidation in
amdgpu_cs_submit, legacy code will perform cleanup of scheduler
job. However, it's not needed at all, as former commit has integrated
job cleanup stuff into amdgpu_job_free. Otherwise, because of double
free, a NULL pointer dereference will occur in such scenario.

Bug: https://gitlab.freedesktop.org/drm/amd/-/issues/2457
Fixes: f7d66fb2ea43 ("drm/amdgpu: cleanup scheduler job initialization v2")
Signed-off-by: Guchun Chen <guchun.chen@amd.com>
Reviewed-by: Christian König <christian.koenig@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Cc: stable@vger.kernel.org
[ Adjust context. The context change is irrelevant
to the current patch logic. ]
Signed-off-by: Alva Lan <alvalan9@foxmail.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/amd/amdgpu/amdgpu_cs.c |   13 +++----------
 1 file changed, 3 insertions(+), 10 deletions(-)

--- a/drivers/gpu/drm/amd/amdgpu/amdgpu_cs.c
+++ b/drivers/gpu/drm/amd/amdgpu/amdgpu_cs.c
@@ -1244,7 +1244,7 @@ static int amdgpu_cs_submit(struct amdgp
 		fence = &p->jobs[i]->base.s_fence->scheduled;
 		r = amdgpu_sync_fence(&leader->sync, fence);
 		if (r)
-			goto error_cleanup;
+			return r;
 	}
 
 	if (p->gang_size > 1) {
@@ -1270,7 +1270,8 @@ static int amdgpu_cs_submit(struct amdgp
 	}
 	if (r) {
 		r = -EAGAIN;
-		goto error_unlock;
+		mutex_unlock(&p->adev->notifier_lock);
+		return r;
 	}
 
 	p->fence = dma_fence_get(&leader->base.s_fence->finished);
@@ -1317,14 +1318,6 @@ static int amdgpu_cs_submit(struct amdgp
 	mutex_unlock(&p->adev->notifier_lock);
 	mutex_unlock(&p->bo_list->bo_list_mutex);
 	return 0;
-
-error_unlock:
-	mutex_unlock(&p->adev->notifier_lock);
-
-error_cleanup:
-	for (i = 0; i < p->gang_size; ++i)
-		drm_sched_job_cleanup(&p->jobs[i]->base);
-	return r;
 }
 
 /* Cleanup the parser structure */


