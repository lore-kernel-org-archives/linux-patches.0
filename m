Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 80118531603;
	Wed, 30 Sep 2026 17:50:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790790640; cv=none; b=MO5JZbQaxeQelC9xhhchqgeztsbgsQYGaZygixFHV2io1OqLRE9HoQYg1i0Y6QuPDfM5K6DhsTJWyND00cHTqoYxKYq2uz+Jtik2sBi3Meabon8JmZG376mxT0hn0vRwDc1XFDamhm+583/21/BNBJdloLrMDJx4hen2X/kxxVU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790790640; c=relaxed/simple;
	bh=/wVAHwXZW+nEwJ/Zpp1j4w3Wo9m7mifS1vEJRs+4Q+8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=KfGbXOMYnjx4Rrz0wN6BTpWNoNqtW3liDMcEN5/Z/tttENR7KyH4UsumOztqGnnYlN1B7kuMxKwhTv7j6kXCQr95qlCCUMjR+WKfyCSEhtToI6KWxlmnakcPQDiYljri8AYQoZ/PpbTOA+tF8pM942cJFHCjEHa+fr4CCxgg3F4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=NKd0Ue5v; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="NKd0Ue5v"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 954C11F000FF;
	Wed, 30 Sep 2026 17:50:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790790639;
	bh=xM/4NLCfUVbdfCBbe5rKzKwRmBsZkAd5fudGS7wbs5Q=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=NKd0Ue5vYb+uGx1vHOaCdaYC/24wgBfWXfcVoY6fqChUL0KWZRFtBdqKoM1pscujP
	 x6E601NLvfho5hnplGeHUY80t+h+Z3KHq6DMu5pHBjzLqDTOQFbjc07o8BlDHAQHJb
	 Nm94CV1Lrk39yuaUhR4FEKdSKz2EWL7sBNHWIGWc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Geert Uytterhoeven <geert+renesas@glider.be>,
	Biju Das <biju.das.jz@bp.renesas.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 022/752] clk: renesas: cpg-mssr: Add number of clock cells check
Date: Wed, 30 Sep 2026 17:18:12 +0200
Message-ID: <20260930152358.631311631@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260930152358.131179731@linuxfoundation.org>
References: <20260930152358.131179731@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
index 54c5d35fe2ae3..31558e443cc64 100644
--- a/drivers/clk/renesas/renesas-cpg-mssr.c
+++ b/drivers/clk/renesas/renesas-cpg-mssr.c
@@ -277,6 +277,9 @@ struct clk *cpg_mssr_clk_src_twocell_get(struct of_phandle_args *clkspec,
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



