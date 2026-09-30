Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C8F6F501F21;
	Wed, 30 Sep 2026 15:34:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790782480; cv=none; b=VgrsRXgJJXkXuGFmxWjAjJS0xrBgwVeVRcRGGUtuHcq7yiFCXP9fq7mmcc2akxCH9gis0eYr2uI9Nr3bqj2HNkEhRkvAhDR1wgQ9hwFuf7rFAS1guQVlq3PLz8viaQ/b085qbYCxEFuFJxPr3rY/OFTzw7KmvxAzoiE2xr+DkXE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790782480; c=relaxed/simple;
	bh=Z8RTzvlYi0o8rB7QQLn4wHcLWnI4tuQuvvpaH2WcUQI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=g+ZPaxeG3RGLg8+vEoU2V3IntGXTYqRjbUkqdu93x08vetkRIfyAh2fxY4Qhn4aah+sOWo46g7426h2WnnpThiqVs101mS0Ps5635EtycL+dTDkOGaV9kgpiOt7u3fSCoIa5c/lM7T7u0OfZoiuP1+tagDzjFdqZXvkSROaSY0g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ZZWKfZYF; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ZZWKfZYF"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 718091F00898;
	Wed, 30 Sep 2026 15:34:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790782465;
	bh=FEEOOKndV/TKhbGj9K+/fJLwvRTlGCfcbts+k9vmq5k=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ZZWKfZYFSiUHCsh4PJyl6zaosiAqEPpTI5wcmZTtTu+YjBFMoVzvRevqi5jVRjMs8
	 jruZE1LtiCw2UBJqgrUaGMparKD65GhHmrvsrSUpYydPZOtR9b79JqK2LszCa08Wa3
	 8NlrNDt480RsmaJvbah0F/G0kmenJfizK9G7Zlt4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Geert Uytterhoeven <geert+renesas@glider.be>,
	Biju Das <biju.das.jz@bp.renesas.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 019/595] clk: renesas: cpg-mssr: Add number of clock cells check
Date: Wed, 30 Sep 2026 17:18:32 +0200
Message-ID: <20260930152348.135793625@linuxfoundation.org>
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
index a5a68e1e75490..5be04e80c01a8 100644
--- a/drivers/clk/renesas/renesas-cpg-mssr.c
+++ b/drivers/clk/renesas/renesas-cpg-mssr.c
@@ -280,6 +280,9 @@ struct clk *cpg_mssr_clk_src_twocell_get(struct of_phandle_args *clkspec,
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



