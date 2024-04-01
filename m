Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 70F081DFF4;
	Mon,  1 Apr 2024 17:03:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711991017; cv=none; b=tB5078W0kXLCkhKhNTI5g0hLT4kQrdSIdpzCVIEFiv1v617czJN6jNgO1enbgrKykcI0Y4pbcYsLw0OeairLL1Z7ESvLoWTIq7VzJezOeoHc7kxvLQmIlSRI0kIuTNQzJ3FmExCYCsLNXCiya3DZ5/trK8iK327HVOMmdg9tr+w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711991017; c=relaxed/simple;
	bh=BajQSgI+XDOeuC513hS1mFabUtsG1Cu5SJwgzglF8ls=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=jmqcY7ImE+DjuDGkp9g/TjjEwbBong5LKl1Hfl/dBx1+FEAyd1z9Byd4epq26uHdfO97ghRFzgXf+/To6TbWJI0yTzeU6URX487YLE7V5mRmc+iqUId4QSe/vJZq/uPuAz/LM9CJr/pTd+udBU/SaZNLUnRTm8deoxUb9/b2FhU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=TLCOpMqM; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="TLCOpMqM"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EC1F6C433C7;
	Mon,  1 Apr 2024 17:03:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1711991017;
	bh=BajQSgI+XDOeuC513hS1mFabUtsG1Cu5SJwgzglF8ls=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=TLCOpMqM47Z6REFxqn3/IMgTQOi+OZM4hmtT+M1BHhutRjPIKTCu8FKyBIzSKrzkC
	 MHtDXXyXXTlkLMicmm0mU64mLH16/hWVozWxtakaFw0aPRl1dzk3KeZznkWhOYMAYS
	 REwlrfdSIWq14222p7fmbC5sW7Q8bRy8Ofna9MPY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Philip Yang <Philip.Yang@amd.com>,
	=?UTF-8?q?Christian=20K=C3=B6nig?= <christian.koenig@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 137/272] drm/amdgpu: amdgpu_ttm_gart_bind set gtt bound flag
Date: Mon,  1 Apr 2024 17:45:27 +0200
Message-ID: <20240401152534.962783230@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240401152530.237785232@linuxfoundation.org>
References: <20240401152530.237785232@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Philip Yang <Philip.Yang@amd.com>

[ Upstream commit 6c6064cbe58b43533e3451ad6a8ba9736c109ac3 ]

Otherwise after the GTT bo is released, the GTT and gart space is freed
but amdgpu_ttm_backend_unbind will not clear the gart page table entry
and leave valid mapping entry pointing to the stale system page. Then
if GPU access the gart address mistakely, it will read undefined value
instead page fault, harder to debug and reproduce the real issue.

Cc: stable@vger.kernel.org
Signed-off-by: Philip Yang <Philip.Yang@amd.com>
Reviewed-by: Christian König <christian.koenig@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/amd/amdgpu/amdgpu_ttm.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/gpu/drm/amd/amdgpu/amdgpu_ttm.c b/drivers/gpu/drm/amd/amdgpu/amdgpu_ttm.c
index 158b791883f03..dfb9d42007730 100644
--- a/drivers/gpu/drm/amd/amdgpu/amdgpu_ttm.c
+++ b/drivers/gpu/drm/amd/amdgpu/amdgpu_ttm.c
@@ -838,6 +838,7 @@ static void amdgpu_ttm_gart_bind(struct amdgpu_device *adev,
 		amdgpu_gart_bind(adev, gtt->offset, ttm->num_pages,
 				 gtt->ttm.dma_address, flags);
 	}
+	gtt->bound = true;
 }
 
 /*
-- 
2.43.0



