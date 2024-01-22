Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7DBB512A155;
	Tue, 23 Jan 2024 00:50:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1705971024; cv=none; b=J/iNGE3E+VnxmlbfPMRZPfjk9a+KsKLxBSn0hyReLM/fr0TVn0MUlaH2fnrO476CqJ4r4YgeCCGOoiGjKaYBc3ucgCCepJakuaXZg3uInHZcQEVg6KvSDX/4jnhDmNLQ3Vhh7xFolxG22hN7Ja/NmAmKPlzwzKRMlnJaWEafjYc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1705971024; c=relaxed/simple;
	bh=wLOt+cTadRQUVYZJWU0xjgfg9EuXdjfKkTMMYR8/yfk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=VWouG8v4/MCsRM6yqaqg8aHwhZQHOK0BvOr6Z0RzoByvUu6Suwz/SZssSGYy2xwpQSWk5KjuWvoHJwOXxx43781ZulTXDvAqYJBesnbG1xfBtB/XBx4NKVfNnFiTXOw1dd4Pdvj6wzqEaLwTRbIqgDn2zOujHbDYKCMJjWKOr34=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=AvdnTTdA; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="AvdnTTdA"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DAA46C43394;
	Tue, 23 Jan 2024 00:50:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1705971024;
	bh=wLOt+cTadRQUVYZJWU0xjgfg9EuXdjfKkTMMYR8/yfk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=AvdnTTdASrSttjbgEgDbG1GQZeXcaMUnGwJD57+JfENourh982txK30LAM1b4+Lsb
	 G7sNTMlhERiFrYwUFfuxGvnMHeDNXe3C882MrE60CLbYd6G3dY9OjIW/FME2LawwGY
	 lmTc9sI/4N1FJPG7Lm2EzpXFEm0p3Dj5WkGY0byA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Thomas Zimmermann <tzimmermann@suse.de>,
	Aradhya Bhatia <a-bhatia1@ti.com>,
	Tomi Valkeinen <tomi.valkeinen@ideasonboard.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 164/417] drm/tilcdc: Fix irq free on unload
Date: Mon, 22 Jan 2024 15:55:32 -0800
Message-ID: <20240122235757.529156294@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240122235751.480367507@linuxfoundation.org>
References: <20240122235751.480367507@linuxfoundation.org>
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

From: Tomi Valkeinen <tomi.valkeinen@ideasonboard.com>

[ Upstream commit 38360bf96d816e175bc602c4ee76953cd303b71d ]

The driver only frees the reserved irq if priv->irq_enabled is set to
true. However, the driver mistakenly sets priv->irq_enabled to false,
instead of true, in tilcdc_irq_install(), and thus the driver never
frees the irq, causing issues on loading the driver a second time.

Fixes: b6366814fa77 ("drm/tilcdc: Convert to Linux IRQ interfaces")
Cc: Thomas Zimmermann <tzimmermann@suse.de>
Reviewed-by: Aradhya Bhatia <a-bhatia1@ti.com>
Signed-off-by: Tomi Valkeinen <tomi.valkeinen@ideasonboard.com>
Link: https://patchwork.freedesktop.org/patch/msgid/20230919-lcdc-v1-1-ba60da7421e1@ideasonboard.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/tilcdc/tilcdc_drv.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/gpu/drm/tilcdc/tilcdc_drv.c b/drivers/gpu/drm/tilcdc/tilcdc_drv.c
index f72755b8ea14..86d34b77b37d 100644
--- a/drivers/gpu/drm/tilcdc/tilcdc_drv.c
+++ b/drivers/gpu/drm/tilcdc/tilcdc_drv.c
@@ -138,7 +138,7 @@ static int tilcdc_irq_install(struct drm_device *dev, unsigned int irq)
 	if (ret)
 		return ret;
 
-	priv->irq_enabled = false;
+	priv->irq_enabled = true;
 
 	return 0;
 }
-- 
2.43.0



