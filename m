Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E387813D635;
	Thu, 13 Jun 2024 12:07:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718280477; cv=none; b=EAQqkMr0P+fJQAPrE0gDTa0vqnsFuh2hYNZ/04s5xmH1uN/hlkJo6088MNzIMQlp3oA+jTqG7KB7Whe0Xqdh4wp0S+d/56CJvBrbxgwxGf3UsJhwv2Pojn2LslWDaTHKH2dHDBc3WsNjhA98DRXbOFX88Uav4VBSDr9ovGWm0i8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718280477; c=relaxed/simple;
	bh=TJHzAPgqcrGNGwhw+Vj055e/amSrvMA28H4qOmvWMp0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=PuOg3AvkyAxeSHI47/NpPP5SK3xIe+R54y7pOZNMnTe63EcGWiVkggT87Yq57jDc4Jr8CntY16yObc8D7H3LMaYk3ymYvr9iYRqo8iSuflBSOrhs25YzpBVG4cnYekBWLqlbmduvrykTBs4LTrxVsd7ECaORW+BRCu8ny/Tlf5Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Y5U2w0cI; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Y5U2w0cI"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6A23EC32786;
	Thu, 13 Jun 2024 12:07:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1718280476;
	bh=TJHzAPgqcrGNGwhw+Vj055e/amSrvMA28H4qOmvWMp0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Y5U2w0cIG956OSiD7Z+8hxhD47TYnWzsfpq96yvMNZUGMxXOGapUGUHDUwXEXMWaj
	 AATwM9Ojk8sIfl9rycDgz/6hesKiktpvG6EjW1CackE2XXCOTxoIqu6vTyMMzdPUA9
	 rZ1ZoHSRFNB4AiktVMmDseoApiR5r+cZjGCuOmMY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Nathan Chancellor <nathan@kernel.org>,
	Kees Cook <keescook@chromium.org>,
	Florian Fainelli <florian.fainelli@broadcom.com>,
	Stephen Boyd <sboyd@kernel.org>
Subject: [PATCH 6.6 066/137] clk: bcm: dvp: Assign ->num before accessing ->hws
Date: Thu, 13 Jun 2024 13:34:06 +0200
Message-ID: <20240613113225.860589554@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240613113223.281378087@linuxfoundation.org>
References: <20240613113223.281378087@linuxfoundation.org>
User-Agent: quilt/0.67
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

From: Nathan Chancellor <nathan@kernel.org>

commit 9368cdf90f52a68120d039887ccff74ff33b4444 upstream.

Commit f316cdff8d67 ("clk: Annotate struct clk_hw_onecell_data with
__counted_by") annotated the hws member of 'struct clk_hw_onecell_data'
with __counted_by, which informs the bounds sanitizer about the number
of elements in hws, so that it can warn when hws is accessed out of
bounds. As noted in that change, the __counted_by member must be
initialized with the number of elements before the first array access
happens, otherwise there will be a warning from each access prior to the
initialization because the number of elements is zero. This occurs in
clk_dvp_probe() due to ->num being assigned after ->hws has been
accessed:

  UBSAN: array-index-out-of-bounds in drivers/clk/bcm/clk-bcm2711-dvp.c:59:2
  index 0 is out of range for type 'struct clk_hw *[] __counted_by(num)' (aka 'struct clk_hw *[]')

Move the ->num initialization to before the first access of ->hws, which
clears up the warning.

Cc: stable@vger.kernel.org
Fixes: f316cdff8d67 ("clk: Annotate struct clk_hw_onecell_data with __counted_by")
Signed-off-by: Nathan Chancellor <nathan@kernel.org>
Link: https://lore.kernel.org/r/20240425-cbl-bcm-assign-counted-by-val-before-access-v1-1-e2db3b82d5ef@kernel.org
Reviewed-by: Kees Cook <keescook@chromium.org>
Reviewed-by: Florian Fainelli <florian.fainelli@broadcom.com>
Signed-off-by: Stephen Boyd <sboyd@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/clk/bcm/clk-bcm2711-dvp.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/clk/bcm/clk-bcm2711-dvp.c b/drivers/clk/bcm/clk-bcm2711-dvp.c
index e4fbbf3c40fe..3cb235df9d37 100644
--- a/drivers/clk/bcm/clk-bcm2711-dvp.c
+++ b/drivers/clk/bcm/clk-bcm2711-dvp.c
@@ -56,6 +56,8 @@ static int clk_dvp_probe(struct platform_device *pdev)
 	if (ret)
 		return ret;
 
+	data->num = NR_CLOCKS;
+
 	data->hws[0] = clk_hw_register_gate_parent_data(&pdev->dev,
 							"hdmi0-108MHz",
 							&clk_dvp_parent, 0,
@@ -76,7 +78,6 @@ static int clk_dvp_probe(struct platform_device *pdev)
 		goto unregister_clk0;
 	}
 
-	data->num = NR_CLOCKS;
 	ret = of_clk_add_hw_provider(pdev->dev.of_node, of_clk_hw_onecell_get,
 				     data);
 	if (ret)
-- 
2.45.2



