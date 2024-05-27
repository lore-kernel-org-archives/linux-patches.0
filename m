Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 94033168C4;
	Mon, 27 May 2024 19:19:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1716837574; cv=none; b=rEO4Zccxdr0wBmSRvNhwZwYvFBzbO9OqmdDvpwTHRNtJ49XmI0aW2/lYPqByc5IHQqBdpLx7DBfL0pKWQZiiUgFuMemub8EcPnb1WNmi2Kv0uWL0lZ3uvr583CUVMXWDII1/nYXwI2YijkuVGBjaJTYr492TCC004PSkQx3xsSU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1716837574; c=relaxed/simple;
	bh=8aVOomUMFjH8eqJqRAuFo+h6DjxaOgBsGKwP8YKdo6E=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ptCppxxf1TL2ATRJUZY9NcD0gzdkYXQnbjNLCd+eqHK/QyMdPEW3A4BGIrJbL/zTDS5AZ3Nma02oUSJkjkhbXseEGC2cdsa9CuxF6JcJ+/YE04UU5DAw9dW+7/2DgbLpPK8skO7FFwZVy+JAIaKWCxh8RbxzUK/vJTZCA4Kp1/I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=rQH8Dc2V; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="rQH8Dc2V"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2CFE6C2BBFC;
	Mon, 27 May 2024 19:19:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1716837574;
	bh=8aVOomUMFjH8eqJqRAuFo+h6DjxaOgBsGKwP8YKdo6E=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=rQH8Dc2VSFpB24l248Uo2rWzER3DZCiK62jn4rCSA74LYtK14ePl83qq9pPAC4jL7
	 aLU3LToZGKVVMkPMa/3O/ZlGhD9K6IMcWAuRm0IfQpHKyqttYAtCATi61vt7pbLgaR
	 ND5qzhK4FPI4Oj3v7Aov06Ao60ZIgFyVjiw37xaM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Matti Vaittinen <mazziesaccount@gmail.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.8 063/493] regulator: irq_helpers: duplicate IRQ name
Date: Mon, 27 May 2024 20:51:05 +0200
Message-ID: <20240527185631.649664150@linuxfoundation.org>
X-Mailer: git-send-email 2.45.1
In-Reply-To: <20240527185626.546110716@linuxfoundation.org>
References: <20240527185626.546110716@linuxfoundation.org>
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

6.8-stable review patch.  If anyone has any objections, please let me know.

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



