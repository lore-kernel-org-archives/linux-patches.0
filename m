Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 00EEC511225;
	Wed, 30 Sep 2026 18:15:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790792142; cv=none; b=T+kIgtLYwq4+o36ysrNSIOd3REKR/Nv7J7MKxGXv2URxrL3AhOAk61XFa85hSOAd2gFlKSY6Fy71wDiB9Ghs80jP487hX7qYzfz6UgoqQp/9UGy/TELw5IDlravHMVfhkNyb4kW2Il9NoWJ0RhQGSm68M3gda12+WHWdlh+x3kA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790792142; c=relaxed/simple;
	bh=QiT77jB0+D+3wlUn6TNbGJm3LiuB0BZsp8ne0VZuD4I=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=qaoGlvwd/7TYim/zOpL0ZvoCMUzVFp+roOP2+h1MWPRejODfsmlY3YBw7SftYuQ2+MuNBmVSRvuXIHmNZb/OOq9u/5xiKgpGD1prev4n2oZJCdiRI0WVrg8D4tQ/5th2nQAPRZ15TdTjXFD8BhAZYORAGh0YzuP1RGwbKPrTQFA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=OJEhWARw; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="OJEhWARw"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 29E521F000FF;
	Wed, 30 Sep 2026 18:15:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790792140;
	bh=U3kyt4h/oag5LChilBttokX8ISaOVimCN7E+T5gIDGQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=OJEhWARwrOEjBx+FQpdPZLDg9MM27qsH2EG6gFEKjkN/Fl2jU1tU1Ny2WCUqskgE6
	 Vg28jJC7LF2aVxCsD8YV75hMnacvE+zL8pAm6dibzADTKZIwppjdCWpBp8AJjtz7Xr
	 3yiGp+uzN7k03nIiNOpAHSFwKjUsOwAJOLjsbeIQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ijae Kim <ae878000@gmail.com>,
	Myeonghun Pak <mhun512@gmail.com>,
	Ulf Hansson <ulfh@kernel.org>
Subject: [PATCH 5.15 548/752] mmc: sdhci-of-aspeed: Remove children before releasing SDC resources
Date: Wed, 30 Sep 2026 17:26:58 +0200
Message-ID: <20260930152410.102786625@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260930152358.131179731@linuxfoundation.org>
References: <20260930152358.131179731@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Myeonghun Pak <mhun512@gmail.com>

commit 4396d70bb7fec531bcf934fed016b2f3300c670b upstream.

Probe failure and removal leave SDHCI child devices registered after the
parent clock and managed resources are released.

Unregister the OF children in reverse order before disabling the parent
clock on both paths. Use of_platform_device_destroy() because manual
child creation does not set the flag required by of_platform_depopulate().

This issue was identified during our ongoing static-analysis research
while reviewing kernel code.

Fixes: bb7b8ec62dfb ("mmc: sdhci-of-aspeed: Add support for the ASPEED SD controller")
Co-developed-by: Ijae Kim <ae878000@gmail.com>
Signed-off-by: Ijae Kim <ae878000@gmail.com>
Signed-off-by: Myeonghun Pak <mhun512@gmail.com>
Assisted-by: OpenAI:GPT-5.6
Cc: stable@vger.kernel.org
Signed-off-by: Ulf Hansson <ulfh@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/mmc/host/sdhci-of-aspeed.c |    5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

--- a/drivers/mmc/host/sdhci-of-aspeed.c
+++ b/drivers/mmc/host/sdhci-of-aspeed.c
@@ -565,12 +565,14 @@ static int aspeed_sdc_probe(struct platf
 		if (!cpdev) {
 			of_node_put(child);
 			ret = -ENODEV;
-			goto err_clk;
+			goto err_children;
 		}
 	}
 
 	return 0;
 
+err_children:
+	device_for_each_child_reverse(&pdev->dev, NULL, of_platform_device_destroy);
 err_clk:
 	clk_disable_unprepare(sdc->clk);
 	return ret;
@@ -580,6 +582,7 @@ static int aspeed_sdc_remove(struct plat
 {
 	struct aspeed_sdc *sdc = dev_get_drvdata(&pdev->dev);
 
+	device_for_each_child_reverse(&pdev->dev, NULL, of_platform_device_destroy);
 	clk_disable_unprepare(sdc->clk);
 
 	return 0;


