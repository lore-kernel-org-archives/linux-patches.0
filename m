Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9286B3ACF00;
	Wed, 30 Sep 2026 19:00:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790794808; cv=none; b=lYCC8PyWrieBnTXS3MNocuIfxRwu5WhVYi61XZoSweQqw/+/9wqBXC7iAGwB9J9KcPGcKnLF7kjM9W1+3+naKRYhrxo5njcsWlYHoli4oLdqTJoiXUhzbCckKpogPtR3kfYnjosRhkpMx59auJEpsNTrwb42wN/9WWyLKo30bNA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790794808; c=relaxed/simple;
	bh=7V+8ME6sp4OJf+Fbmb7d9lkIR+bfNEalbaUySx3W5Rs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=GMMBfZfh4o8X2it8+PDunfStcgiWgQY2tK2L8xODxrjAfV1X/U6h6ZL/pzEuJL5TIcXAuhS0zaiuY1NdOOnroFpgcRPrdZGbix+/HZlXIeOP13NBRCDfe16pTznjEilGy2kxw4l/cBdRASV/rEX5ViFUo9AyAapaVyoYVJh+6TA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=DY6smJQl; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="DY6smJQl"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 231F81F000FF;
	Wed, 30 Sep 2026 19:00:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790794807;
	bh=YX7Q+NMP9HdQ5RpN9fuxT+qV9MErpT75ziThnOYYufY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=DY6smJQlvesi91xT4NAwzQZBtKONlPCCtQajQgC0avV+nJjeITSsBJJF78XeXs+Mf
	 QrAuQ0aL0pAECi4VJMZXb98JVfxHkEOPAE4tZhJw+X8KB7B9hgJHizQWDEeFre8ahn
	 0esAQrpQ+0+KLsGaERpCxN6L8j9HfhaTGFyn+quU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jisheng Zhang <jszhang@kernel.org>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 0341/1193] spi: dw: fix wrong RX_SAMPLE_DLY setting after resume
Date: Wed, 30 Sep 2026 17:17:05 +0200
Message-ID: <20260930152441.738329400@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260930152434.301151190@linuxfoundation.org>
References: <20260930152434.301151190@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jisheng Zhang <jszhang@kernel.org>

[ Upstream commit 133c71b2c0bc976a4751f9e05ef7cdea67f964e5 ]

On platforms which need a non-zero rx sample delay, the RX_SAMPLE_DLY
reg setting is lost after resume. The reason is that the reg may be
reset to 0 after resuming, but dws->cur_rx_sample_dly doesn't know
this fact. Fix this issue by clearing dws->cur_rx_sample_dly in
dw_spi_shutdown_chip().

Signed-off-by: Jisheng Zhang <jszhang@kernel.org>
Suggested-by: Mark Brown <broonie@kernel.org>
Link: https://patch.msgid.link/20260803135925.12622-1-jszhang@kernel.org
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/spi/spi-dw.h | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/spi/spi-dw.h b/drivers/spi/spi-dw.h
index e25e5554ce89d..91f8f978d6779 100644
--- a/drivers/spi/spi-dw.h
+++ b/drivers/spi/spi-dw.h
@@ -283,6 +283,7 @@ static inline void dw_spi_shutdown_chip(struct dw_spi *dws)
 	dw_spi_enable_chip(dws, 0);
 	dw_spi_set_clk(dws, 0);
 	dws->current_freq = 0;
+	dws->cur_rx_sample_dly = 0;
 }
 
 extern void dw_spi_set_cs(struct spi_device *spi, bool enable);
-- 
2.53.0



