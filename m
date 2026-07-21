Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 00FE346EC8E;
	Tue, 21 Jul 2026 19:47:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784663246; cv=none; b=QFdltOQk6AP0RnUIyjkwIKjUCzDoxtxMhlXWy4mwYwv+MIsMj37STDTtFU8Y7y4VS5oGbGfJfeE0NVKG8XP4CU6IYiqLb17jGoqAN54HzPtFyDQy82iYGrUhZ8hgjV33aDIicJrFG+JMC6kFB+ex6UDpSmxpTM6JC3jV2Sd0K0s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784663246; c=relaxed/simple;
	bh=Xlc0T/ZQ38+AQs68x/qWOARBLZLA4Ilrs/9nmUGYLWg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=EYS+jXx1iZirnMbSUYL82jybOyI29S52LcpP741RtV88InW3dTf0D2Y3+fGYvXvBzrBwsGIuFXD73NQMhHHSHSIk5S8fzuMLXGdua2TB4IlhHt9JHW+VzqwQGlb1rHJ2SWGL8duCcOaWKsWdL84H+h6TSd7RJ7DJ0P23Z6+Lq7w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=N/sIeed3; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="N/sIeed3"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 68E471F000E9;
	Tue, 21 Jul 2026 19:47:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784663244;
	bh=UVZm9PtqKvKyUxuk+pivX7jlTEx7Hxhs1dHTSkDjw7o=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=N/sIeed3kzqBp5BGEiGQgKFvhYsBfexAAKXIhqoz3zwcdPV0psPzUzYlMcGF3dvLA
	 IgOWV+4UHgowhNPlb2ulhGnbQyoT43o+gAPW1xp8ENotqQJxmr7E4Vaxux9wyCQAXS
	 eKge8rVpaQ9wBuc1VL5M5Tc4F2bupD8iiqIvAryI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ijae Kim <ae878000@gmail.com>,
	Myeonghun Pak <mhun512@gmail.com>,
	Niklas Cassel <cassel@kernel.org>,
	Linus Walleij <linusw@kernel.org>,
	Damien Le Moal <dlemoal@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 0751/1276] ata: sata_gemini: unwind clocks on IDE pinctrl errors
Date: Tue, 21 Jul 2026 17:19:54 +0200
Message-ID: <20260721152502.884286806@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152446.065700225@linuxfoundation.org>
References: <20260721152446.065700225@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Myeonghun Pak <mhun512@gmail.com>

[ Upstream commit c0ace4130e813acbabdfaa28d4e94a849c2ffdd7 ]

gemini_sata_bridge_init() prepares and enables both SATA PCLKs, then
disables them again while keeping the clocks prepared for later bridge
start and stop operations. If gemini_setup_ide_pins() fails after that,
gemini_sata_probe() returns directly and skips the existing
out_unprep_clk unwind path.

Route the IDE pinctrl failure through out_unprep_clk so the clocks
prepared by gemini_sata_bridge_init() are unprepared before probe
fails.

Fixes: d872ced29d5f ("ata: sata_gemini: Introduce explicit IDE pin control")
Co-developed-by: Ijae Kim <ae878000@gmail.com>
Signed-off-by: Ijae Kim <ae878000@gmail.com>
Signed-off-by: Myeonghun Pak <mhun512@gmail.com>
Reviewed-by: Niklas Cassel <cassel@kernel.org>
Reviewed-by: Linus Walleij <linusw@kernel.org>
Signed-off-by: Damien Le Moal <dlemoal@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/ata/sata_gemini.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/ata/sata_gemini.c b/drivers/ata/sata_gemini.c
index f574e3c3f5b48f..b41a5ad1b06e9e 100644
--- a/drivers/ata/sata_gemini.c
+++ b/drivers/ata/sata_gemini.c
@@ -385,7 +385,7 @@ static int gemini_sata_probe(struct platform_device *pdev)
 	if (sg->ide_pins) {
 		ret = gemini_setup_ide_pins(dev);
 		if (ret)
-			return ret;
+			goto out_unprep_clk;
 	}
 
 	dev_info(dev, "set up the Gemini IDE/SATA nexus\n");
-- 
2.53.0



