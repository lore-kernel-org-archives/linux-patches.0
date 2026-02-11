Received: from n169-111.mail.139.com (n169-111.mail.139.com [120.232.169.111])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7578D285061
	for <patches@lists.linux.dev>; Wed, 11 Feb 2026 01:24:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=120.232.169.111
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770773045; cv=none; b=kS0lJce1rymUHJ0iZ44boJDxlYH9JQQRtlFH1DhnP9ju/IPUF5WnUkEs9s5aDSzbR8uMg8rgmT5r8CRwVAMLWTjb0AFASJTWyG0Cvmyp/2ykysr4WEDMt+Rk3suWxFVxYx2vrs4IfDrSVYvQwXXxzcq47BQQRTMp1WM6nEcdK8Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770773045; c=relaxed/simple;
	bh=HY4GxaF0TfbN5KzTEIMgAVRQnTDYujQobru3c6s0dTg=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=XI6jRZKBRvt4c7XA2bM7bg3H2ZsFGW8sBu6A0+PCZ5aRliCWPx+kGlBTsxjBkIbS0G2enAprtPXB2tOP/8CKQZ5WjN41TtSiuJIJRfRlfbjmgl4eW+9uLvGY3ib84yDXy58+VWaWWIB1OqVshDXFExv21k4QmLnBcYIN6uqDEgA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=139.com; spf=pass smtp.mailfrom=139.com; dkim=pass (1024-bit key) header.d=139.com header.i=@139.com header.b=k4rY8dyG; arc=none smtp.client-ip=120.232.169.111
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=139.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=139.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=139.com header.i=@139.com header.b="k4rY8dyG"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=139.com; s=dkim; l=0;
	h=from:subject:message-id:to:cc:mime-version;
	bh=47DEQpj8HBSa+/TImW+5JCeuQeRkm5NMpJWZG3hSuFU=;
	b=k4rY8dyGr+ZMmzENq7OohDKkBqouz9FEPkuvpZpoPy2YaK+fGQxhYpcBPyeZ+Q+QDqaRoIenyGLWP
	 SR5+0/xsXrRQzCd7gXlTkv4tYv5GSmppWI8powPt/dLQursmCCRm9N+Ujc5LLHySiwEJwG4NK9lJxg
	 oXFIH7Jrn3vN73gI=
X-RM-TagInfo: emlType=0                                       
X-RM-SPAM:                                                                                        
X-RM-SPAM-FLAG:00000000
Received:from NTT-kernel-dev (unknown[60.247.85.88])
	by rmsmtp-lg-appmail-18-12021 (RichMail) with SMTP id 2ef5698bda265d5-02609;
	Wed, 11 Feb 2026 09:23:52 +0800 (CST)
X-RM-TRANSID:2ef5698bda265d5-02609
From: Li hongliang <1468888505@139.com>
To: gregkh@linuxfoundation.org,
	stable@vger.kernel.org,
	u201911157@hust.edu.cn
Cc: patches@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	mturquette@baylibre.com,
	sboyd@kernel.org,
	matthias.bgg@gmail.com,
	angelogioacchino.delregno@collabora.com,
	miles.chen@mediatek.com,
	wenst@chromium.org,
	chun-jie.chen@mediatek.com,
	ikjn@chromium.org,
	weiyi.lu@mediatek.com,
	linux-clk@vger.kernel.org,
	linux-arm-kernel@lists.infradead.org,
	linux-mediatek@lists.infradead.org,
	dzm91@hust.edu.cn
Subject: [PATCH 6.1.y] clk: mediatek: fix of_iomap memory leak
Date: Wed, 11 Feb 2026 09:23:51 +0800
Message-Id: <20260211012351.2076922-1-1468888505@139.com>
X-Mailer: git-send-email 2.34.1
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Bosi Zhang <u201911157@hust.edu.cn>

[ Upstream commit 3db7285e044144fd88a356f5b641b9cd4b231a77 ]

Smatch reports:
drivers/clk/mediatek/clk-mtk.c:583 mtk_clk_simple_probe() warn:
    'base' from of_iomap() not released on lines: 496.

This problem was also found in linux-next. In mtk_clk_simple_probe(),
base is not released when handling errors
if clk_data is not existed, which may cause a leak.
So free_base should be added here to release base.

Fixes: c58cd0e40ffa ("clk: mediatek: Add mtk_clk_simple_probe() to simplify clock providers")
Signed-off-by: Bosi Zhang <u201911157@hust.edu.cn>
Reviewed-by: Dongliang Mu <dzm91@hust.edu.cn>
Link: https://lore.kernel.org/r/20230422084331.47198-1-u201911157@hust.edu.cn
Signed-off-by: Stephen Boyd <sboyd@kernel.org>
Signed-off-by: Li hongliang <1468888505@139.com>
---
 drivers/clk/mediatek/clk-mtk.c | 7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)

diff --git a/drivers/clk/mediatek/clk-mtk.c b/drivers/clk/mediatek/clk-mtk.c
index 7b1ad73309b1..c2ca3d7576c2 100644
--- a/drivers/clk/mediatek/clk-mtk.c
+++ b/drivers/clk/mediatek/clk-mtk.c
@@ -505,8 +505,10 @@ int mtk_clk_simple_probe(struct platform_device *pdev)
 	num_clks += mcd->num_mux_clks;
 
 	clk_data = mtk_alloc_clk_data(num_clks);
-	if (!clk_data)
-		return -ENOMEM;
+	if (!clk_data) {
+		r = -ENOMEM;
+		goto free_base;
+	}
 
 	if (mcd->fixed_clks) {
 		r = mtk_clk_register_fixed_clks(mcd->fixed_clks,
@@ -594,6 +596,7 @@ int mtk_clk_simple_probe(struct platform_device *pdev)
 					      mcd->num_fixed_clks, clk_data);
 free_data:
 	mtk_free_clk_data(clk_data);
+free_base:
 	if (mcd->shared_io && base)
 		iounmap(base);
 
-- 
2.34.1


