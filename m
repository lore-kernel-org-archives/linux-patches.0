Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3111B4BC009;
	Mon, 20 Apr 2026 13:32:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776691973; cv=none; b=nZPYUsys5NpD6Ybdcm6Fe6R6fEKCmvLuwRGyEg8FdyfxsYNFSSp242tHEqb2gJAFY948aMJvLYXcMXyFDWwd5FYbcTkUcwHQjFnE+46OaAUX4YurV2OQ/UNvbRIbnW7IaJ7IpRIox/nd/2l7XmnYxkVPD+hzpJpYKmmqctewvoE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776691973; c=relaxed/simple;
	bh=ygLoYx8ZSLC+bb1Qij8yqEMz1QBgFeofoq+0ubva8y8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=A4NLoBfMPcKA3Oh4TIBPFSswBdEFb64W0EBHtxrosUorHx5TSFnOkD8PPhofTVNHWNuW4gBWwH5MJbiGuEcOj0ikj2XHO2k7b/hi+zMAQpHbFIgkYP1fH5XDkNVf7RskXS5aLZojVoBp6Lq8SIwMcDl6avEkJXARN6zYk8bxXSg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=jhCQE5DU; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="jhCQE5DU"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E2347C2BCB6;
	Mon, 20 Apr 2026 13:32:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1776691973;
	bh=ygLoYx8ZSLC+bb1Qij8yqEMz1QBgFeofoq+0ubva8y8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=jhCQE5DUUdj1SeqHGNC472t5KiFU6bxNwWFdFOcCyG6QmmU5U6H4KG2FNLYcECodP
	 EVfdgws/A7p2Qb2W96dhh0ldiXqgXjaAHvR7H9tSQkm56Jtz6ud/pXGqnmZ7IWLwEZ
	 S7gmaAO1TSuuDcDHOV3WZnAihk2tBBqA8LOHXN/Zh8W1+v7P/GQmAu+HRPSHoTrvru
	 ijREK+UGcf6cNiXsO140x7sGJnkERhVFGLwsOy9PO1CdPBpZYQPBKTmJN3Yfe6ndo6
	 LJehrCq1GaE+02QZrL5HKR70Ynityrlq52ZWDYt0tRgkElnic7LlFKPYXk176jyf8X
	 g7YZ8EtNqzP1g==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Samasth Norway Ananda <samasth.norway.ananda@oracle.com>,
	Bartosz Golaszewski <bartosz.golaszewski@oss.qualcomm.com>,
	Sasha Levin <sashal@kernel.org>,
	linusw@kernel.org,
	brgl@kernel.org,
	thierry.reding@kernel.org,
	jonathanh@nvidia.com,
	linux-gpio@vger.kernel.org,
	linux-tegra@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH AUTOSEL 6.18] gpio: tegra: fix irq_release_resources calling enable instead of disable
Date: Mon, 20 Apr 2026 09:21:33 -0400
Message-ID: <20260420132314.1023554-299-sashal@kernel.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260420132314.1023554-1-sashal@kernel.org>
References: <20260420132314.1023554-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
X-stable-base: Linux 6.18.23
Content-Transfer-Encoding: 8bit

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

LLM Generated explanations, may be completely bogus:

Error: Failed to generate final synthesis

 drivers/gpio/gpio-tegra.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/gpio/gpio-tegra.c b/drivers/gpio/gpio-tegra.c
index 15a5762a82c25..b14052fe64ac6 100644
--- a/drivers/gpio/gpio-tegra.c
+++ b/drivers/gpio/gpio-tegra.c
@@ -595,7 +595,7 @@ static void tegra_gpio_irq_release_resources(struct irq_data *d)
 	struct tegra_gpio_info *tgi = gpiochip_get_data(chip);
 
 	gpiochip_relres_irq(chip, d->hwirq);
-	tegra_gpio_enable(tgi, d->hwirq);
+	tegra_gpio_disable(tgi, d->hwirq);
 }
 
 static void tegra_gpio_irq_print_chip(struct irq_data *d, struct seq_file *s)
-- 
2.53.0

