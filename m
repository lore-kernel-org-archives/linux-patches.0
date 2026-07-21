Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7068A3E008A;
	Tue, 21 Jul 2026 17:07:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784653656; cv=none; b=faCt0kot5xc7ALCXvgnktoN/UmSTdWmNZFEQUkPcLnfuSGtkM9kriP7hHj1Hr8zgHSecI/0u5GAhne/oJITzIkjEstmPmSW/9dVCuEldyrzKWIMlu5CRkGyx69xY1wa0q/ButJuZ//7797uLSTOG3kNmdy1loyzOT9xSMa6iCGs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784653656; c=relaxed/simple;
	bh=YVMuExQyGD9BAAsnwUokWwAW588XIp08JXvwUWmnpp4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=NQbBplUcEApB4zCwvtaonXgpZwlAyekBz5dBWIGkHvhhZ4+lmFIde+Mj4xdwcH5vniROPT9b6iHjiRQSjANgeEdSVgYHjMDVXzFhOerZfDdBGfTS8QeuGXmQnJkJIw6VJS2pUqxfix/91V9rdogsK7GldusBkvHkYrK8ZoDlmIA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=rcUZgwIS; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="rcUZgwIS"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D9D551F000E9;
	Tue, 21 Jul 2026 17:07:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784653655;
	bh=V8hCd+/NxkQHfJlWDeEI+W+HOW74Idy0ffDYUk3bGVA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=rcUZgwISzR3D0hNat7pXAkjz/ZofSV/icKL8kjeM1dId9RULmSPMO6sHr5qyvLDOE
	 j2t9XXdYBStg58CdNhtRSLTT4sEfemFKmtmoN6z5Ra6gEKZhaoLolh1VEAbMDqUXnv
	 VhKlBBhuWfRiNf2A6nBfZSoXcvc2/2tLudBnDLro=
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
Subject: [PATCH 7.1 1409/2077] ata: sata_gemini: unwind clocks on IDE pinctrl errors
Date: Tue, 21 Jul 2026 17:18:02 +0200
Message-ID: <20260721152626.039997310@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152552.646164743@linuxfoundation.org>
References: <20260721152552.646164743@linuxfoundation.org>
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

7.1-stable review patch.  If anyone has any objections, please let me know.

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
index 530ee26b301210..56ae2820df5888 100644
--- a/drivers/ata/sata_gemini.c
+++ b/drivers/ata/sata_gemini.c
@@ -353,7 +353,7 @@ static int gemini_sata_probe(struct platform_device *pdev)
 	if (sg->ide_pins) {
 		ret = gemini_setup_ide_pins(dev);
 		if (ret)
-			return ret;
+			goto out_unprep_clk;
 	}
 
 	dev_info(dev, "set up the Gemini IDE/SATA nexus\n");
-- 
2.53.0



