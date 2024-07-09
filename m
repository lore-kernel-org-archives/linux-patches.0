Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3ACDE155389;
	Tue,  9 Jul 2024 11:13:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1720523605; cv=none; b=c6pHpMbpg60ItgZiakk+58tdk820ckozU9lA1QDRuxihxtlwptWorz2wxNwZSQEPjhwuM3tgcigJYC0GwbNHJGzpxFvnDqcEH9cpM//RtWzOp2ag6Aew1Q59CgNWjpVTFdwgKblt7ot3zQoBMJJrtZndYZbwya2VqUoVegoRGWY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1720523605; c=relaxed/simple;
	bh=L8yIxodAS7/r1t/rIm5yjoZq1qlik3ZyQSxvev2xJ8o=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=Qr3lxcnet/NUpj3gnr0Dm22VZvUTdtt24DLzgDT4faXRiwxYx17s9O+bKxNwnfBGrHvlmmhTCqysyEDxw7s6AvwwKhfDFDDF7e4NZTqdKduqk4cdM1Omw9+kBYGW0stTC/Fp/eCY2mHR7tkMNowDhhx3h6FUQuHZuO7m5YD6UFs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=mVF7vUbU; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="mVF7vUbU"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A9E31C32786;
	Tue,  9 Jul 2024 11:13:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1720523605;
	bh=L8yIxodAS7/r1t/rIm5yjoZq1qlik3ZyQSxvev2xJ8o=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=mVF7vUbU4R00m8unU1ijAQRL0fJTpucRyoHXH4/cNP7mF7vl7JXke3k8b07+C92jj
	 Hcx57nO6QaiyC20kKmR1diJs/Tt5xqksDprcexeUnwMQiKjgwRsejZ787eUL+PUrdu
	 k9tC2XPSTWFMdq0N4LKxhvf64OCOsU6JsbHnYjp0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jesse Zhang <jesse.zhang@amd.com>,
	=?UTF-8?q?Christian=20K=C3=B6nig?= <christian.koenig@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 018/139] drm/amdgpu: Using uninitialized value *size when calling amdgpu_vce_cs_reloc
Date: Tue,  9 Jul 2024 13:08:38 +0200
Message-ID: <20240709110658.866884898@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240709110658.146853929@linuxfoundation.org>
References: <20240709110658.146853929@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jesse Zhang <jesse.zhang@amd.com>

[ Upstream commit 88a9a467c548d0b3c7761b4fd54a68e70f9c0944 ]

Initialize the size before calling amdgpu_vce_cs_reloc, such as case 0x03000001.
V2: To really improve the handling we would actually
   need to have a separate value of 0xffffffff.(Christian)

Signed-off-by: Jesse Zhang <jesse.zhang@amd.com>
Suggested-by: Christian König <christian.koenig@amd.com>
Reviewed-by: Christian König <christian.koenig@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/amd/amdgpu/amdgpu_vce.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/gpu/drm/amd/amdgpu/amdgpu_vce.c b/drivers/gpu/drm/amd/amdgpu/amdgpu_vce.c
index 1904edf684071..88a3aa36b41d7 100644
--- a/drivers/gpu/drm/amd/amdgpu/amdgpu_vce.c
+++ b/drivers/gpu/drm/amd/amdgpu/amdgpu_vce.c
@@ -742,7 +742,8 @@ int amdgpu_vce_ring_parse_cs(struct amdgpu_cs_parser *p,
 	uint32_t created = 0;
 	uint32_t allocated = 0;
 	uint32_t tmp, handle = 0;
-	uint32_t *size = &tmp;
+	uint32_t dummy = 0xffffffff;
+	uint32_t *size = &dummy;
 	unsigned int idx;
 	int i, r = 0;
 
-- 
2.43.0



