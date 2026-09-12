Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0346036E484;
	Sat, 12 Sep 2026 08:00:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789200004; cv=none; b=fRhmfveHP4N2Uv8pjq0jcLd6nfbH16keGPp1Z8qr7UUHSeZsn4u8uddbnuYI/VpT+VTi4ZSRv2aRODCLyvwbDI8x27ADAhtxMAqtLrtH0tFBkyYNdAx+uOJSFvWmPwo1pwH4OgEvpmXN+dPuRwPpQSJZOqS3v4lo3ubNeRN+Y5o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789200004; c=relaxed/simple;
	bh=tyvmucMbZySdJwH501vuHSoYkYi2U2j4cMWHd7NW42o=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=piYzfbQT36Y9TGPreg9/K4iLt29HAWZ6yKQlFvf+V916SuZhxGIzQhomW2v+fuKnIAmBEoD3k+R4kzSRVbTSaLKzNs7Ue0VFuA1KAD+EflLwGGME8Cu9loTE3h78wQhVUA3uDt6Dg7dV8XtaR22Hrvl2BOcLVcVJimJ9haVFK04=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=xUkCqQG4; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="xUkCqQG4"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B06081F000FF;
	Sat, 12 Sep 2026 08:00:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789200002;
	bh=h+iq6CGxASXrLfNOmcKhC2pTOxt2lIl/B9CJZWjps4k=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=xUkCqQG4Amj/+pqaSaL+zArwkli7Fx9TZ+Srt72/4WVGUtp4UCk6iuzMI4jxsww/H
	 /hidxnwYqNZzB7t3h11vDYVg+8EwP6Ub6Qprkf5a+G+Hf4b0orbOA2ywkohcQ52Ydl
	 6svsWM2GX4sqVWUPo2kzciE+8yntFqKZrr4oPUJ8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ijae Kim <ae878000@gmail.com>,
	Myeonghun Pak <mhun512@gmail.com>,
	Brian Masney <bmasney@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.2 0684/1815] clk: mediatek: mt6735: Unregister PLLs on probe failure
Date: Sat, 12 Sep 2026 08:40:34 +0200
Message-ID: <20260912065704.946140452@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065648.999753832@linuxfoundation.org>
References: <20260912065648.999753832@linuxfoundation.org>
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

7.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Myeonghun Pak <mhun512@gmail.com>

[ Upstream commit 935ad6242c47b37380d0cb7ec366516fe11855b4 ]

mtk_clk_register_plls() registers the apmixedsys PLL clocks manually, while
clk_mt6735_apmixed_remove() unregisters them on driver removal.

If devm_of_clk_add_hw_provider() fails after the PLL registration succeeds,
probe returns the error directly and the remove callback is not run. This
leaves the registered PLL clocks behind on the probe failure path.

Unregister the PLLs in that failure branch before returning the error.

Fixes: 43c04ed79189 ("clk: mediatek: Add drivers for MediaTek MT6735 main clock and reset drivers")
Co-developed-by: Ijae Kim <ae878000@gmail.com>
Signed-off-by: Ijae Kim <ae878000@gmail.com>
Signed-off-by: Myeonghun Pak <mhun512@gmail.com>
Reviewed-by: Brian Masney <bmasney@redhat.com>
Signed-off-by: Brian Masney <bmasney@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/clk/mediatek/clk-mt6735-apmixedsys.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/drivers/clk/mediatek/clk-mt6735-apmixedsys.c b/drivers/clk/mediatek/clk-mt6735-apmixedsys.c
index 9e30c089a2092..b6eb6a581c31e 100644
--- a/drivers/clk/mediatek/clk-mt6735-apmixedsys.c
+++ b/drivers/clk/mediatek/clk-mt6735-apmixedsys.c
@@ -102,9 +102,12 @@ static int clk_mt6735_apmixed_probe(struct platform_device *pdev)
 
 	ret = devm_of_clk_add_hw_provider(&pdev->dev, of_clk_hw_onecell_get,
 					  clk_data);
-	if (ret)
+	if (ret) {
 		dev_err(&pdev->dev,
 			"Failed to register clock provider: %d\n", ret);
+		mtk_clk_unregister_plls(apmixedsys_plls, ARRAY_SIZE(apmixedsys_plls),
+					clk_data);
+	}
 
 	return ret;
 }
-- 
2.53.0



