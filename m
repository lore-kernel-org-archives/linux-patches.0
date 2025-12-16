Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6FB5E34405B;
	Tue, 16 Dec 2025 11:53:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765886032; cv=none; b=Zn547YJChf8PHVWXfyldMF++RpGF+y5fFakY0S3FkEEM5uO2XAy5KFhgetprvkSzWQE0NSp94CHgHTyu09EL+h6xAiG4Z28B7yJwPHVTvVCfzc0RlO7LcDAVVDNGl4WoL4QIClx2joDncCLiM8SKe1L8NneNcgT86mE7ORLLfw4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765886032; c=relaxed/simple;
	bh=TvGLya+bm7KjeuOxF8kag/wQgbT/RpA/fgVpIRtb4rg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=fPs+0/IW2K8pkOkJOJgBsHiSE3Ypsj30NlAjJfbDJ+f7nzehrk7kZPZpX/a4W4W3nE5c7g5VylNTpcGQkjZICFy1UiqGLP39XqTzECU0fg5q8jojASvmgaCqvJRuZtRLRitdX/UN2DYv2I284j3RnXiGtatsOVT/Up4mC4vCXaw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=sy3KlP4l; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="sy3KlP4l"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CC3D4C4CEF1;
	Tue, 16 Dec 2025 11:53:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1765886032;
	bh=TvGLya+bm7KjeuOxF8kag/wQgbT/RpA/fgVpIRtb4rg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=sy3KlP4lymTfyqx/C+fnsqfHtQg8P9cydHqzPNhpLlnxJQO87OLvjvcF6WGqVj4O7
	 +J15wZEbTlKCJD8ika1BiRq2nqalAPsj2WSTlq99IQOpAZYbJDU0WtmVHGxhlwnk1Z
	 NCYMPhOfNk/vBBkP+IJlrLqCaPoD97ZK86D/U3sQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Haotian Zhang <vulab@iscas.ac.cn>,
	Lee Jones <lee@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.17 284/507] mfd: mt6397-irq: Fix missing irq_domain_remove() in error path
Date: Tue, 16 Dec 2025 12:12:05 +0100
Message-ID: <20251216111355.768198199@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251216111345.522190956@linuxfoundation.org>
References: <20251216111345.522190956@linuxfoundation.org>
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

6.17-stable review patch.  If anyone has any objections, please let me know.

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



