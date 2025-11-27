Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4B61D32AAC4;
	Thu, 27 Nov 2025 15:05:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764255955; cv=none; b=bGf5WvY3nLiwLj1AQfyzIOn62uJqjaslB7A+Ht2Wqp8+aJSTTLnZDpVgqTqE8V98SQBiFXKXwa1cxQUQ/tX9Q25CaBLqbjZQ2VIc94INQCidN+qiASEO25epnGnSFPPChjiN3WAf/sbEClXx1TM/Mi/xRMsP1fmhZjWKA1l2zNQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764255955; c=relaxed/simple;
	bh=SG2gcscdZlMa7K4swXKzSqKnCuZOckmnLmf+j71fdmg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Jcr9GjKGWo6rV38ccOlupn27KVk9EUymmvonVdlAb9Vux0ol7FScE/GfhyUabWFYjxnh30J1arJvqkpbTOTMJFzGWD/9hIOPTW6AQXf5/uu4q1IQRm3sUob02ldfrdFqbBZH0A+Upse62vddDmjOv+pDX4AYsXVz5W/qaI/jx7Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=mxQRvvJ0; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="mxQRvvJ0"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6EF17C4CEF8;
	Thu, 27 Nov 2025 15:05:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1764255954;
	bh=SG2gcscdZlMa7K4swXKzSqKnCuZOckmnLmf+j71fdmg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=mxQRvvJ0gCSXH51hOB6Y2h+h1LaepqWpCSJ/x6paV6uJlS35YzrKusiZZ6wL21xtj
	 mcx8zjJgz89FUcd71fVK7U+CPQ5kYZKSrT+8NaDjiwjFjePyeZbGKKSP2ePJ9ibHrr
	 nqCRDDaXZbCQr2g7VXkM0gNO5cKlVKQO2VuxJfcM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Shuming Fan <shumingf@realtek.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.17 139/175] ASoC: rt721: fix prepare clock stop failed
Date: Thu, 27 Nov 2025 15:46:32 +0100
Message-ID: <20251127144048.035034751@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251127144042.945669935@linuxfoundation.org>
References: <20251127144042.945669935@linuxfoundation.org>
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

From: Shuming Fan <shumingf@realtek.com>

[ Upstream commit d914ec6f07548f7c13a231a4f526e043e736e82e ]

This patch adds settings to prevent the 'prepare clock stop failed' error.

Signed-off-by: Shuming Fan <shumingf@realtek.com>
Link: https://patch.msgid.link/20251027103333.38353-1-shumingf@realtek.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/codecs/rt721-sdca.c | 4 ++++
 sound/soc/codecs/rt721-sdca.h | 1 +
 2 files changed, 5 insertions(+)

diff --git a/sound/soc/codecs/rt721-sdca.c b/sound/soc/codecs/rt721-sdca.c
index a4bd29d7220b8..5f7b505d54147 100644
--- a/sound/soc/codecs/rt721-sdca.c
+++ b/sound/soc/codecs/rt721-sdca.c
@@ -281,6 +281,10 @@ static void rt721_sdca_jack_preset(struct rt721_sdca_priv *rt721)
 	rt_sdca_index_write(rt721->mbq_regmap, RT721_BOOST_CTRL,
 		RT721_BST_4CH_TOP_GATING_CTRL1, 0x002a);
 	regmap_write(rt721->regmap, 0x2f58, 0x07);
+
+	regmap_write(rt721->regmap, 0x2f51, 0x00);
+	rt_sdca_index_write(rt721->mbq_regmap, RT721_HDA_SDCA_FLOAT,
+		RT721_MISC_CTL, 0x0004);
 }
 
 static void rt721_sdca_jack_init(struct rt721_sdca_priv *rt721)
diff --git a/sound/soc/codecs/rt721-sdca.h b/sound/soc/codecs/rt721-sdca.h
index 71fac9cd87394..24ce188562baf 100644
--- a/sound/soc/codecs/rt721-sdca.h
+++ b/sound/soc/codecs/rt721-sdca.h
@@ -137,6 +137,7 @@ struct rt721_sdca_dmic_kctrl_priv {
 #define RT721_HDA_LEGACY_UAJ_CTL		0x02
 #define RT721_HDA_LEGACY_CTL1			0x05
 #define RT721_HDA_LEGACY_RESET_CTL		0x06
+#define RT721_MISC_CTL				0x07
 #define RT721_XU_REL_CTRL			0x0c
 #define RT721_GE_REL_CTRL1			0x0d
 #define RT721_HDA_LEGACY_GPIO_WAKE_EN_CTL	0x0e
-- 
2.51.0



