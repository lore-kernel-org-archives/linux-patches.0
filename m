Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 58FDC168C4;
	Mon, 27 May 2024 19:20:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1716837643; cv=none; b=H0IGhC0/GxhfNHcmTRmMR9McxWJnqy1/qIqkecCd5bIDUaiSPk0986MApt0ZA8w/3iODuJNoFWIkPL4Zv6AFIb1b5kcE5l/hwXrCbxgZjC4+ZbEIbcRcqL9nSEGSZCOv99QSyirr+fykus950JdI7vJTs5FJlAXMkPxI8vEg3js=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1716837643; c=relaxed/simple;
	bh=1+vLSB0thUMkUQU8Yxx3+/WRaXEcKQviIeeBKy0mBl4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=iYahmoVr8z/46aYypj62XJp/rQO/AVLJjeLCT5peGLSfLR8pc7cGIE3R7b2zPNnEUTe7cDnCibRGqnMrhDmP+yFCnQRrqCNeac5TixdcoKg7dHDRkdz/8ZqGZU3Kj9VvIb+eiy9lH6zzNj+IQhOYVx9IhUCRRTsz4OhyBkl0pIc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=OV5Z3fQ0; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="OV5Z3fQ0"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E154AC2BBFC;
	Mon, 27 May 2024 19:20:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1716837643;
	bh=1+vLSB0thUMkUQU8Yxx3+/WRaXEcKQviIeeBKy0mBl4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=OV5Z3fQ09BiWRFMJbeSe68ko2ALXk2bhJX2KqONGYpXqc5xxBDtJ1w+L5sAkzdIB0
	 WuLmO+TPpJVwngHNdPIJgFrpvH5pHwb2hjHazhv72vI/g8qN5fPNAoO7ZvWjzZClj5
	 yWEw9Fbj9Ug4Ep710c/uoxYxtqSnnEA2FSmM2n1k=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Felix Kuehling <felix.kuehling@amd.com>,
	Mukul Joshi <mukul.joshi@amd.com>,
	=?UTF-8?q?Christian=20K=C3=B6nig?= <christian.koenig@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.8 048/493] drm/amdgpu: Update BO eviction priorities
Date: Mon, 27 May 2024 20:50:50 +0200
Message-ID: <20240527185630.633452932@linuxfoundation.org>
X-Mailer: git-send-email 2.45.1
In-Reply-To: <20240527185626.546110716@linuxfoundation.org>
References: <20240527185626.546110716@linuxfoundation.org>
User-Agent: quilt/0.67
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

6.8-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Felix Kuehling <felix.kuehling@amd.com>

[ Upstream commit b0b13d532105e0e682d95214933bb8483a063184 ]

Make SVM BOs more likely to get evicted than other BOs. These BOs
opportunistically use available VRAM, but can fall back relatively
seamlessly to system memory. It also avoids SVM migrations evicting
other, more important BOs as they will evict other SVM allocations
first.

Signed-off-by: Felix Kuehling <felix.kuehling@amd.com>
Acked-by: Mukul Joshi <mukul.joshi@amd.com>
Tested-by: Mukul Joshi <mukul.joshi@amd.com>
Reviewed-by: Christian König <christian.koenig@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/amd/amdgpu/amdgpu_object.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/gpu/drm/amd/amdgpu/amdgpu_object.c b/drivers/gpu/drm/amd/amdgpu/amdgpu_object.c
index 9e5526046aa15..3af505e8cbbc3 100644
--- a/drivers/gpu/drm/amd/amdgpu/amdgpu_object.c
+++ b/drivers/gpu/drm/amd/amdgpu/amdgpu_object.c
@@ -608,6 +608,8 @@ int amdgpu_bo_create(struct amdgpu_device *adev,
 	else
 		amdgpu_bo_placement_from_domain(bo, bp->domain);
 	if (bp->type == ttm_bo_type_kernel)
+		bo->tbo.priority = 2;
+	else if (!(bp->flags & AMDGPU_GEM_CREATE_DISCARDABLE))
 		bo->tbo.priority = 1;
 
 	if (!bp->destroy)
-- 
2.43.0



