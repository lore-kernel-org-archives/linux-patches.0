Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DF19C1E0480;
	Wed,  6 Nov 2024 12:40:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730896860; cv=none; b=QP7NBlVm1VWbVF2rqRuu2YQ32fkKCT88N4cfpXXQLFaw0dTkNdpDMV3qX3HJeoKJVF6647sdrqKgN2eFcrlRHbMJVhsCUVwJmTLkkfupYXTQjmw720tYMV/73o0kRGVW/s/pt6hkIdpYYAslm/4TpaaK2nMDVc2Qw7SqWknRecM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730896860; c=relaxed/simple;
	bh=iPhQwMJTxNXtgpb8sL7e1ewRZia2BP+TjAN3VetyUEc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Fo77QSPuMfYFnqA2MwEpdYla/WXMGETsJNhVvfAqUe8mjYPnp07tywqw3Yy52SVGE+ichUL8rCFTcCQLOStDsjuPbvhRx1f7n5PuxUywhNj8dVjvA7Y4KAgj0jk4KxsS+zwn6SwDAzC06hXrSRWV5GaoA547r0YUpEVDOjvmwlE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=jLaNjMLI; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="jLaNjMLI"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 579CCC4CED3;
	Wed,  6 Nov 2024 12:40:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1730896859;
	bh=iPhQwMJTxNXtgpb8sL7e1ewRZia2BP+TjAN3VetyUEc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=jLaNjMLILx88ynVYVR9Bb1nI8F/4uVSOsg/g82AjV/i+kzsNrNE9lHqfmqe2hI45f
	 mEM6e/ArY5HQVzU1znh0LglwdrwewNdTEmR9ACIJi7A2Xv0+LJc8lKbQKG/VURxZ1Z
	 8z1psXZMf5Pn3J9oD7b35SX4wm5e2Pk0jYjhkifs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Christophe JAILLET <christophe.jaillet@wanadoo.fr>,
	Charles Keepax <ckeepax@opensource.cirrus.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 069/110] ASoC: cs42l51: Fix some error handling paths in cs42l51_probe()
Date: Wed,  6 Nov 2024 13:04:35 +0100
Message-ID: <20241106120305.093928123@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241106120303.135636370@linuxfoundation.org>
References: <20241106120303.135636370@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Christophe JAILLET <christophe.jaillet@wanadoo.fr>

[ Upstream commit d221b844ee79823ffc29b7badc4010bdb0960224 ]

If devm_gpiod_get_optional() fails, we need to disable previously enabled
regulators, as done in the other error handling path of the function.

Also, gpiod_set_value_cansleep(, 1) needs to be called to undo a
potential gpiod_set_value_cansleep(, 0).
If the "reset" gpio is not defined, this additional call is just a no-op.

This behavior is the same as the one already in the .remove() function.

Fixes: 11b9cd748e31 ("ASoC: cs42l51: add reset management")
Signed-off-by: Christophe JAILLET <christophe.jaillet@wanadoo.fr>
Reviewed-by: Charles Keepax <ckeepax@opensource.cirrus.com>
Link: https://patch.msgid.link/a5e5f4b9fb03f46abd2c93ed94b5c395972ce0d1.1729975570.git.christophe.jaillet@wanadoo.fr
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/codecs/cs42l51.c | 7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)

diff --git a/sound/soc/codecs/cs42l51.c b/sound/soc/codecs/cs42l51.c
index 4b026e1c3fe3e..09445db29aa1f 100644
--- a/sound/soc/codecs/cs42l51.c
+++ b/sound/soc/codecs/cs42l51.c
@@ -754,8 +754,10 @@ int cs42l51_probe(struct device *dev, struct regmap *regmap)
 
 	cs42l51->reset_gpio = devm_gpiod_get_optional(dev, "reset",
 						      GPIOD_OUT_LOW);
-	if (IS_ERR(cs42l51->reset_gpio))
-		return PTR_ERR(cs42l51->reset_gpio);
+	if (IS_ERR(cs42l51->reset_gpio)) {
+		ret = PTR_ERR(cs42l51->reset_gpio);
+		goto error;
+	}
 
 	if (cs42l51->reset_gpio) {
 		dev_dbg(dev, "Release reset gpio\n");
@@ -787,6 +789,7 @@ int cs42l51_probe(struct device *dev, struct regmap *regmap)
 	return 0;
 
 error:
+	gpiod_set_value_cansleep(cs42l51->reset_gpio, 1);
 	regulator_bulk_disable(ARRAY_SIZE(cs42l51->supplies),
 			       cs42l51->supplies);
 	return ret;
-- 
2.43.0



