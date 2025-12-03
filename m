Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4020631961F;
	Wed,  3 Dec 2025 16:34:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764779647; cv=none; b=Qg/x527EEsw9WNLH+jMYEwZxshWwjcVQap9j9ymIlo+DMM86qbBMoBybLcRJkpJFXPuoyGlRCT4nWWkT4Xn5YXJJt1rX1COexGy2KLKaJu+BCIGy7vQoo7CwvQCd0GY+XeplLU8PMlYguOrTQ+wqHqiljPSPm1UlvEvAMAOyFaI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764779647; c=relaxed/simple;
	bh=qpkIcVJ5miBuK6sYHytIt7HDp1ODdKaWYKa1EPzgVoI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=KwFWHMNMM1jJUAo/PbfCThWOVhBmxgfwqNNruJJQs3BvumQQuGSEX/Y7lYccrw9SpPjeEHfJQCeUVRTDiHJUpPy30654XmefHijVUNQMF07dyeWhH7d6om37YqA1yoBkfVJ5oTOSHTZZ0xtiIL/sRTgviSyY6cCLGBpQ8At0raI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=wCOuel4s; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="wCOuel4s"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A1C3FC4CEF5;
	Wed,  3 Dec 2025 16:34:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1764779647;
	bh=qpkIcVJ5miBuK6sYHytIt7HDp1ODdKaWYKa1EPzgVoI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=wCOuel4sGKyEuuDkhcTbyYp83S/49qhAnFpo7ZnzHok4ZMyCkcuWYEjArjXDzMTbw
	 sK1C4xrI2fszo2bj9vPAyn2qsDPFHHcizYgstV707IbcS09E/0s8Kc74NKTZsPr5oz
	 I+pDsGcdD9FmjtA+Ik4KZZvv5oOEfnc+ypNkIF3Q=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ryan Wanner <Ryan.Wanner@microchip.com>,
	Nicolas Ferre <nicolas.ferre@microchip.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 286/568] clk: at91: clk-master: Add check for divide by 3
Date: Wed,  3 Dec 2025 16:24:48 +0100
Message-ID: <20251203152451.179025601@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251203152440.645416925@linuxfoundation.org>
References: <20251203152440.645416925@linuxfoundation.org>
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

From: Ryan Wanner <Ryan.Wanner@microchip.com>

[ Upstream commit e0237f5635727d64635ec6665e1de9f4cacce35c ]

A potential divider for the master clock is div/3. The register
configuration for div/3 is MASTER_PRES_MAX. The current bit shifting
method does not work for this case. Checking for MASTER_PRES_MAX will
ensure the correct decimal value is stored in the system.

Signed-off-by: Ryan Wanner <Ryan.Wanner@microchip.com>
Signed-off-by: Nicolas Ferre <nicolas.ferre@microchip.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/clk/at91/clk-master.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/clk/at91/clk-master.c b/drivers/clk/at91/clk-master.c
index b7cd1924de52a..1f07a5d292602 100644
--- a/drivers/clk/at91/clk-master.c
+++ b/drivers/clk/at91/clk-master.c
@@ -574,6 +574,9 @@ clk_sama7g5_master_recalc_rate(struct clk_hw *hw,
 {
 	struct clk_master *master = to_clk_master(hw);
 
+	if (master->div == MASTER_PRES_MAX)
+		return DIV_ROUND_CLOSEST_ULL(parent_rate, 3);
+
 	return DIV_ROUND_CLOSEST_ULL(parent_rate, (1 << master->div));
 }
 
-- 
2.51.0



