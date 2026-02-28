Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BA66B449EBB
	for <patches@lists.linux.dev>; Sat, 28 Feb 2026 17:53:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772301186; cv=none; b=UQyDWt6LmOFxOvuWKpdzeDv2cRv2HxJwYOYbs+SYh8mvMIDlQ/QsRcDTp8AUFXCblgGBTw6AY/oF8kXAk92wiz1YsRr726UdEajsGAnNtvX0G7SFjnxGqbLb4HhMrERAuoboTQS5v6fbowI63+c9Ep6XfuE8VuIEO9XK3yWpB5M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772301186; c=relaxed/simple;
	bh=xTcTq8oodcuv1Ba4/+yqPFIurfKOhpE/WebVsNgyVC0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=J1aN1jjv0aYKKRPSOWLBKZUAleYfSuFYsLtkAnm5i57rM/HmVUXUbjtnt/mOOf7V6Sd8gAt9EMxNYkKKha1JdLwwo3m8oX1zGZzD7MtYraR9/rYeL+hqaZ3WWG2+5+LtiwmcsOoYJs7eB+S+a1MN9Bzv6vWP71zkOhCSaizRx+0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=GmhAix2u; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="GmhAix2u"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DEEE5C116D0;
	Sat, 28 Feb 2026 17:53:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772301186;
	bh=xTcTq8oodcuv1Ba4/+yqPFIurfKOhpE/WebVsNgyVC0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=GmhAix2uEZ6H7PFsf18X5Dkbgem6KtEDAW9EeKId5hzjOBHiaXETM5vglqA5+kcvw
	 UI8yFZ76JFcAEXKwghfuiWhhULjuyxEN4aD9tz0JmYDwm5mXdnUZ/9gDr5o/xIpKVI
	 BzZiVcSbClCmJqgGl/Q48uTGIl2nr2CScnWvySlkfmZX1D4v5lligBJZNQlL4AAiTb
	 YsdrXPzsZS7v6YEd8zu95OnN3BckASz0VquvghmE9vChpRRGn9ixTojGpsJb//0W/k
	 YDNaSrOqpc3RbZj2rDJmrAOP+ZoY88y8SH5nBkkBYMCxnfZ7A50rdMoRNaAtakW5pZ
	 4rsG/sIeEj71A==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev
Cc: Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
	Geert Uytterhoeven <geert+renesas@glider.be>,
	Andy Shevchenko <andriy.shevchenko@intel.com>,
	=?UTF-8?q?Nuno=20S=C3=A1?= <nuno.sa@analog.com>,
	Jonathan Cameron <Jonathan.Cameron@huawei.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 356/752] iio: magnetometer: Remove IRQF_ONESHOT
Date: Sat, 28 Feb 2026 12:41:07 -0500
Message-ID: <20260228174750.1542406-356-sashal@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20260228174750.1542406-1-sashal@kernel.org>
References: <20260228174750.1542406-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit

From: Sebastian Andrzej Siewior <bigeasy@linutronix.de>

[ Upstream commit a54e9440925e6617c98669066b4753c4cdcea8a0 ]

Passing IRQF_ONESHOT ensures that the interrupt source is masked until
the secondary (threaded) handler is done. If only a primary handler is
used then the flag makes no sense because the interrupt can not fire
(again) while its handler is running.
The flag also disallows force-threading of the primary handler and the
irq-core will warn about this.
The force-threading functionality is required on PREEMPT_RT because the
handler is using locks with can sleep on PREEMPT_RT.

Remove IRQF_ONESHOT from irqflags.

Tested-by: Geert Uytterhoeven <geert+renesas@glider.be>
Signed-off-by: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
Reviewed-by: Andy Shevchenko <andriy.shevchenko@intel.com>
Reviewed-by: Nuno Sá <nuno.sa@analog.com>
Signed-off-by: Jonathan Cameron <Jonathan.Cameron@huawei.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/iio/magnetometer/ak8975.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/iio/magnetometer/ak8975.c b/drivers/iio/magnetometer/ak8975.c
index 3fd0171e5d69b..d30315ad85ded 100644
--- a/drivers/iio/magnetometer/ak8975.c
+++ b/drivers/iio/magnetometer/ak8975.c
@@ -581,7 +581,7 @@ static int ak8975_setup_irq(struct ak8975_data *data)
 		irq = gpiod_to_irq(data->eoc_gpiod);
 
 	rc = devm_request_irq(&client->dev, irq, ak8975_irq_handler,
-			      IRQF_TRIGGER_RISING | IRQF_ONESHOT,
+			      IRQF_TRIGGER_RISING,
 			      dev_name(&client->dev), data);
 	if (rc < 0) {
 		dev_err(&client->dev, "irq %d request failed: %d\n", irq, rc);
-- 
2.51.0

