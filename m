Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0175E24A06D;
	Wed, 25 Feb 2026 01:29:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771982990; cv=none; b=scGbgAH2Rjr/FI6lJyXmlBmyP7w03w/5hU0dU1+JXAWYgkYo+LYvLOJyEaN2X8xnHGrvu3/XwbXvWZAHyzmUvK5ZM6+DBCpHgt7YKehv9U4qk7fOgQdKUpC4CT2ditjWmPq5crpRGT3tIaWQiGTQvwkTdaquAmfeK+4OZvdELHc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771982990; c=relaxed/simple;
	bh=nnJUW9e5B/qXHu72ARPIL+3EoqhmjjfMppv5vOwxsEI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=QjrONHSaNLsVNaYTVm4Pkce1j0A8UhPk2cHJAVvBRrDFo35SJxAU0G2+PKPxNsA8AexzEhPpPhsOgoJ7ZsGbORvvd+OjNwas9AzqmV3JoT7/xlN+dRUNNzLEi4PYM3LcShh+oLelDCu8nio3cn25L6Jare9sCvVPtPJR/nMaPsA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=TiFM3bCb; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="TiFM3bCb"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B7103C116D0;
	Wed, 25 Feb 2026 01:29:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1771982989;
	bh=nnJUW9e5B/qXHu72ARPIL+3EoqhmjjfMppv5vOwxsEI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=TiFM3bCbfGaMsTi5GFm7sNDpKvVjGIhRoqDDyWBsUIhaNbnsbTuHuV4b/5XmWjy8u
	 c8DcdN731Nn82GJPC6EiW69tOJVg43gw0iiBmuI1w6fmt2yYJ1cqiOHXycHefveO0r
	 BYpI7lqrjHWGwOlBrnEXXS0ctrGKBiJd3LZvMEbo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
	Thomas Gleixner <tglx@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.19 117/781] genirq: Set IRQF_COND_ONESHOT in devm_request_irq().
Date: Tue, 24 Feb 2026 17:13:46 -0800
Message-ID: <20260225012402.543493146@linuxfoundation.org>
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
index 266f2b39213a0..b2bb878abd113 100644
--- a/include/linux/interrupt.h
+++ b/include/linux/interrupt.h
@@ -228,7 +228,7 @@ static inline int __must_check
 devm_request_irq(struct device *dev, unsigned int irq, irq_handler_t handler,
 		 unsigned long irqflags, const char *devname, void *dev_id)
 {
-	return devm_request_threaded_irq(dev, irq, handler, NULL, irqflags,
+	return devm_request_threaded_irq(dev, irq, handler, NULL, irqflags | IRQF_COND_ONESHOT,
 					 devname, dev_id);
 }
 
-- 
2.51.0



