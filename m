Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 441753D5642;
	Wed, 20 May 2026 17:14:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779297258; cv=none; b=rdAk5UyHKYPsPxUICNWxG+kzUMxXIGvvZqP/p6yRAMQQ+921D1VRP9FofYPvisYoPGLMy669gnJ9IQpN1Le1JLQuFzU4VLjdHPqGjRJdCz1kEDU+r6XXS3kkzAJbXAIBpJCSg1I7nOxJjWhbhB9pRCJkc8m7EoSQspz29mUwaTo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779297258; c=relaxed/simple;
	bh=Rdf2cwa/LzPXopYsU+DJOl1Ao8Z8d3mC/qQvYdvnaNY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=flf4t/13VbxZi5O48IjcG5DFFi5FwJgRtkQIYbakq7k2aBUpOuzCYUH1Ey2rKfnWITtEOvDTCR4XrUuDN1OhQ6Fr3TCgMgXnaxcpJnvUWPm8FRjUsqmRUyFHp5R+h7Vx3WI1kQd9zEkrejdTid+iqy7KydJbmBerdk/gJin6MkA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=1loVXGig; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="1loVXGig"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A87621F000E9;
	Wed, 20 May 2026 17:14:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1779297257;
	bh=Ef8M3Hb7n4RDBAhSOUpwHxozQtDnGn2DEdcMueMA02w=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=1loVXGigebWl90aTModPNs/PEEgr8BEQCVW1+jzcSdoVuLpBCX2F9meHw6Cnywd6D
	 6ocTueXgWGH8s9cb3WfFbbkFVoNr6Ms5fpiPNr2aUwXhp9xJdyKCzs9h24vXgOd4Y1
	 vGWX2x3RcClwiLHzw+Mk+yMt0Md7G2uFJ8EyWzw4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Xianwei Zhao <xianwei.zhao@amlogic.com>,
	Thomas Gleixner <tglx@kernel.org>
Subject: [PATCH 7.0 1110/1146] irqchip/meson-gpio: Use the correct register in meson_s4_gpio_irq_set_type()
Date: Wed, 20 May 2026 18:22:40 +0200
Message-ID: <20260520162213.366286188@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260520162148.390695140@linuxfoundation.org>
References: <20260520162148.390695140@linuxfoundation.org>
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

7.0-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Xianwei Zhao <xianwei.zhao@amlogic.com>

commit 5363b67ac8ebcc3e227dbf59fc8061949109841d upstream.

meson_s4_gpio_irq_set_type() uses the both-edge trigger register for
configuring level type and single edge mode interrupts, which is not
correct.

Use REG_EDGE_POL instead.

Fixes: bbd6fcc76b39 ("irqchip: Add support for Amlogic A4 and A5 SoCs")
Signed-off-by: Xianwei Zhao <xianwei.zhao@amlogic.com>
Signed-off-by: Thomas Gleixner <tglx@kernel.org>
Cc: stable@vger.kernel.org
Link: https://patch.msgid.link/20260508-a9-gpio-irqchip-v1-1-9dc5f3e022e0@amlogic.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/irqchip/irq-meson-gpio.c |    3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

--- a/drivers/irqchip/irq-meson-gpio.c
+++ b/drivers/irqchip/irq-meson-gpio.c
@@ -415,8 +415,7 @@ static int meson_s4_gpio_irq_set_type(st
 	if (type & (IRQ_TYPE_EDGE_RISING | IRQ_TYPE_EDGE_FALLING))
 		val |= BIT(ctl->params->edge_single_offset + idx);
 
-	meson_gpio_irq_update_bits(ctl, params->edge_pol_reg,
-				   BIT(idx) | BIT(12 + idx), val);
+	meson_gpio_irq_update_bits(ctl, REG_EDGE_POL, BIT(idx) | BIT(12 + idx), val);
 	return 0;
 };
 


