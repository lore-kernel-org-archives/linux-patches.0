Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4525C3C09F3;
	Tue, 21 Jul 2026 21:33:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784669583; cv=none; b=U9mtoal1aohc3z5N/nUCjzcFf0qC2t2QWRVpWGgSv41gAqbmU53R2R/zGKsF8ud3Yj2NzLMkuc3ShpjRdQH/oHSYkKQK2WIA/b6buqeMnHVQzcwMzyfEvlb54chCpXt50V4wH0Ldbd2qblu2boQa6LfZziYnl5f3qXfrMiwCplY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784669583; c=relaxed/simple;
	bh=zOukW06fahGseOky3XqVIDNyanmu71seDtNZZZur0y8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=R/urY4lKpTY5KYlQ5IAGAx7wv7+AVk63JQVdbOE3SREHLL0ObUX0jzpetv0qQm2TGvcOyjwXpmr+2tAOSOblD8MfR8CFrDf8AHzKdT21w8jaatpcRPqKkkz9si0cZPQ9GAf7enKw8+yLnR3tz2K4gLcwfXvnr2NjypWoERM08Kw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=2gKBrwy/; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="2gKBrwy/"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 67FD51F000E9;
	Tue, 21 Jul 2026 21:33:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784669581;
	bh=5aVuKDFINyWLA34I3PFdTVD7aqOeK1WI14tp9fB3at4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=2gKBrwy/RDh4DxzkMJbvHmsQRhCNuV8ounCcCsiF74XRstK5nFArWVuvHHfl9NeNk
	 p9nZddP3vfmIL/cvGAc6EVBTYFcV71pJ11d+R4NMrzlNEtMd1lVvjF//U4wjMMAkC6
	 MzEkvmasHDMAlPEI8GS3PVLa4gabGVZka4hlC1Bk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jisheng Zhang <jszhang@kernel.org>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 0566/1067] spi: dw: fix wrong BAUDR setting after resume
Date: Tue, 21 Jul 2026 17:19:27 +0200
Message-ID: <20260721152437.264681322@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152424.521567757@linuxfoundation.org>
References: <20260721152424.521567757@linuxfoundation.org>
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
index 9e8eb2b52d5c79..62f82024a706ec 100644
--- a/drivers/spi/spi-dw.h
+++ b/drivers/spi/spi-dw.h
@@ -281,6 +281,7 @@ static inline void dw_spi_shutdown_chip(struct dw_spi *dws)
 {
 	dw_spi_enable_chip(dws, 0);
 	dw_spi_set_clk(dws, 0);
+	dws->current_freq = 0;
 }
 
 extern void dw_spi_set_cs(struct spi_device *spi, bool enable);
-- 
2.53.0



