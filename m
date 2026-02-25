Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3CE894369A;
	Wed, 25 Feb 2026 01:29:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771982944; cv=none; b=EDpkP5PMmd39wtgMWfy/6X840wGm9OfwGC5f8eZhr3rAfgF4Qq2KZLuoy6Xu9bEOD/4y+4DzeSXP6Y01cpG5ibIrXkSLd+oEPTPZT8lzwTMjEcE+J1OUwZMp713xFDvnrjdhi0GzoS9CyAGNkd1iHBnOcAp4t1aURD52hjtgHn4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771982944; c=relaxed/simple;
	bh=mxNEPIaD5+EY1f2sYbBxP9fOo3Fn4sIDeCwYRh/tkYg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=drosBFAcmuJeeeGYLcfT9y6U+2yz5u1z5lZE8VchnUsCmTYRFPyOScg6CaH56kEgHMuAQPNwa1Xi+JDTd7C2b0ZOlc4/QgdFQ2Ur6unwLFjXr+U+l5G7UwRyP3KtpFzyomMZdDqhAPczhZngwopMo+Mn04aArb/cJK6lBJse3b0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=FTttFTmT; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="FTttFTmT"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F191BC116D0;
	Wed, 25 Feb 2026 01:29:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1771982944;
	bh=mxNEPIaD5+EY1f2sYbBxP9fOo3Fn4sIDeCwYRh/tkYg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=FTttFTmTFBi5Y3WmKDJ7oUGhEENGXiUdhjExZeZwIKE0I6itun7AVTHn42RFP83AQ
	 bSk8boNdbGtOri7u5XoALVC3Pcevmh+tBjNLJT7iWwI94YlznobPWyMTK4p3pgAZS7
	 iuOy0SVLWL15AN+usWDRgZJbC6y+xu/pcem8880w=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
	Thomas Gleixner <tglx@kernel.org>,
	Heikki Krogerus <heikki.krogerus@linux.intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.19 123/781] usb: typec: fusb302: Remove IRQF_ONESHOT
Date: Tue, 24 Feb 2026 17:13:52 -0800
Message-ID: <20260225012402.687119957@linuxfoundation.org>
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



