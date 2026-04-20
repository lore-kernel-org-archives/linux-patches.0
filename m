Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B38862236E3;
	Mon, 20 Apr 2026 16:09:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776701355; cv=none; b=NxehY2tQO9nVz6kbwYM/qwjdE1AF9RkiMY1ICeydpdhLqbJzsyxyhtd1LdvloflepWRDYqdt/FEPGVMtAtixWVseIJ9MNSv/KGUovEI1i6FkKubWEFKsaekkKgOYzGC+sYk6yyK/m+zzJ/ETM1RxilRj3AgfM3CUgJrnyW+fC0I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776701355; c=relaxed/simple;
	bh=lzFQQHsKRHgIP39PTetC6HUGyxKIL5al+a+Cps4ZW4E=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=dL+R05KTWn9YatBxsbgSeSZ0GW2h/Au2hoU6mpX7fwYkQ+RChollyrqkSigyZy1Mgk/hxQ0Kkic0YKsYm9P2DrF1nhgtGDPLuZR4DPM11DfK4ENvpRX2RmZA2v7CRDbxVqAvwiAaUOOeLLQpOczUnda8uEq8hczY88emH9JEc/8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ozv0Ju/3; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ozv0Ju/3"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4A973C19425;
	Mon, 20 Apr 2026 16:09:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1776701355;
	bh=lzFQQHsKRHgIP39PTetC6HUGyxKIL5al+a+Cps4ZW4E=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ozv0Ju/3Poo9Iltik0fVax6U0v0BA0jYqnGPyFJczXEzQurbPd1n3DyUsq6uDVq1e
	 wMLl3/3U4oiTxkALIVBqZYRJJzi/cGJXR+tyNfJS1RQ4B5Pk+kOjTWk4wXP3y8RVCX
	 y2FjgBJ+wP2Gm3lb6l1pfSOzTDzP8andUl2bXgOI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Samasth Norway Ananda <samasth.norway.ananda@oracle.com>,
	Bartosz Golaszewski <bartosz.golaszewski@oss.qualcomm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 080/162] gpio: tegra: fix irq_release_resources calling enable instead of disable
Date: Mon, 20 Apr 2026 17:41:52 +0200
Message-ID: <20260420153929.933911924@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260420153927.006696811@linuxfoundation.org>
References: <20260420153927.006696811@linuxfoundation.org>
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

From: Samasth Norway Ananda <samasth.norway.ananda@oracle.com>

[ Upstream commit 1561d96f5f55c1bca9ff047ace5813f4f244eea6 ]

tegra_gpio_irq_release_resources() erroneously calls tegra_gpio_enable()
instead of tegra_gpio_disable(). When IRQ resources are released, the
GPIO configuration bit (CNF) should be cleared to deconfigure the pin as
a GPIO. Leaving it enabled wastes power and can cause unexpected behavior
if the pin is later reused for an alternate function via pinctrl.

Fixes: 66fecef5bde0 ("gpio: tegra: Convert to gpio_irq_chip")
Signed-off-by: Samasth Norway Ananda <samasth.norway.ananda@oracle.com>
Link: https://patch.msgid.link/20260407210247.1737938-1-samasth.norway.ananda@oracle.com
Signed-off-by: Bartosz Golaszewski <bartosz.golaszewski@oss.qualcomm.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpio/gpio-tegra.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/gpio/gpio-tegra.c b/drivers/gpio/gpio-tegra.c
index 6d3a39a03f58e..cc7435ecada80 100644
--- a/drivers/gpio/gpio-tegra.c
+++ b/drivers/gpio/gpio-tegra.c
@@ -593,7 +593,7 @@ static void tegra_gpio_irq_release_resources(struct irq_data *d)
 	struct tegra_gpio_info *tgi = gpiochip_get_data(chip);
 
 	gpiochip_relres_irq(chip, d->hwirq);
-	tegra_gpio_enable(tgi, d->hwirq);
+	tegra_gpio_disable(tgi, d->hwirq);
 }
 
 static void tegra_gpio_irq_print_chip(struct irq_data *d, struct seq_file *s)
-- 
2.53.0



