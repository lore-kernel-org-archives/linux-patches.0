Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CB2C951813D;
	Thu, 17 Sep 2026 16:58:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789664317; cv=none; b=i7L/r+4NWF/X+3DTbOqiD8qwe/h3/sNaP4psfUxXKUDwBJJ/NZJFp4nhman2McZ7oAM+hMWoqa4ZIrBGKbVoscu5BB3p6GLfSvjX/p2y4/DOH5ie/gB/RZs+OuBxOO2njYpGwi45RG/D6eKuhNNy5C00sPaPadN/O+XwNBq4NPI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789664317; c=relaxed/simple;
	bh=4Xf9X9QhRhx9aqYI7GpmM7vcxT61pksEO3IxEPTZlxc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=d4+VsYj97VhCRtd2Q8vItiKWNkivbEJ5AMVOrDTEamp6UL3cECA8xbH3jYP24RUrxGsZHe8ZwQy1GVhtwa2xJCdLmngqYKIoo54ZnBgChWg8gIUT1iNT6vu0WB+MPAXGwrnmZuSt01f6tGerCEZ3xDV4vgJXzPmqsAOqSzhaEd8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=HzH5reA0; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="HzH5reA0"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BF5141F00893;
	Thu, 17 Sep 2026 16:58:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789664315;
	bh=Amzeckqg+K5CvKNVsdFAeAsrg1I+KvPRMGfienaSc60=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=HzH5reA0Ib9SbDjoSC54t9luRXPFD4hGb+6y3ZJqkH8h7UG/wWmeLwZzNFk3hjf0M
	 2BJFQb1aw0shuKlQa3Q2Gqt8q+GMqvSea3RhePZGx2Ycfa9RzmbABHVmVqJLrZ2gYU
	 BSTYGYKnupCcUDSonf6U4dB0+S6QhFvgSGH8Cy3c=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Rosen Penev <rosenp@gmail.com>,
	Corey Minyard <corey@minyard.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0330/1250] ipmi: si: Use platform_get_irq_optional() to retrieve interrupt
Date: Thu, 17 Sep 2026 16:02:05 +0100
Message-ID: <20260917151601.036758327@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260917151551.901433442@linuxfoundation.org>
References: <20260917151551.901433442@linuxfoundation.org>
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

From: Rosen Penev <rosenp@gmail.com>

[ Upstream commit 39851b7e580a65bee732e5364f0efb974b242370 ]

Use platform_get_irq_optional() to retrieve the interrupt resource
instead of directly parsing and mapping the OF node via
irq_of_parse_and_map().  This is the standard pattern for platform
devices.  irq_of_parse_and_map() requires ire_dispose_mapping(), which
is missing.

Assisted-by: Antigravity:Gemini-3.5-Flash
Signed-off-by: Rosen Penev <rosenp@gmail.com>
Message-ID: <20260603192511.6869-1-rosenp@gmail.com>
[Handle a negative return from platform_get_irq_optional() to mean
 no interrupt is assigned.]
Signed-off-by: Corey Minyard <corey@minyard.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/char/ipmi/ipmi_si_platform.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/drivers/char/ipmi/ipmi_si_platform.c b/drivers/char/ipmi/ipmi_si_platform.c
index fb6e359ae4946..704b06c919f03 100644
--- a/drivers/char/ipmi/ipmi_si_platform.c
+++ b/drivers/char/ipmi/ipmi_si_platform.c
@@ -276,7 +276,10 @@ static int of_ipmi_probe(struct platform_device *pdev)
 	io.regspacing	= regspacing ? be32_to_cpup(regspacing) : DEFAULT_REGSPACING;
 	io.regshift	= regshift ? be32_to_cpup(regshift) : 0;
 
-	io.irq		= irq_of_parse_and_map(pdev->dev.of_node, 0);
+	io.irq = platform_get_irq_optional(pdev, 0);
+	if (io.irq < 0)
+		io.irq = 0;
+
 	io.dev		= &pdev->dev;
 
 	dev_dbg(&pdev->dev, "addr 0x%lx regsize %d spacing %d irq %d\n",
-- 
2.53.0



