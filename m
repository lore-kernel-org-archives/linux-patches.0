Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6937226A1B7;
	Tue,  8 Apr 2025 12:32:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744115578; cv=none; b=MsdHeu4FSfB6oHS/qNDp2m/Kjq2GiqjgjvDwEL9/gKD5N2uNzmfikdiwlXIMZ+TNBiwdYM055YXv718AU1h2pxBuZ8aoCRv5Q4iYomhDCZyIRorUg9HSzrJtAkx2wDz36TcEmmP2eFCOqB8TutriGKv86sNec4JekUxp2saU3wI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744115578; c=relaxed/simple;
	bh=QSbKkV2m4j0tz4FliBz8GoEzHk7hv2fqH+O8fgSGWj0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Mz5r1T3dFmCRZ/bHCbTqRkAkENZdVxaQN9EUGbTf8NCWjCGnJm1Vym4z2UCJ/PXs0bfa8t3dwyt29QS1zFI+iAEpjEou7vzrM48KGzS3kW9T3zULaERrtrkThcWoZ3eF1s2xWwN6QSLeX3Qkx95mHUes+yiRQOwLBeYbf0yBnWU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Ajcc2+sI; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Ajcc2+sI"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DD69AC4CEE5;
	Tue,  8 Apr 2025 12:32:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1744115578;
	bh=QSbKkV2m4j0tz4FliBz8GoEzHk7hv2fqH+O8fgSGWj0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Ajcc2+sI7FK4PMQkZh3i69ZpUYywaE35EIcpZB6YyDMrE9VAtkdlmj0RuSStfcyAo
	 pPCowX45oBVkZ8FwNT1SgtHHohpNOLXsIC3c3DRFT+9Yg6dMTakvW2WNNPzRRcppRb
	 ZEzvuJ+SJbZ/XHsvPsJq0z+WWMbQpK72WDSER2ic=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jayesh Choudhary <j-choudhary@ti.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 026/204] ASoC: ti: j721e-evm: Fix clock configuration for ti,j7200-cpb-audio compatible
Date: Tue,  8 Apr 2025 12:49:16 +0200
Message-ID: <20250408104821.090540229@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250408104820.266892317@linuxfoundation.org>
References: <20250408104820.266892317@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jayesh Choudhary <j-choudhary@ti.com>

[ Upstream commit 45ff65e30deb919604e68faed156ad96ce7474d9 ]

For 'ti,j7200-cpb-audio' compatible, there is support for only one PLL for
48k. For 11025, 22050, 44100 and 88200 sampling rates, due to absence of
J721E_CLK_PARENT_44100, we get EINVAL while running any audio application.
Add support for these rates by using the 48k parent clock and adjusting
the clock for these rates later in j721e_configure_refclk.

Fixes: 6748d0559059 ("ASoC: ti: Add custom machine driver for j721e EVM (CPB and IVI)")
Signed-off-by: Jayesh Choudhary <j-choudhary@ti.com>
Link: https://patch.msgid.link/20250318113524.57100-1-j-choudhary@ti.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/ti/j721e-evm.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/sound/soc/ti/j721e-evm.c b/sound/soc/ti/j721e-evm.c
index 6a969874c9270..5e0bdbd34a837 100644
--- a/sound/soc/ti/j721e-evm.c
+++ b/sound/soc/ti/j721e-evm.c
@@ -182,6 +182,8 @@ static int j721e_configure_refclk(struct j721e_priv *priv,
 		clk_id = J721E_CLK_PARENT_48000;
 	else if (!(rate % 11025) && priv->pll_rates[J721E_CLK_PARENT_44100])
 		clk_id = J721E_CLK_PARENT_44100;
+	else if (!(rate % 11025) && priv->pll_rates[J721E_CLK_PARENT_48000])
+		clk_id = J721E_CLK_PARENT_48000;
 	else
 		return ret;
 
-- 
2.39.5



