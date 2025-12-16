Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B0B66364046;
	Tue, 16 Dec 2025 12:23:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765887789; cv=none; b=RzdJPNFT3bUHAcfm61X6+5jRb9kblfsTpBnbcQ+wkYCOx5zIGK+qlurMY3m19XpKd+F24or5rqGePJTvbUNiNujXrKvJWkfRNP8k/n6GGB+anBKz0zGahO4lxbbZD049yWUj3neAwCLoAT4DXprd9cCDj1nfr8mlj1pdnAMMqjE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765887789; c=relaxed/simple;
	bh=VTBEHhi9enauVGkTt1EbnC/Hhmw+bWPkF+r6i8vR8zo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=PNV7/IdKjc0M/WO8OdoUfjJX2rt+UfTF3WKn8kKTlxi+1sbbRRMtvJT/O62a23Ga6xFLrGIAI/h0WFxZoRF0M6MCr/pMVXxcGbOg2Ji+k8PVDqqSLH5HkYFeTgm9B4kclVFRTz8WqPwxUnqzwCX2ec5A/KWT55KPR6uk7cpUrOE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=WnXz0Y8Y; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="WnXz0Y8Y"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E6614C4CEF1;
	Tue, 16 Dec 2025 12:23:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1765887789;
	bh=VTBEHhi9enauVGkTt1EbnC/Hhmw+bWPkF+r6i8vR8zo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=WnXz0Y8YJtmpUQ/XLYVTAkpvzl3R9Xq2RxwdeYRPiGh/8Z3I6ADOsc2nK3SpyAR9A
	 AqbnAtzv0cQjqHrRKnf/Ekm8/M7rEI8LtJ0BNE7KNfLMLPNZXTQnFbWbq7zLY6lKAP
	 r+qfPfCpB+Wb/XklHeNiw5JGrvtJDjCfMmgdOo44=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Haotian Zhang <vulab@iscas.ac.cn>,
	Lee Jones <lee@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 338/614] mfd: mt6358-irq: Fix missing irq_domain_remove() in error path
Date: Tue, 16 Dec 2025 12:11:45 +0100
Message-ID: <20251216111413.609618128@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251216111401.280873349@linuxfoundation.org>
References: <20251216111401.280873349@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Haotian Zhang <vulab@iscas.ac.cn>

[ Upstream commit 384bd58bf7095e4c4c8fcdbcede316ef342c630c ]

If devm_request_threaded_irq() fails after irq_domain_add_linear()
succeeds in mt6358_irq_init(), the function returns without removing
the created IRQ domain, leading to a resource leak.

Call irq_domain_remove() in the error path after a successful
irq_domain_add_linear() to properly release the IRQ domain.

Fixes: 2b91c28f2abd ("mfd: Add support for the MediaTek MT6358 PMIC")
Signed-off-by: Haotian Zhang <vulab@iscas.ac.cn>
Link: https://patch.msgid.link/20251118121427.583-1-vulab@iscas.ac.cn
Signed-off-by: Lee Jones <lee@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/mfd/mt6358-irq.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/mfd/mt6358-irq.c b/drivers/mfd/mt6358-irq.c
index f467b00d23660..74cf208430440 100644
--- a/drivers/mfd/mt6358-irq.c
+++ b/drivers/mfd/mt6358-irq.c
@@ -285,6 +285,7 @@ int mt6358_irq_init(struct mt6397_chip *chip)
 	if (ret) {
 		dev_err(chip->dev, "Failed to register IRQ=%d, ret=%d\n",
 			chip->irq, ret);
+		irq_domain_remove(chip->irq_domain);
 		return ret;
 	}
 
-- 
2.51.0



