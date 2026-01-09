Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3FDB335BDAF;
	Fri,  9 Jan 2026 12:33:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767961981; cv=none; b=JpSIjr60+rs4Cnhm+qCaF+t1ifP7c4FCHVTBsmoC6USvMpV/mF1jLWPPLjPSdkP9nmbywiiviipOwkfW9p8QF7rHWSRE8q/7GpZxDXyAKEruc7ec4EF4GKFbJSQCiU332E57V0XVhW/sJwm1Iq+1WOKJbgIhQ8cxrQAg1kpVxRs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767961981; c=relaxed/simple;
	bh=CWeHfkR833jG6WYv23we0G9DdIUzXxtG2NoDJ5Oo/b4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=l+D7ch4drWahLiWNc8Jh4kye1IfQa/E6fn+OOfbcD8A5qj3s0Q87VUGruMiS5Dr8NYR+vpAl1lDE812QOlZqRRVu4w0TuCFSKw8uz3hct0ih2HEZVJowdYwuF5zZIp+zIp1JTOeOWe7VbtAeMiTv1rAwJS2rqD2qB5fZX63/4cg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=a5mwGSxx; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="a5mwGSxx"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BD6D2C16AAE;
	Fri,  9 Jan 2026 12:33:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1767961981;
	bh=CWeHfkR833jG6WYv23we0G9DdIUzXxtG2NoDJ5Oo/b4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=a5mwGSxx63sLPRwBo95AvbOSTW1MYEZ4/0DwcZt2fqEO1xVxoMLYt489oSa7vSxqj
	 VCH/s34rs1Q2JLWEtroaUjc79Fec+6JmBBZWQcbzcciYuHhpaKz83XmWgN4HXmymA6
	 QZjCBqslhDfmkm8snHvxT1QbHEx1o7UmUXbNvKYM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Shengjiu Wang <shengjiu.wang@nxp.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 203/634] ASoC: ak5558: Disable regulator when error happens
Date: Fri,  9 Jan 2026 12:38:01 +0100
Message-ID: <20260109112125.078868550@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260109112117.407257400@linuxfoundation.org>
References: <20260109112117.407257400@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Shengjiu Wang <shengjiu.wang@nxp.com>

[ Upstream commit 1f8f726a2a29c28f65b30880335a1610c5e63594 ]

Disable regulator in runtime resume when error happens to balance
the reference count of regulator.

Fixes: 2ff6d5a108c6 ("ASoC: ak5558: Add regulator support")
Signed-off-by: Shengjiu Wang <shengjiu.wang@nxp.com>
Link: https://patch.msgid.link/20251203100529.3841203-3-shengjiu.wang@nxp.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/codecs/ak5558.c | 10 +++++++++-
 1 file changed, 9 insertions(+), 1 deletion(-)

diff --git a/sound/soc/codecs/ak5558.c b/sound/soc/codecs/ak5558.c
index 60abcffe6a0ce..1b6515fba91e0 100644
--- a/sound/soc/codecs/ak5558.c
+++ b/sound/soc/codecs/ak5558.c
@@ -372,7 +372,15 @@ static int __maybe_unused ak5558_runtime_resume(struct device *dev)
 	regcache_cache_only(ak5558->regmap, false);
 	regcache_mark_dirty(ak5558->regmap);
 
-	return regcache_sync(ak5558->regmap);
+	ret = regcache_sync(ak5558->regmap);
+	if (ret)
+		goto err;
+
+	return 0;
+err:
+	regcache_cache_only(ak5558->regmap, true);
+	regulator_bulk_disable(ARRAY_SIZE(ak5558->supplies), ak5558->supplies);
+	return ret;
 }
 
 static const struct dev_pm_ops ak5558_pm = {
-- 
2.51.0



