Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BB5EB471250;
	Tue, 21 Jul 2026 19:05:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784660721; cv=none; b=bjy2S1UL0TZnRjyqCqYoZZJ4wxZ5XKf3c2wv9YcIpsapkH75rY9FKnkkphYzS+PqbK4jxZNgYoPMh6rUJfFCMnmycB1cp+Qs6LeZSBORoyf5GDAAE8hgc8+fY7mwU4xeObXVDeaPfUGHJm3m/jXmE8frErRzqSa+OqnR99AJNVM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784660721; c=relaxed/simple;
	bh=wvSpoOFVWsCf3XqPoyVprMDNolxukOT7VQcAB7mvXq4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ckkoEgRAN1sCNGloUBSKuVOijdBp8EENlEjD3Nl4euHx89MmnVdk7IIFzDDLWDMj4CdNJ3h584sZTBJ9yjpwvC730Vv3d2mjfq8uLE3eHcwf+3MlfX5F4XgEssDIgJjuLjjKYPkTrmg+Q7O357nkCYd42UpM4N3aEX15Nin8HXs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=l32hs2ra; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="l32hs2ra"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CD1761F000E9;
	Tue, 21 Jul 2026 19:05:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784660719;
	bh=Vzx9S2V+d42IavLNKvCDMgHedy7cpAIy2wAE3+HEhho=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=l32hs2raSAeLDc5CWM9bY2pqamPf6Jl3aaWzYka3yRdg6/ZAQlnS5xw0itEnjID9L
	 6csbiUHD0ftNlHuM8Z00F/YnMiMTrrNsVjC73cmcixBeD+FSK7NXXoG08UoMS4YJ+t
	 riPPUwClBfJHRHNdnKBt/ItA9hRS3jcQqIqRYlPA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jisheng Zhang <jszhang@kernel.org>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.1 1086/2077] spi: dw: fix wrong BAUDR setting after resume
Date: Tue, 21 Jul 2026 17:12:39 +0200
Message-ID: <20260721152618.437881790@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152552.646164743@linuxfoundation.org>
References: <20260721152552.646164743@linuxfoundation.org>
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

7.1-stable review patch.  If anyone has any objections, please let me know.

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
index 9cc79c566a70c0..2f2debc64e7377 100644
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



