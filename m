Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ECAFA35CB91;
	Wed, 30 Sep 2026 15:36:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790782602; cv=none; b=Q5kcNoka8oKw6Ep3nRKIq3QJPwE2UmjLnOP6uD7zIf9omteVpMuFNWh+vuGlAyum+LoR+O8IbYyITHMJPA3VLr4unkduWml5BKYPDEQR8e4m6zW96aR52LUdp+2y1Tm6pJ1WGeES4LJF2s3EGh3zx/eC8Z7kYNq0VJnGpbvZ5lg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790782602; c=relaxed/simple;
	bh=tgf1S88q1jjBBtGz2IlpiC4c/1ETs2xPzKmW8XB/3RQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=a8vroEbs+PIpqYFfRQ+J4WDyrkMsBMiPZlzF28NtsX+sPp58VeZ2pLPDppHtDbxS0coccWC1bNUwXwjbQAWo2HmLtXBT0eq13xlrttbQ4lHsTMRbHqsChXOuJ/cC+MteCKfH8Kodlufk8EK4sMTpIzMASnX+okajTkODlsniyUI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=1BhFwiNH; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="1BhFwiNH"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 296791F00893;
	Wed, 30 Sep 2026 15:36:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790782592;
	bh=ECNU5oqDT7JetCJiIBQM/19oNfTbG9RglHibMsqfmN0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=1BhFwiNH928BQrQadP4aqwDnTruoIYtukmZzWLvNPfQYL/VNKjucfoSPJWwVZvdhj
	 siy/b/D86JKAKQkIxek+CxG88wfGfnVosWfiPHcahhKnuDwNr99+c7X39L4CyR88G7
	 2bwM4fIilRlyduvRy2vtgheBBSssXoqxK2cCwEWY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Rosen Penev <rosenp@gmail.com>,
	Corey Minyard <corey@minyard.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 100/595] ipmi: si: Use platform_get_irq_optional() to retrieve interrupt
Date: Wed, 30 Sep 2026 17:19:53 +0200
Message-ID: <20260930152349.888740851@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260930152347.700140858@linuxfoundation.org>
References: <20260930152347.700140858@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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
index 129b5713f1879..1cc4841eeba80 100644
--- a/drivers/char/ipmi/ipmi_si_platform.c
+++ b/drivers/char/ipmi/ipmi_si_platform.c
@@ -286,7 +286,10 @@ static int of_ipmi_probe(struct platform_device *pdev)
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



