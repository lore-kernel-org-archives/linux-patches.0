Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EEC2B13DDB8;
	Thu, 25 Jul 2024 14:43:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1721918615; cv=none; b=fzvtu5iIKPJdWLb+qNKOQKg7lby+LQ2hXY01SgWiYwdXZNAjI/lzXhEYodcgKVNX7KiWKHReJzbKwuFhSjJVfpxgWp9jesmGXYXiiY1BXA4mN+KPqDUeBsQejXPGQ5laMVpbf3SyPegT7X/ometwQbGGlo+EBIQkd11wcrejD+Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1721918615; c=relaxed/simple;
	bh=m1bXEMbd3iQtQy6kqlpez5HrmJ4xYIrB34VNIay+NuE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ot+ldY+KAmMoAaPyFFhHqAazEO4f0tIG9xhNRViCsvToXa5l6/inRiRVqenizVOrgQkS96037fRQMarPi3HbFlzW2rty0VubL+EaZwbRnxjZ/LyLRK1I4x8E1oP2bT/mOQIVquiO1TSB2RQ4aFsRnEEYJwaD0OXyYoAY4XyL2Fw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=an2FqXZy; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="an2FqXZy"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2C40BC116B1;
	Thu, 25 Jul 2024 14:43:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1721918614;
	bh=m1bXEMbd3iQtQy6kqlpez5HrmJ4xYIrB34VNIay+NuE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=an2FqXZy5IW5yrxubcXa7jYJxszi/c9wIlkuBY6hFf9FLIIp4P9/4O8zbFPKUmKps
	 R18THxltJEFrx2ccfhwxHtLFEMDNfm2+Wwq2JgVrEUYnbObbWK6Vu2f7AhuMIx3ji7
	 y/nknESOFPMYSNBYigIm+DP02DzXKY8mMuzFPEsY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Bob Zhou <bob.zhou@amd.com>,
	Dan Carpenter <dan.carpenter@linaro.org>,
	Alex Deucher <alexander.deucher@amd.com>,
	Siddh Raman Pant <siddh.raman.pant@oracle.com>
Subject: [PATCH 5.4 38/43] drm/amdgpu: Fix signedness bug in sdma_v4_0_process_trap_irq()
Date: Thu, 25 Jul 2024 16:37:01 +0200
Message-ID: <20240725142731.911172186@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240725142730.471190017@linuxfoundation.org>
References: <20240725142730.471190017@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

5.4-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Dan Carpenter <dan.carpenter@linaro.org>

commit 6769a23697f17f9bf9365ca8ed62fe37e361a05a upstream.

The "instance" variable needs to be signed for the error handling to work.

Fixes: 8b2faf1a4f3b ("drm/amdgpu: add error handle to avoid out-of-bounds")
Reviewed-by: Bob Zhou <bob.zhou@amd.com>
Signed-off-by: Dan Carpenter <dan.carpenter@linaro.org>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Cc: Siddh Raman Pant <siddh.raman.pant@oracle.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/amd/amdgpu/sdma_v4_0.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/gpu/drm/amd/amdgpu/sdma_v4_0.c
+++ b/drivers/gpu/drm/amd/amdgpu/sdma_v4_0.c
@@ -2003,7 +2003,7 @@ static int sdma_v4_0_process_trap_irq(st
 				      struct amdgpu_irq_src *source,
 				      struct amdgpu_iv_entry *entry)
 {
-	uint32_t instance;
+	int instance;
 
 	DRM_DEBUG("IH: SDMA trap\n");
 	instance = sdma_v4_0_irq_id_to_seq(entry->client_id);


