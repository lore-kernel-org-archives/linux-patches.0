Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 063EB2FB08C;
	Wed, 25 Feb 2026 06:59:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772002754; cv=none; b=DiYxtnjlUnvq2oCznLVHOwKuHjOEwrUsiySpwx27pgh0QzVStokEGFb4XWUpr1OqtkN6v9S5+M29UTjEg0v59WHEXdKv6TZaaWGQVFGE+N4w90kAMlUMNSfjeybS85DHxfgfBWaUDKGmN5xRd8kDCAHN36WhUaLyWlYG2nAyTe8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772002754; c=relaxed/simple;
	bh=m+c9HxxEPw5jJiAXofbIrVRMRpE5ifdnjrIopWWDbA4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=UG099+283t5v4OKNIC0O2Y/Zi72lFboO3sJP0E+9LLSl3p3e2G2uJ3WhqruRIQtXZCrj/neYIYoXtp3JoR2zEKgeF/gfRQJyKbtHt8kI9GGRihxeVWcl7Y9PgyZrKNkXRH1cixB5rUQSxGsPFrJmk9pupgUrn3I4OnA1SZVy0wI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ZKkNnz8A; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ZKkNnz8A"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D2B10C116D0;
	Wed, 25 Feb 2026 06:59:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1772002753;
	bh=m+c9HxxEPw5jJiAXofbIrVRMRpE5ifdnjrIopWWDbA4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ZKkNnz8AiX/xP2BmD4Tjli/o5VgZvV+ZQZP7nFF4zs0cLcdxCRot1CeZpA79sfxPJ
	 d4UuMdOYoydP4NZtIUMoFT5iYFrPV8kYFzE5HtVjxm1uszn9Eec0GfmyEudoTz56Zb
	 A5y8Yp0jx2/sZtXT4sZPQ3YSTWbKQxrihi7vGWUM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Tao Zhou <tao.zhou1@amd.com>,
	Zilin Guan <zilin@seu.edu.cn>,
	Alex Deucher <alexander.deucher@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 580/641] drm/amdgpu: Fix memory leak in amdgpu_ras_init()
Date: Tue, 24 Feb 2026 17:25:06 -0800
Message-ID: <20260225012402.566332100@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260225012348.915798704@linuxfoundation.org>
References: <20260225012348.915798704@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Zilin Guan <zilin@seu.edu.cn>

[ Upstream commit ee41e5b63c8210525c936ee637a2c8d185ce873c ]

When amdgpu_nbio_ras_sw_init() fails in amdgpu_ras_init(), the function
returns directly without freeing the allocated con structure, leading
to a memory leak.

Fix this by jumping to the release_con label to properly clean up the
allocated memory before returning the error code.

Compile tested only. Issue found using a prototype static analysis tool
and code review.

Fixes: fdc94d3a8c88 ("drm/amdgpu: Rework pcie_bif ras sw_init")
Reviewed-by: Tao Zhou <tao.zhou1@amd.com>
Signed-off-by: Zilin Guan <zilin@seu.edu.cn>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/amd/amdgpu/amdgpu_ras.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/gpu/drm/amd/amdgpu/amdgpu_ras.c b/drivers/gpu/drm/amd/amdgpu/amdgpu_ras.c
index e0ee211508607..3fd19859055a5 100644
--- a/drivers/gpu/drm/amd/amdgpu/amdgpu_ras.c
+++ b/drivers/gpu/drm/amd/amdgpu/amdgpu_ras.c
@@ -4137,7 +4137,7 @@ int amdgpu_ras_init(struct amdgpu_device *adev)
 	 * to handle fatal error */
 	r = amdgpu_nbio_ras_sw_init(adev);
 	if (r)
-		return r;
+		goto release_con;
 
 	if (adev->nbio.ras &&
 	    adev->nbio.ras->init_ras_controller_interrupt) {
-- 
2.51.0



