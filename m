Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2E3F23DDAFC;
	Wed, 30 Sep 2026 19:26:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790796370; cv=none; b=RiC4X8ldmedsEVWnlc+0qhVOiQdR289+/AzR7WyxcFqu0NR0mqoNtweHKapzIah36FSdIM9xLSlA+JKXJVM1erOG4GG02Zm4RPDdYkaeUIBBt17XYlgpL/fOLOhhWpEy3Fmfi26dQbSs0hwqgk0it4dPXGAAG/orQRm7RRL6oYo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790796370; c=relaxed/simple;
	bh=FN9tr4N3vJMGzJYCYKMNR92Uw8edGkE/BZbafq7poeI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=tQXk2mqCczhilRNwxvmM3kiOqAkqTCZ7VyeckwtxNl3aXyGKiWAglN1FqqFiYwIZTg7+twbwQYgTSlh3q7NI26ZS4MUSwbyrY2Wph8i83biudJS8oQab2s/T7zpTdVO0VmtR6rVMnQjRvQ7kjKuvlJw3w4b+NeqHInDXe37GXnA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=oh8lM33R; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="oh8lM33R"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 877BB1F000FF;
	Wed, 30 Sep 2026 19:26:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790796369;
	bh=ekUDBMldAOmGaloC+Wdk44qyNPz14PNWhC/S36Dbodw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=oh8lM33RkQY4TDR7eBeiqpX/0bdoA+U0c7ApmKZecl9j9TMT25K297pPP2DOzFjD2
	 UhUqJ5gTWMd5GySwTrjF/FnWHpg7e7+anx/LSTJ9eaMpyItIkoybw70DJHSpSbrBDa
	 mXhza5o0pmFOxnjY0VlSPEx2bTD5X3UxztQit444=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ijae Kim <ae878000@gmail.com>,
	Myeonghun Pak <mhun512@gmail.com>,
	Ulf Hansson <ulfh@kernel.org>
Subject: [PATCH 6.6 0888/1193] mmc: sdhci-of-aspeed: Remove children before releasing SDC resources
Date: Wed, 30 Sep 2026 17:26:12 +0200
Message-ID: <20260930152453.978392385@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260930152434.301151190@linuxfoundation.org>
References: <20260930152434.301151190@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
 


