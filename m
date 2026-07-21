Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B775C42A7B5;
	Tue, 21 Jul 2026 19:39:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784662746; cv=none; b=QZwQc2JQOXIjHlo76AWNvYkPx3ENA75dU6Ohux0UDKQywpfK9LDRGPbDFLmom0CKbTo9C9bhXiGa/+lP7hk+lA+YkOtf/4Yd6H1texpJvHtm5xNiVAD3QvQMfpfuZpHCTsHYWUOR6W9BtVIVsoOGCop+M5HH5ou8Dt5jmI7LvZA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784662746; c=relaxed/simple;
	bh=KHFA2CEGp3ZevF5FEc1Egrj8Fr+5o5cz8e0C01md67s=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=byPExf2w9sWM6YZzMAtEf8U0WZazXYzpSTIV4roVDN3HqdtR30IQor+lGNqOXoLdhbeFlMxalqZqXpUYqQEYQHUw3E8EI6gB0mgb87/ZRLAdIpzfR7/u8P5UQjwaDEpPcSFTeHKH/z7UZ3Cn1AnOUZ9aht08mTG4UX6t+Wiwyd8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=wOmGTXc0; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="wOmGTXc0"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 288641F000E9;
	Tue, 21 Jul 2026 19:39:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784662745;
	bh=aBuZGBwtVhpoGRsW1YumtSDXYNjAWXvIeJdeR3OCP7o=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=wOmGTXc0xUy38Fxi7sVkkB3K67a2ac8NmwUXE0/T9GvFNC8TkyCHbmdIn+5FJsVBQ
	 z6Bzp2vH/D3Nt+QgjYvz4F+NsOVSCbn9FISu4YiWlgCUN/Gt2FMPP5aMr+gls6DWe0
	 j9M9wOzRYteCDqcThWGVcJTErHLzhLYdIfex68W0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jisheng Zhang <jszhang@kernel.org>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 0562/1276] spi: dw: fix wrong BAUDR setting after resume
Date: Tue, 21 Jul 2026 17:16:45 +0200
Message-ID: <20260721152458.695904750@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152446.065700225@linuxfoundation.org>
References: <20260721152446.065700225@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jisheng Zhang <jszhang@kernel.org>

[ Upstream commit 66b6605bcea7af7aca3d1d858b9c5f14903f9f9a ]

After resuming from suspend to ram, spi transfer stops working. Further
debugging shows that the BAUDR register isn't correctly set, this is
due to dws->current_freq doesn't match the HW BAUDR setting,
specifically, the dws->current_freq equals to speed_hz, but BAUDR is 0.
so the dw_spi_set_clk() in below code won't be called:

        if (dws->current_freq != speed_hz) {
                dw_spi_set_clk(dws, clk_div);
                dws->current_freq = speed_hz;
        }

The mismatch comes from dw_spi_shutdown_chip() when suspending.
Fix this mismatch by setting dws->current_freq to 0 as well when
clearing BAUDR reg in dw_spi_shutdown_chip().

Fixes: e24c74527207 ("spi: controller driver for Designware SPI core")
Signed-off-by: Jisheng Zhang <jszhang@kernel.org>
Link: https://patch.msgid.link/20260612002835.5240-1-jszhang@kernel.org
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/spi/spi-dw.h | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/spi/spi-dw.h b/drivers/spi/spi-dw.h
index fc267c6437ae09..8a3c085c85e078 100644
--- a/drivers/spi/spi-dw.h
+++ b/drivers/spi/spi-dw.h
@@ -282,6 +282,7 @@ static inline void dw_spi_shutdown_chip(struct dw_spi *dws)
 {
 	dw_spi_enable_chip(dws, 0);
 	dw_spi_set_clk(dws, 0);
+	dws->current_freq = 0;
 }
 
 extern void dw_spi_set_cs(struct spi_device *spi, bool enable);
-- 
2.53.0



