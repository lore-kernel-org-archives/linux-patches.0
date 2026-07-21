Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6AC18388E40;
	Tue, 21 Jul 2026 19:11:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784661104; cv=none; b=tLVGLiHlRmfmTJvtAyhU9xuxawLnqP4NrNljNhvW7mBH8vVox4GCJhIRnY2eBNBfjhyGqEPTlLl+Iv/USicmO1/suAJCGiOaD2WRiHCXgSp7Rr70wib0CqjX/KTO5CYwswcqgoCkJ2/Onl89Tx25bZWmnDGSgndAWFT1LtD08m4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784661104; c=relaxed/simple;
	bh=YKrUgAhizPN4+v1e4MxoLvFCV5pgrhKChnnKG0V/F64=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=CxNUEjYk9OxVarLDnTRCWpZu2JhsHu5B3oAHraAka0hjfu6zbbEAUz6gzrdIGHTapcufr6L3/jnll9HZNQxOw1UEqMNCjuCmWW4BlE9oZ/H8dUnEptt8RUVNEqF1tY+tnCI4Q/avNeAKrEyP+dFSGKhkVOoiq/SYZq6AFM2Po5M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=BXUNZncY; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="BXUNZncY"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D0F101F000E9;
	Tue, 21 Jul 2026 19:11:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784661103;
	bh=XnxKzRsb53PEamkGAe1OhoSacR9a72lUo8orIKZVJxY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=BXUNZncYaHVoPS93nw9iJHBWpgd/SdnHk+IexcDgNxj9MbFECVVEiX56iGPjPKMzD
	 nLdbG9kV29G4687P0fApIigVsJP1msE8TNY25wtK5FUNqZXwKknotcApTJvet/BM4y
	 DZFK4QN/4l7Ibd0U3y4Ji9id34OQ2/lKDbGf3z2g=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Qingshuang Fu <fuqingshuang@kylinos.cn>,
	Bartosz Golaszewski <bartosz.golaszewski@oss.qualcomm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.1 1231/2077] gpio: davinci: fix IRQ domain leak on devm_kzalloc failure
Date: Tue, 21 Jul 2026 17:15:04 +0200
Message-ID: <20260721152621.848176025@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152552.646164743@linuxfoundation.org>
References: <20260721152552.646164743@linuxfoundation.org>
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

7.1-stable review patch.  If anyone has any objections, please let me know.

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
index 97780f27ce5b56..270cd7c8881203 100644
--- a/drivers/gpio/gpio-davinci.c
+++ b/drivers/gpio/gpio-davinci.c
@@ -568,8 +568,10 @@ static int davinci_gpio_irq_setup(struct platform_device *pdev)
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



