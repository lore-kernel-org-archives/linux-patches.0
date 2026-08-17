Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CB36343CE64;
	Mon, 17 Aug 2026 15:15:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786979721; cv=none; b=C/KRy5jSpBkcEBUuzjp3IMmu9nC7ebsG8851d7e2fFLLupARas/nrPx9LE2rDqZV5Dh5fYy2E6QHykWVOWxTUJeizEWCzLwLSnuzt4wU/mrD4vriWKBTUk95Pt3NWns/HSYCkx3MLUvMJsLs4Vnh9di/f8+LNNVTbiNnDEGZyPY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786979721; c=relaxed/simple;
	bh=9jIk6Xxstq56tfQssFKZq32R+gwVg6g7HWLpI1knpcc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=LotcHfdpe3HqOZ4bNlFUypjri4aut14pZJGrCGJ+ZQZidSpbM/dBElF/+/0Tc+jhrb9YKFBKhBJIX+qJP8S8c7u1kHoVXgKeZ88ur7AYC37cJnsxGEKNL+jGT0sxZjI7dQsfExVXyaOShVffHwZ3FhVkJb0BwYnh4NPMXNv1AZk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=xbt7nAz2; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="xbt7nAz2"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 267C61F000E9;
	Mon, 17 Aug 2026 15:15:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1786979719;
	bh=qzClMkGNCXkX+ficUiq7DenIEJHxVgM4RQLpOf93DUs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=xbt7nAz2ZDJo6Lw6FASanxk0/kSWpvGfqt6CjGTJUSqn3WWgxwIZ5JlQ3hpsMWsXg
	 e++84Oq4jKzWYw2PAVRDjDX37+9muSF6dUKzqA0hhx6hW/myz8DR/kTuALdTiIpXeH
	 InY0mIRIDVBqbSBxUbBgvz/IZ792veYQSJZQptPg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sean Anderson <sean.anderson@seco.com>,
	Vinod Koul <vkoul@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 317/609] phy: zynqmp: Allow variation in refclk rate
Date: Mon, 17 Aug 2026 15:30:13 +0200
Message-ID: <20260817132554.854656611@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260817132543.039278408@linuxfoundation.org>
References: <20260817132543.039278408@linuxfoundation.org>
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

From: Sean Anderson <sean.anderson@seco.com>

[ Upstream commit 76009ee76e05e30e29aade02e788aebe9ce9ffd2 ]

Due to limited available frequency ratios, the reference clock rate may
not be exactly the same as the required rate. Allow a small (100 ppm)
deviation.

Signed-off-by: Sean Anderson <sean.anderson@seco.com>
Link: https://lore.kernel.org/r/20230711194542.898230-1-sean.anderson@seco.com
Signed-off-by: Vinod Koul <vkoul@kernel.org>
Stable-dep-of: e4779e2a16d6 ("phy: zynqmp: fix clock error handling in xpsgtr_phy_init()")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/phy/xilinx/phy-zynqmp.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/drivers/phy/xilinx/phy-zynqmp.c b/drivers/phy/xilinx/phy-zynqmp.c
index cc36fb7616ae4..00ceeca2a395f 100644
--- a/drivers/phy/xilinx/phy-zynqmp.c
+++ b/drivers/phy/xilinx/phy-zynqmp.c
@@ -958,7 +958,10 @@ static int xpsgtr_get_ref_clocks(struct xpsgtr_dev *gtr_dev)
 		rate = clk_get_rate(clk);
 
 		for (i = 0 ; i < ARRAY_SIZE(ssc_lookup); i++) {
-			if (rate == ssc_lookup[i].refclk_rate) {
+			/* Allow an error of 100 ppm */
+			unsigned long error = ssc_lookup[i].refclk_rate / 10000;
+
+			if (abs(rate - ssc_lookup[i].refclk_rate) < error) {
 				gtr_dev->refclk_sscs[refclk] = &ssc_lookup[i];
 				break;
 			}
-- 
2.53.0



