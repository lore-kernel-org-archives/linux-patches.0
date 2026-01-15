Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0A4203D300D;
	Thu, 15 Jan 2026 17:50:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768499414; cv=none; b=AlRbfXKI7nX2Ev+3721hASwk1pqUScbzvR3yAxbQjk9W8VcDl+l+lKQ9DviHvj7J0PcANERhn5Novc8rNxKHIdBg8ZUDmI/beV2NFwvUIxI0ITf/J8Nm+TUXtT2YuLnB994JiqBsNReE9bQMVKMdsicgIOsZ5ZaESI+XTEA5hdQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768499414; c=relaxed/simple;
	bh=C5tSA08JuPmC5YtnHErF+vSQsMpPGqBKsMnZyEI7hvo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=kGQEdaKg+V5PBf+ou93TTT8OA7F5btmLamvnt9M9bzUpK8uacZ8wyBDOodkZXV4VN97nRh6I+aD1xlFjv1nz0puZD35SgasNa4sAnYRFsCAV0SBOXTirHoZGbcqpm1KDxt0ggCQIKtcmmU2wov7prOat2UaTVEM7PwvHe2519ck=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=hUBNrwix; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="hUBNrwix"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4C48FC19423;
	Thu, 15 Jan 2026 17:50:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1768499413;
	bh=C5tSA08JuPmC5YtnHErF+vSQsMpPGqBKsMnZyEI7hvo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=hUBNrwixvREiZ1Q46RHTKxox1d2ZAMb1QR+hpaXHew9OpGn74XBooHdzi8hKgR/do
	 XZn6nsE3cQG7PUlaIIVPSyjG8SKrFIrNV2v4ym9BRIzLVtWgpJOa27RNxDwbr6spFM
	 gMOuX3Yi+PIy0VaAsno51S+/RizrMnqaw7DmINF8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Wenhua Lin <Wenhua.Lin@unisoc.com>,
	Cixi Geng <cixi.geng@linux.dev>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 218/451] serial: sprd: Return -EPROBE_DEFER when uart clock is not ready
Date: Thu, 15 Jan 2026 17:46:59 +0100
Message-ID: <20260115164238.785036525@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260115164230.864985076@linuxfoundation.org>
References: <20260115164230.864985076@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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
index a1952e4f1fcb..e850959ecf55 100644
--- a/drivers/tty/serial/sprd_serial.c
+++ b/drivers/tty/serial/sprd_serial.c
@@ -1137,6 +1137,9 @@ static int sprd_clk_init(struct uart_port *uport)
 
 	clk_uart = devm_clk_get(uport->dev, "uart");
 	if (IS_ERR(clk_uart)) {
+		if (PTR_ERR(clk_uart) == -EPROBE_DEFER)
+			return -EPROBE_DEFER;
+
 		dev_warn(uport->dev, "uart%d can't get uart clock\n",
 			 uport->line);
 		clk_uart = NULL;
@@ -1144,6 +1147,9 @@ static int sprd_clk_init(struct uart_port *uport)
 
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



