Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E25123749F6;
	Wed, 30 Sep 2026 16:34:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790786097; cv=none; b=OIm+M6JgweMWTHmTmFwcBGXbmvaKe+5v1rWi4uL2om5lB1W4va8QPvsecWl8tRStQjxe0Zoo/jRcSKCYnpF0iTN5Zl3rxVDnot/lNZueDav+3dZLHcsv3+LnXCwiWPQhsHerLfKaTIKSwu5/OhgAPNctgxNHxgodPr7DwjRZwk0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790786097; c=relaxed/simple;
	bh=H6i1FMKy4akM3sFQR0syRAGv6Mh9vmzUgT2CmbzhyWQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Jw/ib7h/JSlJaoM4ArSCgujh+I0VWzlhtHUDin0Nkyb9Metlet8KTcn2wqXzqBfHGTR5N6HkiS3RU6tCwA+3aLkAbHJuqseZvk0UvbVsIhr0Gf0MKo8ZWJjygaNiEmb0fPZnQdB1Rh8ne11kUX8/C5HPWrVII5rb8vToSIQSe7c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=De7Ojchk; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="De7Ojchk"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 477941F000FF;
	Wed, 30 Sep 2026 16:34:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790786095;
	bh=kz6khbcrkbBCdwnR94stWM38b0ETYavzCCI6Zj8BQS8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=De7OjchkpmyvPasXT3L4aCuR7yxt2JBuoOOILEnzHNa6s+JQwoDavDY0lGOzYoIh9
	 cjTI4RwUYiy7l+hE7a+dIm/IJDfbbVH7turmI40UzEbGaZ8QpGcqpPMLadAIoRS39V
	 P+0m32ErNuf1y6C7DnN9MK4AjlLkjlDVQmVD7LT4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ijae Kim <ae878000@gmail.com>,
	Myeonghun Pak <mhun512@gmail.com>,
	Ulf Hansson <ulfh@kernel.org>
Subject: [PATCH 6.1 734/982] mmc: sdhci-of-aspeed: Remove children before releasing SDC resources
Date: Wed, 30 Sep 2026 17:24:30 +0200
Message-ID: <20260930152432.521571891@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260930152416.775402466@linuxfoundation.org>
References: <20260930152416.775402466@linuxfoundation.org>
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


