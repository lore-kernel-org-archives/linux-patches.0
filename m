Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CBC0424677D;
	Wed, 25 Feb 2026 01:43:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771983832; cv=none; b=KWY4FDQ84PKhaL5/VtCU/vqjvCWfL5GOoM1Jnlwt+zz13Vpj+UTQNnTO6wZLrQyV4V51d0Bk6uMeiFnaso8J0wU+vSOpezlUpP5QKbXSCBABGlJghzVRx6yqOzVbo6sbykSsIK5pE4HRlfF012J67ES66B+cjy9OBG4+mFHeI2w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771983832; c=relaxed/simple;
	bh=UurxWU9pPGG2cDPCWK+kcLEGgW383fHT8MNtO4rccKI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=I9jTtaYGJCRejlYIPaPUZ+Xt8EwqcmQ47uRGKE/gqH1oMVIxv7iGRUvffG4lynkVLpp3wCRF2xbgC00hmsawHyaYIMnewwzOKKCs9wDxGikE16gJpUZ/MG2mt/t06oH16kJprSyCmvEugVUJCzH3qV/hEpg0pK0N86sgvDBRKpY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=a38I8MmW; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="a38I8MmW"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8CCFDC116D0;
	Wed, 25 Feb 2026 01:43:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1771983832;
	bh=UurxWU9pPGG2cDPCWK+kcLEGgW383fHT8MNtO4rccKI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=a38I8MmWkiZMkIpztLzmGqDiO7PEwlilhNTApJinnMV83eLewZS2zLNZm5EQ6RXdi
	 g0M/SANvcKPtGhmYYSAJT4Y0h1t0dmMiaci211X4G0jLYv5oUoHTZfkkzbHgNX8bmb
	 QNI0rh3kBJ0xZHM/23QwUyvBDEqe1vs7kRGKQYCk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
	Thomas Gleixner <tglx@kernel.org>,
	Charles Keepax <ckeepax@opensource.cirrus.com>,
	Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 113/641] mfd: wm8350-core: Use IRQF_ONESHOT
Date: Tue, 24 Feb 2026 17:17:19 -0800
Message-ID: <20260225012351.862882088@linuxfoundation.org>
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



