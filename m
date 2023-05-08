Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6FC59168CB
	for <patches@lists.linux.dev>; Mon,  8 May 2023 11:19:45 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2CDA7C433EF;
	Mon,  8 May 2023 11:19:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1683544785;
	bh=tjLUeJE1CJIYDg4itPBro/bY2qaiygOfo1H3q0rTcYw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=tkEFKwZ1DUB3RlVKqLhPZ6+j2mqdyAmAC2AslXFHOmj3s2d3nZw/gcUrgDoasm7oy
	 tBfUZq/N4JMbUGlxsIf+BgCjACvIJSGLqzznt2VyaJ7MO+beXPesExSrGsS/ShtL/L
	 MMmyyrfTHsZhBbYhVQAyuJZ/1nu+pl9b2Jj2NmB8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	kernel test robot <lkp@intel.com>,
	Julia Lawall <julia.lawall@inria.fr>,
	Aashish Sharma <shraash@google.com>,
	Guenter Roeck <groeck@chromium.org>,
	Trevor Wu <trevor.wu@mediatek.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.3 523/694] ASoC: mediatek: common: Fix refcount leak in parse_dai_link_info
Date: Mon,  8 May 2023 11:45:58 +0200
Message-Id: <20230508094451.256161045@linuxfoundation.org>
X-Mailer: git-send-email 2.40.1
In-Reply-To: <20230508094432.603705160@linuxfoundation.org>
References: <20230508094432.603705160@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Aashish Sharma <shraash@google.com>

[ Upstream commit beed115c2ce78f990222a29abed042582df4e87c ]

Add missing of_node_put()s before the returns to balance
of_node_get()s and of_node_put()s, which may get unbalanced
in case the for loop 'for_each_available_child_of_node' returns
early.

Fixes: 4302187d955f ("ASoC: mediatek: common: add soundcard driver common code")
Reported-by: kernel test robot <lkp@intel.com>
Reported-by: Julia Lawall <julia.lawall@inria.fr>
Link: https://lore.kernel.org/r/202304090504.2K8L6soj-lkp@intel.com/
Signed-off-by: Aashish Sharma <shraash@google.com>
Reviewed-by: Guenter Roeck <groeck@chromium.org>
Reviewed-by: Trevor Wu <trevor.wu@mediatek.com>
Link: https://lore.kernel.org/r/20230411003431.4048700-1-shraash@google.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/mediatek/common/mtk-soundcard-driver.c | 12 +++++++++---
 1 file changed, 9 insertions(+), 3 deletions(-)

diff --git a/sound/soc/mediatek/common/mtk-soundcard-driver.c b/sound/soc/mediatek/common/mtk-soundcard-driver.c
index 7c55c2cb1f214..738093451ccbf 100644
--- a/sound/soc/mediatek/common/mtk-soundcard-driver.c
+++ b/sound/soc/mediatek/common/mtk-soundcard-driver.c
@@ -47,20 +47,26 @@ int parse_dai_link_info(struct snd_soc_card *card)
 	/* Loop over all the dai link sub nodes */
 	for_each_available_child_of_node(dev->of_node, sub_node) {
 		if (of_property_read_string(sub_node, "link-name",
-					    &dai_link_name))
+					    &dai_link_name)) {
+			of_node_put(sub_node);
 			return -EINVAL;
+		}
 
 		for_each_card_prelinks(card, i, dai_link) {
 			if (!strcmp(dai_link_name, dai_link->name))
 				break;
 		}
 
-		if (i >= card->num_links)
+		if (i >= card->num_links) {
+			of_node_put(sub_node);
 			return -EINVAL;
+		}
 
 		ret = set_card_codec_info(card, sub_node, dai_link);
-		if (ret < 0)
+		if (ret < 0) {
+			of_node_put(sub_node);
 			return ret;
+		}
 	}
 
 	return 0;
-- 
2.39.2



