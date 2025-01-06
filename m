Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 33258146D6B;
	Mon,  6 Jan 2025 15:42:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736178165; cv=none; b=FeY5cpjzChNWtYk3Ml4JznY55LbSIeNMbmYyTZjcAN9B2Dc3b8ZuYxOU60sWku1XkRFXCm8e2RseJykUJp8XJd4QZ318T3WQH2HDfe6fYskwX5R6PbtpsocDp+G2yRXxGTHEvSz7H0JbNS4qLp5wbSZcCh81L5mtKEySfz+rTaU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736178165; c=relaxed/simple;
	bh=01R9D6F1DKw4N9g3xfQbixEXGR4tQ/Fs+EV7HLBuC4k=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=UCsr+M/2cw6oNx4uCT5XtrbIhG0yeLOReInvb2bjpBHdFZ5L18g9YehZusw+3vSFWRLLLCv/Nzrkg4kiANvkD5HPmYv6DCX1Xb5AjiZvrkIz5BI4DIUFaYU2wVTLPis1namR6ePTQQuWXZABK8PLES7DF4T6yHOuAjIsdpi84MI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=gFJIvJeY; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="gFJIvJeY"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id ACE30C4CED2;
	Mon,  6 Jan 2025 15:42:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1736178165;
	bh=01R9D6F1DKw4N9g3xfQbixEXGR4tQ/Fs+EV7HLBuC4k=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=gFJIvJeYAgUTSk3OVauPHzyKaWnggfTtLk27r7fULMc/HZfBPVXhVVoZqP2LT+QKL
	 jBCXCCXP+SXzV9qdHCgLAkFHZlKf4btybqKiwc6zIGs0UrQ+a0MhvvhnWLcgWTU23F
	 hU0oNcNqW8kSUHgxkxjJgOMzVAwCGeXEr+FpUfhM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Joe Hattori <joe@pf.is.s.u-tokyo.ac.jp>,
	Simon Horman <horms@kernel.org>,
	Paolo Abeni <pabeni@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 019/138] net: ethernet: bgmac-platform: fix an OF node reference leak
Date: Mon,  6 Jan 2025 16:15:43 +0100
Message-ID: <20250106151133.946360900@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20250106151133.209718681@linuxfoundation.org>
References: <20250106151133.209718681@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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
index f37f1c58f368..c2e0bc1326fe 100644
--- a/drivers/net/ethernet/broadcom/bgmac-platform.c
+++ b/drivers/net/ethernet/broadcom/bgmac-platform.c
@@ -171,6 +171,7 @@ static int platform_phy_connect(struct bgmac *bgmac)
 static int bgmac_probe(struct platform_device *pdev)
 {
 	struct device_node *np = pdev->dev.of_node;
+	struct device_node *phy_node;
 	struct bgmac *bgmac;
 	struct resource *regs;
 	const u8 *mac_addr;
@@ -232,7 +233,9 @@ static int bgmac_probe(struct platform_device *pdev)
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



