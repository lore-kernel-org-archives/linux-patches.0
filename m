Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ED20626738C;
	Sat, 30 May 2026 18:39:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780166351; cv=none; b=AmHrvoo3c06RegxJ2gqMvZulq0coDNevQndfDcpamu3Mwv+Wqrr9EMbG9s7r2OcfW2rsrJhVjeAM4N5uMBnuASpCHEDC3zjtM6mOAAaiDkx8dsOYGmG4CQJAKmVOdj26hNlWCFp9PK892BCHk1avGLT0rXfG1mfSeXBkdw5Ivwo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780166351; c=relaxed/simple;
	bh=rH8kX/gYrU9QUBpiPzUZMQou67brqCJK8iX8FzPnq7M=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=MfFplLZ8Dj60BP6wQnqdCg0WuC3LMM4/jskky3X7fA5vbXWJYam0xZIWpoWTcX2WeTzrbZljYSLsX4OCwJXAjKS11UqMPgGdk5rLLZBWtEBVCANHtyC6OPwUyoYEoQ5ayMAqUc/DFiw6/HnT9R6cjiGzr2Uq1SN983L506BXq44=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=foG0s1UD; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="foG0s1UD"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3E15E1F00893;
	Sat, 30 May 2026 18:39:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1780166350;
	bh=SnupiFETsbCevHCsgLyOamsFu8qutY99afAjhk5OFXo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=foG0s1UDr090hyjosvi2t9KBk7bF05oJzVZgRld6/fls9HrwGunUnBK2ZP6eUQrf6
	 S6++AD7YPkDs0j9mvlnE8Qnh/W6Yph0e3qCoiTyZPNvjJ6q3FMV6Oh3U3clT+MSZfd
	 Mikd1jf/s63rN1MIjnjIf3A9Ac7JYlv9ckM3P5GQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Shengjiu Wang <shengjiu.wang@nxp.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 347/589] ASoC: fsl_easrc: Check the variable range in fsl_easrc_iec958_put_bits()
Date: Sat, 30 May 2026 18:03:48 +0200
Message-ID: <20260530160233.995900994@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260530160224.570625122@linuxfoundation.org>
References: <20260530160224.570625122@linuxfoundation.org>
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
index 6e9b9cc98284d..a267ca941d943 100644
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



