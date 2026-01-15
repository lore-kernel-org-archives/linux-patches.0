Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 59B3E3BFE29;
	Thu, 15 Jan 2026 17:46:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768499175; cv=none; b=EeFTvi4jIiTeVx7auh9/m7EZR6RglBoqFGE8yINv9RhZww83Suy16n6JbWX8+AgiJ047IltiZpFYoZKq/YExCbLoYHhmFplYUCo4TbHnO82NzA9DftWXgWBDRf0o23tI2YMEgo5a6lq3FQ0ZvkLVDuLjkx+l8ZfKGTHnU0erpRE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768499175; c=relaxed/simple;
	bh=A0d45ukhUGFRENsVTGpxXBC+mYhb3OU2YcXI4ZCsSQc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=TKZoKetuLVwiuwTR994uuq6iL/BAsLn43VqbHpZKRedSMS6HHTtlt9lw/Jra53rg8iyw4jegzhUZ7G74iNktkfQjOKyv21eBm28We2EeS4urxzoJKgJVdA/opHzbnlbnRTdiviL/LYsf4O1ibPqwQxdvB0kea9jeBdlz6sklDyo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=YQhs7bYZ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="YQhs7bYZ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DA2A3C116D0;
	Thu, 15 Jan 2026 17:46:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1768499175;
	bh=A0d45ukhUGFRENsVTGpxXBC+mYhb3OU2YcXI4ZCsSQc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=YQhs7bYZgC00h0Cw7kdEaJU16axKLE2MVqcrSjEcItHeRI7EEXDT42RRxZ5u3MCyg
	 c+1rAVGkUDS0yO6koQTe+Iow8Mi3Oqg600FZZYG+c8F7gzvcuAGud4nMsJOLtCBtRs
	 3UKu7CnqiIyJbuyvlvZj75FGJsYWFghHJI5ncwZ0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Shengjiu Wang <shengjiu.wang@nxp.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 135/451] ASoC: ak4458: Disable regulator when error happens
Date: Thu, 15 Jan 2026 17:45:36 +0100
Message-ID: <20260115164235.804425254@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260115164230.864985076@linuxfoundation.org>
References: <20260115164230.864985076@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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
index 85a1d00894a9c..af4873c97d3aa 100644
--- a/sound/soc/codecs/ak4458.c
+++ b/sound/soc/codecs/ak4458.c
@@ -683,7 +683,15 @@ static int __maybe_unused ak4458_runtime_resume(struct device *dev)
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
 #endif /* CONFIG_PM */
 
-- 
2.51.0



