Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 49F151DC998;
	Tue, 27 May 2025 17:04:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748365471; cv=none; b=UdCdAgtjFOjvru8mqFD4fmVO6jYLBKj6u5lfvVnLlCObP5VkGQY/S2fzo9rXN6TY5HHq7wrrccpkeA4HmGd1WgB8jIDux5Twf7gzJBUBmwpKlvZZH2BlbK5aF62vldfR/EanEZ6K0su3ljGYjbwdDMTXoTnzLkVvqTRdFm8tT7Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748365471; c=relaxed/simple;
	bh=VRN7l92U9vJc/xLUSyzyjt9fV3Tp2BSPeg8dCyHG7+0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=AyZ4eVEjJhfQNHVIpRIqrvsYFeuOunbG2ahX8L1BrlFoy3dAe5A5WJ/FO5uwipp+vB6R2hh6f9ngpkiattbehOWr9Ah7V5ObktNQFghCcSOrvEnulsA0ZzUUnnr0Q9XILMqVizov+7torOfJ8+NsYOfxHafnQSI57l0XHF9SZOs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=QUxlkRfA; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="QUxlkRfA"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BBB97C4CEE9;
	Tue, 27 May 2025 17:04:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1748365471;
	bh=VRN7l92U9vJc/xLUSyzyjt9fV3Tp2BSPeg8dCyHG7+0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=QUxlkRfAgSWrShVOQHonzatRX4XX6yiaAnD+rlwjeaY/WdRsBZ4zjurv5KgyHbVM9
	 oSm6BCM8tdxd0+yBB554ibCk5gEe6xD218COSfopmp5iYIfUQhUjTe/sKJfEFHrIaQ
	 raWBh9omqp7jvD4WNaWRRQwsfAei+vOcHbKGyiyg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Srinivasan Shanmugam <srinivasan.shanmugam@amd.com>,
	=?UTF-8?q?Christian=20K=C3=B6nig?= <christian.koenig@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 387/626] drm/amdgpu/mes11: fix set_hw_resources_1 calculation
Date: Tue, 27 May 2025 18:24:40 +0200
Message-ID: <20250527162500.744494561@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250527162445.028718347@linuxfoundation.org>
References: <20250527162445.028718347@linuxfoundation.org>
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
index 7a773fcd7752c..49113df8baefd 100644
--- a/drivers/gpu/drm/amd/amdgpu/mes_v11_0.c
+++ b/drivers/gpu/drm/amd/amdgpu/mes_v11_0.c
@@ -690,7 +690,7 @@ static int mes_v11_0_set_hw_resources(struct amdgpu_mes *mes)
 
 static int mes_v11_0_set_hw_resources_1(struct amdgpu_mes *mes)
 {
-	int size = 128 * PAGE_SIZE;
+	int size = 128 * AMDGPU_GPU_PAGE_SIZE;
 	int ret = 0;
 	struct amdgpu_device *adev = mes->adev;
 	union MESAPI_SET_HW_RESOURCES_1 mes_set_hw_res_pkt;
-- 
2.39.5



