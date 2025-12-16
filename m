Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CF126393DE7;
	Tue, 16 Dec 2025 12:28:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765888097; cv=none; b=ffTe587SPdKkbQhmgmA/5bh5cS7SFpszMqcY0Sahllb5w3o1ughbxu6uidlvWsnj/6z4ovFSLIRI09w6pqr/efCKZ6eTkcvTRdyiLUeN41XC/w5Hn7yTi4dBCAW29MPo2yPLUacEuedREUylGEwZQpJvhwUNqZaWFrmfVf0fG3Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765888097; c=relaxed/simple;
	bh=bRzjyzPW93i8iSEnoj/xBAif5trlFhb9yNVBTTH89gY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=NuBnhA/Iqws9qW9mMToHTCec55sd1UtVbdF7UXomhbjiwbbhBUl5VEMU5SFhUFynDXVU6eUlP5VsQf8qkC4OLjnfKoJfMyEzqX0oVOwwDGcjCG6EbQLmyX4GjIH4LH1aWMUcsgMxDmeKDfDiFFiCj5LsHqi+frUFkjjai+v8QnA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=T1xLXHg9; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="T1xLXHg9"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 48186C4CEF5;
	Tue, 16 Dec 2025 12:28:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1765888097;
	bh=bRzjyzPW93i8iSEnoj/xBAif5trlFhb9yNVBTTH89gY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=T1xLXHg9mPPYW/bKHC0fyv8gxjfhvt2CDViyowJq0AF3397bnnN9V8bra/vgErbxH
	 yp84Yz1mlJH1ngRrpcmHHguXiYFNsohe69nEwA2Wk+YxmpE0ctvbVycfNalfygXvey
	 5jXCgEplwJmt8K8xkLnsj26l5u/Xfq86RjwJGS+c=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Haotian Zhang <vulab@iscas.ac.cn>,
	Daniel Lezcano <daniel.lezcano@linaro.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 432/614] clocksource/drivers/ralink: Fix resource leaks in init error path
Date: Tue, 16 Dec 2025 12:13:19 +0100
Message-ID: <20251216111417.026445695@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251216111401.280873349@linuxfoundation.org>
References: <20251216111401.280873349@linuxfoundation.org>
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

From: Haotian Zhang <vulab@iscas.ac.cn>

[ Upstream commit 2ba8e2aae1324704565a7d4d66f199d056c9e3c6 ]

The ralink_systick_init() function does not release all acquired resources
on its error paths. If irq_of_parse_and_map() or a subsequent call fails,
the previously created I/O memory mapping and IRQ mapping are leaked.

Add goto-based error handling labels to ensure that all allocated
resources are correctly freed.

Fixes: 1f2acc5a8a0a ("MIPS: ralink: Add support for systick timer found on newer ralink SoC")
Signed-off-by: Haotian Zhang <vulab@iscas.ac.cn>
Signed-off-by: Daniel Lezcano <daniel.lezcano@linaro.org>
Link: https://patch.msgid.link/20251030090710.1603-1-vulab@iscas.ac.cn
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/clocksource/timer-ralink.c | 11 +++++++++--
 1 file changed, 9 insertions(+), 2 deletions(-)

diff --git a/drivers/clocksource/timer-ralink.c b/drivers/clocksource/timer-ralink.c
index 6ecdb4228f763..68434d9ed9107 100644
--- a/drivers/clocksource/timer-ralink.c
+++ b/drivers/clocksource/timer-ralink.c
@@ -130,14 +130,15 @@ static int __init ralink_systick_init(struct device_node *np)
 	systick.dev.irq = irq_of_parse_and_map(np, 0);
 	if (!systick.dev.irq) {
 		pr_err("%pOFn: request_irq failed", np);
-		return -EINVAL;
+		ret = -EINVAL;
+		goto err_iounmap;
 	}
 
 	ret = clocksource_mmio_init(systick.membase + SYSTICK_COUNT, np->name,
 				    SYSTICK_FREQ, 301, 16,
 				    clocksource_mmio_readl_up);
 	if (ret)
-		return ret;
+		goto err_free_irq;
 
 	clockevents_register_device(&systick.dev);
 
@@ -145,6 +146,12 @@ static int __init ralink_systick_init(struct device_node *np)
 			np, systick.dev.mult, systick.dev.shift);
 
 	return 0;
+
+err_free_irq:
+	irq_dispose_mapping(systick.dev.irq);
+err_iounmap:
+	iounmap(systick.membase);
+	return ret;
 }
 
 TIMER_OF_DECLARE(systick, "ralink,cevt-systick", ralink_systick_init);
-- 
2.51.0



