Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DF686145B18;
	Mon, 14 Oct 2024 15:00:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728918060; cv=none; b=Bh7HXZLEe9lvbvF2whrm5Xcqv8aAcPp1KH4BrhXIOmDEM+fmq8IdFRWrww+BHx8JpVpWWDvhV2FJvdhdBzwSgwT3z08PyOhoecTN8DbvF9Sur8DN6+fUc2xX0Q+7yvTzgUDFQIMRRaZRNhxy6E5Ygm38HbPKykkke+ezXXDozVQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728918060; c=relaxed/simple;
	bh=T6jqKofW9RS7NSJUBHGBsZoWickE1RUoP5fxQLep58E=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=LiKmnzl2iQfiRl5rmxLfsVzO3+xwwLATRWIJ0Vh0NxN/rch78yTnlfecW4Y1SI28TwkOu0OxwL0KbMTgxwpHj7H+oZKTfZshGuzE/XRI0BL2a+rUEq6U8rT/hBfhUC2AFelARUZ/icMEQh+aGA+3ZYK9oErVSiIhv1ov0hymbU4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=GiCIKzIL; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="GiCIKzIL"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4F979C4CEC3;
	Mon, 14 Oct 2024 15:00:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1728918059;
	bh=T6jqKofW9RS7NSJUBHGBsZoWickE1RUoP5fxQLep58E=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=GiCIKzILBjv3AL/cyZNGcvz+tdfjMfsaT7obtzHUV2nJMGjWfMI8jXh/IXQaGLdb0
	 uzU8rZHKHQMKuuKhT8gm1kZYoLao5qsKQSQOAZrKNubyZ8ALmIjloNTs+SyiVzl6WT
	 YTomPGW4dst5O8QpOg/r3DJ5jMMBW1OtGUOi51fo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	David Lechner <dlechner@baylibre.com>,
	Stephen Boyd <sboyd@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 210/798] clk: ti: dra7-atl: Fix leak of of_nodes
Date: Mon, 14 Oct 2024 16:12:44 +0200
Message-ID: <20241014141226.182820369@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241014141217.941104064@linuxfoundation.org>
References: <20241014141217.941104064@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: David Lechner <dlechner@baylibre.com>

[ Upstream commit 9d6e9f10e2e031fb7bfb3030a7d1afc561a28fea ]

This fix leaking the of_node references in of_dra7_atl_clk_probe().

The docs for of_parse_phandle_with_args() say that the caller must call
of_node_put() on the returned node. This adds the missing of_node_put()
to fix the leak.

Fixes: 9ac33b0ce81f ("CLK: TI: Driver for DRA7 ATL (Audio Tracking Logic)")
Signed-off-by: David Lechner <dlechner@baylibre.com>
Link: https://lore.kernel.org/r/20240826-clk-fix-leak-v1-1-f55418a13aa6@baylibre.com
Signed-off-by: Stephen Boyd <sboyd@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/clk/ti/clk-dra7-atl.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/clk/ti/clk-dra7-atl.c b/drivers/clk/ti/clk-dra7-atl.c
index 1c576599f6dbd..32b8adfa8bbf6 100644
--- a/drivers/clk/ti/clk-dra7-atl.c
+++ b/drivers/clk/ti/clk-dra7-atl.c
@@ -250,6 +250,7 @@ static int of_dra7_atl_clk_probe(struct platform_device *pdev)
 		}
 
 		clk = of_clk_get_from_provider(&clkspec);
+		of_node_put(clkspec.np);
 		if (IS_ERR(clk)) {
 			pr_err("%s: failed to get atl clock %d from provider\n",
 			       __func__, i);
-- 
2.43.0



