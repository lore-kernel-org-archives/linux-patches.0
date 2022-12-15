Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0AD7B569B
	for <patches@lists.linux.dev>; Thu, 15 Dec 2022 18:12:13 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 61380C433EF;
	Thu, 15 Dec 2022 18:12:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1671127932;
	bh=TqBnjsY6W9h8nVSTWhKJucNnSNV9DfSlrfaeFN+ZBDM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=F3ZzvcQq6IAOkMf+3HCl5VX/j85KlyUB7OwzWi+NnwPCENA4ogIXSj2wJzUEuMO7m
	 /pqpb8b7DN6lqw8gu7qlW02Xl9uP8Oi8EZ+ZaS2hrxGgMDEQh/isItzIE3gh8GfWyJ
	 SzCB+GuBbS8dCY+DQHyIRvkoZlwgwGDD8d+ObH3k=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Shengjiu Wang <shengjiu.wang@nxp.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 04/14] ASoC: fsl_micfil: explicitly clear software reset bit
Date: Thu, 15 Dec 2022 19:10:40 +0100
Message-Id: <20221215172906.537422169@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20221215172906.338769943@linuxfoundation.org>
References: <20221215172906.338769943@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Shengjiu Wang <shengjiu.wang@nxp.com>

[ Upstream commit 292709b9cf3ba470af94b62c9bb60284cc581b79 ]

SRES is self-cleared bit, but REG_MICFIL_CTRL1 is defined as
non volatile register, it still remain in regmap cache after set,
then every update of REG_MICFIL_CTRL1, software reset happens.
to avoid this, clear it explicitly.

Signed-off-by: Shengjiu Wang <shengjiu.wang@nxp.com>
Link: https://lore.kernel.org/r/1651925654-32060-1-git-send-email-shengjiu.wang@nxp.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/fsl/fsl_micfil.c | 11 +++++++++++
 1 file changed, 11 insertions(+)

diff --git a/sound/soc/fsl/fsl_micfil.c b/sound/soc/fsl/fsl_micfil.c
index 9f90989ac59a..cb84d95c3aac 100644
--- a/sound/soc/fsl/fsl_micfil.c
+++ b/sound/soc/fsl/fsl_micfil.c
@@ -191,6 +191,17 @@ static int fsl_micfil_reset(struct device *dev)
 		return ret;
 	}
 
+	/*
+	 * SRES is self-cleared bit, but REG_MICFIL_CTRL1 is defined
+	 * as non-volatile register, so SRES still remain in regmap
+	 * cache after set, that every update of REG_MICFIL_CTRL1,
+	 * software reset happens. so clear it explicitly.
+	 */
+	ret = regmap_clear_bits(micfil->regmap, REG_MICFIL_CTRL1,
+				MICFIL_CTRL1_SRES);
+	if (ret)
+		return ret;
+
 	return 0;
 }
 
-- 
2.35.1



