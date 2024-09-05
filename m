Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0C8A318732F;
	Thu,  5 Sep 2024 09:53:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725529994; cv=none; b=eqzHcuH3OlUuKIuyzpsnL+oXMgNDpBkZefA6BUZNSGiJs8pQQjUyUf8Ej3WLwqqKxb8jaKVj+YoapQPqttfNZ8GsaHytC5pTqulMMOWodd0eBJL4rQZ+JDZ/Bc8pvK8FeSmL6EOWMNbJfO1Qghc7y4sqFDUJcj+GMKL7shQSjNU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725529994; c=relaxed/simple;
	bh=oJnd94uyNeeQ6+ww0yNg1pzEJhOVsh7In5ZPqLJNcN8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=P+FdqbFtOj4YLLs51jW92HpdsZ/haruB1reqL5zvwfPBPlfVrWFh5nCmIeSu/HPdsSS/nJbQFMW+Iriea8wMnAgAIowrRnNr/noxxDrZ2H5Co2Y67WCI/psbGnsgentDY2qFXGu7z+EPnkh166A1ge1z7mk9pRjlU704dVSmNG0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=XhROg3hx; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="XhROg3hx"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 45726C4CEC3;
	Thu,  5 Sep 2024 09:53:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1725529993;
	bh=oJnd94uyNeeQ6+ww0yNg1pzEJhOVsh7In5ZPqLJNcN8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=XhROg3hxPBQ3/rzagMrtUzGhOZInOkd8NoTmRBJ5YpwSUmfoGv8RQjvVTWz3eQ6ZF
	 vYO0uAKRRHqoen3An1wk5rqS1e2wprVe9RkVHtSciNBMcnSL7j2phj7+QnLms8tfRd
	 Gba+w8eRXRtAQm//luQCeEqJ1ELHy3uao7EuZuGE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Zhang Yi <zhangyi@everest-semi.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 021/132] ASoC: codecs: ES8326: button detect issue
Date: Thu,  5 Sep 2024 11:40:08 +0200
Message-ID: <20240905093723.062060642@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240905093722.230767298@linuxfoundation.org>
References: <20240905093722.230767298@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Zhang Yi <zhangyi@everest-semi.com>

[ Upstream commit 4684a2df9c5b3fc914377127faf2515aa9049093 ]

We find that we need to set snd_jack_types to 0. If not,
there will be a probability of button detection errors

Signed-off-by: Zhang Yi <zhangyi@everest-semi.com>
Link: https://patch.msgid.link/20240807025356.24904-2-zhangyi@everest-semi.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/codecs/es8326.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/sound/soc/codecs/es8326.c b/sound/soc/codecs/es8326.c
index 6c263086c44d2..32a9b26ee2c89 100644
--- a/sound/soc/codecs/es8326.c
+++ b/sound/soc/codecs/es8326.c
@@ -617,6 +617,8 @@ static void es8326_jack_detect_handler(struct work_struct *work)
 		es8326_disable_micbias(es8326->component);
 		if (es8326->jack->status & SND_JACK_HEADPHONE) {
 			dev_dbg(comp->dev, "Report hp remove event\n");
+			snd_soc_jack_report(es8326->jack, 0,
+				    SND_JACK_BTN_0 | SND_JACK_BTN_1 | SND_JACK_BTN_2);
 			snd_soc_jack_report(es8326->jack, 0, SND_JACK_HEADSET);
 			/* mute adc when mic path switch */
 			regmap_write(es8326->regmap, ES8326_ADC_SCALE, 0x33);
-- 
2.43.0



