Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 735AA1C3300;
	Mon, 14 Oct 2024 15:00:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728918046; cv=none; b=OegdQOUdKYlSc4macuGXiNsYtTCMpaxloFt9xkMXdPIN1UHJKUm4u54ae3Vq9rpVog0cRwfSmDzxMvXni6zBhUXJ3j0Po4VN4EdZJipYdpseBWqv6YadKUKoMo4RyvUHk5UhM0/EVcppT9cgJpzWR6YUmUn3s+K8bOI/AQ891LM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728918046; c=relaxed/simple;
	bh=gIyF8+QW6n/VvJ8kiIrHZD6uWoTd1OXO/E0W27hsTBQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=NeHv66Vt1kvS9b9xRxzRwQkX4o5RpKdsRXX832XnaeCTWc9gMp9gUHBn/AdmyrfEg9in3byP6iFsIP4r+Og1Z+0PnsAgUphYqXXEUUC2Nh+wrpOIC1P3sbv2AT+eHLRdiIldcG9AXRe/uCJqhqqRTAu61QaP9GMJNBik9uG7/cY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Et5LCn9W; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Et5LCn9W"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 940B8C4CEC7;
	Mon, 14 Oct 2024 15:00:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1728918046;
	bh=gIyF8+QW6n/VvJ8kiIrHZD6uWoTd1OXO/E0W27hsTBQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Et5LCn9Wke+4scQ1hp6W4y2mEjpC93Txpg5iZ1nrv6KNOIvSa97mpVFWclnEj6DBv
	 xeFzSNuyNDkSxt63l9XIxZFH1nMmyG0uxaRlIPT2c1kL13bhWUYx5pCtL2c2bwblD/
	 NU6tvTBbCwS4kN8U7m5xqN9jXmxtDA36/01r+fQU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yang Yingliang <yangyingliang@huawei.com>,
	Linus Walleij <linus.walleij@linaro.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 207/798] pinctrl: single: fix missing error code in pcs_probe()
Date: Mon, 14 Oct 2024 16:12:41 +0200
Message-ID: <20241014141226.062198264@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241014141217.941104064@linuxfoundation.org>
References: <20241014141217.941104064@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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



