Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5CC4C4369A;
	Wed, 25 Feb 2026 01:29:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771982946; cv=none; b=IvVeQoKg94vDMbpibrzHFWSWHEqICP8g/MGgKXppuxxLmmIIg5fTsQssLabCunnGxCaXFbu+LvLuc6qAoE3nkX5wHoorN8nYwBEVeiFuKJVMsisSj6wy/luuqwupbJ4tj2AMQ4ZwAxMLes5RvsVwJD2J7q01f7Rvl0d18M2o6Jg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771982946; c=relaxed/simple;
	bh=1W3sb79tx61lhISkuCbgCxXqIbMXTCBAGk26Y0ifRUw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=dPBjPOVKATb9IF3T78HYUEE2qaqxskJm8s0JtZ9S8UHsJPqhSAmpm61NQPuFtfz9ujNN35OKs1PKfgmRpEU5o7xDJxxqUMDNT1PccbKnc+irLJi0EFWW3eiS9BMWbr+fx0ExElhLhxo6jNEwKYgDUWFd5X/DguJj8rMKtqKzEw4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=I5/Sc69J; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="I5/Sc69J"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2DEC6C116D0;
	Wed, 25 Feb 2026 01:29:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1771982946;
	bh=1W3sb79tx61lhISkuCbgCxXqIbMXTCBAGk26Y0ifRUw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=I5/Sc69Jw1BxHJqjlsXGustzyEAQ0yuFb4hrMQn7Sy1J8zdYTnDLw1FTz7jxndl/t
	 dU9RxEjzte3RQ9qp/oTRVbExlNOnOlQcXiLCroG4OxPpUS7iUkXwINRV0e6D3/7Qc7
	 dYOynpZ/48ndO4wnHt39GoZAI9RVVZrRL3gp+sh8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
	Thomas Gleixner <tglx@kernel.org>,
	Charles Keepax <ckeepax@opensource.cirrus.com>,
	Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.19 125/781] mfd: wm8350-core: Use IRQF_ONESHOT
Date: Tue, 24 Feb 2026 17:13:54 -0800
Message-ID: <20260225012402.734251122@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260225012359.695468795@linuxfoundation.org>
References: <20260225012359.695468795@linuxfoundation.org>
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

6.19-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Sebastian Andrzej Siewior <bigeasy@linutronix.de>

[ Upstream commit 553b4999cbe231b5011cb8db05a3092dec168aca ]

Using a threaded interrupt without a dedicated primary handler mandates
the IRQF_ONESHOT flag to mask the interrupt source while the threaded
handler is active. Otherwise the interrupt can fire again before the
threaded handler had a chance to run.

Mark explained that this should not happen with this hardware since it
is a slow irqchip which is behind an I2C/ SPI bus but the IRQ-core will
refuse to accept such a handler.

Set IRQF_ONESHOT so the interrupt source is masked until the secondary
handler is done.

Fixes: 1c6c69525b40e ("genirq: Reject bogus threaded irq requests")
Signed-off-by: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
Signed-off-by: Thomas Gleixner <tglx@kernel.org>
Reviewed-by: Charles Keepax <ckeepax@opensource.cirrus.com>
Reviewed-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Link: https://patch.msgid.link/20260128095540.863589-16-bigeasy@linutronix.de
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/linux/mfd/wm8350/core.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/include/linux/mfd/wm8350/core.h b/include/linux/mfd/wm8350/core.h
index 5f70d3b5d1b1a..097ef4dfcdac8 100644
--- a/include/linux/mfd/wm8350/core.h
+++ b/include/linux/mfd/wm8350/core.h
@@ -667,7 +667,7 @@ static inline int wm8350_register_irq(struct wm8350 *wm8350, int irq,
 		return -ENODEV;
 
 	return request_threaded_irq(irq + wm8350->irq_base, NULL,
-				    handler, flags, name, data);
+				    handler, flags | IRQF_ONESHOT, name, data);
 }
 
 static inline void wm8350_free_irq(struct wm8350 *wm8350, int irq, void *data)
-- 
2.51.0



