Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 16E961E7660;
	Wed, 20 May 2026 16:42:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779295331; cv=none; b=HtLuRoRWvFcozD8UnMZ3p2nMWuF9Ovo156vbzWeaWhwlSvAm0qY7ZTzvCuAY9VckvMYxhdukAS8bLd6InPOrd9W4nEqFr1Of4+RW+8I10ua5MvMgVv8PkE1LErnrS24qkEkrytajgQDXcTqkvimigkqk3/yjtRWblvGb81IrEUY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779295331; c=relaxed/simple;
	bh=7RoB5AfLDxFuK9QmPoG25Chf+tJePcW9gf/DNEoVqkY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=RW5oMqcivPcKIb7ktZODUKdosdpZqBPgoke4cLmMMKNZGFk1j+lo1pLG8RhWcTznEWHdDYVs3K83WpAlWVuRVxPaaizmxy9O0mhQvWMBGFl7S8Ej6Cnwo2xWOoavYwmmz5bSbIVqlDUP1rxGIiNRoL87BGPGtX61AaghajyY3Pc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=yqKd3kMT; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="yqKd3kMT"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7B2731F000E9;
	Wed, 20 May 2026 16:42:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1779295330;
	bh=Fqr3DEAvadUDrhn8uC8gahmj8SQe9aqX/83tGszydcs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=yqKd3kMTyBIvcgSnTscRpmnbTIHzcz9F62frVtSApji7tGJhNUxp/QrO3jm1U1QQG
	 lIjNY3SalWl0EJpy9hvNTY2XClQ225x8hyzlM31+GZmHRDrq3u/fmIsEHTeFTYzZPL
	 1PRUlHGRNh7tTCIkxy8CxnsCergmsW+K/wJ+dOiw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Shengjiu Wang <shengjiu.wang@nxp.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.0 0377/1146] ASoC: fsl_easrc: Check the variable range in fsl_easrc_iec958_put_bits()
Date: Wed, 20 May 2026 18:10:27 +0200
Message-ID: <20260520162156.732465338@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260520162148.390695140@linuxfoundation.org>
References: <20260520162148.390695140@linuxfoundation.org>
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

7.0-stable review patch.  If anyone has any objections, please let me know.

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
index 599e439b359a9..f48e43a0edcfc 100644
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



