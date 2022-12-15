Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 59319569B
	for <patches@lists.linux.dev>; Thu, 15 Dec 2022 18:11:57 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 98C33C433F0;
	Thu, 15 Dec 2022 18:11:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1671127917;
	bh=fnYpf1KMAowkcUXWPb36W/ocy6bzlV1c1fTke1mPyUk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=B34ZLX+A8t7r4yOxfYMwbPiUlgHPPK9/sLA+Iyf8SmRfOFom/EJ+UEML8QMl9eD4N
	 Pz1GHlsBPiPqSNSE27iCHs238DNbkucR0ViHgVep5oZG676zyx+ND1CIutLTLfwYtr
	 Gsxvx94YknfLr9dyw2dSweeQRXfhBGGurRL7raD4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Shengjiu Wang <shengjiu.wang@nxp.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 08/15] ASoC: fsl_micfil: explicitly clear CHnF flags
Date: Thu, 15 Dec 2022 19:10:35 +0100
Message-Id: <20221215172907.365131655@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20221215172906.638553794@linuxfoundation.org>
References: <20221215172906.638553794@linuxfoundation.org>
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

[ Upstream commit b776c4a4618ec1b5219d494c423dc142f23c4e8f ]

There may be failure when start 1 channel recording after
8 channels recording. The reason is that the CHnF
flags are not cleared successfully by software reset.

This issue is triggerred by the change of clearing
software reset bit.

CHnF flags are write 1 clear bits. Clear them by force
write.

Signed-off-by: Shengjiu Wang <shengjiu.wang@nxp.com>
Link: https://lore.kernel.org/r/1651925654-32060-2-git-send-email-shengjiu.wang@nxp.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/fsl/fsl_micfil.c | 8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/sound/soc/fsl/fsl_micfil.c b/sound/soc/fsl/fsl_micfil.c
index ead4bfa13561..6c794605e33c 100644
--- a/sound/soc/fsl/fsl_micfil.c
+++ b/sound/soc/fsl/fsl_micfil.c
@@ -201,6 +201,14 @@ static int fsl_micfil_reset(struct device *dev)
 	if (ret)
 		return ret;
 
+	/*
+	 * Set SRES should clear CHnF flags, But even add delay here
+	 * the CHnF may not be cleared sometimes, so clear CHnF explicitly.
+	 */
+	ret = regmap_write_bits(micfil->regmap, REG_MICFIL_STAT, 0xFF, 0xFF);
+	if (ret)
+		return ret;
+
 	return 0;
 }
 
-- 
2.35.1



