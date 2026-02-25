Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2083B24A06D;
	Wed, 25 Feb 2026 01:29:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771982991; cv=none; b=BX0+Rx5gk+GvUZhq1rZ4B0juLb/1gdDg6t4ZrloJg3octjnZHOPMLTM2vRZeTLTKFM45W8hWWcXlXYM4CRuqTNxOzlsC4u9vBf2UCR3MGhs/4cFVjmSs/JJHjj0t2SSqpfH5ATqVw/yZbOeuYmSKRp4JyRGFWguBOh8Y9vVuccc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771982991; c=relaxed/simple;
	bh=KOftbSe5YKufDFyK+/V9+3ZpvW3R8uGgVdN4zLzhCA4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=RO7TU/eZH72TPjr6uSNGGnBD8rudUk2RIF9ueQQj97Q1FKRx42dYHyrwHYcoDJ8ysPaa9+8DZBz/mEaCC9gPXbIzt2W9uBJN5jKc+m5JWsy4KQj6dvlqLFa1+PPM9MLyQdmzVZLd/P8btogLnVJ+u1ERqAmxp0VAAHPpJtJlapM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=mjCUm3Bl; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="mjCUm3Bl"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DE596C116D0;
	Wed, 25 Feb 2026 01:29:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1771982991;
	bh=KOftbSe5YKufDFyK+/V9+3ZpvW3R8uGgVdN4zLzhCA4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=mjCUm3BlUf9mgtthn6D4UPPYmL8fxdEjkjvIsYtQ+W71aSPEkBouN5qKpsCVUgvzb
	 BaBpZbykg0nFZxEulhm4SFSEYdhP7oIjarnWJJ2hiO0UhoPgFsY/gZ2/LdlSeXGbA+
	 dEpW7TLvk81Xnf51cv28i/9HOeoOaSQ1iM8InTIk=
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
Subject: [PATCH 6.19 118/781] platform/x86: int0002: Remove IRQF_ONESHOT from request_irq()
Date: Tue, 24 Feb 2026 17:13:47 -0800
Message-ID: <20260225012402.566526817@linuxfoundation.org>
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
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

6.19-stable review patch.  If anyone has any objections, please let me know.

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



