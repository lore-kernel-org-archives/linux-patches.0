Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D32B946AA74;
	Tue, 21 Jul 2026 15:33:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784648037; cv=none; b=fFmRUuZMZDg8EnrvNwa/Lw5AvvuStLUv8zNOrNlYVAe+V1vUrZAK6SLD+AxWlvF+8MOpT4rHKO+nFpOWkgNeRPYRl76Scc821mcOSGGMxzPuR922IQBsdfiAM+XL3IKfTp4J9ik5H5oy0yPewe1RVo2YAqD4dzDqQBSCtwOgI7I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784648037; c=relaxed/simple;
	bh=jaL7HylwWgwy2ulj+N+/1n7amlGiMBjWWjzwC3GcfyI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=j8odKGYa6v/MB2opwURHOjoCpGe8i20DnLyQOUwy7vWw6OiPzae+exFM5aS8S47kbwn7feQRTU+N0WX38aU9evBkeDOb/KcI8RfTwsNdk2tV9A2qr6fw4uOJUs1bxwK/eFrOP/F6egpFLjQalMtE/k6EHXUvoKsk4D60OP6Q0eY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=wDo28lEi; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="wDo28lEi"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0C2D51F000E9;
	Tue, 21 Jul 2026 15:33:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784648036;
	bh=TV0rPgdEhWjYHiPOkodYNADAl40UUTx5NQdeAOX1Uss=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=wDo28lEifXKv2gK+VBVdsykm+VkN57kvBwavaYbZ6/s0TgMSF5gCOhYcOummihJgE
	 Dv36+FgghS+/ha22H8CLmsseIW4/DTmrJy7CmsVUnAm0M7urqwlxug9dbfPAQLOxlf
	 /d/igxDB2iBoMjBwzJ19zioI1/brHY2JbEj8IiZc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Maxime Ripard <mripard@kernel.org>,
	Tomi Valkeinen <tomi.valkeinen@ideasonboard.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.1 0049/2077] drm/tidss: Drop extra drm_mode_config_reset() call
Date: Tue, 21 Jul 2026 16:55:22 +0200
Message-ID: <20260721152553.846729540@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152552.646164743@linuxfoundation.org>
References: <20260721152552.646164743@linuxfoundation.org>
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

7.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Tomi Valkeinen <tomi.valkeinen@ideasonboard.com>

[ Upstream commit f468fef38716f667e805e0fa2c497c6b9c325bb9 ]

We are calling drm_mode_config_reset() twice at probe time. There's no
reason for this and the second call can be removed, reducing work at
probe time slightly.

Fixes: 32a1795f57ee ("drm/tidss: New driver for TI Keystone platform Display SubSystem")
Acked-by: Maxime Ripard <mripard@kernel.org>
Link: https://patch.msgid.link/20260311-tidss-minor-fixes-v2-1-cb4479784458@ideasonboard.com
Signed-off-by: Tomi Valkeinen <tomi.valkeinen@ideasonboard.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/tidss/tidss_kms.c | 2 --
 1 file changed, 2 deletions(-)

diff --git a/drivers/gpu/drm/tidss/tidss_kms.c b/drivers/gpu/drm/tidss/tidss_kms.c
index 8bb93194e5ac68..b4779c09a1bfa5 100644
--- a/drivers/gpu/drm/tidss/tidss_kms.c
+++ b/drivers/gpu/drm/tidss/tidss_kms.c
@@ -287,8 +287,6 @@ int tidss_modeset_init(struct tidss_device *tidss)
 	if (ret)
 		return ret;
 
-	drm_mode_config_reset(ddev);
-
 	dev_dbg(tidss->dev, "%s done\n", __func__);
 
 	return 0;
-- 
2.53.0



