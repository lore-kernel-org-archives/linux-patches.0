Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 980A213B2B8;
	Tue, 27 Feb 2024 14:23:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709043818; cv=none; b=kpGzmnM4HOjnZTUBNX7NQDy62Lpey7PBIH72+4mFb4nyEGloq/ZwIsRNfE1cq34IQAWsiUQGxR6mYPQ0u9K8LL0Z8QIVgEraXvm3j1p5yfUdmhgsUXbZBLtBqjICOor7ypneLjV3bbgJqD43soJDRHCByf10ifZTqfEI3X3WB28=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709043818; c=relaxed/simple;
	bh=d9v14ZSnIRnJ6tAtQoN6AjQ7QpU0yJOtCdigfn88OTs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=tKemQ6quacuiCvZJdpgm7g9HXcPD6/V4T0WWsYHb0i7Ux31ZnjVm5nnYb1opStU9gXkhv/VOq/myEsMbYcw4vciIFp27VJf4dwdVxhFAy0hvfH7GsIjnhdAckI5neKVxfdPnuAmBbMlurnxZ0TfUCKiAHIt4tj2eQDqM+dM0H5I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=p9hgVJif; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="p9hgVJif"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 22DBAC433C7;
	Tue, 27 Feb 2024 14:23:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1709043818;
	bh=d9v14ZSnIRnJ6tAtQoN6AjQ7QpU0yJOtCdigfn88OTs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=p9hgVJifgCKQ9WHZupxKeqdvNnFheopuKWDhQGqgr9Ck0bYp6DjH3bha4+YsqAaRT
	 8aJu7iDS5O6BP20Z8StnYrf9RNt9BwGJ9IYhOZTj0wPYPdmLkAAeMgTvip4dvc641b
	 ZWkU2/gy2yI/AdsXi0a6kf/jP8HxPrAS0Cy5EkrM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Christophe JAILLET <christophe.jaillet@wanadoo.fr>,
	Matthias Brugger <matthias.bgg@gmail.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 40/84] spi: mt7621: Fix an error message in mt7621_spi_probe()
Date: Tue, 27 Feb 2024 14:27:07 +0100
Message-ID: <20240227131554.178091720@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240227131552.864701583@linuxfoundation.org>
References: <20240227131552.864701583@linuxfoundation.org>
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

5.4-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Christophe JAILLET <christophe.jaillet@wanadoo.fr>

[ Upstream commit 2b2bf6b7faa9010fae10dc7de76627a3fdb525b3 ]

'status' is known to be 0 at this point. The expected error code is
PTR_ERR(clk).

Switch to dev_err_probe() in order to display the expected error code (in a
human readable way).
This also filters -EPROBE_DEFER cases, should it happen.

Fixes: 1ab7f2a43558 ("staging: mt7621-spi: add mt7621 support")
Signed-off-by: Christophe JAILLET <christophe.jaillet@wanadoo.fr>
Reviewed-by: Matthias Brugger <matthias.bgg@gmail.com>
Link: https://lore.kernel.org/r/928f3fb507d53ba0774df27cea0bbba4b055993b.1661599671.git.christophe.jaillet@wanadoo.fr
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/spi/spi-mt7621.c | 8 +++-----
 1 file changed, 3 insertions(+), 5 deletions(-)

diff --git a/drivers/spi/spi-mt7621.c b/drivers/spi/spi-mt7621.c
index b4b9b7309b5e9..351b0ef52bbc8 100644
--- a/drivers/spi/spi-mt7621.c
+++ b/drivers/spi/spi-mt7621.c
@@ -340,11 +340,9 @@ static int mt7621_spi_probe(struct platform_device *pdev)
 		return PTR_ERR(base);
 
 	clk = devm_clk_get(&pdev->dev, NULL);
-	if (IS_ERR(clk)) {
-		dev_err(&pdev->dev, "unable to get SYS clock, err=%d\n",
-			status);
-		return PTR_ERR(clk);
-	}
+	if (IS_ERR(clk))
+		return dev_err_probe(&pdev->dev, PTR_ERR(clk),
+				     "unable to get SYS clock\n");
 
 	status = clk_prepare_enable(clk);
 	if (status)
-- 
2.43.0



