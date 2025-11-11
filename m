Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 51AF534AB1B;
	Tue, 11 Nov 2025 01:42:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762825350; cv=none; b=OTZN4vDMlATwDkhAJWKGYwPhTg3CVd6llHxgz5+5qJVXWtC0aBeh03xeUvrho1DS9svjJcqgz8cRdVoAHKqgbK7VuP+8KyQZm/trQCbjz5zysvLUhHzY6i65xY+IgC+QN1b5ks8KzoKGSKDuOwoNNs6hIFDvq9scdzZ77hb1gFE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762825350; c=relaxed/simple;
	bh=DF/cWCzDOmTRVyTNkf/D/PcDyU2SNjSTWax3z56k1qE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=LDyFXSIz8DDGd6GH70us94+c/Krs7MFdhQj0Ue+UhfJrwvDDcDddR3rYfXi1GTlgw5F/Az9U2U/Px04RE1vTbJ84Pou4HgU3OLO29a8t2XlkkvC29qhhzTW8TJAZDvisojID+tkDgflPgEch3VVSJP0qo7Z3qzBe6Dhs+rRvE5w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=BhLaSGLh; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="BhLaSGLh"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E0C79C116B1;
	Tue, 11 Nov 2025 01:42:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1762825350;
	bh=DF/cWCzDOmTRVyTNkf/D/PcDyU2SNjSTWax3z56k1qE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=BhLaSGLhMhUC3Z85wi8hOyuZ79MbCed+CBcny2q7AtEvYONuHpKZgusDttIFEgsB7
	 vPoSjBF49MOgjGWqiebbPWve6+t2dtPGwx4CXvMpMWm1b1gRNLqKlyrHy/FI6X1LZ5
	 YCuHZurGO7LTBWI9OUi5kJ6c0o+YRFpW5MTcNr6A=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Linus Walleij <linus.walleij@linaro.org>,
	Bartosz Golaszewski <bartosz.golaszewski@linaro.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.17 766/849] gpio: swnode: dont use the swnodes name as the key for GPIO lookup
Date: Tue, 11 Nov 2025 09:45:36 +0900
Message-ID: <20251111004554.949162403@linuxfoundation.org>
X-Mailer: git-send-email 2.51.2
In-Reply-To: <20251111004536.460310036@linuxfoundation.org>
References: <20251111004536.460310036@linuxfoundation.org>
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

6.17-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Bartosz Golaszewski <bartosz.golaszewski@linaro.org>

[ Upstream commit e5d527be7e6984882306b49c067f1fec18920735 ]

Looking up a GPIO controller by label that is the name of the software
node is wonky at best - the GPIO controller driver is free to set
a different label than the name of its firmware node. We're already being
passed a firmware node handle attached to the GPIO device to
swnode_get_gpio_device() so use it instead for a more precise lookup.

Acked-by: Linus Walleij <linus.walleij@linaro.org>
Fixes: e7f9ff5dc90c ("gpiolib: add support for software nodes")
Link: https://lore.kernel.org/r/20251103-reset-gpios-swnodes-v4-4-6461800b6775@linaro.org
Signed-off-by: Bartosz Golaszewski <bartosz.golaszewski@linaro.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpio/gpiolib-swnode.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/gpio/gpiolib-swnode.c b/drivers/gpio/gpiolib-swnode.c
index f21dbc28cf2c8..e3806db1c0e07 100644
--- a/drivers/gpio/gpiolib-swnode.c
+++ b/drivers/gpio/gpiolib-swnode.c
@@ -41,7 +41,7 @@ static struct gpio_device *swnode_get_gpio_device(struct fwnode_handle *fwnode)
 	    !strcmp(gdev_node->name, GPIOLIB_SWNODE_UNDEFINED_NAME))
 		return ERR_PTR(-ENOENT);
 
-	gdev = gpio_device_find_by_label(gdev_node->name);
+	gdev = gpio_device_find_by_fwnode(fwnode);
 	return gdev ?: ERR_PTR(-EPROBE_DEFER);
 }
 
-- 
2.51.0



