Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5F29A3E5ED6;
	Tue, 17 Mar 2026 16:49:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773766163; cv=none; b=FgKeInNdgjHjYJB/hi9j3DHMmohkh9I+pnLgPqVJv0bxGByEAxZy9LzUTj9XKGoUnbvcHFSOe288bQ99AARuZ1lhmmEwuNbam4umuocqxPnilpaVu5dD5HUTHVQTl7L93Bqp0VtAZdO+BeXOFBOquiZF4+EH+KmAsQMrIemWltQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773766163; c=relaxed/simple;
	bh=1LQM42FAV7rMQACOHETfqaBJ9oXCGwTYv8Zo5SbBvm4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=j/Ms1M+JA8wTcCjc/o9Zf+C216XteAW696RfcS214NVEDGYVbpBl3edPcJhREE4WBS5c8rEGpQfrS8pYn+k8XiF+Dn3aFawJrj5c1RVwE6J+seK1JLSZsr/E11duM02fm9EJ1s1J1anM3qdhKxuWCmEPWbeZ9jIUxpmXTNQt+/4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=mxThlu8j; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="mxThlu8j"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B60ACC4CEF7;
	Tue, 17 Mar 2026 16:49:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1773766163;
	bh=1LQM42FAV7rMQACOHETfqaBJ9oXCGwTYv8Zo5SbBvm4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=mxThlu8jz+ReaM+d3GJo6FtTUI1PRXzqadENsbpwbv9M0CymsyRCVeG8I1ZhzP2Gg
	 Y8ULNgfjyxifpTHuZ39OsuSCn2sB7tjvb/h6gEUk/RjVQqIry0ihVYua8rP6dBtC4X
	 W0LptnzAtsDwdT20jtyL0SVu2nyMmeph6LN1ur7Y=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jessica Liu <liu.xuemei1@zte.com.cn>,
	Thomas Gleixner <tglx@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.19 183/378] irqchip/riscv-aplic: Register syscore operations only once
Date: Tue, 17 Mar 2026 17:32:20 +0100
Message-ID: <20260317163013.740260526@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260317163006.959177102@linuxfoundation.org>
References: <20260317163006.959177102@linuxfoundation.org>
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

From: Jessica Liu <liu.xuemei1@zte.com.cn>

[ Upstream commit b330fbfd34d7624bec62b99ad88dba2614326a19 ]

Since commit 95a8ddde3660 ("irqchip/riscv-aplic: Preserve APLIC
states across suspend/resume"), when multiple NUMA nodes exist
and AIA is not configured as "none", aplic_probe() is called
multiple times. This leads to register_syscore(&aplic_syscore)
being invoked repeatedly, causing the following Oops:

 list_add double add: new=ffffffffb91461f0, prev=ffffffffb91461f0, next=ffffffffb915c408.
 [<ffffffffb7b5c8ca>] __list_add_valid_or_report+0x60/0xc0
 [<ffffffffb7cc3236>] register_syscore+0x3e/0x70
 [<ffffffffb7b8d61c>] aplic_probe+0xc6/0x112

Fix this by registering syscore operations only once, using a static
variable aplic_syscore_registered to track registration.

[ tglx: Trim backtrace properly ]

Fixes: 95a8ddde3660 ("irqchip/riscv-aplic: Preserve APLIC states across suspend/resume")
Signed-off-by: Jessica Liu <liu.xuemei1@zte.com.cn>
Signed-off-by: Thomas Gleixner <tglx@kernel.org>
Link: https://patch.msgid.link/20260310141731145xMwLsyvXl9Gw-m6A4VRYj@zte.com.cn
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/irqchip/irq-riscv-aplic-main.c | 12 +++++++++++-
 1 file changed, 11 insertions(+), 1 deletion(-)

diff --git a/drivers/irqchip/irq-riscv-aplic-main.c b/drivers/irqchip/irq-riscv-aplic-main.c
index 8775f188ea4fc..9f53979b69625 100644
--- a/drivers/irqchip/irq-riscv-aplic-main.c
+++ b/drivers/irqchip/irq-riscv-aplic-main.c
@@ -116,6 +116,16 @@ static struct syscore aplic_syscore = {
 	.ops = &aplic_syscore_ops,
 };
 
+static bool aplic_syscore_registered __ro_after_init;
+
+static void aplic_syscore_init(void)
+{
+	if (!aplic_syscore_registered) {
+		register_syscore(&aplic_syscore);
+		aplic_syscore_registered = true;
+	}
+}
+
 static int aplic_pm_notifier(struct notifier_block *nb, unsigned long action, void *data)
 {
 	struct aplic_priv *priv = container_of(nb, struct aplic_priv, genpd_nb);
@@ -379,7 +389,7 @@ static int aplic_probe(struct platform_device *pdev)
 		return rc;
 	}
 
-	register_syscore(&aplic_syscore);
+	aplic_syscore_init();
 
 #ifdef CONFIG_ACPI
 	if (!acpi_disabled)
-- 
2.51.0



