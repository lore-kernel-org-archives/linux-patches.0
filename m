Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0C008280035;
	Tue, 27 May 2025 17:42:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748367776; cv=none; b=OBwSw3Y3Au9mR0S3ASHxCei0jwafQk2+Li3MnhA1ku1rbrtpj40NglgcPN5OJedS60lNz25g3cQXPM5NcxN8MUfv92BsaV7+KyCwQ6CpN2mkJoX6onW3rB0uytNZ83Ryu8FIGtzPmGZ3YveUb+2CadU/qUXxgOhHmKjQ0grSaxs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748367776; c=relaxed/simple;
	bh=VGrk3c2hwdTn7Rv9F6Ewyjqv/JpalRazTCvqSBEiUhY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=LYkHkHpPQrL3wj74CJD8UjAPsoNmV1Dh3IVZggplhT7XrjOtNWxAYnut6hSOZruPfFV2CDXnNrxFy/FK9aMNxFgMePf/l6qX6RsooKiYWducWkPHwS9Aw+NPoqBjjUs9Y0STMwRTrsxbT4u90NYKCJJsDqdy7GfXvvpXvjUrIig=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=MGFPqasJ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="MGFPqasJ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6E532C4CEE9;
	Tue, 27 May 2025 17:42:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1748367775;
	bh=VGrk3c2hwdTn7Rv9F6Ewyjqv/JpalRazTCvqSBEiUhY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=MGFPqasJz1a4GdrSy2CSHu49L9smeF6Yxl3fV6tSB371yU8wOyJng7QGRQh+/w3qZ
	 +swW6E4dLpimz20YP04BSGO9/jzO/J8cE2JmNEdqbE3Ye8J45SXAIMYUe4brVi73M4
	 x2jXW3c16Jahf7ABgdLnUzRtd6V0pjnIi1n7L8TA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Srinivasan Shanmugam <srinivasan.shanmugam@amd.com>,
	=?UTF-8?q?Christian=20K=C3=B6nig?= <christian.koenig@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.14 478/783] drm/amdgpu/mes11: fix set_hw_resources_1 calculation
Date: Tue, 27 May 2025 18:24:35 +0200
Message-ID: <20250527162532.591165905@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250527162513.035720581@linuxfoundation.org>
References: <20250527162513.035720581@linuxfoundation.org>
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

6.14-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Alex Deucher <alexander.deucher@amd.com>

[ Upstream commit 1350dd3691b5f757a948e5b9895d62c422baeb90 ]

It's GPU page size not CPU page size.  In most cases they
are the same, but not always.  This can lead to overallocation
on systems with larger pages.

Cc: Srinivasan Shanmugam <srinivasan.shanmugam@amd.com>
Cc: Christian König <christian.koenig@amd.com>
Reviewed-by: Christian König <christian.koenig@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/amd/amdgpu/mes_v11_0.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/gpu/drm/amd/amdgpu/mes_v11_0.c b/drivers/gpu/drm/amd/amdgpu/mes_v11_0.c
index 0f808ffcab943..68bb334393bb6 100644
--- a/drivers/gpu/drm/amd/amdgpu/mes_v11_0.c
+++ b/drivers/gpu/drm/amd/amdgpu/mes_v11_0.c
@@ -730,7 +730,7 @@ static int mes_v11_0_set_hw_resources(struct amdgpu_mes *mes)
 
 static int mes_v11_0_set_hw_resources_1(struct amdgpu_mes *mes)
 {
-	int size = 128 * PAGE_SIZE;
+	int size = 128 * AMDGPU_GPU_PAGE_SIZE;
 	int ret = 0;
 	struct amdgpu_device *adev = mes->adev;
 	union MESAPI_SET_HW_RESOURCES_1 mes_set_hw_res_pkt;
-- 
2.39.5



