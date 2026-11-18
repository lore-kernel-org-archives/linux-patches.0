Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795048680;
	b=rK+nZQ9jVXyoXUh+MKV/TCm5fdqJmu8wex2D3KAeJhpI69JiKrQyW0hArKrokDxClPyx
	 rE/iIpomul+LZ61vmIr/UYE0+mGSPZH7pFYwLn1E6lOW4EoLsOfSWPX4JxSR+bUoomdXM
	 8haOTI4JJ8PIs/33Uawgi6vw84AJtdWihDSnEsHTSB4v1L4e5xnlJG1xJeLMOX8kRQ2w2
	 eqk1AH7VQidEElCS0kibwbbXldb2lnRG6zAv9YQhwDWeVgWgGbji2kXxzmEjkckSIUykL
	 cqRd5rq6Y6+6LCfhygpj/chJfPNLQaXe+zKP6boX0LyJTAnYF/wthWgtfGMVYe70Wrg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795048680;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=CudNG2zR5gJDFw6i03oTqwv4wB+EcTyGQpb1KL2H93g=;
	b=u/bX64rU4KBGwRRg4huTDVeolQNK+FWjYpzz1NougfvAZStBbWyYlZz8p/nBhRIarcrF
	 AqXAbLOv3GYF2cAtYusEhm3j6d+Bvr9rwmQQLpsIKNx8ezMJwKB6wtVCMJqav+VZ1MudV
	 2Li2F6lBrJAI2qYJTsS4t58bi4etWH7Z+krp9vrQBtulUgcH1HI13uuskWghiO+NvGaS4
	 xU96AZeQJc4TxjMgo4lwBcEJMg3EyzO4PJxq9p9L3Ynh/zi1k7ijH3Ajj91o0m86OrUz2
	 rpPh5B5B6UmzDHsjIWkWEBEXjoy0wkwMuDzPlMM4AnYE6KTT5v/b8T6eMaXLO/AjVow==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=l+7VskQg;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8F0DF606A320;
	Thu, 19 Nov 2026 00:38:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=l+7VskQg
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AAAD91F000C4;
	Thu, 19 Nov 2026 00:37:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795048680;
	bh=CudNG2zR5gJDFw6i03oTqwv4wB+EcTyGQpb1KL2H93g=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=l+7VskQgbT26bfspjo3RTLuZWgnv9oguk3SBKjQvGh5d0rHfiOMswvmUSQRT/B92e
	 vjR872FjFLLloHPNGcqjgDdO+DBPa03gxBWnCkCRmVR7eaxBL2FEMZL+sJujfUmxH0
	 RA11KUhNw33fP4up4bfLwAfihGlxAS0lKA0+KVAw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Zongmin Zhou <zhouzongmin@kylinos.cn>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 2031/2857] serial: sifive: fix off-by-one in console port bounds check
Date: Wed, 18 Nov 2026 15:51:05 +0100
Message-ID: <20261118150314.536539432@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150201.293410965@linuxfoundation.org>
References: <20261118150201.293410965@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Zongmin Zhou <zhouzongmin@kylinos.cn>

[ Upstream commit bf961847813d9edcb5a9c089714069428d141fa9 ]

sifive_serial_console_ports[] is sized SIFIVE_SERIAL_MAX_PORTS (8), so
valid indices are 0..7. The bounds check in sifive_serial_probe() uses
"id > SIFIVE_SERIAL_MAX_PORTS", which lets id == 8 pass and causes an
out-of-bounds write in __ssp_add_console_port() through
sifive_serial_console_ports[ssp->port.line].

Fix the check to use >= instead, matching the check already used in
sifive_serial_console_setup().

Fixes: 45c054d0815b ("tty: serial: add driver for the SiFive UART")
Signed-off-by: Zongmin Zhou <zhouzongmin@kylinos.cn>
Link: https://patch.msgid.link/20260827014524.19375-1-min_halo@163.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/tty/serial/sifive.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/tty/serial/sifive.c b/drivers/tty/serial/sifive.c
index 4d7825c4d769b..cc041a642ed45 100644
--- a/drivers/tty/serial/sifive.c
+++ b/drivers/tty/serial/sifive.c
@@ -964,7 +964,7 @@ static int sifive_serial_probe(struct platform_device *pdev)
 	}
 
 #ifdef CONFIG_SERIAL_SIFIVE_CONSOLE
-	if (id > SIFIVE_SERIAL_MAX_PORTS) {
+	if (id >= SIFIVE_SERIAL_MAX_PORTS) {
 		dev_err(&pdev->dev, "too many UARTs (%d)\n", id);
 		return -EINVAL;
 	}
-- 
2.53.0



