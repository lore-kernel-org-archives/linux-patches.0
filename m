Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DA06F326D44;
	Tue, 21 Jul 2026 17:41:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784655692; cv=none; b=Ay7Vdg65aG/7MOJSlvYx9kx4xudHBzGaIOxa5U6lOGxvfKQceCzbGVp3zF7V2/J3gJHM6/sNlIdXksXU5etANlWvZqhdd1zNjplWRdLdD6u+9UjBDz0q+QxGd62fYhlwWfzgxuK+6JY6uGsD26ADRzGOwdu1funMjG12KNfMwSg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784655692; c=relaxed/simple;
	bh=uCzGZCQmusLmMOKr6DEtbIpDO3HCvUyHwtIP2y+f0NI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=WJRw2tSYDtY9egiGkBirz4iYYfkdfm8ahIfBfXgtKp+X3qLdIrhnLMcqlcZIzIyg1+pGnl+G1CshgDztS1+mqotdkrlQizMUpPbsOdMKhP5mMh5q8WBJ5ZOJUWsY6ZZ8nemA2YP4sxI/vEmws/smhCMNwZcqXzLSRNoXDhQ1fEE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=QCbiABK/; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="QCbiABK/"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0076A1F00A3A;
	Tue, 21 Jul 2026 17:41:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784655691;
	bh=pS/xWxtSWHrQglqXZPXm/OcollCAMCyHJLH8bB0LKqw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=QCbiABK/5LG0zzFNs1lIi5ZMYQOBbrTI5+sPp23HUxjpI5fuyB0jTC6DIdDvbcgoe
	 Kxdg2hIOe4g5tAKsrscKEeocOWLwMMu9Fbz798e6g+Jy2559BrfFnOVgFxWhl4FAZL
	 nFS+F7l+SAFm9FozMThYb3Ft1dZ4aZWQ5lrPdayU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Felix Gu <ustc.gu@gmail.com>,
	Andre Przywara <andre.przywara@arm.com>,
	Linus Walleij <linusw@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0106/1611] pinctrl: sunxi: fix regulator leak in sunxi_pmx_request() error path
Date: Tue, 21 Jul 2026 17:03:42 +0200
Message-ID: <20260721152517.232970215@linuxfoundation.org>
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

From: Felix Gu <ustc.gu@gmail.com>

[ Upstream commit 334f7bcbdc79dc8e5b938ac3372453a5368221cf ]

In the error path of sunxi_pmx_request(), the code calls
regulator_put(s_reg->regulator) to release the regulator. However,
s_reg->regulator is only assigned after a successful regulator_enable().
This causes a memory leak: the regulator obtained via regulator_get()
is never properly released when regulator_enable() fails.

Fixes: dc1445584177 ("pinctrl: sunxi: Fix and simplify pin bank regulator handling")
Signed-off-by: Felix Gu <ustc.gu@gmail.com>
Reviewed-by: Andre Przywara <andre.przywara@arm.com>
Signed-off-by: Linus Walleij <linusw@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/pinctrl/sunxi/pinctrl-sunxi.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/pinctrl/sunxi/pinctrl-sunxi.c b/drivers/pinctrl/sunxi/pinctrl-sunxi.c
index 0fb057a07dccb6..93e396041456aa 100644
--- a/drivers/pinctrl/sunxi/pinctrl-sunxi.c
+++ b/drivers/pinctrl/sunxi/pinctrl-sunxi.c
@@ -896,7 +896,7 @@ static int sunxi_pmx_request(struct pinctrl_dev *pctldev, unsigned offset)
 	return 0;
 
 out:
-	regulator_put(s_reg->regulator);
+	regulator_put(reg);
 
 	return ret;
 }
-- 
2.53.0



