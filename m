Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A11F1263F44;
	Sat, 30 May 2026 17:19:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780161573; cv=none; b=grkrSV82oeO7oRrUQswAkoLNEBITeu7oL1sBYWR7qQ7EuWTnxe9zQuAcx20jK0RBm/kO+GIRP689ZRhrWuBAkXyLjPNPEUOmoh8rXwK2pOnUavrTjhw+X57YQ8BSmCbQsbfIeQwJtxh9hTTdiZzx/Y/49XWtr3ZxNx0OGEMUGuU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780161573; c=relaxed/simple;
	bh=raCq8dQ7rvg/86HLuHYFDJ7vYOeE5zUIlg7BvtxCnyg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=baN0mG7q4o23ex78EVV7xmsDVZnFBWnIGyEtJs7oVpZr4OeL+e+KwqT00yT4lAF+lZPriBl9HRuwrRylvRqi9/SIjUnlxNkFAZ8NO09RvG49iQOc0lOStP6S5SIJsGOtC5sbslsTa8JbGH8Vn2LFwL7lpA52xX7tWOk5zsi36ZE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=gmlxpmpQ; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="gmlxpmpQ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E22D61F00893;
	Sat, 30 May 2026 17:19:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1780161572;
	bh=SDBBdSV62zNUrf0+5GkPFS8oaHQU4lplAvI+YcQS16E=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=gmlxpmpQGhYWUz/UPw2RSX2xpREs5xXnjWX8viS/vLfRWZIM65SIMMCYGEiMt8luW
	 pp8xLQ5hxyo5KJOTz3UQMDLr8/Z33+LZ/GP1xRDpmhCWrKWcG5wns2Lg3eAmTHfXW7
	 5OW7ge+NvJNDm2rSan8T2w6easzeXD/1RYHljpRk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Geert Uytterhoeven <geert+renesas@glider.be>,
	Brian Masney <bmasney@redhat.com>,
	Stephen Boyd <sboyd@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 662/969] clk: xgene: Fix mapping leak in xgene_pllclk_init()
Date: Sat, 30 May 2026 18:03:06 +0200
Message-ID: <20260530160318.758707860@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260530160300.485627683@linuxfoundation.org>
References: <20260530160300.485627683@linuxfoundation.org>
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

From: Geert Uytterhoeven <geert+renesas@glider.be>

[ Upstream commit f520a492e07bc6718e26cfb7543ab4cadd8bb0e2 ]

If xgene_register_clk_pll() fails, the mapped register block is never
unmapped.

Fixes: 308964caeebc45eb ("clk: Add APM X-Gene SoC clock driver")
Signed-off-by: Geert Uytterhoeven <geert+renesas@glider.be>
Reviewed-by: Brian Masney <bmasney@redhat.com>
Signed-off-by: Stephen Boyd <sboyd@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/clk/clk-xgene.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/clk/clk-xgene.c b/drivers/clk/clk-xgene.c
index 0c3d0cee98c83..a542b78d9c731 100644
--- a/drivers/clk/clk-xgene.c
+++ b/drivers/clk/clk-xgene.c
@@ -187,6 +187,8 @@ static void xgene_pllclk_init(struct device_node *np, enum xgene_pll_type pll_ty
 		of_clk_add_provider(np, of_clk_src_simple_get, clk);
 		clk_register_clkdev(clk, clk_name, NULL);
 		pr_debug("Add %s clock PLL\n", clk_name);
+	} else {
+		iounmap(reg);
 	}
 }
 
-- 
2.53.0



