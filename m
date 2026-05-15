Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9C7603F926C;
	Fri, 15 May 2026 16:12:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778861579; cv=none; b=KrVY3c86IgLfqFBEYF5pZu0doUCfuU9arNL3CfCzVUXbktUM5i4sLplFDkon56EyXFXKZ2ibspIUM+mrkvJXXCfoAvKSZvd0rKQdUOf1NF91Aj9DBQV7YY8ocSjj3YjJzt/Dpy5eilCLM3aI22DCJMZygIyTaahDaeeHgJ5pMCw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778861579; c=relaxed/simple;
	bh=FaJvH8N/pYJcR1e7sqK1dmqnNasHvgCuzuU63BGxrz8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=gCE16RTJuqBJEo7B63sgoRQCZt/XuAYv03/sGReYP2XKAfAg+mBWcqOwWwccZ8ab/jbdLs+QRV/igRWm9GlBmtSuXyoFX3QT2Ka3f7lFoSBfaTPJ6i6wBwCYiuLrIWFHO8GFmn0PJYYaOyT7alM2dagC50I/EPq3SrGEZ6B6BdM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Q/XoR047; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Q/XoR047"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 344A2C2BCB0;
	Fri, 15 May 2026 16:12:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1778861579;
	bh=FaJvH8N/pYJcR1e7sqK1dmqnNasHvgCuzuU63BGxrz8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Q/XoR047/31UwJZn7mFSl0A7dpXZpEA78EWj+LcRNPUmfQPmO8rfvLdHym5aEw95w
	 JfIiq3QzzcPEXTwBDUQ4pSeiUGi3NSR/NPOmsdy240XuDe8JX+IMraKj3jpzyHXte3
	 yA4IgOBKwDroFWwRo0rkK1QUr2tv+hQsNO5nQuAM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Benjamin Cheng <benjamin.cheng@amd.com>,
	=?UTF-8?q?Christian=20K=C3=B6nig?= <christian.koenig@amd.com>,
	Ruijing Dong <ruijing.dong@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>
Subject: [PATCH 6.6 342/474] drm/amdgpu: Add bounds checking to ib_{get,set}_value
Date: Fri, 15 May 2026 17:47:31 +0200
Message-ID: <20260515154722.415387150@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260515154715.053014143@linuxfoundation.org>
References: <20260515154715.053014143@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Benjamin Cheng <benjamin.cheng@amd.com>

commit 66085e206431ef88ce36f53c1f53d570790ccc9e upstream.

The uvd/vce/vcn code accesses the IB at predefined offsets without
checking that the IB is large enough. Check the bounds here. The caller
is responsible for making sure it can handle arbitrary return values.

Also make the idx a uint32_t to prevent overflows causing the condition
to fail.

Signed-off-by: Benjamin Cheng <benjamin.cheng@amd.com>
Reviewed-by: Christian König <christian.koenig@amd.com>
Reviewed-by: Ruijing Dong <ruijing.dong@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Cc: stable@vger.kernel.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/amd/amdgpu/amdgpu_ring.h |   11 +++++++----
 1 file changed, 7 insertions(+), 4 deletions(-)

--- a/drivers/gpu/drm/amd/amdgpu/amdgpu_ring.h
+++ b/drivers/gpu/drm/amd/amdgpu/amdgpu_ring.h
@@ -440,15 +440,18 @@ void amdgpu_debugfs_ring_init(struct amd
 
 int amdgpu_ring_init_mqd(struct amdgpu_ring *ring);
 
-static inline u32 amdgpu_ib_get_value(struct amdgpu_ib *ib, int idx)
+static inline u32 amdgpu_ib_get_value(struct amdgpu_ib *ib, uint32_t idx)
 {
-	return ib->ptr[idx];
+	if (idx < ib->length_dw)
+		return ib->ptr[idx];
+	return 0;
 }
 
-static inline void amdgpu_ib_set_value(struct amdgpu_ib *ib, int idx,
+static inline void amdgpu_ib_set_value(struct amdgpu_ib *ib, uint32_t idx,
 				       uint32_t value)
 {
-	ib->ptr[idx] = value;
+	if (idx < ib->length_dw)
+		ib->ptr[idx] = value;
 }
 
 int amdgpu_ib_get(struct amdgpu_device *adev, struct amdgpu_vm *vm,


