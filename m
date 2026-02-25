Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2B79A26CE2D;
	Wed, 25 Feb 2026 01:43:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771983821; cv=none; b=d9mBDZPSDAqSAwRfdNZjryNn+OgpACowZqOkDDNrm5NM8NF+M6oZX4cGd/JEBtj674bCxiU50pWbWZ1zpb4JlHwDOm9c0eP5iX2cTocmuCbcKygtHU7APUA0eJOeiYRer090aFRoq9mPcQ2J8WSzSSZQVIhmVLpHdAYszIWu/3I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771983821; c=relaxed/simple;
	bh=XgojT4Umzuxe5d7s9NvANPkt+OVlLO9Yi2nD24gMxyw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=lbSMDsFAKtDBHpM59Q/XrqyKmRxAUD9367sxnrrjTudwiWOyHDsbD9vHUE7rSAPdNa19aY+k2vjZizs/5Voim3gkv2689aN5ALVaGWOuFux0X9dQOkNLpH0+xzN8+tc5n6QaPDK3uh/zdr6sq1xdrbQllmK2z2Gd5msjJeyfBAU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=R+OMztHY; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="R+OMztHY"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E148DC19423;
	Wed, 25 Feb 2026 01:43:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1771983821;
	bh=XgojT4Umzuxe5d7s9NvANPkt+OVlLO9Yi2nD24gMxyw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=R+OMztHYyDP2bi2y+TNvIkD3Ia91NBeQE5AnSZLZG1wVdkJp/AzvIAz0jiJLg/h/Y
	 6tA6bhQaPJpvnUnUuHAQcbmEOEif5bEULeBjE68I6hNaOw61kHXKjXfDYexpdzzmoR
	 0k8SWHna6eEEnjuGJL33VTxUTNsl2t7b9NMqcaAI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
	Thomas Gleixner <tglx@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 105/641] genirq: Set IRQF_COND_ONESHOT in devm_request_irq().
Date: Tue, 24 Feb 2026 17:17:11 -0800
Message-ID: <20260225012351.661316096@linuxfoundation.org>
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

[ Upstream commit 943b052ded21feb84f293d40b06af3181cd0d0d7 ]

The flag IRQF_COND_ONESHOT was already force-added to request_irq() because
the ACPI SCI interrupt handler is using the IRQF_ONESHOT flag which breaks
all shared handlers.

devm_request_irq() needs the same change since some users, such as
int0002_vgpio, are using this function instead.

Add IRQF_COND_ONESHOT to the flags passed to devm_request_irq().

Fixes: c37927a203fa2 ("genirq: Set IRQF_COND_ONESHOT in request_irq()")
Signed-off-by: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
Signed-off-by: Thomas Gleixner <tglx@kernel.org>
Link: https://patch.msgid.link/20260128095540.863589-2-bigeasy@linutronix.de
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/linux/interrupt.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/include/linux/interrupt.h b/include/linux/interrupt.h
index 51b6484c04934..8f1166bc3b1ce 100644
--- a/include/linux/interrupt.h
+++ b/include/linux/interrupt.h
@@ -215,7 +215,7 @@ static inline int __must_check
 devm_request_irq(struct device *dev, unsigned int irq, irq_handler_t handler,
 		 unsigned long irqflags, const char *devname, void *dev_id)
 {
-	return devm_request_threaded_irq(dev, irq, handler, NULL, irqflags,
+	return devm_request_threaded_irq(dev, irq, handler, NULL, irqflags | IRQF_COND_ONESHOT,
 					 devname, dev_id);
 }
 
-- 
2.51.0



