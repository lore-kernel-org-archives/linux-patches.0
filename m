Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D7935335BCD;
	Fri,  9 Jan 2026 12:38:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767962338; cv=none; b=QT71COEr8fo70s0yRtZK+RFYN5bGRcnPGtV70QGYZrALxJqJpsS49ox0yuIw1Df6bogPgl5tlqFJWyjodxZMqEO+TxctZnfeW4FEynprI4CTyedpnyxNy0jIkdjMowg6x8DKxRZDLR3Q5UKrjNPLKN1Msgu7LtqPklcaXaM0llk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767962338; c=relaxed/simple;
	bh=jHChAbudTZZ/jg1y+irlPVAppC4HFYaT2EI/0H0eGxk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=c20dfJkmM/Pr+klamFWViKMX6cSiUVPuG6VXMGjkOm0jYYWrVwEZnrRxQGcilDn2kSg5kDP8WNoaP5vJj+5Z+MoRihDlWBuI8aRvF1zdNMPnxJuN0Jfipe0Qhy928sSaBbFR2lj7Fsk1aO440jRzDoMx3evYUzVihcx39OKj578=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=yEFa79Ax; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="yEFa79Ax"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 63A17C4CEF1;
	Fri,  9 Jan 2026 12:38:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1767962338;
	bh=jHChAbudTZZ/jg1y+irlPVAppC4HFYaT2EI/0H0eGxk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=yEFa79AxQZm663ROAf00+5Om7LrSXUrHeJXyfoy1Kj30joo+76kxwIwCpepS5x551
	 FGgQAcBkhadWOrlvzP21gfVpzEV4HwneDlJL6S0ZgD8PmMDKVPpIaw4Kakpinf251h
	 HsacTGeipDd+JVKceajbaPXB8HXthBxsEXocaKVo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Wenhua Lin <Wenhua.Lin@unisoc.com>,
	Cixi Geng <cixi.geng@linux.dev>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 313/634] serial: sprd: Return -EPROBE_DEFER when uart clock is not ready
Date: Fri,  9 Jan 2026 12:39:51 +0100
Message-ID: <20260109112129.310300025@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260109112117.407257400@linuxfoundation.org>
References: <20260109112117.407257400@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Wenhua Lin <Wenhua.Lin@unisoc.com>

[ Upstream commit 29e8a0c587e328ed458380a45d6028adf64d7487 ]

In sprd_clk_init(), when devm_clk_get() returns -EPROBE_DEFER
for either uart or source clock, we should propagate the
error instead of just warning and continuing with NULL clocks.

Currently the driver only emits a warning when clock acquisition
fails and proceeds with NULL clock pointers. This can lead to
issues later when the clocks are actually needed. More importantly,
when the clock provider is not ready yet and returns -EPROBE_DEFER,
we should return this error to allow deferred probing.

This change adds explicit checks for -EPROBE_DEFER after both:
1. devm_clk_get(uport->dev, uart)
2. devm_clk_get(uport->dev, source)

When -EPROBE_DEFER is encountered, the function now returns
-EPROBE_DEFER to let the driver framework retry probing
later when the clock dependencies are resolved.

Signed-off-by: Wenhua Lin <Wenhua.Lin@unisoc.com>
Link: https://patch.msgid.link/20251022030840.956589-1-Wenhua.Lin@unisoc.com
Reviewed-by: Cixi Geng <cixi.geng@linux.dev>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/tty/serial/sprd_serial.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/drivers/tty/serial/sprd_serial.c b/drivers/tty/serial/sprd_serial.c
index 9c7f71993e94..33cc3773cf56 100644
--- a/drivers/tty/serial/sprd_serial.c
+++ b/drivers/tty/serial/sprd_serial.c
@@ -1136,6 +1136,9 @@ static int sprd_clk_init(struct uart_port *uport)
 
 	clk_uart = devm_clk_get(uport->dev, "uart");
 	if (IS_ERR(clk_uart)) {
+		if (PTR_ERR(clk_uart) == -EPROBE_DEFER)
+			return -EPROBE_DEFER;
+
 		dev_warn(uport->dev, "uart%d can't get uart clock\n",
 			 uport->line);
 		clk_uart = NULL;
@@ -1143,6 +1146,9 @@ static int sprd_clk_init(struct uart_port *uport)
 
 	clk_parent = devm_clk_get(uport->dev, "source");
 	if (IS_ERR(clk_parent)) {
+		if (PTR_ERR(clk_parent) == -EPROBE_DEFER)
+			return -EPROBE_DEFER;
+
 		dev_warn(uport->dev, "uart%d can't get source clock\n",
 			 uport->line);
 		clk_parent = NULL;
-- 
2.51.0



