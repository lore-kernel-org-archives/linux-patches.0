Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 857DB4369A;
	Wed, 25 Feb 2026 01:29:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771982947; cv=none; b=SB5vXCdpZsOYhO40Ut77U3GfYhupH7R88JbVV4yisdQ+tKtIEYgKdTfVxVz3GMERDmNAZW7PcPLg/SZbAMAWUMj/b2tWzc7LjqC6WVVhhFnUlDuWPaveoMS3WmSQ7hAY7mbDc0lprJt6fQ9+C9MTrzwXJG+//UzBwkoo32oL0iQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771982947; c=relaxed/simple;
	bh=+7Vc/quehHG+ArwZWa4jU4ylLD7kJNRv4Hyi53wzBNs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=eOMe1utIgIIiPimIC25uBp0sWGQBJMrrXOjwI3+OxqVndwMG+FtWcAFFFSt6mhlAPBAXJ9++MeA+y5384Nk8ZJqU2c7asrjkjCXqXAns/rOS1Op9Va3btwPdHvv5c9Va1CQHwKkv2N83+gJtDaKEq+u3gAsWDSiOmUZh63UGszk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=DfleCEVN; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="DfleCEVN"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 46D34C116D0;
	Wed, 25 Feb 2026 01:29:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1771982947;
	bh=+7Vc/quehHG+ArwZWa4jU4ylLD7kJNRv4Hyi53wzBNs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=DfleCEVNRn6jbhcVCCy1CQuBzcyMfriFh6z5xroi1kHt9V2wbk8cl5OEPMODeWhoo
	 vhOkIOTk+ng1rOm6NhAtos4Aocm5miSnPlHVJWooauNu+KU9PtTnGK7oDt/BIjHpit
	 vP1QWBf5v6GZ0TUdj4gdMpMhyFIZUgGvXUF/AfhM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
	Thomas Gleixner <tglx@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.19 126/781] media: pci: mg4b: Use IRQF_NO_THREAD
Date: Tue, 24 Feb 2026 17:13:55 -0800
Message-ID: <20260225012402.758498216@linuxfoundation.org>
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

[ Upstream commit ef92b98f5f6758a049898b53aa30476010db04fa ]

The interrupt handler iio_trigger_generic_data_rdy_poll() will invoke other
interrupt handlers and this supposed to happen from hard interrupt context.

Use IRQF_NO_THREAD to forbid forced-threading.

Fixes: 0ab13674a9bd1 ("media: pci: mgb4: Added Digiteq Automotive MGB4 driver")
Signed-off-by: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
Signed-off-by: Thomas Gleixner <tglx@kernel.org>
Link: https://patch.msgid.link/20260128095540.863589-21-bigeasy@linutronix.de
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/media/pci/mgb4/mgb4_trigger.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/media/pci/mgb4/mgb4_trigger.c b/drivers/media/pci/mgb4/mgb4_trigger.c
index 4f9a35904b418..70cad324df608 100644
--- a/drivers/media/pci/mgb4/mgb4_trigger.c
+++ b/drivers/media/pci/mgb4/mgb4_trigger.c
@@ -115,7 +115,7 @@ static int probe_trigger(struct iio_dev *indio_dev, int irq)
 	if (!st->trig)
 		return -ENOMEM;
 
-	ret = request_irq(irq, &iio_trigger_generic_data_rdy_poll, 0,
+	ret = request_irq(irq, &iio_trigger_generic_data_rdy_poll, IRQF_NO_THREAD,
 			  "mgb4-trigger", st->trig);
 	if (ret)
 		goto error_free_trig;
-- 
2.51.0



