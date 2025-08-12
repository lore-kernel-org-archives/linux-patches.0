Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8FA341A9F89;
	Tue, 12 Aug 2025 18:33:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755023611; cv=none; b=ZwTGLVLSMC3uS92DTL5H+RnvLqGoE1p+0pOWYuEttMSXmk4rfUrWJysUogEWaBAdKM8tkH3p6YAI1dMmGnO5WdOH8JtcroGOog2XwTgoNpPqCYN8cUAnIRr/F1XWXtFVcSI1b1b0aLmyLMwi8X0bg44Xlk98MLWbd1nZxQIZb/4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755023611; c=relaxed/simple;
	bh=U84ytQ8rdQ7W1MTPYHtVVQdrkoKfA9/7u74zGakvOOk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=eCL6uMeCr/dGy8s+2IoGlXzBMwXUw8pOTEalmK9YbsHsA0vqo2YWEc+MxrY+0oBdbs3FEAc101XK30b9aNVj0fJEHygkN4xNbwM7ObdGzzhT3fyoZuqN4RNF5PA00f+8wK+lC4ohJHiTBDZRSiUOx8iC/jl6U2ACH3E52oquw00=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=TH5QnHMk; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="TH5QnHMk"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A092DC4CEF0;
	Tue, 12 Aug 2025 18:33:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1755023611;
	bh=U84ytQ8rdQ7W1MTPYHtVVQdrkoKfA9/7u74zGakvOOk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=TH5QnHMkxr89DHqgj/Vz1ahEY4WgX5gS5st93+Ibq5qFpBnVhJcvXHTjAq8BEo8hp
	 jCOJVG3IyI97Sk7LeQQcpTeewFCNljwvPxScC20AW6+NgUZAis06DybD/rvv3aD3G8
	 B17DeurrNuxle09hSxXJrTUGJUYfV3AcipIH56Ew=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Thomas Bogendoerfer <tsbogend@alpha.franken.de>,
	Bartosz Golaszewski <bartosz.golaszewski@linaro.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.16 129/627] MIPS: alchemy: gpio: use new GPIO line value setter callbacks for the remaining chips
Date: Tue, 12 Aug 2025 19:27:04 +0200
Message-ID: <20250812173424.227634022@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250812173419.303046420@linuxfoundation.org>
References: <20250812173419.303046420@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.16-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Bartosz Golaszewski <bartosz.golaszewski@linaro.org>

[ Upstream commit 6b94bf976f9f9e6d4a6bf3218968a506c049702e ]

Previous commit missed two other places that need converting, it only
came out in tests on autobuilders now. Convert the rest of the driver.

Fixes: 68bdc4dc1130 ("MIPS: alchemy: gpio: use new line value setter callbacks")
Acked-by: Thomas Bogendoerfer <tsbogend@alpha.franken.de>
Link: https://lore.kernel.org/r/20250727082442.13182-1-brgl@bgdev.pl
Signed-off-by: Bartosz Golaszewski <bartosz.golaszewski@linaro.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/mips/alchemy/common/gpiolib.c | 12 ++++++++----
 1 file changed, 8 insertions(+), 4 deletions(-)

diff --git a/arch/mips/alchemy/common/gpiolib.c b/arch/mips/alchemy/common/gpiolib.c
index 411f70ceb762..194034eba75f 100644
--- a/arch/mips/alchemy/common/gpiolib.c
+++ b/arch/mips/alchemy/common/gpiolib.c
@@ -40,9 +40,11 @@ static int gpio2_get(struct gpio_chip *chip, unsigned offset)
 	return !!alchemy_gpio2_get_value(offset + ALCHEMY_GPIO2_BASE);
 }
 
-static void gpio2_set(struct gpio_chip *chip, unsigned offset, int value)
+static int gpio2_set(struct gpio_chip *chip, unsigned offset, int value)
 {
 	alchemy_gpio2_set_value(offset + ALCHEMY_GPIO2_BASE, value);
+
+	return 0;
 }
 
 static int gpio2_direction_input(struct gpio_chip *chip, unsigned offset)
@@ -68,10 +70,12 @@ static int gpio1_get(struct gpio_chip *chip, unsigned offset)
 	return !!alchemy_gpio1_get_value(offset + ALCHEMY_GPIO1_BASE);
 }
 
-static void gpio1_set(struct gpio_chip *chip,
+static int gpio1_set(struct gpio_chip *chip,
 				unsigned offset, int value)
 {
 	alchemy_gpio1_set_value(offset + ALCHEMY_GPIO1_BASE, value);
+
+	return 0;
 }
 
 static int gpio1_direction_input(struct gpio_chip *chip, unsigned offset)
@@ -97,7 +101,7 @@ struct gpio_chip alchemy_gpio_chip[] = {
 		.direction_input	= gpio1_direction_input,
 		.direction_output	= gpio1_direction_output,
 		.get			= gpio1_get,
-		.set			= gpio1_set,
+		.set_rv			= gpio1_set,
 		.to_irq			= gpio1_to_irq,
 		.base			= ALCHEMY_GPIO1_BASE,
 		.ngpio			= ALCHEMY_GPIO1_NUM,
@@ -107,7 +111,7 @@ struct gpio_chip alchemy_gpio_chip[] = {
 		.direction_input	= gpio2_direction_input,
 		.direction_output	= gpio2_direction_output,
 		.get			= gpio2_get,
-		.set			= gpio2_set,
+		.set_rv			= gpio2_set,
 		.to_irq			= gpio2_to_irq,
 		.base			= ALCHEMY_GPIO2_BASE,
 		.ngpio			= ALCHEMY_GPIO2_NUM,
-- 
2.39.5



