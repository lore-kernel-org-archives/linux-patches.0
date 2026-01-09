Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 90C5235A952;
	Fri,  9 Jan 2026 12:29:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767961768; cv=none; b=rLRvieGaH1d3zGzS9b28ZLZTke0mn9qI5mJERLKtHgg1IN7ZNjrIjPDeSm8cfT6q3EGdGyyr0zE55xUyJc2FEFauAskBLC5hOSA1xRht8SqmpY6z0mDd3HpSwTcPeFD4CtIkJvgFUV2nDOggsENtKscPuyeSXxQSA8BzS+Zsix4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767961768; c=relaxed/simple;
	bh=h1ql0isgTkkrYXCVEX891tWzNjgZ40o9xB8UIgFvNwg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=iZkZt7tDy1yQrIDUO0Xv83rjJzZ7IWVHttDrmtcCKjwTACpFmJZ5/MbyV0FGbXMTT1/qN+m6YHlO3zSLRPiNgBH7aIY6DJmPsRm4du9PuYUYXUBdQWWLnPGy1HsMG8WYxoX4BhgbI1sXM6nd8xQMCKopYmM55I0/e0/V4CEyPOo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=z2BNsSdy; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="z2BNsSdy"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F375AC4CEF1;
	Fri,  9 Jan 2026 12:29:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1767961768;
	bh=h1ql0isgTkkrYXCVEX891tWzNjgZ40o9xB8UIgFvNwg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=z2BNsSdy6OYSFZPzzdI9TVtO9DjtqNvnp6Loa68ZcK6rbM92ImwVK9Kynh0qSSg8Z
	 lBOm9vniVmB98H/XtWE05yXDI+CVMzS+Yvnk8f9fyixVEoY8oQwTG4ehtQfU0U1jXm
	 IDMPQzRY5EZYD1Q96zg+B5izhFmAgcE30S3Igc/M=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Haotian Zhang <vulab@iscas.ac.cn>,
	Lee Jones <lee@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 128/634] mfd: mt6397-irq: Fix missing irq_domain_remove() in error path
Date: Fri,  9 Jan 2026 12:36:46 +0100
Message-ID: <20260109112122.265509115@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260109112117.407257400@linuxfoundation.org>
References: <20260109112117.407257400@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
index eff53fed8fe73..eee40ec162ceb 100644
--- a/drivers/mfd/mt6397-irq.c
+++ b/drivers/mfd/mt6397-irq.c
@@ -213,6 +213,7 @@ int mt6397_irq_init(struct mt6397_chip *chip)
 	if (ret) {
 		dev_err(chip->dev, "failed to register irq=%d; err: %d\n",
 			chip->irq, ret);
+		irq_domain_remove(chip->irq_domain);
 		return ret;
 	}
 
-- 
2.51.0



