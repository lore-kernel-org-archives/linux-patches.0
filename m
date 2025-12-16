Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 05E7431B10F;
	Tue, 16 Dec 2025 11:27:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765884431; cv=none; b=UlX9ZK8vE37hkhUVWM7yjWqkNdmNq53cg0uF2ZFp1UKZ82G34H6YZMu3WFpBOWezJHoz95v4tGO5VyTknsPvi8vi9/vDgGlgOqr77wIGiBqZuInRGs+jy7jOjba758O+LBKT8WZUCrKmNLEkepdmHOHswPoqp3QsHy5uLmY0pks=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765884431; c=relaxed/simple;
	bh=Sok0bEkFfDcajiSz/ZynEFQuhbz6xsVaQfVvmX8ZueI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=eTMOaqfDKp9XqSun5MrsyeTwlNqFIJWyCwMbnQ0/eo68UU7P29FIYYoSQZQUwm4BNLzGXl52k+nEpGx0KwTxT5pKhrRKqKwsaT0fmHp4mTKmFdMbjZ+ZRJytrdR70bhEOBNIFEaQPy75bhh36rArOf402WyBueOmUknH2FgQ6TY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=xjcigebU; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="xjcigebU"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7DA07C4CEF1;
	Tue, 16 Dec 2025 11:27:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1765884430;
	bh=Sok0bEkFfDcajiSz/ZynEFQuhbz6xsVaQfVvmX8ZueI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=xjcigebUUJ48wsf/jhvloqfTUtIRxLRczzRxDeUUHm+RzfvKUx98nNJn4WmEFuS9o
	 MpqQaApkGPir5WYabHk9h0zEg8GhN9l1qs7p+IKvXVfcDd/xjzYAyIOJOR96lSYD+z
	 vQmt2Ou7AP/nAxSDp40R98zWOg9f09A7WWqXdnBk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Haotian Zhang <vulab@iscas.ac.cn>,
	Lee Jones <lee@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 191/354] mfd: mt6358-irq: Fix missing irq_domain_remove() in error path
Date: Tue, 16 Dec 2025 12:12:38 +0100
Message-ID: <20251216111327.832690592@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251216111320.896758933@linuxfoundation.org>
References: <20251216111320.896758933@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
index 49830b526ee88..10a0952615a17 100644
--- a/drivers/mfd/mt6358-irq.c
+++ b/drivers/mfd/mt6358-irq.c
@@ -286,6 +286,7 @@ int mt6358_irq_init(struct mt6397_chip *chip)
 	if (ret) {
 		dev_err(chip->dev, "Failed to register IRQ=%d, ret=%d\n",
 			chip->irq, ret);
+		irq_domain_remove(chip->irq_domain);
 		return ret;
 	}
 
-- 
2.51.0



