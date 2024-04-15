Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CA8C374E3A;
	Mon, 15 Apr 2024 14:24:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713191067; cv=none; b=Cb9o8tvXLUIdq7rZYnn2nuv5brx9Odbth8d3ezSYJ8Hm2JNZZacHWZ9lR5FqExrB1bxPj3KoPrwF7jg82wntjXeViM7GwssFzJHSTMeZ/5ipNsTl+KyNMnyIT4jSLko8MV1Yls9fPHf5Coa9qSU1Cj4li/ZWMkmP6ff+96kZspg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713191067; c=relaxed/simple;
	bh=P+vxjZz0E2y3ba0Is6Rr2vFW/Qjqi+snGnDoo3jJHzk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=aaZOGxzbPTmgjwIWJnhP9ryoNumWjxgZTtt4zTAkTDipZUXa3EPA5fNP8C5adqgQfatvyZZERLEBcyreROGP+4V6DtoTFMnaiI68uuVKLQMGHQP9yzsKeLiL7GGMo8h/KehiUoFJTHP6Kyo+UWqMKXlZKsnRq/gGSyUfhoEZdZY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=lizyR52Q; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="lizyR52Q"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 20B81C113CC;
	Mon, 15 Apr 2024 14:24:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1713191067;
	bh=P+vxjZz0E2y3ba0Is6Rr2vFW/Qjqi+snGnDoo3jJHzk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=lizyR52QkqPT1czdfE5kNqhDwEaCZ3O1zpAuXxkyw7SMRNUO5xYQBkZiYF+iamP2m
	 WiMsrsHsxJR3yHNVMkWELCDqkLw2AHoeugizkQhJ/GO5H6cIcGjBdeaGJMIMZ1HFw1
	 olacWdI99H89a+f3c7NtFGJBmilJt9KYrQ/JEO7c=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Aaro Koskinen <aaro.koskinen@iki.fi>,
	Linus Walleij <linus.walleij@linaro.org>,
	Ulf Hansson <ulf.hansson@linaro.org>,
	Tony Lindgren <tony@atomide.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.8 022/172] mmc: omap: fix broken slot switch lookup
Date: Mon, 15 Apr 2024 16:18:41 +0200
Message-ID: <20240415142001.026280344@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240415141959.976094777@linuxfoundation.org>
References: <20240415141959.976094777@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.8-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Aaro Koskinen <aaro.koskinen@iki.fi>

[ Upstream commit d4debbcbffa45c3de5df0040af2eea74a9e794a3 ]

The lookup is done before host->dev is initialized. It will always just
fail silently, and the MMC behaviour is totally unpredictable as the switch
is left in an undefined state. Fix that.

Fixes: e519f0bb64ef ("ARM/mmc: Convert old mmci-omap to GPIO descriptors")
Signed-off-by: Aaro Koskinen <aaro.koskinen@iki.fi>
Message-ID: <20240223181439.1099750-4-aaro.koskinen@iki.fi>
Reviewed-by: Linus Walleij <linus.walleij@linaro.org>
Acked-by: Ulf Hansson <ulf.hansson@linaro.org>
Signed-off-by: Tony Lindgren <tony@atomide.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/mmc/host/omap.c | 13 ++++++-------
 1 file changed, 6 insertions(+), 7 deletions(-)

diff --git a/drivers/mmc/host/omap.c b/drivers/mmc/host/omap.c
index 9fb8995b43a1c..aa40e1a9dc29e 100644
--- a/drivers/mmc/host/omap.c
+++ b/drivers/mmc/host/omap.c
@@ -1384,13 +1384,6 @@ static int mmc_omap_probe(struct platform_device *pdev)
 	if (IS_ERR(host->virt_base))
 		return PTR_ERR(host->virt_base);
 
-	host->slot_switch = gpiod_get_optional(host->dev, "switch",
-					       GPIOD_OUT_LOW);
-	if (IS_ERR(host->slot_switch))
-		return dev_err_probe(host->dev, PTR_ERR(host->slot_switch),
-				     "error looking up slot switch GPIO\n");
-
-
 	INIT_WORK(&host->slot_release_work, mmc_omap_slot_release_work);
 	INIT_WORK(&host->send_stop_work, mmc_omap_send_stop_work);
 
@@ -1409,6 +1402,12 @@ static int mmc_omap_probe(struct platform_device *pdev)
 	host->dev = &pdev->dev;
 	platform_set_drvdata(pdev, host);
 
+	host->slot_switch = gpiod_get_optional(host->dev, "switch",
+					       GPIOD_OUT_LOW);
+	if (IS_ERR(host->slot_switch))
+		return dev_err_probe(host->dev, PTR_ERR(host->slot_switch),
+				     "error looking up slot switch GPIO\n");
+
 	host->id = pdev->id;
 	host->irq = irq;
 	host->phys_base = res->start;
-- 
2.43.0



