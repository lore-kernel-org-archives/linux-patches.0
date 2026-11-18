Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795039907;
	b=ZU7Op8PotOUpxsL6d/vSn28KAI9tkCBBoFEWXSuf9wJMwiSWxsrI6lNb3TFNPlN41vZ8
	 PPOFFETP3wPQnoT6f69su2c8kC16GsW8lafdNPBABDzf11/pxoobjLuYmKgnmNANuWTzy
	 cW9rsYKwpDtM/7DPd75KrEqvRlB7rJ0SXwNfx8PXVh2GdoerzQLU/9TlvimNcS/aeX74A
	 pZX4y9LG1uiJBnbBoNKfQsDDNuRXWs1tyUeX3BzqfCO1DFPa6uaGTcdeWtxhJKGAfAQQ2
	 wHULqKhkXeW/FzsS4HrtMDFeFASUSX+JR0t03aT9tb8TM8cjohH9+30rf6/Bsl2tHOw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795039907;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=OnuSq/1845HBBcjqsQYiFk4fk/xAODCoGE+lwJTkpP4=;
	b=fJAxZKaGaD1y3ssEhjGRcBdrJ5vHbI1AYJKdSiWzqm3yU3Kzs8xKDdP0f7UyuYIqeOWj
	 oC2UN8kdfDQJVGkQ8aw+QPA2DwSzt3UEf/Xp1zRwfk/sekcjGMBFaNnBwVW97/O//pVut
	 iYGmOA974bufFXID5T/JvXz25KySCY5xXUK9aLL1PxTBFTBBd2gBnAmtsO4xLM1VS9MT6
	 1b9tXWBOw42AOg+YoXGSmA9V41eqn62JUnxK+57n0xB8NuZNw5oMC9Oi9SmrjJ5ivTLXr
	 MPGiNZSTOSH5Y5mdsFIqzzpBgsv68JBIAI8Ovenrx9rUmlfMBymEOl3bdtiejtlS9mA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=gB4nWek7;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F3916606A32A;
	Wed, 18 Nov 2026 22:11:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=gB4nWek7
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 52D5C1F000C4;
	Wed, 18 Nov 2026 22:11:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795039906;
	bh=OnuSq/1845HBBcjqsQYiFk4fk/xAODCoGE+lwJTkpP4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=gB4nWek7tduJhmNJxidn5bGDNUdIPIvpZVnyGmCPKvHbtwfbG4L3IWVohfphP2dJV
	 CGNL+npfUEpXL3r4GZeUWuJQ8MXNadqBP+uoMQ+swGjXv8KiCmOJsAO+HaqHC+6JS1
	 q0BwccV4LNTxYyzG9giAGWb8aoWtV2XI16vpu4Ak=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Felix Gu <ustc.gu@gmail.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 2266/3318] spi: mxic: fix ps_clk leak in runtime resume
Date: Wed, 18 Nov 2026 15:48:08 +0100
Message-ID: <20261118150429.787046957@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150313.527275416@linuxfoundation.org>
References: <20261118150313.527275416@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Felix Gu <ustc.gu@gmail.com>

[ Upstream commit 648e3c436032b675b339662ea9c0edd9221add76 ]

mxic_spi_runtime_resume() enables ps_clk before calling
mxic_spi_clk_enable(). If the latter fails, ps_clk was not
disabled.

Unwind ps_clk with clk_disable_unprepare() before returning
the error.

Fixes: b942d80b0a39 ("spi: Add MXIC controller driver")
Signed-off-by: Felix Gu <ustc.gu@gmail.com>
Link: https://patch.msgid.link/20260902-mxic-v1-1-76806325826d@gmail.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/spi/spi-mxic.c | 8 +++++++-
 1 file changed, 7 insertions(+), 1 deletion(-)

diff --git a/drivers/spi/spi-mxic.c b/drivers/spi/spi-mxic.c
index 00617fd4b2c3a..a13ee5edfe6d8 100644
--- a/drivers/spi/spi-mxic.c
+++ b/drivers/spi/spi-mxic.c
@@ -734,7 +734,13 @@ static int __maybe_unused mxic_spi_runtime_resume(struct device *dev)
 		return ret;
 	}
 
-	return mxic_spi_clk_enable(mxic);
+	ret = mxic_spi_clk_enable(mxic);
+	if (ret) {
+		clk_disable_unprepare(mxic->ps_clk);
+		return ret;
+	}
+
+	return 0;
 }
 
 static const struct dev_pm_ops mxic_spi_dev_pm_ops = {
-- 
2.53.0



