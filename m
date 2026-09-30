Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DA5BD4EA39A;
	Wed, 30 Sep 2026 15:52:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790783579; cv=none; b=kcGCHl/ZaOLWzfBW/Z53scIwkUxMlqAvthgKISESLK+QMjTbwyaBKMZyaxEyEEOm1+9DhRGZ/SFSPEMuzwlsRLoc9666eSnCtVBemWZlGm8RSddN7MJ6mjl6Dc0yMCnqWUlaHfiZtyfWMCZnU//nddXiDwUu4/tjuDAR73cPxWQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790783579; c=relaxed/simple;
	bh=qL7YE7IythBiXd6iYn3d1Tgfk4rBheWJZHF9gFLI6ps=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=QbPs9FUcFCjHwBmwFMHEM6mjYStyWJvSg+cYuNj8UXJRmbanTmcCgMskqdxf6bEcKYZWb0H2Vv4gmUPDHmr/2myLEO/SM24Cz7bwI3Rg1C/tLuTAyjcf+z5Mnm5Nf4L9G0H7auG/k/vugme3qqBL5pL/NzJHqhIqpBIEsoioyM0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=fquhVNfg; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="fquhVNfg"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D99261F00893;
	Wed, 30 Sep 2026 15:52:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790783574;
	bh=bgH5ai93s62g4lEYTdJKx2s1jyndI1HCXVHjlJHMQog=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=fquhVNfgVmdsHiyw5UlLMa2qPQu7DqoHQFV/8O4E+7bWbQyKxLNoerto7LEZvLz9u
	 y3Wr5DDdiRxERG7WA8zn0d2Jq0DnGOdvVa/XQaWGU6aldhmijYjJy/Wr3+vkipvUMC
	 +ZtR/T8qNB4OUgYGd2mUdc5nFInh+tJBXLSV2KjU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Runyu Xiao <runyu.xiao@seu.edu.cn>,
	Ulf Hansson <ulfh@kernel.org>
Subject: [PATCH 5.10 445/595] mmc: sh_mmcif: initialize IRQ-thread mutex before requesting interrupt
Date: Wed, 30 Sep 2026 17:25:38 +0200
Message-ID: <20260930152357.253062126@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260930152347.700140858@linuxfoundation.org>
References: <20260930152347.700140858@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Runyu Xiao <runyu.xiao@seu.edu.cn>

commit d5ea0d226e8f0801d78702142a124d78c317d822 upstream.

The threaded IRQ handler can run before devm_request_threaded_irq()
returns, but thread_lock was initialized afterwards. Initialize it before
requesting either interrupt.

Fixes: 8047310ee984 ("mmc: sh_mmcif: fix a race, causing an Oops on SMP")
Cc: stable@vger.kernel.org
Assisted-by: Codex:GPT-5
Signed-off-by: Runyu Xiao <runyu.xiao@seu.edu.cn>
Signed-off-by: Ulf Hansson <ulfh@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/mmc/host/sh_mmcif.c |    3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

--- a/drivers/mmc/host/sh_mmcif.c
+++ b/drivers/mmc/host/sh_mmcif.c
@@ -1422,6 +1422,7 @@ static int sh_mmcif_probe(struct platfor
 	host->pd = pdev;
 
 	spin_lock_init(&host->lock);
+	mutex_init(&host->thread_lock);
 
 	mmc->ops = &sh_mmcif_ops;
 	sh_mmcif_init_ocr(host);
@@ -1482,8 +1483,6 @@ static int sh_mmcif_probe(struct platfor
 		}
 	}
 
-	mutex_init(&host->thread_lock);
-
 	ret = mmc_add_host(mmc);
 	if (ret < 0)
 		goto err_clk;


