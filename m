Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 22EFD1D079C;
	Wed,  2 Oct 2024 14:41:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727880073; cv=none; b=W8706OgvnIlUgOoOSwcChmr9SyQOY2yggmR8bJmM+Qqw52bD0JhIptlx/3fJCZTSEYY/vr9AXGELVuBiC1RTsz92xuFHEM4yEsOEGBb5xbkaW6THdO6JTMGJ2V+FY6+k4XYGcWin9wbmhvibuCdpiDeS9rxvdQ+yt6lWVpj2TNo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727880073; c=relaxed/simple;
	bh=WOnFDK+bikbZzLZ//Y/XlQnlcNNQlHlPiR8nxrfjiVI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=MVT2i5ZVkEoEjwib3f4S/qlOll7DCm2e2z48lyZIMjn0enSsvnZLJpaVnTTS1oLziSWFybMWwRiWJJ5vzD5yZBNrf9K6ymQl6cHbX0QugSFiiRJxKSZitN6A2A+/KzpeTy8SqGb+IvfezSy+O6aVPVrvZmx+rBLmpGGG/9ebKds=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=bLhqdDhJ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="bLhqdDhJ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A15BAC4CEC2;
	Wed,  2 Oct 2024 14:41:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1727880073;
	bh=WOnFDK+bikbZzLZ//Y/XlQnlcNNQlHlPiR8nxrfjiVI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=bLhqdDhJGZMDnHOapxiKUCWFDR6CX/SuUHVdOq8KpqoMVd3kZo6yKFcEojFzAlmof
	 57k7u2zRx90AHa0HitGEbEuFOQrNliyooPyTzLZu483leS5tykoaqkkcMRWdUioOcf
	 NciGJJnvOdssGmf/vuA2Y+pDoy3j9sak98EXGHQM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	David Lechner <dlechner@baylibre.com>,
	Stephen Boyd <sboyd@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 304/538] clk: ti: dra7-atl: Fix leak of of_nodes
Date: Wed,  2 Oct 2024 14:59:03 +0200
Message-ID: <20241002125804.416388733@linuxfoundation.org>
X-Mailer: git-send-email 2.46.2
In-Reply-To: <20241002125751.964700919@linuxfoundation.org>
References: <20241002125751.964700919@linuxfoundation.org>
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
index d964e3affd42c..0eab7f3e2eab9 100644
--- a/drivers/clk/ti/clk-dra7-atl.c
+++ b/drivers/clk/ti/clk-dra7-atl.c
@@ -240,6 +240,7 @@ static int of_dra7_atl_clk_probe(struct platform_device *pdev)
 		}
 
 		clk = of_clk_get_from_provider(&clkspec);
+		of_node_put(clkspec.np);
 		if (IS_ERR(clk)) {
 			pr_err("%s: failed to get atl clock %d from provider\n",
 			       __func__, i);
-- 
2.43.0



