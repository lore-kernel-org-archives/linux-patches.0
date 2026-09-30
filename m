Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 489491E1A17;
	Wed, 30 Sep 2026 18:52:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790794340; cv=none; b=qFTy9Tty2NamkM5FYCHGPt1wyAysEFmMdMfKxPQFjD3Pco6K4mO/KMOuYNeb0YjQMuVuiceOqvJaCKMmdRFzaHE1wr2Vp/FLgAqviXCX6nJSnFWbxBGlmKtCYlH+RJu6uBUNgNxlkLCD+u0YKz8dboSbeR000TtSo8ZFKBfSAok=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790794340; c=relaxed/simple;
	bh=KG6kEFX704X4N3fJ9kvlgjgXKtPR8YCSV2UX3PHZi9w=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=fwQdSQinjnxOTVrIO5VWwrxQHC4W5Lh8DIEDPvC8QCJiO7gb36OBhLZc1gNoYgTDdK0USycnp6krlCx+QqOgNNEg1ksDmDES35vlx+Jwtw7XU8wOWLAOvflqfCdUDzNLmWLFBwsVXh9wr4hiJecCtfObTVIDYsYnodgmj0MK5nU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=s6DMulMt; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="s6DMulMt"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A3A851F000FF;
	Wed, 30 Sep 2026 18:52:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790794339;
	bh=XEU2YKJCI1QeX23LUw5Z13xvbHFyZ/+sOHRgJtby/sI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=s6DMulMt3W0eVH6zuezd6NLUjs0lqQvPfEMoggMIZxlEEk+u4cuhGlSjROZZuGUpT
	 LCQlfffqto3r+GP6seqUGIKNn1Z/z7XfMsqlxP4p/7OwbiIW+CRw6QyEdP+BBhjsiN
	 /hotND8UqTtxvuJWjHAjXt0A39LeaseQEjxryiSU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Rosen Penev <rosenp@gmail.com>,
	Corey Minyard <corey@minyard.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 0176/1193] ipmi: si: Use platform_get_irq_optional() to retrieve interrupt
Date: Wed, 30 Sep 2026 17:14:20 +0200
Message-ID: <20260930152438.104521648@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260930152434.301151190@linuxfoundation.org>
References: <20260930152434.301151190@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
index c3d8ac7873baa..de98f23b354a6 100644
--- a/drivers/char/ipmi/ipmi_si_platform.c
+++ b/drivers/char/ipmi/ipmi_si_platform.c
@@ -279,7 +279,10 @@ static int of_ipmi_probe(struct platform_device *pdev)
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



