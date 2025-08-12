Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B5EA120409A;
	Tue, 12 Aug 2025 18:52:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755024757; cv=none; b=a6k2l1Bhxpet1zMf4W1z2Z0yUBfjYMPJBhwqiIzlAfVVzow9lgUcshai0BIiXuiXip9p44yOoBICOGp0gyNg7NukaiWjWwP8p4gRIW4XLSl8aM/RU1M0cG7uViMjy3/GdPM01PD34KGKNWeo0gOP/O7yTDHFBJEZPXcuw33+Y58=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755024757; c=relaxed/simple;
	bh=+F1CDl/eZmt0b9rhFjwVLU2uW1KxvOyqhJDbHrBBOkI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=WE3v311TK3u7j/r1JWjTSR0ZtGKid1lRHPxsaF/laAoR2EWbEif0WX3VDB1jjLLgipQ+3JmHNwPXPGmZp8Z0vbtxQ7D/3O5blZ6Pr/YfahySZdUEn+6529+fW09oWh7OxfQJO0nwBM/+aBsybxotLKdeSmDvMIAO09yphCgVJWQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=l/Y70kxt; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="l/Y70kxt"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 242CEC4CEF6;
	Tue, 12 Aug 2025 18:52:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1755024757;
	bh=+F1CDl/eZmt0b9rhFjwVLU2uW1KxvOyqhJDbHrBBOkI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=l/Y70kxtYi/Z7Cy9M2JvMcCNxr5VboL1yuTg347e4xE6oyDt2hmHmllZADTZ9M1Pn
	 vXGnCyiGAtHF6qStvLoIghe0muTkz9KLmu71VileNPG/AgjexFCbHwv6GxlshcfsW8
	 GEuGrqlSyhmxj2K/DaWIfF/eTAXP+6iLWysRGLxo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Brian Masney <bmasney@redhat.com>,
	Alexandre Belloni <alexandre.belloni@bootlin.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.16 469/627] rtc: pcf8563: fix incorrect maximum clock rate handling
Date: Tue, 12 Aug 2025 19:32:44 +0200
Message-ID: <20250812173440.739105557@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250812173419.303046420@linuxfoundation.org>
References: <20250812173419.303046420@linuxfoundation.org>
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

6.16-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Brian Masney <bmasney@redhat.com>

[ Upstream commit 906726a5efeefe0ef0103ccff5312a09080c04ae ]

When pcf8563_clkout_round_rate() is called with a requested rate higher
than the highest supported rate, it currently returns 0, which disables
the clock. According to the clk API, round_rate() should instead return
the highest supported rate. Update the function to return the maximum
supported rate in this case.

Fixes: a39a6405d5f94 ("rtc: pcf8563: add CLKOUT to common clock framework")
Signed-off-by: Brian Masney <bmasney@redhat.com>
Link: https://lore.kernel.org/r/20250710-rtc-clk-round-rate-v1-5-33140bb2278e@redhat.com
Signed-off-by: Alexandre Belloni <alexandre.belloni@bootlin.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/rtc/rtc-pcf8563.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/rtc/rtc-pcf8563.c b/drivers/rtc/rtc-pcf8563.c
index b2611697fa5e..a2a2067b28a1 100644
--- a/drivers/rtc/rtc-pcf8563.c
+++ b/drivers/rtc/rtc-pcf8563.c
@@ -339,7 +339,7 @@ static long pcf8563_clkout_round_rate(struct clk_hw *hw, unsigned long rate,
 		if (clkout_rates[i] <= rate)
 			return clkout_rates[i];
 
-	return 0;
+	return clkout_rates[0];
 }
 
 static int pcf8563_clkout_set_rate(struct clk_hw *hw, unsigned long rate,
-- 
2.39.5



