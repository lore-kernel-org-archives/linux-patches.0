Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 41928364032;
	Tue, 16 Dec 2025 12:23:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765887786; cv=none; b=IFr+RjIfie5MYZHIMezpRfIo/UHqOs7wLw3AAZHAImGouTu+mmYG45X21w5xgVNuOwqdDaxxyxKaJyYcsaeblPHsv06BHnwyhdi0ITmpnUn6fEaR5m0hrYJPJNeyiRCkAG+i/GPSLUAn68tDeJgFDrRwLtwJmNjT0t7FaB3u9Uc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765887786; c=relaxed/simple;
	bh=pWP1H+tnWBUX4Voil8UqUaq7y2WDBAiteANoKm3kP7M=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Bcss422/R8dLsDtdDvcjrFDbwGpW7eYIbj7A+0bZCKW3J24XmoD8eet4cOzV7ETLDuWfDOjfFcSBTv7IeNuuWDjBt+MsFQxLeGHfBm9GyhzcnkQ/RZVjwfJsQn+XPXgIF/6O+KuHJ9JlfjRHFmeKwOS7J5PZNfOD5COEt2cjxfs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=PW/Pdrbv; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="PW/Pdrbv"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B5E8EC4CEF1;
	Tue, 16 Dec 2025 12:23:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1765887786;
	bh=pWP1H+tnWBUX4Voil8UqUaq7y2WDBAiteANoKm3kP7M=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=PW/PdrbvWEv5+2rmGIERPESKeQtg23qoqB7J+ljOyxVCau1kN2p49hVN/G+gy5X1h
	 p7oH4bz2TNKoiJoLW++zPWjZsjVZvOvyzQn3VkQEtbU7QKCGzptbN8kgA7SKbZ74lW
	 uRCNjR8Yu0EHGtHuOGwPKGKVzz8gLyxeWwOg/KnU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Haotian Zhang <vulab@iscas.ac.cn>,
	Lee Jones <lee@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 337/614] mfd: mt6397-irq: Fix missing irq_domain_remove() in error path
Date: Tue, 16 Dec 2025 12:11:44 +0100
Message-ID: <20251216111413.574066700@linuxfoundation.org>
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

[ Upstream commit b4b1bd1f330fdd13706382be6c90ce9f58cee3f5 ]

If devm_request_threaded_irq() fails after irq_domain_create_linear()
succeeds in mt6397_irq_init(), the function returns without removing
the created IRQ domain, leading to a resource leak.

Call irq_domain_remove() in the error path after a successful
irq_domain_create_linear() to properly release the IRQ domain.

Fixes: a4872e80ce7d ("mfd: mt6397: Extract IRQ related code from core driver")
Signed-off-by: Haotian Zhang <vulab@iscas.ac.cn>
Link: https://patch.msgid.link/20251118121500.605-1-vulab@iscas.ac.cn
Signed-off-by: Lee Jones <lee@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/mfd/mt6397-irq.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/mfd/mt6397-irq.c b/drivers/mfd/mt6397-irq.c
index 0e463026c5a91..5d2e5459f7444 100644
--- a/drivers/mfd/mt6397-irq.c
+++ b/drivers/mfd/mt6397-irq.c
@@ -229,6 +229,7 @@ int mt6397_irq_init(struct mt6397_chip *chip)
 	if (ret) {
 		dev_err(chip->dev, "failed to register irq=%d; err: %d\n",
 			chip->irq, ret);
+		irq_domain_remove(chip->irq_domain);
 		return ret;
 	}
 
-- 
2.51.0



