Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AF2533FF1DA;
	Fri, 15 May 2026 15:53:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778860425; cv=none; b=hIvIgAgf3ksor1DtDKgojhcoF4RnY+yTsEHdb7RvOe1IPZdeLK2rWaw6W//EcFYxPBmp+IKj05UM8D7UznKaiK2lQo7Pt0/r9OATxj28lU8BCP1X8MUgTX+SzD/Yy7xHhrRXrOEJGP89GKThi7G0fxMxhrMI37p+L0B8vgqDFdk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778860425; c=relaxed/simple;
	bh=xxcXbv13ciefRQx/bgPskdBgtbg65xFQbGXG9Z0ASGY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=ZHvQwrILm3UbX8xU2I3lwKzmQTQEiAFXBbKQtognNQ7zDeQ/HRZ+hdt8aDZxFmUis8LFdpAJ1JG/6kTuPRf8vrnVUtHlGLy2OdcyTHIx1G6nYdxXggihoiF4upF1VaRfYyB1SMa7XM8oevfjX++mITe74odWs5a2DEiV4VVXp3U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=LXBOqgjV; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="LXBOqgjV"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 47033C2BCB0;
	Fri, 15 May 2026 15:53:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1778860425;
	bh=xxcXbv13ciefRQx/bgPskdBgtbg65xFQbGXG9Z0ASGY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=LXBOqgjVevZbZtUb8vsG5g8LuUxGHiU6w4p2i5kEAzUtVpDQSeFriYmjAfivq7SwP
	 4kRJW9tcj0y1cC5eoNvEMxbiRJG9lgiHlVdur+NYNQjrOv1QLZa9yQaVQ5SbmgYzXT
	 JJ+3FDdKm1jYAPgQayCVwaNhvKjSfPuh/76zgbPE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Felix Kuehling <felix.kuehling@amd.com>,
	Philip Yang <Philip.Yang@amd.com>,
	=?UTF-8?q?Christian=20K=C3=B6nig?= <christian.koenig@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>
Subject: [PATCH 6.12 084/144] drm/amdgpu: zero-initialize GART table on allocation
Date: Fri, 15 May 2026 17:48:30 +0200
Message-ID: <20260515154655.470925919@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260515154653.469907118@linuxfoundation.org>
References: <20260515154653.469907118@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Philip Yang <Philip.Yang@amd.com>

commit e6c2e6c2e1fa066968a16aca1cb66cd1bdde7741 upstream.

GART TLB is flushed after unmapping but not after mapping. Since
amdgpu_bo_create_kernel() does not zero-initialize the buffer, when a
single PTE is written the TLB may speculatively load other uninitialized
entries from the same cacheline. Those garbage entries can appear valid,
and a subsequent write to another PTE in the same cacheline may cause the
GPU to use a stale garbage PTE from the TLB.

Fix this by calling memset_io() to zero-initialize the GART table with
gart_pte_flags immediately after allocation.

Using AMDGPU_GEM_CREATE_VRAM_CLEARED, SDMA-based clear will not work
since SDMA needs GART to be initialized to work.

Suggested-by: Felix Kuehling <felix.kuehling@amd.com>
Signed-off-by: Philip Yang <Philip.Yang@amd.com>
Reviewed-by: Christian König <christian.koenig@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
(cherry picked from commit d9af8263b82b6eaa60c5718e0c6631c5037e4b24)
Cc: stable@vger.kernel.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/amd/amdgpu/amdgpu_gart.c |   13 ++++++++++---
 1 file changed, 10 insertions(+), 3 deletions(-)

--- a/drivers/gpu/drm/amd/amdgpu/amdgpu_gart.c
+++ b/drivers/gpu/drm/amd/amdgpu/amdgpu_gart.c
@@ -260,12 +260,19 @@ void amdgpu_gart_table_ram_free(struct a
  */
 int amdgpu_gart_table_vram_alloc(struct amdgpu_device *adev)
 {
+	int r;
+
 	if (adev->gart.bo != NULL)
 		return 0;
 
-	return amdgpu_bo_create_kernel(adev,  adev->gart.table_size, PAGE_SIZE,
-				       AMDGPU_GEM_DOMAIN_VRAM, &adev->gart.bo,
-				       NULL, (void *)&adev->gart.ptr);
+	r = amdgpu_bo_create_kernel(adev,  adev->gart.table_size, PAGE_SIZE,
+				    AMDGPU_GEM_DOMAIN_VRAM, &adev->gart.bo,
+				    NULL, (void *)&adev->gart.ptr);
+	if (r)
+		return r;
+
+	memset_io(adev->gart.ptr, adev->gart.gart_pte_flags, adev->gart.table_size);
+	return 0;
 }
 
 /**


