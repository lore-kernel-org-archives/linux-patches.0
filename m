Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0B4152C327B;
	Tue, 15 Jul 2025 13:23:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752585796; cv=none; b=HozaSFin0LZfSrda+4Yy9hSxnCxF/iioaZU6loFyz7dXQCk3t9tugkmTs0cdL80QsiH9VRuhI4OpOqKCNzYpPuRyK5jUZW2b3jJ5rh0W3FG/UURrFzNG8Bt+AjtBB/QWdRdHfEZXGgxt7GIMuLr87Z8kWVw7jQGsR6TEVGewlts=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752585796; c=relaxed/simple;
	bh=DVyT0VRiT5iu9AX0dqRVlPg47rY+8E7+jYO9gp5TTsE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=SlXWV3Ls1xOAvlIpe28R/NTVzz0vnEmb8gkjQNNobatAhhZTChmzSqBVtjA5ufpKy9/cduz/BK0wcZdIQqmpfBoRtH2vHjFyy9pFNrvDNpnUuJve9l3rjzZ/EhQSM/vCVpv0l34+VCATB+XIIqIb+CxLPQdapEPVtkrCirEXEdQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=JNsycmj0; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="JNsycmj0"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 33ABFC4CEE3;
	Tue, 15 Jul 2025 13:23:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1752585795;
	bh=DVyT0VRiT5iu9AX0dqRVlPg47rY+8E7+jYO9gp5TTsE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=JNsycmj0QrL1YqyIg0IIp/U7E1LXekWxh7RiETHqOln2L8N7onJjevrPLHc2lXae3
	 pzk4AVfMJTMOqnOQ95QTwx445ataRH9GDyQcWd0oLOXk7IyPAoGAwYq8VsvHPlotFL
	 9jY/YXQj7L0T2OoD1SqAALiWUnyM/LLRkXhTL+Gg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Shengjiu Wang <shengjiu.wang@nxp.com>,
	Daniel Baluta <daniel.baluta@nxp.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 003/109] ASoC: fsl_asrc: use internal measured ratio for non-ideal ratio mode
Date: Tue, 15 Jul 2025 15:12:19 +0200
Message-ID: <20250715130759.009040923@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250715130758.864940641@linuxfoundation.org>
References: <20250715130758.864940641@linuxfoundation.org>
User-Agent: quilt/0.68
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

From: Shengjiu Wang <shengjiu.wang@nxp.com>

[ Upstream commit cbe876121633dadb2b0ce52711985328638e9aab ]

When USRC=0, there is underrun issue for the non-ideal ratio mode;
according to the reference mannual, the internal measured ratio can be
used with USRC=1 and IDRC=0.

Fixes: d0250cf4f2ab ("ASoC: fsl_asrc: Add an option to select internal ratio mode")
Signed-off-by: Shengjiu Wang <shengjiu.wang@nxp.com>
Reviewed-by: Daniel Baluta <daniel.baluta@nxp.com>
Link: https://patch.msgid.link/20250625020504.2728161-1-shengjiu.wang@nxp.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/fsl/fsl_asrc.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/sound/soc/fsl/fsl_asrc.c b/sound/soc/fsl/fsl_asrc.c
index b793263291dc8..72dc23c994bcd 100644
--- a/sound/soc/fsl/fsl_asrc.c
+++ b/sound/soc/fsl/fsl_asrc.c
@@ -517,7 +517,8 @@ static int fsl_asrc_config_pair(struct fsl_asrc_pair *pair, bool use_ideal_rate)
 	regmap_update_bits(asrc->regmap, REG_ASRCTR,
 			   ASRCTR_ATSi_MASK(index), ASRCTR_ATS(index));
 	regmap_update_bits(asrc->regmap, REG_ASRCTR,
-			   ASRCTR_USRi_MASK(index), 0);
+			   ASRCTR_IDRi_MASK(index) | ASRCTR_USRi_MASK(index),
+			   ASRCTR_USR(index));
 
 	/* Set the input and output clock sources */
 	regmap_update_bits(asrc->regmap, REG_ASRCSR,
-- 
2.39.5



