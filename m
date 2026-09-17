Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BFA014ABBD4;
	Thu, 17 Sep 2026 16:05:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789661103; cv=none; b=OOi/Yl0uS+WppKHsqw6GpayG/o4jgd6JOyxEFcc6AUfBsDaWnX2IE15/JW7s2grMIUG+vJKKvjBGulyZ3iY1gY8MqoKZTxGOYCyA7SCPOFXCzYxEBoExT5XJCNZva5aCUQoat19JBXTs8R/vekmHbH2WX0EB7qIxg+2H+hZ7wp0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789661103; c=relaxed/simple;
	bh=JmxdrRDeYnKA8Fqd28mBvfmELF+TyTIFvEQ57pmGh/U=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=c/bQtteiL9VNIUJ4ZEcYOXWX4SrvEAr72GxZkFNOBBDg2czZhkQvXa+Z+WDR0bElR7f/kHXRGz5eexy0jzy0at6dEP0pIxxHXdoHDDeywCmx440Ccfoa3GCHd/dWTMAMpjR/nTY64G3Eln5xVQ1tREPieDhTOMTOqPRUT4Shl+U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Wgdom/xp; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Wgdom/xp"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3C0391F000FF;
	Thu, 17 Sep 2026 16:05:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789661102;
	bh=Obm2zBg+q1zs92fYKsXlBVL9W5kNDn+KFcvDJV96534=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Wgdom/xpe0stc5XjuDPsU1LAKyDYqA3VxhaUcqh2D9S/mmzJuWOCsEc82RPu0a5qq
	 JsVY4wSvJBdAzTJRHldbYWzkwAIRvaZsNqoXc+Laq/U6us+Z71syRHBiJ4P/hg5Mpn
	 u7VtarXKQ1q/RR9nr5okGo1WGG2icNbll0IpHoms=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Geert Uytterhoeven <geert+renesas@glider.be>,
	Biju Das <biju.das.jz@bp.renesas.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0076/1250] clk: renesas: cpg-mssr: Add number of clock cells check
Date: Thu, 17 Sep 2026 15:57:51 +0100
Message-ID: <20260917151554.017910608@linuxfoundation.org>
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

From: Geert Uytterhoeven <geert+renesas@glider.be>

[ Upstream commit 7f0c422c7fbfd9294ff9321ada0c63561e5c6ea0 ]

The number of clock cells is not validated in the clock provider's
clk_src_get() callback.  Add the missing check.

Signed-off-by: Geert Uytterhoeven <geert+renesas@glider.be>
Reviewed-by: Biju Das <biju.das.jz@bp.renesas.com>
Link: https://patch.msgid.link/46e010659ffdffd5e3541369f3b65d43ebe236ec.1777562043.git.geert+renesas@glider.be
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/clk/renesas/renesas-cpg-mssr.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/clk/renesas/renesas-cpg-mssr.c b/drivers/clk/renesas/renesas-cpg-mssr.c
index a0a68ec0490f7..87ede1ee64d7a 100644
--- a/drivers/clk/renesas/renesas-cpg-mssr.c
+++ b/drivers/clk/renesas/renesas-cpg-mssr.c
@@ -349,6 +349,9 @@ struct clk *cpg_mssr_clk_src_twocell_get(struct of_phandle_args *clkspec,
 	struct clk *clk;
 	int range_check;
 
+	if (clkspec->args_count != 2)
+		return ERR_PTR(-EINVAL);
+
 	switch (clkspec->args[0]) {
 	case CPG_CORE:
 		type = "core";
-- 
2.53.0



