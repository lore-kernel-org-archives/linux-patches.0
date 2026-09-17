Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E6740399D0B;
	Thu, 17 Sep 2026 17:48:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789667324; cv=none; b=Bxu4PkgQj2fEbRInZpnxc1VWdCyYmlkUnqka2Bo4AUpFzzCaOZdOVQyVcI1Qgj4X0e4QOM5T7OMrZlMZIgxfR8LRRDvfdi+D6CU8Llg4qmaFgTCzrcrw/OcDNBRO9kIvEyuzzch6blLKRcFbFpSBkIaBpvm8Vit8BHYwSX7OYc8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789667324; c=relaxed/simple;
	bh=qqmb6q6pbh2OF8d/uii1rdJ9lB11RahpZPhFP3asAVk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=K0QAn0/eF03T/E/0CHsBCTek0y1Dd9ysmW5x0k/lc0NWlEPcUioRY4MDY/vuVdsQNfyaNjX40pm3wa9HNWwLZhP6RUU4dwzyhFrHC/uZc1sedw910esP9ezy4QNGRVn6Bmh7diVlrfUv4wsfNmNZFOhJCUrsCSPbnqZ0DVWvcPw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=rxY6mrEy; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="rxY6mrEy"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DA1151F000FF;
	Thu, 17 Sep 2026 17:48:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789667322;
	bh=WX6SjIyxHYqWKTYYMSsl4UgTasy3KLheBYQHkBBJFUY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=rxY6mrEyn1bFrQwYptd5AVf/y0jpOKaqxbng0IWp6drPyYSHA4KaBHLdbhVmhVI44
	 Sqn30jsn9sbULJ8PeK1JAid0DaWvLEWb3kMb7T15uiiVqb2IRUU6BPGNWqF4oAm2U0
	 56JI2jKbRc/+lFl3KDxf7rZf8648F4lOPV7QDBkc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Geert Uytterhoeven <geert+renesas@glider.be>,
	Biju Das <biju.das.jz@bp.renesas.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 0055/1102] clk: renesas: cpg-mssr: Add number of clock cells check
Date: Thu, 17 Sep 2026 15:59:58 +0100
Message-ID: <20260917151540.833382976@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260917151539.408551884@linuxfoundation.org>
References: <20260917151539.408551884@linuxfoundation.org>
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
index e0f0dc8c0e56d..d6b26e3bc799c 100644
--- a/drivers/clk/renesas/renesas-cpg-mssr.c
+++ b/drivers/clk/renesas/renesas-cpg-mssr.c
@@ -283,6 +283,9 @@ struct clk *cpg_mssr_clk_src_twocell_get(struct of_phandle_args *clkspec,
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



