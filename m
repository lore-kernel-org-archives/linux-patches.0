Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 48F548F5D
	for <patches@lists.linux.dev>; Sun, 16 Jul 2023 20:37:06 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BFF03C433C8;
	Sun, 16 Jul 2023 20:37:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1689539826;
	bh=+QVoBGjCHwHyp0NZ0tsRY2KoP61YcdYpqRxaf/wZ3yY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Kg8r2vY+rJp7ajYJQqUAOX7M894+8zuwNbGCYbn5v0s9lVJbxHiWDxaYaYFpGWNfM
	 e5UZO6di7VAGe7Hm/FiwuXzd+eICUX1gCDiXoJg4otHJsry75Powpsj8WFj1lYCVrH
	 1tSTqqPiY7BTNdFpPk9fKUR+zZvxADBEV+zi5P+Q=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Alexander Stein <alexander.stein@ew.tq-group.com>,
	Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	Robert Foss <rfoss@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 146/591] drm/bridge: ti-sn65dsi83: Fix enable error path
Date: Sun, 16 Jul 2023 21:44:45 +0200
Message-ID: <20230716194927.649018897@linuxfoundation.org>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20230716194923.861634455@linuxfoundation.org>
References: <20230716194923.861634455@linuxfoundation.org>
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
index 047c14ddbbf11..0635b824e3682 100644
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



