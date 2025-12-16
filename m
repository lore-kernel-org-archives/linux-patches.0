Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E4FD43563C8;
	Tue, 16 Dec 2025 12:02:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765886532; cv=none; b=UfdxSAbMyDRjFKiMD3c2Yy4O35KmT9uk+h60rGeygIQ1f0e8o60V6/Ex08dCOWB4RcaLafUMxIy8TxNxcKR+Li21mHLOiUWi22xVuJz4nb7pjrFqXBJ/qFvTJyEJJChi/ocVvpJBYLq84cDAt8+VusWqOB+l4uZtZTrQezivNTQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765886532; c=relaxed/simple;
	bh=Xzwx1xRbielLx4xU/2EbU9G+0Jw6z0rOp27b+VxeaAI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=kD90IWvH1ZaIEymLXhPeEuQKeumofVf1af+j+4F88wUd34d0Q8icEHtVw2m4706OJkhRsUw4G6xGGpSoXgwDVJbylywIYWsTJvO3N3JBI6PUh0YWpMBKClaLwNYqjZJqP7P2pI2liPwFtvGxOstGuopioWkn43UpgU+0CowHw3A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=BwL6vmHX; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="BwL6vmHX"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2D529C4CEF1;
	Tue, 16 Dec 2025 12:02:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1765886531;
	bh=Xzwx1xRbielLx4xU/2EbU9G+0Jw6z0rOp27b+VxeaAI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=BwL6vmHXUVul/8msLrQxZS7yPTiJxQPnsY7XqdkK1zqRmjIVYMK2Tsc1C+jCvng4F
	 gaarHdp90bBORP9ZWaCAnWu/FMIl5TyYy+WvB5cvT9sPbUMU1EY/Vcu0Qgji7si6fd
	 NQ36J5ZR6OR/Wu/LNA3uyjCSmYKM98HHeCZpnyAI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Shengjiu Wang <shengjiu.wang@nxp.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.17 457/507] ASoC: ak4458: Disable regulator when error happens
Date: Tue, 16 Dec 2025 12:14:58 +0100
Message-ID: <20251216111402.005467493@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251216111345.522190956@linuxfoundation.org>
References: <20251216111345.522190956@linuxfoundation.org>
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

6.17-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Shengjiu Wang <shengjiu.wang@nxp.com>

[ Upstream commit ae585fabb9713a43e358cf606451386757225c95 ]

Disable regulator in runtime resume when error happens to balance
the reference count of regulator.

Fixes: 7e3096e8f823 ("ASoC: ak4458: Add regulator support")
Signed-off-by: Shengjiu Wang <shengjiu.wang@nxp.com>
Link: https://patch.msgid.link/20251203100529.3841203-2-shengjiu.wang@nxp.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/codecs/ak4458.c | 10 +++++++++-
 1 file changed, 9 insertions(+), 1 deletion(-)

diff --git a/sound/soc/codecs/ak4458.c b/sound/soc/codecs/ak4458.c
index 57cf601d3df35..a6c04dd3de3ed 100644
--- a/sound/soc/codecs/ak4458.c
+++ b/sound/soc/codecs/ak4458.c
@@ -671,7 +671,15 @@ static int ak4458_runtime_resume(struct device *dev)
 	regcache_cache_only(ak4458->regmap, false);
 	regcache_mark_dirty(ak4458->regmap);
 
-	return regcache_sync(ak4458->regmap);
+	ret = regcache_sync(ak4458->regmap);
+	if (ret)
+		goto err;
+
+	return 0;
+err:
+	regcache_cache_only(ak4458->regmap, true);
+	regulator_bulk_disable(ARRAY_SIZE(ak4458->supplies), ak4458->supplies);
+	return ret;
 }
 
 static const struct snd_soc_component_driver soc_codec_dev_ak4458 = {
-- 
2.51.0



