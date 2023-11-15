Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A40D8364B3
	for <patches@lists.linux.dev>; Wed, 15 Nov 2023 20:48:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="aBmiprto"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5408DC3277E;
	Wed, 15 Nov 2023 20:48:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1700081332;
	bh=VYmoS7hIaiL6xUH+NNLe8QVhSW8D439j3tvxm5be3EI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=aBmiprtoHA9LFHCXZ1ZDTrygD8BuJyqJ0eF6lFc4FlzyCwftWSQDe6BKG6tbJ17Se
	 pdt0v/QBboMcD3RqV3Ancqh66gnrBWBQsLeo76DVCtQV9+kJ33+BfFzvk1RGjCPYFQ
	 ftf7+uGjRu9B0qd7GhgEbu6aI8W7y+dtHYjkhjLY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sam Ravnborg <sam@ravnborg.org>,
	Maxime Ripard <maxime@cerno.tech>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 089/244] drm/bridge: lt8912b: Register and attach our DSI device at probe
Date: Wed, 15 Nov 2023 15:34:41 -0500
Message-ID: <20231115203553.699521100@linuxfoundation.org>
X-Mailer: git-send-email 2.42.1
In-Reply-To: <20231115203548.387164783@linuxfoundation.org>
References: <20231115203548.387164783@linuxfoundation.org>
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

From: Maxime Ripard <maxime@cerno.tech>

[ Upstream commit d89078c37b10f05fa4f4791b71db2572db361b68 ]

In order to avoid any probe ordering issue, the best practice is to move
the secondary MIPI-DSI device registration and attachment to the
MIPI-DSI host at probe time. Let's do this.

Acked-by: Sam Ravnborg <sam@ravnborg.org>
Signed-off-by: Maxime Ripard <maxime@cerno.tech>
Link: https://patchwork.freedesktop.org/patch/msgid/20211025151536.1048186-7-maxime@cerno.tech
Stable-dep-of: 941882a0e96d ("drm/bridge: lt8912b: Fix bridge_detach")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/bridge/lontium-lt8912b.c | 11 +++++++----
 1 file changed, 7 insertions(+), 4 deletions(-)

diff --git a/drivers/gpu/drm/bridge/lontium-lt8912b.c b/drivers/gpu/drm/bridge/lontium-lt8912b.c
index 24ca22b0b9f56..6ad3b2d1819f1 100644
--- a/drivers/gpu/drm/bridge/lontium-lt8912b.c
+++ b/drivers/gpu/drm/bridge/lontium-lt8912b.c
@@ -552,10 +552,6 @@ static int lt8912_bridge_attach(struct drm_bridge *bridge,
 	if (ret)
 		goto error;
 
-	ret = lt8912_attach_dsi(lt);
-	if (ret)
-		goto error;
-
 	lt->is_attached = true;
 
 	return 0;
@@ -714,8 +710,15 @@ static int lt8912_probe(struct i2c_client *client,
 
 	drm_bridge_add(&lt->bridge);
 
+	ret = lt8912_attach_dsi(lt);
+	if (ret)
+		goto err_attach;
+
 	return 0;
 
+err_attach:
+	drm_bridge_remove(&lt->bridge);
+	lt8912_free_i2c(lt);
 err_i2c:
 	lt8912_put_dt(lt);
 err_dt_parse:
-- 
2.42.0



