Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3D57E1BE229;
	Tue,  2 Jul 2024 17:10:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719940250; cv=none; b=hlKC3YQp2PVlaK9ldOuUgdffN7HdgOifLocxCtPBbkJ/ysFRVJ8dDe9lH797/bibcRLWegn59a1mZcYPQK7ZlrD0tQsg0Vx3PzH1D170YQ2EXo7A8SCLG+uFUnnKBzHAAA3yTk1UlewhGHTyrPq1cd8yXj86sibsoDqd5gw92dc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719940250; c=relaxed/simple;
	bh=VIgq2G8BX6aAsMF/8EgmsVLg/hE9bgtUo7jymFecdZ8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=FsME2mx6dWhxaIic1i0rFw+pqjsZ0vd+HoWXBwflGcgxsnj/wtOF4T0flfkq0/df5ynjgujeDOvHGXq+3ixdgIWe4IOYVlnPa84XonKNWNACU5SUsDKQAPSxCzsq9eEmg3RP3LTWyCP3U5POLrgWa2bWmnFmAl0gkmSfA+g+1+Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=sUaR+RTR; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="sUaR+RTR"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 69172C4AF07;
	Tue,  2 Jul 2024 17:10:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1719940249;
	bh=VIgq2G8BX6aAsMF/8EgmsVLg/hE9bgtUo7jymFecdZ8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=sUaR+RTR0HuGRbPjgj90giwnFgod/LWSxYifXh4L7c5gwrJuJw+3h5I1oqa/cKbbW
	 CE9GZJDuOoo+tjnJuCaTH5NIlq57G5I1sGYhNUrR2o2TXd8USl3ib6jsoC1eKVGcnD
	 Lo/4ar7DD/QfhzGV59rwoRNn/uXFxY7p21I8C1ws=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Aleksandr Mishin <amishin@t-argos.ru>,
	Bartosz Golaszewski <bartosz.golaszewski@linaro.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.9 098/222] gpio: davinci: Validate the obtained number of IRQs
Date: Tue,  2 Jul 2024 19:02:16 +0200
Message-ID: <20240702170247.715179465@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240702170243.963426416@linuxfoundation.org>
References: <20240702170243.963426416@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.9-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Aleksandr Mishin <amishin@t-argos.ru>

[ Upstream commit 7aa9b96e9a73e4ec1771492d0527bd5fc5ef9164 ]

Value of pdata->gpio_unbanked is taken from Device Tree. In case of broken
DT due to any error this value can be any. Without this value validation
there can be out of chips->irqs array boundaries access in
davinci_gpio_probe().

Validate the obtained nirq value so that it won't exceed the maximum
number of IRQs per bank.

Found by Linux Verification Center (linuxtesting.org) with SVACE.

Fixes: eb3744a2dd01 ("gpio: davinci: Do not assume continuous IRQ numbering")
Signed-off-by: Aleksandr Mishin <amishin@t-argos.ru>
Link: https://lore.kernel.org/r/20240618144344.16943-1-amishin@t-argos.ru
Signed-off-by: Bartosz Golaszewski <bartosz.golaszewski@linaro.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpio/gpio-davinci.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/drivers/gpio/gpio-davinci.c b/drivers/gpio/gpio-davinci.c
index bb499e3629125..1d0175d6350b7 100644
--- a/drivers/gpio/gpio-davinci.c
+++ b/drivers/gpio/gpio-davinci.c
@@ -225,6 +225,11 @@ static int davinci_gpio_probe(struct platform_device *pdev)
 	else
 		nirq = DIV_ROUND_UP(ngpio, 16);
 
+	if (nirq > MAX_INT_PER_BANK) {
+		dev_err(dev, "Too many IRQs!\n");
+		return -EINVAL;
+	}
+
 	chips = devm_kzalloc(dev, sizeof(*chips), GFP_KERNEL);
 	if (!chips)
 		return -ENOMEM;
-- 
2.43.0



