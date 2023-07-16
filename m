Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E88E68F74
	for <patches@lists.linux.dev>; Sun, 16 Jul 2023 20:03:46 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6A9DFC433C8;
	Sun, 16 Jul 2023 20:03:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1689537826;
	bh=5UKJjGQJ05FiP5/uIvyKl5nE1zX6M8FMqrte+R0HY8A=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=b9WmvxYgQt0VdSP23W7UF50Mu444fqYwIyLHsra2/CsmATBE63XzXPauaQApRSj09
	 zVGY6Fhhh/jEXDi/jis3dYigBJG3KCutwB/AAw+iBt0ACdkTZEwjduKHkRb9qHP0he
	 gvno8ncyteyIYVnUvF9Tq4kyn/dUOSWg5v78QuS8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Alexander Stein <alexander.stein@ew.tq-group.com>,
	Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	Robert Foss <rfoss@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.4 234/800] drm/bridge: ti-sn65dsi83: Fix enable error path
Date: Sun, 16 Jul 2023 21:41:27 +0200
Message-ID: <20230716194954.524320460@linuxfoundation.org>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20230716194949.099592437@linuxfoundation.org>
References: <20230716194949.099592437@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Alexander Stein <alexander.stein@ew.tq-group.com>

[ Upstream commit 8a91b29f1f50ce7742cdbe5cf11d17f128511f3f ]

If PLL locking failed, the regulator needs to be disabled again.

Fixes: 5664e3c907e2 ("drm/bridge: ti-sn65dsi83: Add vcc supply regulator support")
Signed-off-by: Alexander Stein <alexander.stein@ew.tq-group.com>
Reviewed-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Signed-off-by: Robert Foss <rfoss@kernel.org>
Link: https://patchwork.freedesktop.org/patch/msgid/20230504065316.2640739-1-alexander.stein@ew.tq-group.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/bridge/ti-sn65dsi83.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/gpu/drm/bridge/ti-sn65dsi83.c b/drivers/gpu/drm/bridge/ti-sn65dsi83.c
index 75286c9afbb96..1f5c07989e2bf 100644
--- a/drivers/gpu/drm/bridge/ti-sn65dsi83.c
+++ b/drivers/gpu/drm/bridge/ti-sn65dsi83.c
@@ -478,6 +478,7 @@ static void sn65dsi83_atomic_enable(struct drm_bridge *bridge,
 		dev_err(ctx->dev, "failed to lock PLL, ret=%i\n", ret);
 		/* On failure, disable PLL again and exit. */
 		regmap_write(ctx->regmap, REG_RC_PLL_EN, 0x00);
+		regulator_disable(ctx->vcc);
 		return;
 	}
 
-- 
2.39.2



