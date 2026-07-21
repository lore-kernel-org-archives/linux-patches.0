Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 169CD44AB71;
	Tue, 21 Jul 2026 21:35:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784669760; cv=none; b=QEErBsm5wytRQX4nifHNJ3rADlrWvuMBGddx20jnuUKNDoGb3elpkMcyugX7ayI/3Ppbrcm6e2XUoXNcmfTOfG2/SLKrzn2jJ2ncni37YKkToQlAEoIfNI2pCbVTxbiJ/CitQW3U9xBYUhj7Eamq4GRdd6WYvckJhLKrvljf+5g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784669760; c=relaxed/simple;
	bh=J2SaumONScN0XLONsuXybCSp39eQX3kyfZZSobuWcfs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ZAKTuHck8HxdK/AXfPQqh/oideqmqMzBfnuG6x+nFahqySKSY835WmTxshBUqRWMhU+Grk+3tlf9Y9ZA4S+imCYZOs4+p3efpQ1W6ticABo60avkhoZQGBXLjuuAVOVtyMHQMJu3BNqnsJiR8dmaijgh4gjMj8hhFhJptFbaR5I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=D+8x/Tpj; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="D+8x/Tpj"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8173E1F000E9;
	Tue, 21 Jul 2026 21:35:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784669759;
	bh=h9FDo6wpL9/+IV4fGkJ50SlPKWvo56Y3wQ/vC8CBIww=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=D+8x/TpjQtKzXupxGykNd2wKIIzbkcS7aUpfx1fLNXl7V9ZG7GQ8+c5kiPinAys4i
	 /e4RLStBWLRcTIGN9mTeGcO6TSn2a+tMEgau/kZS5rqqUGH3T/o0528WQmK1jSK47e
	 kR5wSGg8xKFnx2+Zr+t7hb55BVdjT+oemXafKxvM=
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
Subject: [PATCH 6.1 0676/1067] ata: sata_gemini: unwind clocks on IDE pinctrl errors
Date: Tue, 21 Jul 2026 17:21:17 +0200
Message-ID: <20260721152439.720142831@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152424.521567757@linuxfoundation.org>
References: <20260721152424.521567757@linuxfoundation.org>
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
index 01f050b1bc93b6..f6bfaa25ecca63 100644
--- a/drivers/ata/sata_gemini.c
+++ b/drivers/ata/sata_gemini.c
@@ -386,7 +386,7 @@ static int gemini_sata_probe(struct platform_device *pdev)
 	if (sg->ide_pins) {
 		ret = gemini_setup_ide_pins(dev);
 		if (ret)
-			return ret;
+			goto out_unprep_clk;
 	}
 
 	dev_info(dev, "set up the Gemini IDE/SATA nexus\n");
-- 
2.53.0



