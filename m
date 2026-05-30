Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 61CD83016E1;
	Sat, 30 May 2026 17:13:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780161190; cv=none; b=YsEdBNB0PcJDYLr49Ii4UV7d8Qa3tDNLrCJwLkctfKWwrG+kMgl9z1n5SkzDbJkdYG3GoCEcQoY6K7rDShFgVcXiXBUQA+GLFCREn9wESDfVWOhyqh0TOKxRaNK8eMXJuOeWO+xqpdFPVOzPu+8sJtEJ82mHB776/hQvvogGkfk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780161190; c=relaxed/simple;
	bh=OpXY245IjJzuWHfkHapUEtwJtvQWgPYE5T7iA6KV/Lo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=RApXxc0TJ4eZ2yLV89bcMlnAbzM09BKPIDTcemvlWp9dDChTX2kH9eUS2+guA8xN3oClb/EW3uedGwphFX9Rxkx3ZAsno0ICVpYcAE6SH7dziCNo8eedoZ8D21YHytkZf7jAYSBfZQSjs4Az43yfxwlSPrRmlFSWcAVMI3zgeoU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=n52+Ifjt; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="n52+Ifjt"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A536D1F00893;
	Sat, 30 May 2026 17:13:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1780161189;
	bh=9lypXuy5PhH2GVgmk7o9J3K6ssd6uXxc5mPnvOHUkY4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=n52+IfjtCALNgBXmLC8FgWBeA46QtKOFUDSnb3CRhCiO3hjQ0CPqrTyMdoi6YQ7/2
	 JUHctyrdhxPIHiq8DyF/MsLpwi+C2iknJLPxAmP95GUqIB5RQ3wqUhIWjJCclvRJJp
	 01PTMQnCRknTaB5kB98hhEV7eEjOnqYb/+h46lcA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Shengjiu Wang <shengjiu.wang@nxp.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 534/969] ASoC: fsl_easrc: Check the variable range in fsl_easrc_iec958_put_bits()
Date: Sat, 30 May 2026 18:00:58 +0200
Message-ID: <20260530160315.114686119@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260530160300.485627683@linuxfoundation.org>
References: <20260530160300.485627683@linuxfoundation.org>
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

[ Upstream commit 00541b86fb578d4949cfdd6aff1f82d43fcf07af ]

Add check of input value's range in fsl_easrc_iec958_put_bits(),
otherwise the wrong value may be written from user space.

Fixes: 955ac624058f ("ASoC: fsl_easrc: Add EASRC ASoC CPU DAI drivers")
Signed-off-by: Shengjiu Wang <shengjiu.wang@nxp.com>
Link: https://patch.msgid.link/20260401094226.2900532-10-shengjiu.wang@nxp.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/fsl/fsl_easrc.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/sound/soc/fsl/fsl_easrc.c b/sound/soc/fsl/fsl_easrc.c
index f04d183fe099f..bb8bad04fb47d 100644
--- a/sound/soc/fsl/fsl_easrc.c
+++ b/sound/soc/fsl/fsl_easrc.c
@@ -54,6 +54,9 @@ static int fsl_easrc_iec958_put_bits(struct snd_kcontrol *kcontrol,
 	unsigned int regval = ucontrol->value.integer.value[0];
 	int ret;
 
+	if (regval < EASRC_WIDTH_16_BIT || regval > EASRC_WIDTH_24_BIT)
+		return -EINVAL;
+
 	ret = (easrc_priv->bps_iec958[mc->regbase] != regval);
 
 	easrc_priv->bps_iec958[mc->regbase] = regval;
-- 
2.53.0



