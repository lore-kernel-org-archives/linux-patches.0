Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1EA24176ADE;
	Thu, 15 Aug 2024 13:43:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723729390; cv=none; b=jD7KkN5s0InBZx3QJTIZl4JsyY4G0N9T4XxgG+EtM53rKpbjxSQw1Vd6X37L3mMxZInNZOqGv7bx0YwRCqv0K/zfvVflaxezZJ454fG/d3UwZHpVGX4tGfi4Pajhgf+NdnekZazKDBKtZhVQMLY1PKrRwInlUdtLTFli07OyZBY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723729390; c=relaxed/simple;
	bh=b4snOd0xIPabMip197S4u6S6j7wn/XOyHk5wFFwxuN4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=SYoVAhUqGj0hQDzQsIHLRwZ7num2Y+CpjCIlvu66nbpF++n9vDCx5gZiKPbSUqaISXRCvwlLG0DdbqYYBsvkphCzYz+DBrRaBqvgbfgx5swXH+YjP5ef0GdJpor4WiAZLjOWD1e0XUGrZbPR8Dvq08p7Hy8A9PSPmJqjcxorpK4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=xQPOARJc; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="xQPOARJc"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8ECF1C32786;
	Thu, 15 Aug 2024 13:43:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1723729390;
	bh=b4snOd0xIPabMip197S4u6S6j7wn/XOyHk5wFFwxuN4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=xQPOARJcJWcZTN3y6GHgqX8FFS9AwXfCkA8WvgZPIYY/vxiFfa53hoFOYtuZhaEl/
	 RcziJEqU5Q0ZR9PhZByhWNDsFk0y76sxTzlEKgwUkGXzfwJaXLiAlnj58Ptp99CqRG
	 zYiAtiWrxvGBvcsEhlID+aStmW5yZz2hxO6gtmas=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Friedrich Vock <friedrich.vock@gmx.de>,
	Alex Deucher <alexander.deucher@amd.com>,
	=?UTF-8?q?Christian=20K=C3=B6nig?= <christian.koenig@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 082/484] drm/amdgpu: Check if NBIO funcs are NULL in amdgpu_device_baco_exit
Date: Thu, 15 Aug 2024 15:19:00 +0200
Message-ID: <20240815131944.455776882@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240815131941.255804951@linuxfoundation.org>
References: <20240815131941.255804951@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Friedrich Vock <friedrich.vock@gmx.de>

[ Upstream commit 0cdb3f9740844b9d95ca413e3fcff11f81223ecf ]

The special case for VM passthrough doesn't check adev->nbio.funcs
before dereferencing it. If GPUs that don't have an NBIO block are
passed through, this leads to a NULL pointer dereference on startup.

Signed-off-by: Friedrich Vock <friedrich.vock@gmx.de>
Fixes: 1bece222eabe ("drm/amdgpu: Clear doorbell interrupt status for Sienna Cichlid")
Cc: Alex Deucher <alexander.deucher@amd.com>
Cc: Christian König <christian.koenig@amd.com>
Acked-by: Christian König <christian.koenig@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/amd/amdgpu/amdgpu_device.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/gpu/drm/amd/amdgpu/amdgpu_device.c b/drivers/gpu/drm/amd/amdgpu/amdgpu_device.c
index 5f6c32ec674d3..300d3b236bb35 100644
--- a/drivers/gpu/drm/amd/amdgpu/amdgpu_device.c
+++ b/drivers/gpu/drm/amd/amdgpu/amdgpu_device.c
@@ -5531,7 +5531,7 @@ int amdgpu_device_baco_exit(struct drm_device *dev)
 	    adev->nbio.funcs->enable_doorbell_interrupt)
 		adev->nbio.funcs->enable_doorbell_interrupt(adev, true);
 
-	if (amdgpu_passthrough(adev) &&
+	if (amdgpu_passthrough(adev) && adev->nbio.funcs &&
 	    adev->nbio.funcs->clear_doorbell_interrupt)
 		adev->nbio.funcs->clear_doorbell_interrupt(adev);
 
-- 
2.43.0



