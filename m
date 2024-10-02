Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2B2543232;
	Wed,  2 Oct 2024 14:39:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727879984; cv=none; b=dfSrC+Rd0T72r3fRPNqx41NbYJS7Eadn7OU+KKlilrtexnbnMaCr+jRLhbAmj5e0cLA4KVE13HZAeQSAKNYii0M0lJjxDFm6vNso3reWDua0fSmT3KzBjDWB2gvC79oIbD8uX4QZa3LpgAzQzR6Tjcr2HK95OAIa2D4bmSyvy0c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727879984; c=relaxed/simple;
	bh=FoOAaoJdUeEXPH084RqWHn8XKqsJPQ1Z8HRVtldUp7s=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=uL+iaSvyRBbiwxSmIkcemeQu8skXUvG6JghOXgPSq9+j47uflcCpBp92pq5eaiU+QVGIM6r+g/28ckRbIFmp1PCUeKPdUgPG3RT2SRQz52qfCQQgaUME9dzB8kg7fVaJCX2lqyq2tohza4fkjJBIRh3a4eleFAIWrD6C6t5kmIE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Cq2Hirmn; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Cq2Hirmn"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A8A68C4CEC5;
	Wed,  2 Oct 2024 14:39:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1727879984;
	bh=FoOAaoJdUeEXPH084RqWHn8XKqsJPQ1Z8HRVtldUp7s=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Cq2Hirmn0JOm8YhXLFulE3YVdx5iT9UrxHO1QJCTXY6HWQOF8bAvzXJdCvyS66qKF
	 zt3f72TQEBzMlRTj38Biie7Dl0u8WgfjhS6EqAH4j9plnicEdfM8UcyxqYZ0P0LVGJ
	 AVUcM1Kx9CvyGZhYrDtuiSRSWA9lEMQnCpK3YYMs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yang Yingliang <yangyingliang@huawei.com>,
	Linus Walleij <linus.walleij@linaro.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 297/538] pinctrl: single: fix missing error code in pcs_probe()
Date: Wed,  2 Oct 2024 14:58:56 +0200
Message-ID: <20241002125804.137991048@linuxfoundation.org>
X-Mailer: git-send-email 2.46.2
In-Reply-To: <20241002125751.964700919@linuxfoundation.org>
References: <20241002125751.964700919@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
index bbe7cc894b1a1..6c670203b3ac2 100644
--- a/drivers/pinctrl/pinctrl-single.c
+++ b/drivers/pinctrl/pinctrl-single.c
@@ -1918,7 +1918,8 @@ static int pcs_probe(struct platform_device *pdev)
 
 	dev_info(pcs->dev, "%i pins, size %u\n", pcs->desc.npins, pcs->size);
 
-	if (pinctrl_enable(pcs->pctl))
+	ret = pinctrl_enable(pcs->pctl);
+	if (ret)
 		goto free;
 
 	return 0;
-- 
2.43.0



