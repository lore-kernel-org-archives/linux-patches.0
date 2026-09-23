Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 55A283F58D9;
	Wed, 23 Sep 2026 14:51:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790175101; cv=none; b=XHC6pbYZcEUS6JmNPnY+A1vtM7WdTONb9p6eerC1kgxTQELSEArYzoqFqxbZeC/eHAO2a6AircUJKvWryzn06EoiWcjOZpb3xES7QFkGMB3ZmucGvke3JqL62kcDWjz3ex693+yVeDcjCsUKTz8UJUpKKKXO6BhlTekM5AVn/Vg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790175101; c=relaxed/simple;
	bh=aziR/8rq4QhbPYxqPOXJbDfLauwaI43RFqbDTO7qRo8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=oWWs7kQYmyJd7z/1eqnG2qSaBNQnclOdDLMoS4eej4Svb83elz0P0RLBr4VkOUvSA/6rSpwSD88XpMRhPZJ9f7058nKsDXE6wGmoytFNARgmsuqqVylC1prtk2Rdb1tvbnvTetAjCV8WadfiFLeDbVJs+zp/iSjBWP1ewjAeAeQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=DYFt6LAD; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="DYFt6LAD"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8C6A91F000FF;
	Wed, 23 Sep 2026 14:51:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790175100;
	bh=lCUFhujgxG8x+cIxOW2G8brdrB105LDAvtcS02omNZc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=DYFt6LADm3N0tV8cHON7E/Oi8KakL0mCX3wUrWsC3nMy7S7hmKkpVz9AF3m4pLQ+l
	 F08dEactc0VW6gvBVg3UZUePhnCviy/ZyMzaXaS+wOosx9qaEkJLPjd5VwhjttKtpM
	 WeXbegDpZE8oifwpI0X2nV5kI+SgIo3vMvlXhJO8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ijae Kim <ae878000@gmail.com>,
	Myeonghun Pak <mhun512@gmail.com>,
	Ulf Hansson <ulfh@kernel.org>
Subject: [PATCH 6.18 286/398] mmc: sdhci-of-aspeed: Remove children before releasing SDC resources
Date: Wed, 23 Sep 2026 16:06:00 +0200
Message-ID: <20260923140650.834491462@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260923140643.441954610@linuxfoundation.org>
References: <20260923140643.441954610@linuxfoundation.org>
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
@@ -555,12 +555,14 @@ static int aspeed_sdc_probe(struct platf
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
@@ -570,6 +572,7 @@ static void aspeed_sdc_remove(struct pla
 {
 	struct aspeed_sdc *sdc = dev_get_drvdata(&pdev->dev);
 
+	device_for_each_child_reverse(&pdev->dev, NULL, of_platform_device_destroy);
 	clk_disable_unprepare(sdc->clk);
 }
 


