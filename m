Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 34394126C02;
	Thu,  3 Jul 2025 14:57:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751554664; cv=none; b=pXLZUgEn4sYhGpHTCeNbEipRXa7+iu0Pb6LPtMMl8qLqgIYdbaxAJh51u3Id2T2pWjrB/4BgjbFplyIO5PRj+keV/0k34rkA6h9wf+nN2dg+IG4kptU76sWycZXgs2nYW5Tx9zt1VUee+SR0r9ly1xfobpRO+6F7KVILEZTQ4Wk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751554664; c=relaxed/simple;
	bh=mXv1W8kt6/hTgQ2JmWLzdYM7mJyGsZMF82H7rORuLZE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=Dwyp/tPRy4VVQWBTqL3iTbKPCGBZYAFjEZ6eFGClGx+YULJAu4n8KhJ8a/uAHwB7ocDbOiCB8Rdz6fKvEAQZ+ILvtx0vi9fgoAcLjf8Od/buw+oM3E3xuLSwHEdDNmflk9C3IrO5S4wmcSMAf02BgZRc+5tHUr+htzenRZco3nA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=JTqtDM9W; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="JTqtDM9W"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 98D81C4CEE3;
	Thu,  3 Jul 2025 14:57:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1751554664;
	bh=mXv1W8kt6/hTgQ2JmWLzdYM7mJyGsZMF82H7rORuLZE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=JTqtDM9WLhBGbnBPPsqZJXJM7D9GRCjNPv5XNL29FVBohuDDynThfMUhp//mu4WFD
	 Ci24Vi8htzISzji1JQ9U8JEiswZtioH5W619ud4YNeSm7hmCfoJp7sn8dD7BI8B381
	 soiBAAe6h6j574EFM3PvuyTa78Ha6u0QGFNOtt3M=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Philip Yang <Philip.Yang@amd.com>,
	=?UTF-8?q?Christian=20K=C3=B6nig?= <christian.koenig@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.15 042/263] drm/amdgpu: seq64 memory unmap uses uninterruptible lock
Date: Thu,  3 Jul 2025 16:39:22 +0200
Message-ID: <20250703144005.995957353@linuxfoundation.org>
X-Mailer: git-send-email 2.50.0
In-Reply-To: <20250703144004.276210867@linuxfoundation.org>
References: <20250703144004.276210867@linuxfoundation.org>
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

6.15-stable review patch.  If anyone has any objections, please let me know.

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



