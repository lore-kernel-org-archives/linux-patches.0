Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1BAF3156653;
	Thu, 13 Feb 2025 15:21:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739460103; cv=none; b=iF9JXoM7RzhZwJuk2XtLpD2DmWqDjxWQOpZhGAVminHxI1p+KNDliNEQ8/IiRNEGVdyde1UiHZVSMFowy86ykrooNnqeN6b05p8t/KyPnlnJLBuup7yYke6sh52HnaezBKhVTwU3dBFFZvW1jIqiNC7FccLixF7i1hgNtXRHSXE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739460103; c=relaxed/simple;
	bh=k/lS4tYfd6t+zxD6jrVD0Qed8mboKsSLNFxKkmrugNI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=S2dUvgkwZvC47JIF6yX18ax77+pbL4rLaI0bshMPHjf6bjUQ6xyPuxvhEJZa/KPP/wWrsa5G7A5SWlWJsV7f72KdJL9MDTNk9Q1QJQSaV/u8k7NLfm9YMWSJYG7B/y+cnKWecrp3wJcbY2DRGN8m6DZ1EvyxENnpBHfyT1A9rds=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=zEsC+rqS; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="zEsC+rqS"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3C487C4CED1;
	Thu, 13 Feb 2025 15:21:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1739460102;
	bh=k/lS4tYfd6t+zxD6jrVD0Qed8mboKsSLNFxKkmrugNI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=zEsC+rqSdahRw+83OrwJHyqfk56JKkM5yxtH94JOVP7+uwLk0MVLRaZl7qJV6vyCP
	 KbwPWvvftH+boql0jtkJDmJbASoEtSloGLuRIKIvxviEu+JgbVecblrC5to165n9C2
	 uHlQruk1n2vD7Z9SaIIsHhPqJmWKa+3/46U5cqzU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Maxime Ripard <mripard@kernel.org>,
	Harry Wentland <harry.wentland@amd.com>,
	Dmitry Baryshkov <dmitry.baryshkov@linaro.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 016/273] drm/amd/display: use eld_mutex to protect access to connector->eld
Date: Thu, 13 Feb 2025 15:26:28 +0100
Message-ID: <20250213142408.001497534@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250213142407.354217048@linuxfoundation.org>
References: <20250213142407.354217048@linuxfoundation.org>
User-Agent: quilt/0.68
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

From: Dmitry Baryshkov <dmitry.baryshkov@linaro.org>

[ Upstream commit 819bee01eea06282d7bda17d46caf29cae4f6d84 ]

Reading access to connector->eld can happen at the same time the
drm_edid_to_eld() updates the data. Take the newly added eld_mutex in
order to protect connector->eld from concurrent access.

Reviewed-by: Maxime Ripard <mripard@kernel.org>
Reviewed-by: Harry Wentland <harry.wentland@amd.com>
Link: https://patchwork.freedesktop.org/patch/msgid/20241206-drm-connector-eld-mutex-v2-4-c9bce1ee8bea@linaro.org
Signed-off-by: Dmitry Baryshkov <dmitry.baryshkov@linaro.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c b/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c
index 8a152f4974d3c..aab99df3ba1ae 100644
--- a/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c
+++ b/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c
@@ -955,8 +955,10 @@ static int amdgpu_dm_audio_component_get_eld(struct device *kdev, int port,
 			continue;
 
 		*enabled = true;
+		mutex_lock(&connector->eld_mutex);
 		ret = drm_eld_size(connector->eld);
 		memcpy(buf, connector->eld, min(max_bytes, ret));
+		mutex_unlock(&connector->eld_mutex);
 
 		break;
 	}
-- 
2.39.5



