Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A93661A186B;
	Thu,  6 Jun 2024 14:13:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717683183; cv=none; b=F7Os11uAdkEyCD8NqWVaFsEozsHUoMZqIhR+O6aJ+H0g3X0gIhSjaxd91hetnByJUnd1W8cysosmv6U9Ybe/kyEnspIGg1M+tVSvYr39sKillIAotRWQ6vdJOp9oGDsR2VxRBeVIM6LlRQri85SKQiTUMflgs+bI8aM7YYI+OsQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717683183; c=relaxed/simple;
	bh=zazTcPIItb6KdguK4wvaJmBAS63EhVUrX/NJKB9zGc0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ex7SwjV6k3jlnQHdS6rFBq7Ygwy6n+lX6Q4DDwAVtcVQQo8cns+wDePJ1oc6eMtmCyWD4Vu2B6y3Lt+fRLulbPo5XwwkWRWvGPWSY7Wzg+zLdMDpD4mF6Hk7e9fOI+oBQLRabbvVtQRoyvK22aY/w48POwfT3Uq1pQy35s4VAUM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=1DnILOAr; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="1DnILOAr"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 81F6EC2BD10;
	Thu,  6 Jun 2024 14:13:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1717683183;
	bh=zazTcPIItb6KdguK4wvaJmBAS63EhVUrX/NJKB9zGc0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=1DnILOArj8TgBTvu86QYkdV9lYdDaZecSpb58fs/m/ytwhMj4ZRzn07Ong10EB33H
	 1+Gv1JuRPAR/DZARg/pQr1N6Q0WB7hT/qqxDV7i3MRp+hnuvqznCV1oJunYtwrkO01
	 7lXhcoxZ/oms+6grjvi7yyXxTnr8UKblyz3z34Lo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Matti Vaittinen <mazziesaccount@gmail.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 040/473] regulator: irq_helpers: duplicate IRQ name
Date: Thu,  6 Jun 2024 15:59:29 +0200
Message-ID: <20240606131701.216834492@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240606131659.786180261@linuxfoundation.org>
References: <20240606131659.786180261@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Matti Vaittinen <mazziesaccount@gmail.com>

[ Upstream commit 7ab681ddedd4b6dd2b047c74af95221c5f827e1d ]

The regulator IRQ helper requires caller to provide pointer to IRQ name
which is kept in memory by caller. All other data passed to the helper
in the regulator_irq_desc structure is copied. This can cause some
confusion and unnecessary complexity.

Make the regulator_irq_helper() to copy also the provided IRQ name
information so caller can discard the name after the call to
regulator_irq_helper() completes.

Signed-off-by: Matti Vaittinen <mazziesaccount@gmail.com>
Link: https://msgid.link/r/ZhJMuUYwaZbBXFGP@drtxq0yyyyyyyyyyyyydy-3.rev.dnainternet.fi
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/regulator/irq_helpers.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/regulator/irq_helpers.c b/drivers/regulator/irq_helpers.c
index fe7ae0f3f46af..5ab1a0befe12f 100644
--- a/drivers/regulator/irq_helpers.c
+++ b/drivers/regulator/irq_helpers.c
@@ -352,6 +352,9 @@ void *regulator_irq_helper(struct device *dev,
 
 	h->irq = irq;
 	h->desc = *d;
+	h->desc.name = devm_kstrdup(dev, d->name, GFP_KERNEL);
+	if (!h->desc.name)
+		return ERR_PTR(-ENOMEM);
 
 	ret = init_rdev_state(dev, h, rdev, common_errs, per_rdev_errs,
 			      rdev_amount);
-- 
2.43.0



