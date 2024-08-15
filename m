Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D886719EECD;
	Thu, 15 Aug 2024 13:44:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723729456; cv=none; b=QntYremnz1/05WP9lXN+bIJ9umzasoLLogD7wnqwLMwYgoA7a4WQ+3186Ac7Vs3LZFX3hRJdlx37Vk1HDxvCxP4cvO28Vhw4u4iTYkv1M2Yj6dV3wulR5muLw16yYlfP6cKPHfdKIZMxuiSDGfk498fS8bMosivc5h5t8a5n3YU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723729456; c=relaxed/simple;
	bh=0NImaFvGN8AF3oEJ0kP+pSb0WCO99AB8Tm4l7betCqY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Lbv9CgzR/qyUpEqU54hIM6vVx3KUI1YnwfQZArHGiQXspoBA83Zl/XPSt7I4GEi2lYygkX3H4XEzoJI9ITLhk70BsLOCmtW/xfhcuXlJeRvFi4NSaarGitjRU5gxKnNh9hYl6hrAg3G8XbHxM/+ID0uF6De/ADkAEv/xNFDGICE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=L7R+DTbu; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="L7R+DTbu"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 17BF3C4AF0C;
	Thu, 15 Aug 2024 13:44:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1723729456;
	bh=0NImaFvGN8AF3oEJ0kP+pSb0WCO99AB8Tm4l7betCqY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=L7R+DTbueErrnfjk4/+hbQ5s+n1O27Qenintn2KGWK8zX/b04lFWrCg8IR4qULhCo
	 OD79r2YpOpFVUKce3+r43ymuRQTyOyb+RY7nnw8G0OFsAG2YV31JJ6WAj+Dn1KJlyO
	 E7rsv7v8BA2TPAo6h2sZpUYmjnBtxAn6UHDkpKjs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Chen Ni <nichen@iscas.ac.cn>,
	Heng Qi <hengqi@linux.alibaba.com>,
	Maxime Ripard <mripard@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 104/484] drm/qxl: Add check for drm_cvt_mode
Date: Thu, 15 Aug 2024 15:19:22 +0200
Message-ID: <20240815131945.313902518@linuxfoundation.org>
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
Content-Transfer-Encoding: 8bit

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Chen Ni <nichen@iscas.ac.cn>

[ Upstream commit 7bd09a2db0f617377027a2bb0b9179e6959edff3 ]

Add check for the return value of drm_cvt_mode() and return the error if
it fails in order to avoid NULL pointer dereference.

Fixes: 1b043677d4be ("drm/qxl: add qxl_add_mode helper function")
Signed-off-by: Chen Ni <nichen@iscas.ac.cn>
Reviewed-by: Heng Qi <hengqi@linux.alibaba.com>
Signed-off-by: Maxime Ripard <mripard@kernel.org>
Link: https://patchwork.freedesktop.org/patch/msgid/20240621071031.1987974-1-nichen@iscas.ac.cn
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/qxl/qxl_display.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/gpu/drm/qxl/qxl_display.c b/drivers/gpu/drm/qxl/qxl_display.c
index dc04412784a0d..c17b24eee0cf4 100644
--- a/drivers/gpu/drm/qxl/qxl_display.c
+++ b/drivers/gpu/drm/qxl/qxl_display.c
@@ -233,6 +233,9 @@ static int qxl_add_mode(struct drm_connector *connector,
 		return 0;
 
 	mode = drm_cvt_mode(dev, width, height, 60, false, false, false);
+	if (!mode)
+		return 0;
+
 	if (preferred)
 		mode->type |= DRM_MODE_TYPE_PREFERRED;
 	mode->hdisplay = width;
-- 
2.43.0



