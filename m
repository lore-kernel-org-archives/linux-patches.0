Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A2DE22585
	for <patches@lists.linux.dev>; Mon, 12 Dec 2022 13:12:09 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 95545C433D2;
	Mon, 12 Dec 2022 13:12:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1670850729;
	bh=DPPczfweauoHm+8fcnAinxuupRv+3HXZOb4CpCady1A=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=W3guBnAb8Hc6lrsmun7uQNeeROeY3XXb8nn6dJcW+AQ2iuoVMbo2wN+/ajX6+Hp59
	 yLkT7DeAgE1L4T9IyH+WE49KyInzkePOYD9cLfug5zxRW0EkdML/32KiAbqik9iwVS
	 WvFdsFZLj2LkSNnxDiRRXfuwX1bOe2xzuBNk9Oj8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Chancel Liu <chancel.liu@nxp.com>,
	Charles Keepax <ckeepax@opensource.cirrus.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 015/106] ASoC: wm8962: Wait for updated value of WM8962_CLOCKING1 register
Date: Mon, 12 Dec 2022 14:09:18 +0100
Message-Id: <20221212130925.537229703@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221212130924.863767275@linuxfoundation.org>
References: <20221212130924.863767275@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Chancel Liu <chancel.liu@nxp.com>

[ Upstream commit 3ca507bf99611c82dafced73e921c1b10ee12869 ]

DSPCLK_DIV field in WM8962_CLOCKING1 register is used to generate
correct frequency of LRCLK and BCLK. Sometimes the read-only value
can't be updated timely after enabling SYSCLK. This results in wrong
calculation values. Delay is introduced here to wait for newest value
from register. The time of the delay should be at least 500~1000us
according to test.

Signed-off-by: Chancel Liu <chancel.liu@nxp.com>
Acked-by: Charles Keepax <ckeepax@opensource.cirrus.com>
Link: https://lore.kernel.org/r/20221109121354.123958-1-chancel.liu@nxp.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/codecs/wm8962.c | 8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/sound/soc/codecs/wm8962.c b/sound/soc/codecs/wm8962.c
index 21574447650c..57aeded978c2 100644
--- a/sound/soc/codecs/wm8962.c
+++ b/sound/soc/codecs/wm8962.c
@@ -2489,6 +2489,14 @@ static void wm8962_configure_bclk(struct snd_soc_component *component)
 		snd_soc_component_update_bits(component, WM8962_CLOCKING2,
 				WM8962_SYSCLK_ENA_MASK, WM8962_SYSCLK_ENA);
 
+	/* DSPCLK_DIV field in WM8962_CLOCKING1 register is used to generate
+	 * correct frequency of LRCLK and BCLK. Sometimes the read-only value
+	 * can't be updated timely after enabling SYSCLK. This results in wrong
+	 * calculation values. Delay is introduced here to wait for newest
+	 * value from register. The time of the delay should be at least
+	 * 500~1000us according to test.
+	 */
+	usleep_range(500, 1000);
 	dspclk = snd_soc_component_read(component, WM8962_CLOCKING1);
 
 	if (snd_soc_component_get_bias_level(component) != SND_SOC_BIAS_ON)
-- 
2.35.1



