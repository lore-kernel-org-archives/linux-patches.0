Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 147F84E781D;
	Thu, 17 Sep 2026 16:04:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789661064; cv=none; b=rwCwWU3h/GXTUovPC/w9X6NC7u1Hrln/kala5PBGT98JiF89YrF+hD2y0Xl7vsjdL9N7zr/tEAQrWQqFp5geqRS8TwZdt4esUSRBbCggsqsKBy29aK4fROg6PtErRMckAG8FK5Vrh7tI18BJh+aikOV/ZyVENBi66EAWKj96PfI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789661064; c=relaxed/simple;
	bh=H+UzHqjB5pJyIIxi4awYKLo6QTB4BuCp80MPZrtqes4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=SrKTAe5cZEe/079LAtfhJc2LXUX5qQykqKW/3y2ZgJOfJJFa/PTsNTvGPI25awLPGpMqSbHHBZ5xgpZPwZ1S164W5OaCbUKUsfqG+U5IXozOxTJWcuL9CLmf1ko8sW013EoXpm64p/5K2j+NpymeI9i+epg+BiEp/gDpODaS9NE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=sYrYg4cK; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="sYrYg4cK"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4399F1F000FF;
	Thu, 17 Sep 2026 16:04:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789661062;
	bh=yTO3jhPWTolKx/Wx0dGAiobu9b1ujr2XFOdQtEHmbiU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=sYrYg4cKGm5f0DFKbyR//ifiU/fbyMTN5tnmCSGovrlrpjtEk2rfaGlBWhjbluyhD
	 k2Oon2DvW0bO5VAzvM3GlqEitmGkHglyvnIUS3SO4TLlae9B9iJmzZbOxvF9AgzzoE
	 +IYolGTomC4Ad2q9+DYO88Dtv1fiq9NT2C9qEfGM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Paul Cercueil <paul@crapouillou.net>,
	Mehdi Djait <mehdi.djait@linux.intel.com>,
	Hans Verkuil <hverkuil+cisco@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0069/1250] media: v4l2-common: Always register clock with device-specific name
Date: Thu, 17 Sep 2026 15:57:44 +0100
Message-ID: <20260917151553.813767114@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260917151551.901433442@linuxfoundation.org>
References: <20260917151551.901433442@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Paul Cercueil <paul@crapouillou.net>

[ Upstream commit 0b42657bea6ba635226e8ef551076d024ceacdc9 ]

If we need to register a dummy fixed-frequency clock, always register it
using a device-specific name.

This supports the use case where a system has two of the same sensor,
meaning two instances of the same driver, which previously both tried
(and failed) to create a clock with the same name.

Signed-off-by: Paul Cercueil <paul@crapouillou.net>
Reviewed-by: Mehdi Djait <mehdi.djait@linux.intel.com>
Signed-off-by: Hans Verkuil <hverkuil+cisco@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/media/v4l2-core/v4l2-common.c | 13 +++++++------
 1 file changed, 7 insertions(+), 6 deletions(-)

diff --git a/drivers/media/v4l2-core/v4l2-common.c b/drivers/media/v4l2-core/v4l2-common.c
index c1e3bcb4c1c40..524c11e92aec5 100644
--- a/drivers/media/v4l2-core/v4l2-common.c
+++ b/drivers/media/v4l2-core/v4l2-common.c
@@ -764,14 +764,15 @@ struct clk *__devm_v4l2_sensor_clk_get(struct device *dev, const char *id,
 	if (ret)
 		return ERR_PTR(ret == -EINVAL ? -EPROBE_DEFER : ret);
 
-	if (!id) {
+	if (id)
+		clk_id = kasprintf(GFP_KERNEL, "clk-%s-%s", dev_name(dev), id);
+	else
 		clk_id = kasprintf(GFP_KERNEL, "clk-%s", dev_name(dev));
-		if (!clk_id)
-			return ERR_PTR(-ENOMEM);
-		id = clk_id;
-	}
 
-	clk_hw = devm_clk_hw_register_fixed_rate(dev, id, NULL, 0, rate);
+	if (!clk_id)
+		return ERR_PTR(-ENOMEM);
+
+	clk_hw = devm_clk_hw_register_fixed_rate(dev, clk_id, NULL, 0, rate);
 	if (IS_ERR(clk_hw))
 		return ERR_CAST(clk_hw);
 
-- 
2.53.0



