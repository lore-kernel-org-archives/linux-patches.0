Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E49FA1F1318;
	Wed,  6 Nov 2024 13:02:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730898180; cv=none; b=INdozikvFvuhO+b72J98Y8QnhLj1xwOJZ03EhAg3vlsBybZ67Eti3vlOojwxMoAMYIrXYO7sn3ryjAkaoq61IJEyfFBOTW+MTt5nCGGBWbXEtMv0m5gHdDW6MEem0Li0I5J2fq6FzNi60TWO8dU7EisirBw+O1r7e5f1PBy/QrM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730898180; c=relaxed/simple;
	bh=SqRmGLFjknGq2pjFki+8ZzxeQnfMq5tnLcUsT+eZvsI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Mk0WUG8igIpDh+7klraDBMOKQVc83C7TQmnIBdghOo2CDa8muFOB7NTHk+a4LmnY/ug8IwASmmo55rhTVL1+OxAJqBeNr2lkOiM0lcA59BjkvsV1p+q4sXT57w9CPANF2PEBQT5ZyfykILmwXnCm0JFQGBwaSG46A/e72LBhD6E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=R++nTNAV; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="R++nTNAV"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 699B2C4CECD;
	Wed,  6 Nov 2024 13:02:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1730898179;
	bh=SqRmGLFjknGq2pjFki+8ZzxeQnfMq5tnLcUsT+eZvsI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=R++nTNAV/679bS8p6e4Nq1o3NqQttnjKafMokBrdssQejwTTKMQDu81ROU8JBgUQm
	 TpEHCOs+WUXXAmUTJ6wJjVqhth2FHJvsrwSiAb1kwuOmInQhHCWGNRrrEUpOR8q8R/
	 0vqBjj0/fpxXbtRLXt0wrCmUE3geobZkQhCOyHrM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yang Yingliang <yangyingliang@huawei.com>,
	Linus Walleij <linus.walleij@linaro.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 114/462] pinctrl: single: fix missing error code in pcs_probe()
Date: Wed,  6 Nov 2024 13:00:07 +0100
Message-ID: <20241106120334.323648297@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241106120331.497003148@linuxfoundation.org>
References: <20241106120331.497003148@linuxfoundation.org>
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
index 43b25119efa2e..ec021e6580b2c 100644
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



