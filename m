Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F310424A06A;
	Fri, 15 May 2026 16:31:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778862669; cv=none; b=q0dDe1+ONmqr2pqHKUoOM624ZF2I0eFYzClj6Lk+1//l+2qRh43JHXbjiPIxW4dwWncyf4HMOTkc+J/Kay99QgEViMF/A1US+wdUMD3hsIQVLv+zrf9tfyjrpxxyQKr4xaAxfZZnP2Q6R8vT7NWH5r9QQqPfK+6CFUdV9uNJ6I8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778862669; c=relaxed/simple;
	bh=AAPRAy3GDyYuty22KOISynXLCYwnsAD4ar7SM8wofyQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=dbMQfvGQSo25KhqKslD6XD3N3rIdCElAwG6Iag22Zu0s5MeLTtSHztA7R6/zUSnFKfBPLc5l1qbYSElmx3rEtczAjtc4nlE1rPNDcKC99euEcTxvD7StXEXJPKvHin7feb0wHuSFK3Zeal1iSuJwqN7PfXw3a2GUQJ1J8keND8E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=NCKAOnuJ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="NCKAOnuJ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 88DCEC2BCB0;
	Fri, 15 May 2026 16:31:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1778862668;
	bh=AAPRAy3GDyYuty22KOISynXLCYwnsAD4ar7SM8wofyQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=NCKAOnuJpYW3o+/9ShUgXrpXX3CLw5j2RDLpVrVSbAHLD32bRFFSOB9CsVL0rHE9C
	 57RkIjVMvVO8MbRZvmKaTl3Rm5rQopJX+9cZEW3V0VAS8dvQf6dlXWS/0Tq5GTJw1h
	 49O1hEks6I0UU1qD7VWGhdHcWwO4NTYfzkWThGjM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Benjamin Cheng <benjamin.cheng@amd.com>,
	=?UTF-8?q?Christian=20K=C3=B6nig?= <christian.koenig@amd.com>,
	Ruijing Dong <ruijing.dong@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>
Subject: [PATCH 7.0 138/201] drm/amdgpu: Add bounds checking to ib_{get,set}_value
Date: Fri, 15 May 2026 17:49:16 +0200
Message-ID: <20260515154701.557720696@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260515154658.538039039@linuxfoundation.org>
References: <20260515154658.538039039@linuxfoundation.org>
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
@@ -553,15 +553,18 @@ void amdgpu_debugfs_ring_init(struct amd
 
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


