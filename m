Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7FA3A2C1A5;
	Mon, 12 Aug 2024 16:15:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723479331; cv=none; b=lEuGOV9dAgXRY7DyngHeUxysNR8TyDU7j/Y1NNGM7+3ruP47Q8WYwmESXZLznGfqaoTUf33Vwz880gM02/TOE3CTLCnwx365CC16TPpVsnD8B2dXtZ+4XKXQXA5S93zXPk9broJfs/Iad/2LmvX+Ckp9c0/8SkklOhmigBu0Aa0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723479331; c=relaxed/simple;
	bh=vvP1lYlY/T+YVeYWR+WgF9Paehkj3FBXFWNwHyBCuv0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=u3Sl29osN6ltOCghOgUmfwrz6Y4bdpg7Dx30hUA6kbYdwq5xGF6+Wb6QdRPzFkluc9av+DM+U+6A0C31/5FkEjlyN4f01ADQ2hnPIXD+i4ep6p0rBacIfaT0RQxunfh4gu4SIZ3xXGEB0tjCLsWyDwYhXTXb6Exr4R/p/tJcf5k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Llj2GcdI; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Llj2GcdI"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CB14EC4AF0D;
	Mon, 12 Aug 2024 16:15:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1723479331;
	bh=vvP1lYlY/T+YVeYWR+WgF9Paehkj3FBXFWNwHyBCuv0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Llj2GcdI0SyJBmmIo5IGUgFDC1koIrF3KTyBS5awMBe2N/y1nc70h/HcxqtZqaYKD
	 rhWDLKWEgDaha0dOkGlvWNj1obABN5PTdpbKEPrHp6jjc8aUfC1R+UrqP8+SKc0wX9
	 L0xpkiGPsuGX42ZyAWTtn3l+TemiSdo6UWR1yrMM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ma Jun <Jun.Ma2@amd.com>,
	Lijo Lazar <lijo.lazar@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 053/189] drm/amdgpu: Fix the null pointer dereference to ras_manager
Date: Mon, 12 Aug 2024 18:01:49 +0200
Message-ID: <20240812160134.186429347@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240812160132.135168257@linuxfoundation.org>
References: <20240812160132.135168257@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Ma Jun <Jun.Ma2@amd.com>

[ Upstream commit 4c11d30c95576937c6c35e6f29884761f2dddb43 ]

Check ras_manager before using it

Signed-off-by: Ma Jun <Jun.Ma2@amd.com>
Reviewed-by: Lijo Lazar <lijo.lazar@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/amd/amdgpu/amdgpu_ras.c | 7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)

diff --git a/drivers/gpu/drm/amd/amdgpu/amdgpu_ras.c b/drivers/gpu/drm/amd/amdgpu/amdgpu_ras.c
index 67b75ff0f7c37..7cba98f8bbdca 100644
--- a/drivers/gpu/drm/amd/amdgpu/amdgpu_ras.c
+++ b/drivers/gpu/drm/amd/amdgpu/amdgpu_ras.c
@@ -1780,12 +1780,15 @@ static void amdgpu_ras_interrupt_process_handler(struct work_struct *work)
 int amdgpu_ras_interrupt_dispatch(struct amdgpu_device *adev,
 		struct ras_dispatch_if *info)
 {
-	struct ras_manager *obj = amdgpu_ras_find_obj(adev, &info->head);
-	struct ras_ih_data *data = &obj->ih_data;
+	struct ras_manager *obj;
+	struct ras_ih_data *data;
 
+	obj = amdgpu_ras_find_obj(adev, &info->head);
 	if (!obj)
 		return -EINVAL;
 
+	data = &obj->ih_data;
+
 	if (data->inuse == 0)
 		return 0;
 
-- 
2.43.0



