Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 73F231EBA0A;
	Tue, 15 Oct 2024 11:47:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728992852; cv=none; b=b4rbTEFHILA9I+iMTqYS2t/LoGD73J7c0Pr9HwCvlGdBhxtVE0nQYrwHzSYDmI2ww/p0KeQf0YHn/XzlIXuox472mJM5VbRbnv0FMdwZPZl66hUYLIfkwx9oqDsFy340UfVoPM8OTt16DueCSsuCIFmt0evT/6h1e443ul+MauU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728992852; c=relaxed/simple;
	bh=RUuew2MTY3Ipm4utfrC5EyNi3oB3fpNdIq8Ag0PwboI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=mTM/57GBF5pRn8RxWa1toQsPX9fNpGAS3tUmA/ummZ7pbv5qdW/poaOTMpjl1cq6DRdIXewuONw22dQCFzCnzD//A89GFO6LZuY7PHpYIkaO2fuWyl9A8YJquQGLyrtEgeE8OvfQKPCyVpIDXjjvkLCbJyz+yBt/3kLhz32EmJw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=f+xWCivF; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="f+xWCivF"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 90349C4CECF;
	Tue, 15 Oct 2024 11:47:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1728992852;
	bh=RUuew2MTY3Ipm4utfrC5EyNi3oB3fpNdIq8Ag0PwboI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=f+xWCivFPv/mThMp7tHJZtpQ4GtxjLTkSG/wcETauZR6k1c04X3Bk0WyZO6X0nwtX
	 Nqqi0JdO7RFdH69Se+CJ0aoseLE8r56plUXQ9bg6CIrEcuYzy4zwkYLes76YXVHGeQ
	 1u4liNncipYmBNnlSP172s5G4S5cbD6Z5FXtBVtM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yang Yingliang <yangyingliang@huawei.com>,
	Linus Walleij <linus.walleij@linaro.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 237/691] pinctrl: single: fix missing error code in pcs_probe()
Date: Tue, 15 Oct 2024 13:23:05 +0200
Message-ID: <20241015112449.764054282@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241015112440.309539031@linuxfoundation.org>
References: <20241015112440.309539031@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
index d32d5c5e99bcd..28f3fabc72e30 100644
--- a/drivers/pinctrl/pinctrl-single.c
+++ b/drivers/pinctrl/pinctrl-single.c
@@ -1919,7 +1919,8 @@ static int pcs_probe(struct platform_device *pdev)
 
 	dev_info(pcs->dev, "%i pins, size %u\n", pcs->desc.npins, pcs->size);
 
-	if (pinctrl_enable(pcs->pctl))
+	ret = pinctrl_enable(pcs->pctl);
+	if (ret)
 		goto free;
 
 	return 0;
-- 
2.43.0



