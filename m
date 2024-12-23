Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A4B7C2EAE6;
	Mon, 23 Dec 2024 16:04:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734969885; cv=none; b=knYByVJzacnQoBenPmOQm6LzAQctoBBl7GO0EJboes3KFuzU3B0uNpyfmr4QTuW3NXNQv9m9m5/+2QYtpojIyFKobMx5lV5W7UhPESHocuCsiGS/ihSVPGuoKRfUHKyN9cRVS7b1tCZkzjzQfnArDPJ8jOSCPSIj0itTYz8wYFA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734969885; c=relaxed/simple;
	bh=AkEdCqBkDTKb69fsXjkDhbelkaK920bn5bGMUcZf2Yo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=IITagVznCeztuJjas2VyABJnRUc/XnjE1/fWXmgZDfp6saU/dhhSzc6mgCC80I5Ds3ZUaG1t7NlMxu0+NOvIkADizyMo3gUYRgmi9BxamNTnt+angIycFnsxyrzbHbvkJYRqYrxm//1MLmv1Eh0evjGJ1G8+Xp5WZOruFgqJMu4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=gY1t2+rh; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="gY1t2+rh"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2A83AC4CED3;
	Mon, 23 Dec 2024 16:04:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1734969885;
	bh=AkEdCqBkDTKb69fsXjkDhbelkaK920bn5bGMUcZf2Yo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=gY1t2+rhIvKROirzA0ga+7GqdohBvmTZDY7DiGdbPiRJRRquxfY/EODAmZUiXF51q
	 udqF0+bnpXyKdPjZNBoTt9P4eEksDgwCmda4Ep4DD5CFV51kk/9enJvcMKRBSVScG1
	 jCn2dpqkgUfF5DhDgZ1iI1EsEUhfsw+vkFWLGepA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Joe Hattori <joe@pf.is.s.u-tokyo.ac.jp>,
	Simon Horman <horms@kernel.org>,
	Paolo Abeni <pabeni@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 052/160] net: ethernet: bgmac-platform: fix an OF node reference leak
Date: Mon, 23 Dec 2024 16:57:43 +0100
Message-ID: <20241223155410.697103867@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241223155408.598780301@linuxfoundation.org>
References: <20241223155408.598780301@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
index 77425c7a32db..78f7862ca006 100644
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



