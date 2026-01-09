Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7430C2DEA6F;
	Fri,  9 Jan 2026 11:58:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767959899; cv=none; b=d1iXhEnW3przY9X9+X3XiQC74JOYIf85lYIbnol0m5DIPjzoanUoNIR0iQ0zNlZGP7M0cKWjLhrnqjA1csAmVd28yRT3YBISUsxiic3wLWi8zlwk59D1DIrWDBJTiS2MfALDyXKsgyK3TjQqdknZxsI095YqqDR1nPC2XjxOR6w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767959899; c=relaxed/simple;
	bh=2pP+hrht66k6Xz8c+sGX7P94tH3JQXtSR8+DibfQgj4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Nt6FAib8GU1EPkVWGWdSpuQvalr+hpRS2tsVeFx72J7I70t/eGAWwKsI2teZTlUWABq9hqg5jYZF0K8YLrn2eynJZgGe3xlLt/rz5FYu7jSnLO8Pxc21DtW23zpquKACWfpjMQQxdw50KBWr0AsTdZ32hqITrZO5EAWcDsYoRHs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=OVTClfaV; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="OVTClfaV"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F3008C4CEF1;
	Fri,  9 Jan 2026 11:58:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1767959899;
	bh=2pP+hrht66k6Xz8c+sGX7P94tH3JQXtSR8+DibfQgj4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=OVTClfaVV9ZhLOD+JFftV5EPAGYlNWMbAPwThLEZPrtnxgUG4TAS1vnA2u36jy/uM
	 VKAGP2EMwA16jkszY/YTN1NvptrUuCORaE4G+8wflSciRHkIObgnQHb0T6X2QEa0Nc
	 rSYy1iNLOBwaNRxY4T3gB88YqD2M2zNh7ybQvOBo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Haotian Zhang <vulab@iscas.ac.cn>,
	Lee Jones <lee@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 182/737] mfd: mt6397-irq: Fix missing irq_domain_remove() in error path
Date: Fri,  9 Jan 2026 12:35:21 +0100
Message-ID: <20260109112140.840776484@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260109112133.973195406@linuxfoundation.org>
References: <20260109112133.973195406@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
index 886745b5b607c..1e83f7c7ce145 100644
--- a/drivers/mfd/mt6397-irq.c
+++ b/drivers/mfd/mt6397-irq.c
@@ -208,6 +208,7 @@ int mt6397_irq_init(struct mt6397_chip *chip)
 	if (ret) {
 		dev_err(chip->dev, "failed to register irq=%d; err: %d\n",
 			chip->irq, ret);
+		irq_domain_remove(chip->irq_domain);
 		return ret;
 	}
 
-- 
2.51.0



