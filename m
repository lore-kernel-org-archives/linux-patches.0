Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4165651C5C;
	Mon, 11 Dec 2023 18:58:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="dDTrPUSX"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BC59AC433C7;
	Mon, 11 Dec 2023 18:58:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1702321130;
	bh=98wBZfP/UhL5zEZ6JKCwhnijgKYvmJndQ2fWaNc4fRk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=dDTrPUSXIbrArsm7EkB9NJXYUITsbUsj4j/4NI8NbevK5zKsw2KS1zhy1SEN6RF5T
	 uAono+eT+SMyr9eOABwsyVYRhQgJIrK29DDtgC2UHPmwqsFNSM+oAKd3q1PlJVxUrI
	 WeMlRbxxTiS2aHLjy83A1JYz0UMgQenBK2tq+698=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Prike Liang <Prike.Liang@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 120/141] drm/amdgpu: correct the amdgpu runtime dereference usage count
Date: Mon, 11 Dec 2023 19:22:59 +0100
Message-ID: <20231211182031.771183393@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20231211182026.503492284@linuxfoundation.org>
References: <20231211182026.503492284@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Prike Liang <Prike.Liang@amd.com>

[ Upstream commit c6df7f313794c3ad41a49b9a7c95da369db607f3 ]

Fix the amdgpu runpm dereference usage count.

Signed-off-by: Prike Liang <Prike.Liang@amd.com>
Reviewed-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Cc: stable@vger.kernel.org
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/amd/amdgpu/amdgpu_display.c | 9 +++------
 1 file changed, 3 insertions(+), 6 deletions(-)

diff --git a/drivers/gpu/drm/amd/amdgpu/amdgpu_display.c b/drivers/gpu/drm/amd/amdgpu/amdgpu_display.c
index 2952f89734487..11413b3e80c5b 100644
--- a/drivers/gpu/drm/amd/amdgpu/amdgpu_display.c
+++ b/drivers/gpu/drm/amd/amdgpu/amdgpu_display.c
@@ -296,14 +296,11 @@ int amdgpu_display_crtc_set_config(struct drm_mode_set *set,
 		adev->have_disp_power_ref = true;
 		return ret;
 	}
-	/* if we have no active crtcs, then drop the power ref
-	 * we got before
+	/* if we have no active crtcs, then go to
+	 * drop the power ref we got before
 	 */
-	if (!active && adev->have_disp_power_ref) {
-		pm_runtime_put_autosuspend(dev->dev);
+	if (!active && adev->have_disp_power_ref)
 		adev->have_disp_power_ref = false;
-	}
-
 out:
 	/* drop the power reference we got coming in here */
 	pm_runtime_put_autosuspend(dev->dev);
-- 
2.42.0



