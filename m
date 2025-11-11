Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 18B7526CE37;
	Tue, 11 Nov 2025 01:37:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762825059; cv=none; b=c5HzczF2xGwkS2Qqw/H42dgp83EQSPGdxYDuDKnnLzGO1si0SdDpXP0kjKQ2iPJHLfwOSQDTBfpucQXoK6O3Klv6P8vDBaGWrXa3asMa7al9NEr+wEgrusWYqtJL0L1wxYWeI7m/T8/2x9t+AVuTdyGeJ0Wiyu4lz+SPureamxc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762825059; c=relaxed/simple;
	bh=ofqtRckkAWlzv8J8fZhZv04Mx44eArmvqFf3cJJNmZY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=SlaNzaxwPzkLnMfblmqANyGHD0PgUeFfq/EPha9x99fSklUspwmlPrw7j7cvPanOY5e2GBFXmm+3FWhdpTOxRO+CsfgG4MGibYRU8MM1zjiNS6CuKy5ZVCGeH48/6PIJkVHMQyL3fq108AAODTqYWhCWfSb4Jb+hqRSztLbDli4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=IyQVqydu; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="IyQVqydu"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AD0DBC116D0;
	Tue, 11 Nov 2025 01:37:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1762825059;
	bh=ofqtRckkAWlzv8J8fZhZv04Mx44eArmvqFf3cJJNmZY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=IyQVqyduSx9X9ZlmxGi65VRRy+LTdXYyDr7DIeJTLyQy2/lq2Q2Vj1/+rOgxtLgRb
	 B3ZnV9lCes/KIMn0TcQBYSkJXN54hAG08qaqo8FIg5WCZmkVDPC+cvYoK8mNQEP7l6
	 hLKsdVaGFLm9esqdjgZNTT9E4s0hbitC4WLi9oEM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Kuninori Morimoto <kuninori.morimoto.gx@renesas.com>,
	Yusuke Goda <yusuke.goda.sx@renesas.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.17 643/849] ASoC: renesas: msiof: set SIFCTR register
Date: Tue, 11 Nov 2025 09:43:33 +0900
Message-ID: <20251111004551.976735621@linuxfoundation.org>
X-Mailer: git-send-email 2.51.2
In-Reply-To: <20251111004536.460310036@linuxfoundation.org>
References: <20251111004536.460310036@linuxfoundation.org>
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

6.17-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Kuninori Morimoto <kuninori.morimoto.gx@renesas.com>

[ Upstream commit 130947b4681c515a5e5a7961244b502de2de85ca ]

Because it uses DMAC, we would like to transfer data if there is any data.
Set SIFCTR for it.

Signed-off-by: Kuninori Morimoto <kuninori.morimoto.gx@renesas.com>
Tested-by: Yusuke Goda <yusuke.goda.sx@renesas.com>
Link: https://patch.msgid.link/87bjmzyuub.wl-kuninori.morimoto.gx@renesas.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/renesas/rcar/msiof.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/sound/soc/renesas/rcar/msiof.c b/sound/soc/renesas/rcar/msiof.c
index 555fdd4fb2513..ede0211daacba 100644
--- a/sound/soc/renesas/rcar/msiof.c
+++ b/sound/soc/renesas/rcar/msiof.c
@@ -185,6 +185,12 @@ static int msiof_hw_start(struct snd_soc_component *component,
 		msiof_write(priv, SIRMDR3, val);
 	}
 
+	/* SIFCTR */
+	if (is_play)
+		msiof_update(priv, SIFCTR, SIFCTR_TFWM, FIELD_PREP(SIFCTR_TFWM, SIFCTR_TFWM_1));
+	else
+		msiof_update(priv, SIFCTR, SIFCTR_RFWM, FIELD_PREP(SIFCTR_RFWM, SIFCTR_RFWM_1));
+
 	/* SIIER */
 	if (is_play)
 		val = SIIER_TDREQE | SIIER_TDMAE | SISTR_ERR_TX;
-- 
2.51.0



