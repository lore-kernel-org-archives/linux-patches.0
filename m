Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 42194342509;
	Tue, 16 Dec 2025 11:36:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765884962; cv=none; b=BIUSvXgH4HSKvy6uhOPx1VAnqIS5rw8iTfy0mT2f1aPVdvBKqQffeIAPQmmrln9Zx2qrz4O9pBWIm/1hQ3JbzFz3baytic6B3JUjhpXZYuv1iym1PvdJ+u09iUyRYAUVOPt7po5JB4xHZP2oU+ykRGMvkhYlQtoAAswvHBeG+fY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765884962; c=relaxed/simple;
	bh=ev+ligHSc4hHStIeM4MtEfLHhbZBAu2QjCybWzoWlEU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=B4cL+u3GTbVz6/YLIdnv1zee/sjZq5fZws6lhAChCvLYqQ+xEn6Hcwl0Rb1p8lT0o5NDM3iPJIN5C45rzJoEueiHrP7XR3esRfQTMfERs1DYfkGDhdHasjjk5ZkHBE120x853y7tzJGN69TB6mHsoPXO76XtLM55AbCc7n/wn+c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=QCpEK7qL; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="QCpEK7qL"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B6584C4CEF1;
	Tue, 16 Dec 2025 11:36:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1765884962;
	bh=ev+ligHSc4hHStIeM4MtEfLHhbZBAu2QjCybWzoWlEU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=QCpEK7qLB+gMsh57lV1KNBeaxEZThA7C/3yreg7VScpR+ysZumhryCkXGIjjE9U9I
	 GTtS4gZs86JNL3T6zpDyU7TboHVXtSf7BuPluGtiDuFWTS+ly8hTalpM2RhLVdogAN
	 JbOmXdHY/UpiMpPI7IJ8PrN4E3eanA6WBqcOffrc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Shengjiu Wang <shengjiu.wang@nxp.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 318/354] ASoC: ak4458: Disable regulator when error happens
Date: Tue, 16 Dec 2025 12:14:45 +0100
Message-ID: <20251216111332.430698157@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251216111320.896758933@linuxfoundation.org>
References: <20251216111320.896758933@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
index d472d99526287..fb1ab335a4c18 100644
--- a/sound/soc/codecs/ak4458.c
+++ b/sound/soc/codecs/ak4458.c
@@ -676,7 +676,15 @@ static int __maybe_unused ak4458_runtime_resume(struct device *dev)
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



