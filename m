Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DA9414F3924;
	Wed, 30 Sep 2026 17:18:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790788729; cv=none; b=fut7ccqrgXOqGY2U0fsHXt4o5f/TSu3F/gyxdOPM2enCKWb2ZcR//sjn/Jg6FQBUeNvh9LLsTq2AZYc+shuejo7FNXwfuQxWhXlMyFMR69tN0OHPRKjn2czuFwb2z5lyaOYdWfnANPjG0cvoqN+B2zwquzh0Gnuky51a3Go/Vas=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790788729; c=relaxed/simple;
	bh=JXXK3mfrFpiAEHJyg/5kL8Zv69OkcAweDfsw8ED3W90=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=GPr0VnJmzg8Daqrg3EB3vpOJSeGMuPAq4vLOozj4GWm6kVwqMb/VSB7q3EifWAyP9oKokHXw4zvLOEJR6WD6LjHfH6sEbWNSeLnbFuji1gfKgjNLEdHqE5GbGmcZIo7kpAYVV+q70bM8Zx0EPus0QvzgGk6j7g6AGw6JLOXA92Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=JjB++fEr; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="JjB++fEr"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 41E6C1F000FF;
	Wed, 30 Sep 2026 17:18:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790788727;
	bh=pYwBwWMTTaRBfd35IuhkKBgrLPPjJO6Flw1F6rrFohI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=JjB++fEr9LaAUUEcMF8DiFqaD0zFHTzfZRjAg9iLIvm2vfCpuY2EqDkzQk3+TT7to
	 BipXegaZYx4wcg+yQt0ewDgCdHC7AFW9fPtePxORU68sZ4KIu3QmIZ6saas7d2Rv3K
	 /PvV0rTQhu9LvMjxvM8xHg3yZhSghHg90qZSA6+Q=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ijae Kim <ae878000@gmail.com>,
	Myeonghun Pak <mhun512@gmail.com>,
	Ulf Hansson <ulfh@kernel.org>
Subject: [PATCH 6.12 227/877] mmc: sdhci-of-aspeed: Remove children before releasing SDC resources
Date: Wed, 30 Sep 2026 17:18:58 +0200
Message-ID: <20260930152419.625648818@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260930152414.738996857@linuxfoundation.org>
References: <20260930152414.738996857@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
@@ -561,12 +561,14 @@ static int aspeed_sdc_probe(struct platf
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
@@ -576,6 +578,7 @@ static void aspeed_sdc_remove(struct pla
 {
 	struct aspeed_sdc *sdc = dev_get_drvdata(&pdev->dev);
 
+	device_for_each_child_reverse(&pdev->dev, NULL, of_platform_device_destroy);
 	clk_disable_unprepare(sdc->clk);
 }
 


