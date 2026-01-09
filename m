Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6D5943191D2;
	Fri,  9 Jan 2026 12:32:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767961978; cv=none; b=RStZcdhSN/Xte4npgt3MxjfYK718eyearbfUfk9laPCPVTqDOtrNXgSdyxfgaB4STJViYYMVmcsA4Jp/t3u5jQd3lowPb6CmAH8yIlo/jLJdhFRsF3yIKhK2SL8tVLjPmsjirbUC1Pr/CrP2tbeX7B7BJmAnJO1YeUJ223mn1V0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767961978; c=relaxed/simple;
	bh=u867Rx7IrJXlNs5pJePJs0eXSmMyZYoMvK11wy61pBQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=BE9CYEBl/cTb0mIoJzdN+rYuZOaHzsy2p/dZ6FCf1XDMUn+SFDtHJdR2QB94/wjcdn7RXhd9/k+pXNXa3/czLDcfj7rmHYIrvDuyNE0k8ZcONF69HpT20Qatk8ZhmDfYR0AFKVDYlC+3Y34iVAsqjejhpHbYZVVzjdPhR4Czq8Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=mihiGZ1K; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="mihiGZ1K"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id ED765C4CEF1;
	Fri,  9 Jan 2026 12:32:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1767961978;
	bh=u867Rx7IrJXlNs5pJePJs0eXSmMyZYoMvK11wy61pBQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=mihiGZ1KtRSAxuLHtompBZLQSJbN34QOCuLC7duy/tEbn0aTUYCzEEqBR6i1FFzxn
	 afn9d3UNGQ99YR+FiMAqZD2YFrlOfRI+1hmjsWslZRGWr3xlHdjrQo8EgK0wiHlNBB
	 aB0yPmIGA3qWbyas3VGkAd8UeQxDRQKLl0Xtdd/w=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Shengjiu Wang <shengjiu.wang@nxp.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 202/634] ASoC: ak4458: Disable regulator when error happens
Date: Fri,  9 Jan 2026 12:38:00 +0100
Message-ID: <20260109112125.033736041@linuxfoundation.org>
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
index 1db73552c7466..fd7f2cc0abdc9 100644
--- a/sound/soc/codecs/ak4458.c
+++ b/sound/soc/codecs/ak4458.c
@@ -674,7 +674,15 @@ static int __maybe_unused ak4458_runtime_resume(struct device *dev)
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



