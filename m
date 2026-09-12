Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3D216311597;
	Sat, 12 Sep 2026 10:18:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789208303; cv=none; b=VhKNpCeN4lYfLpS1Uat9EiIEc1njAjv0HeFEnWR9DtxIyPASbmjsgdeoHFD/4EJqpGrzBKMV110XlN+mF4XJMsbPdmPm7mbW7Dw8I5s4sqrfzEONU5IYyvy4H+es6gtyx5hAck075eD57wMPJ49PDiQxZPntUePAWHLMt09JGWw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789208303; c=relaxed/simple;
	bh=aYj7ti1OjRVuj5VDn1kz1eLZpgnNYBEBMu36KInmWQg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=m3xuXt9prjqNgi78bZLfLfOtPpHOwfG0I7RFvjC8B401oUT6//3dB+D4n8qqikXN7q7bf0J16H/X5/1CDru/0npp02bU5iue9CRd0S+xEnlSt3qnwcnXoQCfk291t2KnIGjfwHWvqe5xt1w0y8twoxwK48EeGcyrv4l2uHW4kLA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=zKTM3Rqd; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="zKTM3Rqd"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E69B71F000FF;
	Sat, 12 Sep 2026 10:18:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789208301;
	bh=HA+yuVqkoLL7BDFX99+SomDMjTbKkKycEkG1/yr3pVY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=zKTM3RqdHqVe9CgSHH5mM4d0q0D1FgKRZq9JrLkaaVS8pLK1N8wy2EIUE6CnC/JW/
	 H+a2a7+cWFO7mrvcUMzHLmrGDnMrorg5OlmLX1+sAxgC3B20Ej0xmD8l4ymxH7ErMd
	 IinOY+1KwXucxAOOcireTK4UW7C9WKqx3CwaNK3Y=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ijae Kim <ae878000@gmail.com>,
	Myeonghun Pak <mhun512@gmail.com>,
	Brian Masney <bmasney@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0589/1518] clk: mediatek: mt6735: Unregister PLLs on probe failure
Date: Sat, 12 Sep 2026 08:45:58 +0200
Message-ID: <20260912065636.751122940@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065623.398859879@linuxfoundation.org>
References: <20260912065623.398859879@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

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
index e0949911e8f7d..be51b97cab1f3 100644
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



