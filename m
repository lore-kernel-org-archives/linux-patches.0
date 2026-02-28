Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7B10E379EE2
	for <patches@lists.linux.dev>; Sat, 28 Feb 2026 18:01:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772301687; cv=none; b=uifd2HMZUDquwMWt76ha4L0DY26UD09F1LieB7+deXCP/+j9bLOxVFnC9gKs0YI62OdTTdjeRNiQyNmnaMEVg3ZrPHOf8Gf+jyykTqUWK8n4i+r0eAy3WaK55raI3cpTGmtrfEI6nyQJDmaxPXoDA+3GYgWDzHoywm2RHCNj5mA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772301687; c=relaxed/simple;
	bh=+plbUiYg4git9ZUZt3d+iJEz6iG0cqJMeWYgSfgBTg8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=so6cjmaueFpLNO/Ame2PCpgWSgY4wULjHdoFDxjQi18W3KjYanhA6UtUU41e+HfW+JKLoL/i7LxT3zM0Y3pHplweNJz8Ub+fFS/olhMxOu3LdsG/O9KpDvab220M4MynBqKI71JCZwTHr0kJPRy6KPcGyL0SoATRF5ydU9+zznk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=fNF0NOHW; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="fNF0NOHW"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D6F84C19423;
	Sat, 28 Feb 2026 18:01:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772301687;
	bh=+plbUiYg4git9ZUZt3d+iJEz6iG0cqJMeWYgSfgBTg8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=fNF0NOHWMAoqWTiBo95i5W2QFmzcJEaFYsevMMI58v8uh1hILxfdJb8zk+IaR/a3+
	 LXCDpyz0xwhyWbYF0py3BGa80GQ2Zs9ksIq6UC0gtDRtsam9m6QH69MKX+pFdG9saL
	 4tb2ltdUcrzyb3ZL+ZWwn7ExlqlU40XuPIaHpFGh6KzrSbq65EHoNXrKK3AxSeElN1
	 wUEu8Mh48WVfHuqJY2TfiOZspkKoaf+IF0yCFB6ZI+pc+yrsT8EgSBRLjuaB07iZGn
	 u07KDjhD6xJze0ICSE93+A3FN7AeiRmcYOva9nMmTsVsJoZKp2AOyHyL8LcfdP5I6v
	 7nKz8scm0sutQ==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev
Cc: Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
	Thomas Gleixner <tglx@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 077/385] genirq: Set IRQF_COND_ONESHOT in devm_request_irq().
Date: Sat, 28 Feb 2026 12:54:59 -0500
Message-ID: <20260228180011.1568201-77-sashal@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20260228180011.1568201-1-sashal@kernel.org>
References: <20260228180011.1568201-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit

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
index b378fbf885ce3..2125d4d9b44f2 100644
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

