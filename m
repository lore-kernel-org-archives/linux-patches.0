Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ED3A012D1F1;
	Mon, 23 Dec 2024 16:05:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734969924; cv=none; b=d8K3feujLhHlg5Iwl9nGzmqiexrZRIkKekbfjGHvB54vGHfBRz9ahp2iN2C2XdBLc537AG4hS4UjFmXmB0GPna3Jq4xtAOD4b6yufMhaPrYS+ZrhGkRw0hG5Tf+R+1lrZN0uyRmbQ8DQDy5oCuwG0JAA+oLSJVhbZIecLwfT9M4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734969924; c=relaxed/simple;
	bh=pUmTjMCXwZNBSStXSwTBgNp19Wz3VECA21ZB+Ppu/lc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=XosUDYr60rcvvi2i5KSdhDOYuppEg3H/HV4oINyNV8qKIAKSofR09T/VVuAHi3qaQm3Pom6ucN0WJgnDMSF2Z8890kQTSv/WDwNTL2bgj4HOEnNfAfgO/OdRYlpiNhhk8H/dcbfFx301dw60YecMOGVUir85zE+jcGCgydFIhqM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=oePSCWa2; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="oePSCWa2"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5B7ACC4CEDF;
	Mon, 23 Dec 2024 16:05:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1734969923;
	bh=pUmTjMCXwZNBSStXSwTBgNp19Wz3VECA21ZB+Ppu/lc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=oePSCWa2tDPS0eyza/KWiYNBxGdK3BSP1ePaIghx/cOcyvaFAS59JwcvvBIqorHHv
	 ye1qHG/oZ7knpFUEY72lZc6w52QAFuoTceSB+RVLTNRKTF4wuDkcuAV6a1luwwhiBK
	 eoxoQ3uZ6NeQaKpXYDIq2ehugwkmprJtYftEpb9o=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Zhang Zekun <zhangzekun11@huawei.com>,
	Neil Armstrong <neil.armstrong@linaro.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 093/160] drm/panel: himax-hx83102: Add a check to prevent NULL pointer dereference
Date: Mon, 23 Dec 2024 16:58:24 +0100
Message-ID: <20241223155412.284821550@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241223155408.598780301@linuxfoundation.org>
References: <20241223155408.598780301@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Zhang Zekun <zhangzekun11@huawei.com>

[ Upstream commit e1e1af9148dc4c866eda3fb59cd6ec3c7ea34b1d ]

drm_mode_duplicate() could return NULL due to lack of memory,
which will then call NULL pointer dereference. Add a check to
prevent it.

Fixes: 0ef94554dc40 ("drm/panel: himax-hx83102: Break out as separate driver")
Signed-off-by: Zhang Zekun <zhangzekun11@huawei.com>
Reviewed-by: Neil Armstrong <neil.armstrong@linaro.org>
Link: https://lore.kernel.org/r/20241025073408.27481-3-zhangzekun11@huawei.com
Signed-off-by: Neil Armstrong <neil.armstrong@linaro.org>
Link: https://patchwork.freedesktop.org/patch/msgid/20241025073408.27481-3-zhangzekun11@huawei.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/panel/panel-himax-hx83102.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/gpu/drm/panel/panel-himax-hx83102.c b/drivers/gpu/drm/panel/panel-himax-hx83102.c
index 8b48bba18131..3644a7544b93 100644
--- a/drivers/gpu/drm/panel/panel-himax-hx83102.c
+++ b/drivers/gpu/drm/panel/panel-himax-hx83102.c
@@ -565,6 +565,8 @@ static int hx83102_get_modes(struct drm_panel *panel,
 	struct drm_display_mode *mode;
 
 	mode = drm_mode_duplicate(connector->dev, m);
+	if (!mode)
+		return -ENOMEM;
 
 	mode->type = DRM_MODE_TYPE_DRIVER | DRM_MODE_TYPE_PREFERRED;
 	drm_mode_set_name(mode);
-- 
2.39.5



