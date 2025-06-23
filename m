Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C4CE3230BC2;
	Mon, 23 Jun 2025 13:33:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750685618; cv=none; b=cx/uWi2Cl2/BA5nKFN5odJCYDopVxV5iBo3IJZ5DJDereENCPsz6ruKOlSXS1ebWPAFD8zJy8q6mA7AfEdkgIN15GpAbN8Go1diIw4LQ7exkPjbb76Ogf9xyGoa4EtvpDNUcbFUCtSNmhzo2gC9oaWk7LHev5PU1Z8fxxwMpxSU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750685618; c=relaxed/simple;
	bh=3K0Q2aWZBPeNYPZJUkHN7t5jH/zz79Z/udI4JH1gSVY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Khm+rRR0t/dQr4Ts40XkkrWFO9yjuLVja10JmUFJceSSYra/5Xh7MvMFRdz5YUHhbpGnfgaXza5DqYtk6lYLjcT9tzz2Z+Kkkgf/OIjgeBxEnZdpq+h2TNgq50Rh24WsyXFy5+6ekTVMwDVd8qIYA5M/pIbzGFXq6wweNIuwoHE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=aw30Ob8K; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="aw30Ob8K"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5A92CC4CEEA;
	Mon, 23 Jun 2025 13:33:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1750685618;
	bh=3K0Q2aWZBPeNYPZJUkHN7t5jH/zz79Z/udI4JH1gSVY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=aw30Ob8Kt6Ya+Lq8Yl8xcqZhsUWyqecg4wyQMx2QLPrjiPPc1fCrR/0tl/QyHWXJ8
	 MZ/fvemaNoV+yKbsJ5gKyK5X1XiFU7x5js9RIxAea91G/6WNMfSqHt+sqgWpKtZqDK
	 gI2zrYUQVGNJ59ks5UIkvNH0kud+NaRlJ3BeFqrM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ayushi Makhija <quic_amakhija@quicinc.com>,
	Dmitry Baryshkov <dmitry.baryshkov@oss.qualcomm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.15 248/592] drm/bridge: anx7625: enable HPD interrupts
Date: Mon, 23 Jun 2025 15:03:26 +0200
Message-ID: <20250623130706.192897972@linuxfoundation.org>
X-Mailer: git-send-email 2.50.0
In-Reply-To: <20250623130700.210182694@linuxfoundation.org>
References: <20250623130700.210182694@linuxfoundation.org>
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

6.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Ayushi Makhija <quic_amakhija@quicinc.com>

[ Upstream commit ca8a78cdceb48ad3b753f836068611265840ef22 ]

When the device enters the suspend state, it prevents
HPD interrupts from occurring. To address this, implement
.hpd_enable() and .hpd_disable() callbacks functions of
the drm_bridge.

Signed-off-by: Ayushi Makhija <quic_amakhija@quicinc.com>
Reviewed-by: Dmitry Baryshkov <dmitry.baryshkov@oss.qualcomm.com>
Link: https://lore.kernel.org/r/20250505094245.2660750-4-quic_amakhija@quicinc.com
Signed-off-by: Dmitry Baryshkov <dmitry.baryshkov@oss.qualcomm.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/bridge/analogix/anx7625.c | 18 ++++++++++++++++++
 1 file changed, 18 insertions(+)

diff --git a/drivers/gpu/drm/bridge/analogix/anx7625.c b/drivers/gpu/drm/bridge/analogix/anx7625.c
index 0b97b66de5774..99ef3f27ae429 100644
--- a/drivers/gpu/drm/bridge/analogix/anx7625.c
+++ b/drivers/gpu/drm/bridge/analogix/anx7625.c
@@ -2474,6 +2474,22 @@ static const struct drm_edid *anx7625_bridge_edid_read(struct drm_bridge *bridge
 	return anx7625_edid_read(ctx);
 }
 
+static void anx7625_bridge_hpd_enable(struct drm_bridge *bridge)
+{
+	struct anx7625_data *ctx = bridge_to_anx7625(bridge);
+	struct device *dev = ctx->dev;
+
+	pm_runtime_get_sync(dev);
+}
+
+static void anx7625_bridge_hpd_disable(struct drm_bridge *bridge)
+{
+	struct anx7625_data *ctx = bridge_to_anx7625(bridge);
+	struct device *dev = ctx->dev;
+
+	pm_runtime_put_sync(dev);
+}
+
 static const struct drm_bridge_funcs anx7625_bridge_funcs = {
 	.attach = anx7625_bridge_attach,
 	.detach = anx7625_bridge_detach,
@@ -2487,6 +2503,8 @@ static const struct drm_bridge_funcs anx7625_bridge_funcs = {
 	.atomic_reset = drm_atomic_helper_bridge_reset,
 	.detect = anx7625_bridge_detect,
 	.edid_read = anx7625_bridge_edid_read,
+	.hpd_enable = anx7625_bridge_hpd_enable,
+	.hpd_disable = anx7625_bridge_hpd_disable,
 };
 
 static int anx7625_register_i2c_dummy_clients(struct anx7625_data *ctx,
-- 
2.39.5



