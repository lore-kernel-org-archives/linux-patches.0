Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DF962101DE;
	Thu,  3 Jul 2025 14:47:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751554042; cv=none; b=jIRAT7c5z3fvho3xGUV2cFyzj2A88UUapzMFiPRR4lzqLrXVZbQiCmQEZDhyZY77RXS8YUGBu8JDrxGdeGhfqa+5N/wzs4xAyRNypXSATct/FKA6IKz9ww10U2AbHsaXmQm43LSrVKjA2fQwBJpKi30HcXhGZUIDIQ9U+9KIkDI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751554042; c=relaxed/simple;
	bh=AhpqKxojo+Tq1JKoCNOScdKBi0zX6RibN8tjlnHV3DY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=qNckUVZVZj4LnGqBy/adcz6cT6+P0Ee8RhSAPFAxupuuOKN8m4jLu/mpNW/zbeRSlIoV+IjE1JJxADDx+1VRWUao72lKaaRtcb4L5aJPGVKak/R+fBYV4w9fxGigpzrFqktERHJCua3Akcf8ISdOc2YYgUpn/94Sk9G9KwAEbAc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=J2MPrb7u; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="J2MPrb7u"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5A29BC4CEF3;
	Thu,  3 Jul 2025 14:47:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1751554041;
	bh=AhpqKxojo+Tq1JKoCNOScdKBi0zX6RibN8tjlnHV3DY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=J2MPrb7uq+618qDNXHJJB0Y+q4la8d719XxR+qErDjiRoO+VrGZmUQ/8CLkLbxFzh
	 czBeBxH7kEFzcbh0rBhZwhjhTePTOg3iT/NpdVG2t5hj/K2FFDddPjj3YKk/NrgFZS
	 LjDuyj9vrxYaSTT328cGsbD7dP6B2srMQ43igFNA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Philip Yang <Philip.Yang@amd.com>,
	=?UTF-8?q?Christian=20K=C3=B6nig?= <christian.koenig@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 031/218] drm/amdgpu: seq64 memory unmap uses uninterruptible lock
Date: Thu,  3 Jul 2025 16:39:39 +0200
Message-ID: <20250703143957.200088421@linuxfoundation.org>
X-Mailer: git-send-email 2.50.0
In-Reply-To: <20250703143955.956569535@linuxfoundation.org>
References: <20250703143955.956569535@linuxfoundation.org>
User-Agent: quilt/0.68
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

From: Philip Yang <Philip.Yang@amd.com>

[ Upstream commit a359288ccb4dd8edb086e7de8fdf6e36f544c922 ]

To unmap and free seq64 memory when drm node close to free vm, if there
is signal accepted, then taking vm lock failed and leaking seq64 va
mapping, and then dmesg has error log "still active bo inside vm".

Change to use uninterruptible lock fix the mapping leaking and no dmesg
error log.

Signed-off-by: Philip Yang <Philip.Yang@amd.com>
Reviewed-by: Christian König <christian.koenig@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/amd/amdgpu/amdgpu_seq64.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/gpu/drm/amd/amdgpu/amdgpu_seq64.c b/drivers/gpu/drm/amd/amdgpu/amdgpu_seq64.c
index e22cb2b5cd926..dba8051b8c14b 100644
--- a/drivers/gpu/drm/amd/amdgpu/amdgpu_seq64.c
+++ b/drivers/gpu/drm/amd/amdgpu/amdgpu_seq64.c
@@ -133,7 +133,7 @@ void amdgpu_seq64_unmap(struct amdgpu_device *adev, struct amdgpu_fpriv *fpriv)
 
 	vm = &fpriv->vm;
 
-	drm_exec_init(&exec, DRM_EXEC_INTERRUPTIBLE_WAIT, 0);
+	drm_exec_init(&exec, 0, 0);
 	drm_exec_until_all_locked(&exec) {
 		r = amdgpu_vm_lock_pd(vm, &exec, 0);
 		if (likely(!r))
-- 
2.39.5



