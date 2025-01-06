Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E69491DE4F3;
	Mon,  6 Jan 2025 15:49:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736178565; cv=none; b=W4+knR5bv89dMTFT/0q+cvJo/anUiuAynzcjG85oHdveqIHQEs8gx3j6iutr7MD+uphxcTG7af/f3WSNw59cwPHFBUX/0YVEakFLNBrN44R0y/GYG68ah9vPh/OX9NGcP/M5hgW8lZ9qmrF2LtHIM68fewq1+ou5KonzrfoWyFs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736178565; c=relaxed/simple;
	bh=6LVsUY3V4Q/PyAn0iYsCAq9Gau6rBMCTS6s9rNqzLGg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=X1KgFM/d1gibhmx1Jq5PNnNBb3w5DzEONgRvmezcEiu4zF4JjRxXac/o9kAddWSLSxZ3o9VQFeoaImeoR/2nPD3YJOYwTmbeaDScxqoCzwC98CSCo+pR2JZx5kAFfx5qYsM1VbZaWnIfUVGh+gllD0yfFwRMBEfkApS3TQPYv/A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=0oqYOjiu; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="0oqYOjiu"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0BAC2C4CED2;
	Mon,  6 Jan 2025 15:49:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1736178564;
	bh=6LVsUY3V4Q/PyAn0iYsCAq9Gau6rBMCTS6s9rNqzLGg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=0oqYOjiuDL87At0q6C17yqpwCYY3Tai2G/lO5fF5+X7TsPsRQfNSt0chtnlfeibT6
	 JRYgpb9nk75jE58CST0Haxx1XQpKB/90VGdgz+MHC7wgqC2kYSijCH00cDVkmwiWfn
	 UAnEahmLKfMvZ/oGeJ1EObB8IHYm5WOWcIpoXzwk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Joe Hattori <joe@pf.is.s.u-tokyo.ac.jp>,
	Simon Horman <horms@kernel.org>,
	Paolo Abeni <pabeni@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 021/168] net: ethernet: bgmac-platform: fix an OF node reference leak
Date: Mon,  6 Jan 2025 16:15:29 +0100
Message-ID: <20250106151139.263950766@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20250106151138.451846855@linuxfoundation.org>
References: <20250106151138.451846855@linuxfoundation.org>
User-Agent: quilt/0.68
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

From: Joe Hattori <joe@pf.is.s.u-tokyo.ac.jp>

[ Upstream commit 0cb2c504d79e7caa3abade3f466750c82ad26f01 ]

The OF node obtained by of_parse_phandle() is not freed. Call
of_node_put() to balance the refcount.

This bug was found by an experimental static analysis tool that I am
developing.

Fixes: 1676aba5ef7e ("net: ethernet: bgmac: device tree phy enablement")
Signed-off-by: Joe Hattori <joe@pf.is.s.u-tokyo.ac.jp>
Reviewed-by: Simon Horman <horms@kernel.org>
Link: https://patch.msgid.link/20241214014912.2810315-1-joe@pf.is.s.u-tokyo.ac.jp
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/broadcom/bgmac-platform.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/broadcom/bgmac-platform.c b/drivers/net/ethernet/broadcom/bgmac-platform.c
index b4381cd41979..3f4e8bac40c1 100644
--- a/drivers/net/ethernet/broadcom/bgmac-platform.c
+++ b/drivers/net/ethernet/broadcom/bgmac-platform.c
@@ -171,6 +171,7 @@ static int platform_phy_connect(struct bgmac *bgmac)
 static int bgmac_probe(struct platform_device *pdev)
 {
 	struct device_node *np = pdev->dev.of_node;
+	struct device_node *phy_node;
 	struct bgmac *bgmac;
 	struct resource *regs;
 	int ret;
@@ -236,7 +237,9 @@ static int bgmac_probe(struct platform_device *pdev)
 	bgmac->cco_ctl_maskset = platform_bgmac_cco_ctl_maskset;
 	bgmac->get_bus_clock = platform_bgmac_get_bus_clock;
 	bgmac->cmn_maskset32 = platform_bgmac_cmn_maskset32;
-	if (of_parse_phandle(np, "phy-handle", 0)) {
+	phy_node = of_parse_phandle(np, "phy-handle", 0);
+	if (phy_node) {
+		of_node_put(phy_node);
 		bgmac->phy_connect = platform_phy_connect;
 	} else {
 		bgmac->phy_connect = bgmac_phy_connect_direct;
-- 
2.39.5



