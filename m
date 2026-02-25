Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6BD7624677D;
	Wed, 25 Feb 2026 01:43:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771983830; cv=none; b=jMfI3stkyP3CxyamTLTRuM19o9mYw4Zg6w0GU/8Lbr3ybvJKtgLfl1UyjaawmEiVuVqWyjZ6iQE7wd4vQXyCbNNdvEIdiIMvgOrWBDy0YoGMoqfNMhBHKr3usN0B5ajrbejUGWIHkQsh1xdAmzKrAqWsSmdrVjlnREpul8iOfo4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771983830; c=relaxed/simple;
	bh=jYb/iwTdFa21o1Nh4duX3+s7sij+vjoNTAkGMliY4eQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=uMgt+sbTfxXLlPN5a4RTeuYPcGKxyUTzQBJzqc9sQJ8ENJ5wsw//RL5JXZLiAvF40skESekaIRFa0GKVjCMRc5+CSR13z4PYHB91dmoJSBmGgTRTCggMIT0gCE+XSt83h49GaA4+T5fSOyIQ41GVU4QOwW4gtah9k1cNnAZTxM4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=hY6YLxC+; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="hY6YLxC+"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 28617C116D0;
	Wed, 25 Feb 2026 01:43:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1771983830;
	bh=jYb/iwTdFa21o1Nh4duX3+s7sij+vjoNTAkGMliY4eQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=hY6YLxC+gMk/sN7/Fjqtlmf5oG8c9z6Cd54EAksmcHVefAwvGJcdPKOYqeoWbdiUI
	 V3JUjL0M2xWpdodcGIIROdxZSC0uMLEVclVwszkxXxX0QojjAJzU3CGlZ1v/opAFHA
	 ymxoUfVA0rzRaNKAPCqLmn9cJ6jO2CV0OZKnVsN4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
	Thomas Gleixner <tglx@kernel.org>,
	Heikki Krogerus <heikki.krogerus@linux.intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 111/641] usb: typec: fusb302: Remove IRQF_ONESHOT
Date: Tue, 24 Feb 2026 17:17:17 -0800
Message-ID: <20260225012351.812939390@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260225012348.915798704@linuxfoundation.org>
References: <20260225012348.915798704@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Sebastian Andrzej Siewior <bigeasy@linutronix.de>

[ Upstream commit a7fb84ea70aae9a92a842932206e70ed1b3c7007 ]

Passing IRQF_ONESHOT ensures that the interrupt source is masked until
the secondary (threaded) handler is done. If only a primary handler is
used then the flag makes no sense because the interrupt can not fire
(again) while its handler is running.

The flag also prevents force-threading of the primary handler and the
irq-core will warn about this.

Remove IRQF_ONESHOT from irqflags.

Fixes: 309b6341d5570 ("usb: typec: fusb302: Revert incorrect threaded irq fix")
Signed-off-by: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
Signed-off-by: Thomas Gleixner <tglx@kernel.org>
Acked-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Acked-by: Heikki Krogerus <heikki.krogerus@linux.intel.com>
Link: https://patch.msgid.link/20260128095540.863589-12-bigeasy@linutronix.de
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/usb/typec/tcpm/fusb302.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/drivers/usb/typec/tcpm/fusb302.c b/drivers/usb/typec/tcpm/fusb302.c
index 870a71f953f6c..19ff8217818e7 100644
--- a/drivers/usb/typec/tcpm/fusb302.c
+++ b/drivers/usb/typec/tcpm/fusb302.c
@@ -1756,8 +1756,7 @@ static int fusb302_probe(struct i2c_client *client)
 	}
 
 	ret = request_irq(chip->gpio_int_n_irq, fusb302_irq_intn,
-			  IRQF_ONESHOT | IRQF_TRIGGER_LOW,
-			  "fsc_interrupt_int_n", chip);
+			  IRQF_TRIGGER_LOW, "fsc_interrupt_int_n", chip);
 	if (ret < 0) {
 		dev_err(dev, "cannot request IRQ for GPIO Int_N, ret=%d", ret);
 		goto tcpm_unregister_port;
-- 
2.51.0



