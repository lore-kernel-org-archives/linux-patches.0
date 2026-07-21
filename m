Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 08E0B37DE97;
	Tue, 21 Jul 2026 18:16:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784657811; cv=none; b=miU1CaICyS7fAh9/KBtZ7RIB9o0009Sexq1B1SmL6mWD/vogU9fVGHxh8POfWcWC29k35R6II79vemwWLw/ycxC0S9eSu8Hnmf5YHIB5WcmhZ3AAhsRmkXQqPc7s0J//E3Cp/tGy9SBKad4wfHwY+1XkkKws7IWM2Yd2OpxA8xc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784657811; c=relaxed/simple;
	bh=lfBV3OsLRQerQ9bmjYHVM4G7N3Y6/DAqQC4/T7LvSms=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=e86FzdahaGKlTJX61M4Ud6S1rF6OwDKdRoVsqZiRiffadoJg4sjFfKSdMAqHtPsZxJWp+hsyoiw4I/lkWwmFM6k6tmwhhXdKNUyQIRSXkPy6QZUPH+qT3fv/p4pIab8i0XOvJmVJmhS0CIpLkHzg1IMI4UiBcH1dRe454e/7qB8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=UJAgMOPR; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="UJAgMOPR"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6F0A61F00A3A;
	Tue, 21 Jul 2026 18:16:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784657809;
	bh=O15cWDyF8o3FthSNHECgorawkc0RaUOdZ7wc+p+6gc8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=UJAgMOPR5wX1VBb80GXS4rgf2uvB/FSZXhbmQxXCWkWLWDjDaM2CMSMWSDzWPTYPt
	 Rsq8JhSvfUZTrPq4Q8UvleQvgNaLtsYd1ZSgKUc5+Efk/dT3O3Xq8QHM0OhRveWJff
	 +zrIRG1cH362srGHBN/FlW7m8ki3Qzl6/RAYH8VE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Qingshuang Fu <fuqingshuang@kylinos.cn>,
	Bartosz Golaszewski <bartosz.golaszewski@oss.qualcomm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0906/1611] gpio: davinci: fix IRQ domain leak on devm_kzalloc failure
Date: Tue, 21 Jul 2026 17:17:02 +0200
Message-ID: <20260721152535.769058264@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152514.750365251@linuxfoundation.org>
References: <20260721152514.750365251@linuxfoundation.org>
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

From: Qingshuang Fu <fuqingshuang@kylinos.cn>

[ Upstream commit 4e8eb6952aa6749726c6c3763ae0032a6332c24f ]

In davinci_gpio_irq_setup(), after successfully creating an IRQ domain
with irq_domain_create_legacy(), a subsequent devm_kzalloc() failure
in the bank loop causes the function to return -ENOMEM without
removing the IRQ domain.

Unlike devm-managed resources, irq_domain_create_legacy() does not
auto-clean up on probe failure, so the domain is leaked.

Fix by calling irq_domain_remove() before returning on allocation
failure.

Fixes: b5cf3fd827d2 ("gpio: davinci: Redesign driver to accommodate ngpios in one gpio chip")
Signed-off-by: Qingshuang Fu <fuqingshuang@kylinos.cn>
Link: https://patch.msgid.link/20260623023106.117229-1-fffsqian@163.com
Signed-off-by: Bartosz Golaszewski <bartosz.golaszewski@oss.qualcomm.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpio/gpio-davinci.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/gpio/gpio-davinci.c b/drivers/gpio/gpio-davinci.c
index 538f27209ce718..5de42f1143dab6 100644
--- a/drivers/gpio/gpio-davinci.c
+++ b/drivers/gpio/gpio-davinci.c
@@ -550,8 +550,10 @@ static int davinci_gpio_irq_setup(struct platform_device *pdev)
 				       sizeof(struct
 					      davinci_gpio_irq_data),
 					      GFP_KERNEL);
-		if (!irqdata)
+		if (!irqdata) {
+			irq_domain_remove(chips->irq_domain);
 			return -ENOMEM;
+		}
 
 		irqdata->regs = g;
 		irqdata->bank_num = bank;
-- 
2.53.0



