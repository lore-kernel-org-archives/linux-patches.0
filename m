Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2A1922C1A2;
	Fri, 24 Nov 2023 19:13:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="IObGolmE"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 41106C433C8;
	Fri, 24 Nov 2023 19:13:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1700853194;
	bh=8/EIP52LrnZuHW+7iirnquJz4aVK7qeZ4yiq4ZdYBUY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=IObGolmEsgBB5m7AY4aj1z34M3UgNQqiTzViM7OgGQ+692g9rj6vj3cu1T5qzfk1F
	 wzvk8jooc9J+bPcDfKpDR73+ENBhLFW2v2TaprwWOGQniwubqa/Wu8m6j4ANPn0s/C
	 yZH+LO6agrDXlsdA6WMOJp1tvZFLErYb0V5kLp3M=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Andy Shevchenko <andy.shevchenko@gmail.com>,
	Bartosz Golaszewski <brgl@bgdev.pl>,
	Marc Zyngier <maz@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 091/297] gpio: Add helpers to ease the transition towards immutable irq_chip
Date: Fri, 24 Nov 2023 17:52:13 +0000
Message-ID: <20231124172003.432550908@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20231124172000.087816911@linuxfoundation.org>
References: <20231124172000.087816911@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Marc Zyngier <maz@kernel.org>

[ Upstream commit 36b78aae4bfee749bbde73be570796bfd0f56bec ]

Add a couple of new helpers to make it slightly simpler to convert
drivers to immutable irq_chip structures:

- GPIOCHIP_IRQ_RESOURCE_HELPERS populates the irq_chip structure
  with the resource management callbacks

- gpio_irq_chip_set_chip() populates the gpio_irq_chip.chip
  structure, avoiding the proliferation of ugly casts

Reviewed-by: Andy Shevchenko <andy.shevchenko@gmail.com>
Reviewed-by: Bartosz Golaszewski <brgl@bgdev.pl>
Signed-off-by: Marc Zyngier <maz@kernel.org>
Link: https://lore.kernel.org/r/20220419141846.598305-4-maz@kernel.org
Stable-dep-of: dc3115e6c5d9 ("hid: cp2112: Fix IRQ shutdown stopping polling for all IRQs on chip")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/linux/gpio/driver.h | 12 ++++++++++++
 1 file changed, 12 insertions(+)

diff --git a/include/linux/gpio/driver.h b/include/linux/gpio/driver.h
index b241fc23ff3a2..91f60d1e3eb31 100644
--- a/include/linux/gpio/driver.h
+++ b/include/linux/gpio/driver.h
@@ -599,6 +599,18 @@ void gpiochip_enable_irq(struct gpio_chip *gc, unsigned int offset);
 int gpiochip_irq_reqres(struct irq_data *data);
 void gpiochip_irq_relres(struct irq_data *data);
 
+/* Paste this in your irq_chip structure  */
+#define	GPIOCHIP_IRQ_RESOURCE_HELPERS					\
+		.irq_request_resources  = gpiochip_irq_reqres,		\
+		.irq_release_resources  = gpiochip_irq_relres
+
+static inline void gpio_irq_chip_set_chip(struct gpio_irq_chip *girq,
+					  const struct irq_chip *chip)
+{
+	/* Yes, dropping const is ugly, but it isn't like we have a choice */
+	girq->chip = (struct irq_chip *)chip;
+}
+
 /* Line status inquiry for drivers */
 bool gpiochip_line_is_open_drain(struct gpio_chip *gc, unsigned int offset);
 bool gpiochip_line_is_open_source(struct gpio_chip *gc, unsigned int offset);
-- 
2.42.0



