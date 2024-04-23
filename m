Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DEBA4146A94;
	Tue, 23 Apr 2024 21:44:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713908679; cv=none; b=FT25O8Nn5W39fS4CLdQxVub+1Ijzsb+ifs7XZfyIloGBEHnwbRX2VtFX6e6sJw/MpD55lzsM/bFWPflrALJHA1VFWKdEZ/kcPHFi+OwvtNcCv3HkNJzsgATQ9wD7U+Orjo7EPZEavsMegOilf+WhoNazhb09yHUncv4T3gv6W5Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713908679; c=relaxed/simple;
	bh=9AOt29k2fEqqW+JkPMGA/FxX34wANXmME0zxpr1XXxQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=I07cNsJpmEMkjHjEEmu9PemPoxP6if4ojWAV/SbSMstkFcPF+tpiyZ03wHta23ztgqSKjLu+/HeSemY+bItKVtEwbtNV+2UkU9aZkO2tIeGwU2cmV6rFHE4+YBDunX/WwrCi5tijLYlIxqF/sx8YksHVpgQNgfOb7A+vFlaEe/s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=oR0ltvu5; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="oR0ltvu5"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B3B78C116B1;
	Tue, 23 Apr 2024 21:44:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1713908678;
	bh=9AOt29k2fEqqW+JkPMGA/FxX34wANXmME0zxpr1XXxQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=oR0ltvu5man2K3CrR5GZTYFKf0A+bTnNsNoG7zGUxKQWGCUU1egdaMqzl6msybIdi
	 aRi8lYtAbWoBof/PCi1sGjp1LBT7qtrgH4jZN05LBSdMINfC2BbVELERm1CNf2fIWh
	 dBiif18kJQp4tHjaZY+7xVXqWJlBDWQFc+uAswpM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Tim Huang <Tim.Huang@amd.com>,
	Yifan Zhang <yifan1.zhang@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 003/141] drm/amdgpu: fix incorrect number of active RBs for gfx11
Date: Tue, 23 Apr 2024 14:37:51 -0700
Message-ID: <20240423213853.469961946@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240423213853.356988651@linuxfoundation.org>
References: <20240423213853.356988651@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Tim Huang <Tim.Huang@amd.com>

[ Upstream commit bbca7f414ae9a12ea231cdbafd79c607e3337ea8 ]

The RB bitmap should be global active RB bitmap &
active RB bitmap based on active SA.

Signed-off-by: Tim Huang <Tim.Huang@amd.com>
Reviewed-by: Yifan Zhang <yifan1.zhang@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Cc: stable@vger.kernel.org
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/amd/amdgpu/gfx_v11_0.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/gpu/drm/amd/amdgpu/gfx_v11_0.c b/drivers/gpu/drm/amd/amdgpu/gfx_v11_0.c
index ec40f88da00c3..5a5787bfbce7f 100644
--- a/drivers/gpu/drm/amd/amdgpu/gfx_v11_0.c
+++ b/drivers/gpu/drm/amd/amdgpu/gfx_v11_0.c
@@ -1592,7 +1592,7 @@ static void gfx_v11_0_setup_rb(struct amdgpu_device *adev)
 			active_rb_bitmap |= (0x3 << (i * rb_bitmap_width_per_sa));
 	}
 
-	active_rb_bitmap |= global_active_rb_bitmap;
+	active_rb_bitmap &= global_active_rb_bitmap;
 	adev->gfx.config.backend_enable_mask = active_rb_bitmap;
 	adev->gfx.config.num_rbs = hweight32(active_rb_bitmap);
 }
-- 
2.43.0



