Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 62B8946C4C0;
	Tue, 21 Jul 2026 18:24:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784658244; cv=none; b=YZGpcmqAMTVqFjxzF1SUaDdPIB6BSsAuJXOOLLFf1NV4K4dIz1t2Qn+vEYpuwarRlOxcUVJWXRx0aTbxXMWfRo8QO8a44CtOCOox784tidGyM5Jkf8ImPys5ZfDXgL9BewyLaymi+YYusM0uQwiAjTRjR8XquJiogyPZN85V1rs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784658244; c=relaxed/simple;
	bh=C7E9qxVsI794Ylxb7Mi4lD5uP1jZqzETMgXeNoKAroQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=e8lNPcsUD/cKL7VMACNMdt7jtrf5452KqWzG9913OkAe4fdnLh0YPrjiDxmxcvDXi+2VZMytw8421iuujHh0aUSgNacfOyD/qiW7sQOt+4iGChDCOExD/qBoSpxNwxAvxXW0PMLUo/umkgtd+L+HzMULSlMUob3cczzDBG+sJ/E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=APem7OUE; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="APem7OUE"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C4FD11F000E9;
	Tue, 21 Jul 2026 18:24:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784658243;
	bh=Ax0BGvHkPyZdMa3MxmYwOQbDhBex799kzFc3ALjeE+c=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=APem7OUE2sdRgjGZMU8VAxIZUWgSYuZSAtFm/hbGFs+P24qEW3/sWUbUQn9UF2i59
	 6MB3AWiduMj1CVZYNXz2+F+kKdi441H5Y6dC23YclQBz2I/CJ5jdsrJDAoNfvhBcvk
	 IXjDE8EQ6oMrw8RHXoSFoQQh/5P0BoZvlZJonUHg=
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
Subject: [PATCH 6.18 1027/1611] ata: sata_gemini: unwind clocks on IDE pinctrl errors
Date: Tue, 21 Jul 2026 17:19:03 +0200
Message-ID: <20260721152538.495557864@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152514.750365251@linuxfoundation.org>
References: <20260721152514.750365251@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

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



