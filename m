Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 29E19265CBE;
	Wed, 25 Feb 2026 01:43:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771983825; cv=none; b=tRxcJg5oFKwDYks8gC/TKUyScmANo8Y4DPbryM94vbmcF1UZzkwTNE0GuFfSDcoy8OmSgEjxL/xAoeGY4Iq5jpKQEGtMO/ZvPnsh0u1Be7D4MFfgH1LrNfQWyGAOIpN7uh3/20bi279/PBc0lLBf9WBaKr/LTh61gIX8EPJTDgs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771983825; c=relaxed/simple;
	bh=kFQMkW66agkfE/l9hhZm4QbxfFnECwdF1UTUiiB23M4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=m0/A/rJV4T7Q2sCu1lMAxa7+FOwlB+5MMxuog41/qKeyPhAX/QBehGgGa61iaQmyPm9BQEc+jarPi+2KWMXHtU44mAPpwxUlvZ9iRZkElk02FoYKLayFBu1zAfrAW2EWedxigjdoSmDnyUIrnSNBU3xG+Shne82hPmgYf0lIfkA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=nVxQ+v/7; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="nVxQ+v/7"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E0C0CC116D0;
	Wed, 25 Feb 2026 01:43:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1771983825;
	bh=kFQMkW66agkfE/l9hhZm4QbxfFnECwdF1UTUiiB23M4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=nVxQ+v/7Z3hzyu7xnWfM03BfcyhjJvhi9krXJ891u80iyjdS2gQkbT7PUcW9J1Xdg
	 9UiSHeWA46gzu3vNOyPCEP6ptjB/NFRDBSrOcf/XkwKWLQzL3JQo+EWtYG0/yQPwXA
	 ctQlbJqAxIfXxHCtDr5MvrIGVA+I1VoDgQtWyzHg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Borah, Chaitanya Kumar" <chaitanya.kumar.borah@intel.com>,
	Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
	Thomas Gleixner <tglx@kernel.org>,
	Hans de Goede <johannes.goede@oss.qualcomm.com>,
	=?UTF-8?q?Ilpo=20J=C3=A4rvinen?= <ilpo.jarvinen@linux.intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 106/641] platform/x86: int0002: Remove IRQF_ONESHOT from request_irq()
Date: Tue, 24 Feb 2026 17:17:12 -0800
Message-ID: <20260225012351.685711603@linuxfoundation.org>
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
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Sebastian Andrzej Siewior <bigeasy@linutronix.de>

[ Upstream commit f6bc712877f24dc89bdfd7bdbf1a32f3b9960b34 ]

Passing IRQF_ONESHOT ensures that the interrupt source is masked until the
secondary (threaded) handler is done. If only a primary handler is used
then the flag makes no sense because the interrupt cannot fire (again)
while its handler is running.

The flag also prevents force-threading of the primary handler and the
irq-core will warn about this.

The flag was added to match the flag on the shared handler which uses a
threaded handler and therefore IRQF_ONESHOT. This is no longer needed
because devm_request_irq() now passes IRQF_COND_ONESHOT for this case.

Revert adding IRQF_ONESHOT to irqflags.

Fixes: 8f812373d1958 ("platform/x86: intel: int0002_vgpio: Pass IRQF_ONESHOT to request_irq()")
Reported-by: Borah, Chaitanya Kumar <chaitanya.kumar.borah@intel.com>
Signed-off-by: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
Signed-off-by: Thomas Gleixner <tglx@kernel.org>
Reviewed-by: Hans de Goede <johannes.goede@oss.qualcomm.com>
Acked-by: Ilpo Järvinen <ilpo.jarvinen@linux.intel.com>
Link: https://patch.msgid.link/20260128095540.863589-3-bigeasy@linutronix.de
Closes: https://lore.kernel.org/all/555f1c56-0f74-41bf-8bd2-6217e0aab0c6@intel.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/platform/x86/intel/int0002_vgpio.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/platform/x86/intel/int0002_vgpio.c b/drivers/platform/x86/intel/int0002_vgpio.c
index 6f5629dc3f8db..562e880256436 100644
--- a/drivers/platform/x86/intel/int0002_vgpio.c
+++ b/drivers/platform/x86/intel/int0002_vgpio.c
@@ -206,8 +206,8 @@ static int int0002_probe(struct platform_device *pdev)
 	 * FIXME: augment this if we managed to pull handling of shared
 	 * IRQs into gpiolib.
 	 */
-	ret = devm_request_irq(dev, irq, int0002_irq,
-			       IRQF_ONESHOT | IRQF_SHARED, "INT0002", chip);
+	ret = devm_request_irq(dev, irq, int0002_irq, IRQF_SHARED, "INT0002",
+			       chip);
 	if (ret) {
 		dev_err(dev, "Error requesting IRQ %d: %d\n", irq, ret);
 		return ret;
-- 
2.51.0



