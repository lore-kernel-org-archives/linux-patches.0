Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E044322257E;
	Tue,  8 Apr 2025 11:53:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744113202; cv=none; b=EaHymyLT4RbrODMlvYK4SOte9C9STLc/wVDD4Ff0Ez69bC+mobFWlBz5+EEY1IxhH0EdUFvJWAM1whrAug6CFMYxFhfu3IuhiXGoNYC0ryjYSRQdLCaKKiQiaKtZfOYGCUCAwXWyXoTqtsKt27MqkffmcOWdZVau+606f+V1Ffk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744113202; c=relaxed/simple;
	bh=3/Eq/uGgXYi2v8OJlyfLb8FLL3QTqy8SWNRwtAzs81Y=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Jit8uCeDhkJhjmOBpKWKwXMxFvLLTWwN076sLPEks7FAGDn22rZHIuRjvLh8k/zZXxLWDmcCeB9xOpUaWeaJOYV/1PSecTC+I4UIahumh+AY7APCUlHq/xt+Ea2KToWosrLKhStqkKdtTdDxXmpPupUZ5U65n7PKXyH1St3Nkcg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=JhMMwiJn; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="JhMMwiJn"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 45D2CC4CEE5;
	Tue,  8 Apr 2025 11:53:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1744113201;
	bh=3/Eq/uGgXYi2v8OJlyfLb8FLL3QTqy8SWNRwtAzs81Y=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=JhMMwiJn/AhJw6YI7IwEqiPE1Lpz+aMmY2MNi6Qpw732XB8qRbKYwbNyhbwD5QsEB
	 iEWXxh2oe0/mjRbxdz3uvB0SC/0lsRCV/hqHQxOLYbzD58ZZvAXT9uosp1VU4y7q5j
	 EvusRJrqpeoWe/ia1JZj+/y619O/FemyZX6lNEew=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jayesh Choudhary <j-choudhary@ti.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 031/268] ASoC: ti: j721e-evm: Fix clock configuration for ti,j7200-cpb-audio compatible
Date: Tue,  8 Apr 2025 12:47:22 +0200
Message-ID: <20250408104829.342067112@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250408104828.499967190@linuxfoundation.org>
References: <20250408104828.499967190@linuxfoundation.org>
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



