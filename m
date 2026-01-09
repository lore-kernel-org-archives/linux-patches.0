Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4EFFC2737EE;
	Fri,  9 Jan 2026 12:29:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767961771; cv=none; b=g1pBrsi6L0t645aNeVSLDa9sbjbsNQnH46gOPQGKQSM+vL5vSdD4et7b+1mhey1xv7Zrcc9O3OxcZ7Zdmr3kE4tCsGy7JohByphYTzqmlRGG/dWYcNBZ/ff0+ESSisZY9ba6ratr6PWWLZ+Sx7uyRcnJDEIxj0kbcR1zmaMB6uU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767961771; c=relaxed/simple;
	bh=exdxAsvS6BIZnD3vXhfe0pBgFwV19GEaFetjv852xtU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ilFWDXQROjv8PrZz9jszeuxQ5T1KE6eHJg+wBLf9hEJvnno659KwL1FnO1XBNC3m75IeQ/xLIhwdqDrEG/qIHVaPr1Gr8BTNPo5JyM0j5M3vCvs3szXpLu5dl+o7NcJt4AKHqwdXU3bVoFYtFIL0Z30eP3EgvnhfIy+k/F1fhPA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ShSU9cU0; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ShSU9cU0"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CB8B4C4CEF1;
	Fri,  9 Jan 2026 12:29:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1767961771;
	bh=exdxAsvS6BIZnD3vXhfe0pBgFwV19GEaFetjv852xtU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ShSU9cU0AlB5moXk5ravQq2DLvBm0QKXbFMgAlkNshaTZOw7fi4fKXtBVZyMgcv6H
	 eZ6AbHhjJm5TQawF4MhtVjQRXgUR78vd1qiFjHs+VyfbAF8ifOp2p0fgy/9D5HOVYk
	 LnJ2xTGqDFAviXhLVgoJ2YcIipAj9/saWUDL8Uxg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Haotian Zhang <vulab@iscas.ac.cn>,
	Lee Jones <lee@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 129/634] mfd: mt6358-irq: Fix missing irq_domain_remove() in error path
Date: Fri,  9 Jan 2026 12:36:47 +0100
Message-ID: <20260109112122.303467499@linuxfoundation.org>
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
index 389756436af6c..d1e6e473c8e0a 100644
--- a/drivers/mfd/mt6358-irq.c
+++ b/drivers/mfd/mt6358-irq.c
@@ -287,6 +287,7 @@ int mt6358_irq_init(struct mt6397_chip *chip)
 	if (ret) {
 		dev_err(chip->dev, "Failed to register IRQ=%d, ret=%d\n",
 			chip->irq, ret);
+		irq_domain_remove(chip->irq_domain);
 		return ret;
 	}
 
-- 
2.51.0



