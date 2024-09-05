Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1B6DA47796;
	Thu,  5 Sep 2024 09:45:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725529521; cv=none; b=GWSd9pjCvH3EIuWlcssqohN1IHoy3E/owENj6+oAGNX2mvljTve42jZCvjgATwum1TZI8z3/kqt9KmBZ6KvRuUR4hsI8BvlHvr6KG8VMLFjzJ9KlbpN5zYYD8MggzNUiqRhvu5pQxa/UpiXHKIBigS6eH3s7Ref20xK4N1GG8Ak=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725529521; c=relaxed/simple;
	bh=cygvxqd3Ylo6D4Hyg0Q6C/twN2928jWHVnd6OEZ8htM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=AbEIPw5gGLsCD0MjySjDW02bKMYGhXDkvUm8agJhcypuePXP16DquNFRNwUnMvxAXiz8++gJjU9hS1Q0fPS8H+lhclTSIWN9RCcyOlGmmfYkSDxN8b/GRFCFL4Hf89MRmu+GcWWxM0FbJBFYL92SlZy5c6YD1zkrTydaYx9NN+c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=cpnK818X; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="cpnK818X"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 06EFAC4CEC3;
	Thu,  5 Sep 2024 09:45:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1725529520;
	bh=cygvxqd3Ylo6D4Hyg0Q6C/twN2928jWHVnd6OEZ8htM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=cpnK818XzDSUYNmEeOWjqL54vGLQxb1jawmhoSUSLTc4te0NxGPmOj+Z4G3P6sXo2
	 ZiYBimGdeVhedWvLw32iymkLL6QyVJdiRSf06oCBVObxNPdV7YKrZvtzjfq1t7A8R5
	 Z4k0yZKAaw1nJifbND/6pw9h0bUsCKm2F+XwTRDM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Zhang Yi <zhangyi@everest-semi.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.10 028/184] ASoC: codecs: ES8326: button detect issue
Date: Thu,  5 Sep 2024 11:39:01 +0200
Message-ID: <20240905093733.345864490@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240905093732.239411633@linuxfoundation.org>
References: <20240905093732.239411633@linuxfoundation.org>
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

6.10-stable review patch.  If anyone has any objections, please let me know.

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
index 6a4e42e5e35b9..e620af9b864cb 100644
--- a/sound/soc/codecs/es8326.c
+++ b/sound/soc/codecs/es8326.c
@@ -825,6 +825,8 @@ static void es8326_jack_detect_handler(struct work_struct *work)
 		es8326_disable_micbias(es8326->component);
 		if (es8326->jack->status & SND_JACK_HEADPHONE) {
 			dev_dbg(comp->dev, "Report hp remove event\n");
+			snd_soc_jack_report(es8326->jack, 0,
+				    SND_JACK_BTN_0 | SND_JACK_BTN_1 | SND_JACK_BTN_2);
 			snd_soc_jack_report(es8326->jack, 0, SND_JACK_HEADSET);
 			/* mute adc when mic path switch */
 			regmap_write(es8326->regmap, ES8326_ADC1_SRC, 0x44);
-- 
2.43.0



