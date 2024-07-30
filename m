Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3FF0518455E;
	Tue, 30 Jul 2024 16:25:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722356729; cv=none; b=U8ZosYB5JfnYWDpq6azPyqEsr40flBp4/OgqK5krhA9eUq8ri5YnKoGLvrVDUPK74L7lUmzVoOWCgyFd+54esJl3zXxwWRF2xe6hrQwsq2nEdjAb3yiG8SjkZ6plW+/7QKbXQxQaE5TFOTavljlrXsN5VxgFEHynqhICd+FqIKM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722356729; c=relaxed/simple;
	bh=TqppeM0BmbjDuNoAbzQHYn5+nmu0I90aj4DqTHBb1Qs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=jZY3emY1YR//dhlPv/Bs5LWzZuPtkWAFOx2p+UhNvoxVPIXx9jJC/MLIGQ1wF/OWUROYSnJxDdTbAowrx49Rq+QxAQ6blvfk8ikdp8KGo9Dl21ZSnWvpBosznh2j+3aPAgVyJEr4hqt/XKSqoupkkXAPHvZuspDCZ6ynWBHhJQU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=c803+fG8; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="c803+fG8"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9C155C32782;
	Tue, 30 Jul 2024 16:25:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1722356729;
	bh=TqppeM0BmbjDuNoAbzQHYn5+nmu0I90aj4DqTHBb1Qs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=c803+fG8BS0hsLL6ZS7sUU4O/cA53ibtRIeIxNNDxiyFYuFk2bYTlOwgxqHZnSkOn
	 JOIjK16GBrGPz601U2GB6E5B5ZvOjCtNxpPe2eiCqJdIfPodvd3+u86NNv6tXPnTYj
	 5wk94OgztofU9MAdT/DCi+cjmr/iqldgSdmjBq/M=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Chen Ni <nichen@iscas.ac.cn>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 204/440] ASoC: max98088: Check for clk_prepare_enable() error
Date: Tue, 30 Jul 2024 17:47:17 +0200
Message-ID: <20240730151623.837680443@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240730151615.753688326@linuxfoundation.org>
References: <20240730151615.753688326@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Chen Ni <nichen@iscas.ac.cn>

[ Upstream commit 1a70579723fde3624a72dfea6e79e55be6e36659 ]

clk_prepare_enable() may fail, so we should better check its return
value and propagate it in the case of error.

Fixes: 62a7fc32a628 ("ASoC: max98088: Add master clock handling")
Signed-off-by: Chen Ni <nichen@iscas.ac.cn>
Link: https://patch.msgid.link/20240628080534.843815-1-nichen@iscas.ac.cn
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/codecs/max98088.c | 10 +++++++---
 1 file changed, 7 insertions(+), 3 deletions(-)

diff --git a/sound/soc/codecs/max98088.c b/sound/soc/codecs/max98088.c
index 405ec16be2b6a..eaabfe2cfd70d 100644
--- a/sound/soc/codecs/max98088.c
+++ b/sound/soc/codecs/max98088.c
@@ -1318,6 +1318,7 @@ static int max98088_set_bias_level(struct snd_soc_component *component,
                                   enum snd_soc_bias_level level)
 {
 	struct max98088_priv *max98088 = snd_soc_component_get_drvdata(component);
+	int ret;
 
 	switch (level) {
 	case SND_SOC_BIAS_ON:
@@ -1333,10 +1334,13 @@ static int max98088_set_bias_level(struct snd_soc_component *component,
 		 */
 		if (!IS_ERR(max98088->mclk)) {
 			if (snd_soc_component_get_bias_level(component) ==
-			    SND_SOC_BIAS_ON)
+			    SND_SOC_BIAS_ON) {
 				clk_disable_unprepare(max98088->mclk);
-			else
-				clk_prepare_enable(max98088->mclk);
+			} else {
+				ret = clk_prepare_enable(max98088->mclk);
+				if (ret)
+					return ret;
+			}
 		}
 		break;
 
-- 
2.43.0



