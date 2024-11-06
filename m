Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DA9AD1DF24A;
	Wed,  6 Nov 2024 12:10:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730895050; cv=none; b=d8V+dy04SyHzSViM+FWvUSHlB1MTQ54qvY2CA4TtMFhQQ4VUG7qtHTdUnHW935sjlrqF/BwgVjEYVkG42m+D9P9jxT9WRmsvmo4AGwNkfMkyJwkRQ/EtH58rH+1xque4moYJM76dFmjadE+VoMvuvLd5r5DsV5qzs5+X9UVKCAc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730895050; c=relaxed/simple;
	bh=jk+lFSJiIYhV5W2sc9v5muOJgS/PleZ06Eauk9zhstY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=HGTp0PCW52Uykw191+jgyerPIZw1Cb226gFrvMjceQ2XTSdSJWIDxG+P/rVWVcbRe+4zjaCDUFRt9udEG4EH3ThZl/dz4F4ga75W7yHtb/CtMHYKfuqdPg6/tKLN4Lz9SF8RYJYsrqi2HzmtvCGAx4xOta2zYnSjfLfGes1rU2U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=apmwNka7; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="apmwNka7"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5C2E9C4CED3;
	Wed,  6 Nov 2024 12:10:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1730895050;
	bh=jk+lFSJiIYhV5W2sc9v5muOJgS/PleZ06Eauk9zhstY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=apmwNka78VgvLVH2u/j7K9UzAPX3sLG+46/2D12g7NUQB4+rpk0tkKTHkHwjg/iu1
	 +CMMUV8hhyftk613h0ooB1EdRtg3plZdYvK5jT5fGggY14PgWvS1cwmxP+9pF/vDg/
	 dlSHPrV2ajjUgH5/IS4XahykkFDI6sQRio1JPRH4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yang Yingliang <yangyingliang@huawei.com>,
	Linus Walleij <linus.walleij@linaro.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 087/350] pinctrl: single: fix missing error code in pcs_probe()
Date: Wed,  6 Nov 2024 13:00:15 +0100
Message-ID: <20241106120323.046053300@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241106120320.865793091@linuxfoundation.org>
References: <20241106120320.865793091@linuxfoundation.org>
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

4.19-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Yang Yingliang <yangyingliang@huawei.com>

[ Upstream commit cacd8cf79d7823b07619865e994a7916fcc8ae91 ]

If pinctrl_enable() fails in pcs_probe(), it should return the error code.

Fixes: 8f773bfbdd42 ("pinctrl: single: fix possible memory leak when pinctrl_enable() fails")
Signed-off-by: Yang Yingliang <yangyingliang@huawei.com>
Link: https://lore.kernel.org/20240819024625.154441-1-yangyingliang@huaweicloud.com
Signed-off-by: Linus Walleij <linus.walleij@linaro.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/pinctrl/pinctrl-single.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/pinctrl/pinctrl-single.c b/drivers/pinctrl/pinctrl-single.c
index 86691841efc01..004410e58e54b 100644
--- a/drivers/pinctrl/pinctrl-single.c
+++ b/drivers/pinctrl/pinctrl-single.c
@@ -1898,7 +1898,8 @@ static int pcs_probe(struct platform_device *pdev)
 
 	dev_info(pcs->dev, "%i pins, size %u\n", pcs->desc.npins, pcs->size);
 
-	if (pinctrl_enable(pcs->pctl))
+	ret = pinctrl_enable(pcs->pctl);
+	if (ret)
 		goto free;
 
 	return 0;
-- 
2.43.0



