Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EECE41ED38
	for <patches@lists.linux.dev>; Tue, 25 Jul 2023 11:29:41 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6FFDDC433C7;
	Tue, 25 Jul 2023 11:29:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1690284581;
	bh=fu8CJD/THZTXHNlEh0mtEDWCdNvQyzUavi+Geh1wHzM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=XpdkJvqPNKQoO9w1XAro0wtKL9lWO0xcj6TvGEd3vlfq+kRN/NKJ5XCJcy8DKeBRF
	 qK1ea599IU5GV/rKlmuyu/kRoeD/Eph6Uw3R8XrUgxeG4BiJJXNto+fN1epYeU/dQu
	 qan6JBTOVGyQeQAJHUnc3YVAQI50FYbstFYaKGaE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jan Visser <starquake@linuxeverywhere.org>,
	Mario Limonciello <mario.limonciello@amd.com>,
	Linus Walleij <linus.walleij@linaro.org>
Subject: [PATCH 5.10 379/509] pinctrl: amd: Only use special debounce behavior for GPIO 0
Date: Tue, 25 Jul 2023 12:45:18 +0200
Message-ID: <20230725104611.080188347@linuxfoundation.org>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20230725104553.588743331@linuxfoundation.org>
References: <20230725104553.588743331@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Mario Limonciello <mario.limonciello@amd.com>

commit 0d5ace1a07f7e846d0f6d972af60d05515599d0b upstream.

It's uncommon to use debounce on any other pin, but technically
we should only set debounce to 0 when working off GPIO0.

Cc: stable@vger.kernel.org
Tested-by: Jan Visser <starquake@linuxeverywhere.org>
Fixes: 968ab9261627 ("pinctrl: amd: Detect internal GPIO0 debounce handling")
Signed-off-by: Mario Limonciello <mario.limonciello@amd.com>
Link: https://lore.kernel.org/r/20230705133005.577-2-mario.limonciello@amd.com
Signed-off-by: Linus Walleij <linus.walleij@linaro.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/pinctrl/pinctrl-amd.c |    8 +++++---
 1 file changed, 5 insertions(+), 3 deletions(-)

--- a/drivers/pinctrl/pinctrl-amd.c
+++ b/drivers/pinctrl/pinctrl-amd.c
@@ -128,9 +128,11 @@ static int amd_gpio_set_debounce(struct
 	raw_spin_lock_irqsave(&gpio_dev->lock, flags);
 
 	/* Use special handling for Pin0 debounce */
-	pin_reg = readl(gpio_dev->base + WAKE_INT_MASTER_REG);
-	if (pin_reg & INTERNAL_GPIO0_DEBOUNCE)
-		debounce = 0;
+	if (offset == 0) {
+		pin_reg = readl(gpio_dev->base + WAKE_INT_MASTER_REG);
+		if (pin_reg & INTERNAL_GPIO0_DEBOUNCE)
+			debounce = 0;
+	}
 
 	pin_reg = readl(gpio_dev->base + offset * 4);
 


