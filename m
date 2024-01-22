Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CFEDA131748;
	Tue, 23 Jan 2024 00:24:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1705969447; cv=none; b=gOpXWtlNY6mbaGQlfqI3JfPRyMhKzOodBAQ5wjvi9ZzKEiUg/pP36FJBGZFSG50mYxuwUufAZP/r2FvOsyB77n1f4C+o/6QGngx4O5qGVb9zRe2cI6S4864zkJxkAnO77DaCS/syT+d+fVqYvucYjw+QojGD0MVKbRy1od/K7Ro=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1705969447; c=relaxed/simple;
	bh=31IE789LQMFxm+yls3Pzg0NVGVMKbCW6EzCCuyaGZ2w=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=aJwRBzHV1aChSQ6bVtxHnr476oiw5CaHSlL7NmXgiIiH5BD+s+V0u8LyzJ1FrDUUjRAEBtOLHSKGOLShDMYV0LC7z12YiZ+H92RvXUr5pRYS5zA6PfPsyy83gBe1DhqIUKNGTBfQRrEE3a+BYa44Mj9JBS5p+fBsGmCkWwrfk4k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=AlQkm+YL; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="AlQkm+YL"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 91FB3C43399;
	Tue, 23 Jan 2024 00:24:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1705969447;
	bh=31IE789LQMFxm+yls3Pzg0NVGVMKbCW6EzCCuyaGZ2w=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=AlQkm+YLPQhwI7cJKAiY3ONFTJJA/XIcQBYq/8yxdDC/WYaB7EZ3F4jXloTik7qcq
	 ETnrbc6mV4O01PDlLhvV7kzG7pLdzPAPbkMxAQjboZsc63zOyOwk6o8eYtMZGuCV5w
	 uOtu6pEwZJw9ficjrAhuXBg6K/IdkY+RXZPQArMg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Thomas Zimmermann <tzimmermann@suse.de>,
	Aradhya Bhatia <a-bhatia1@ti.com>,
	Tomi Valkeinen <tomi.valkeinen@ideasonboard.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.7 253/641] drm/tilcdc: Fix irq free on unload
Date: Mon, 22 Jan 2024 15:52:37 -0800
Message-ID: <20240122235825.832218669@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240122235818.091081209@linuxfoundation.org>
References: <20240122235818.091081209@linuxfoundation.org>
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

6.7-stable review patch.  If anyone has any objections, please let me know.

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
index 8ebd7134ee21..2f6eaac7f659 100644
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



