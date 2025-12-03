Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 66D80346772;
	Wed,  3 Dec 2025 16:40:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764780030; cv=none; b=iKJB9B65NfN1XSVvHZsAdzWOGMuVxaK5M6IxAj/WTixxDBrswwJU/4/hRQk0HZhX1ric+JPYz06/oDTXr27eQBfUMAAf7dKJ9HSJMefn8V8FDuF7sjwGZwPfIQ07Zh7DieYJEpSEX2cUrU3srDNkyHerlDQs/O4Q5ltZAoutWDA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764780030; c=relaxed/simple;
	bh=fJclwKQWN82ncBjC/z9KE054wzVOUtoVu02HUhQv+Uc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Zq1eEGk2iqJvowyGL5VPoOeRuda/jJjlSVt7Vrvhhezeb8lQo9gUhWuwTuExNxsk9PSv1i2kCXYU2rd52DpqsLqAPMS2NqDg7gbDn2kHgLO7nqj89cs6KhnWDYRGYfjS4uJcMl2wYfyRihW4kLzzXsg0I9WtpZdXT4afInWcKr4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=VmcO/zvQ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="VmcO/zvQ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6CB68C4CEF5;
	Wed,  3 Dec 2025 16:40:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1764780029;
	bh=fJclwKQWN82ncBjC/z9KE054wzVOUtoVu02HUhQv+Uc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=VmcO/zvQAxlXPD5GzRTBzi6ADOLLyue1AtYJUQSLxSNZQKScO52qOT27hHvUxE4xC
	 kyCs8xVsL/w02DCsbSY+PNWQg7T34060Ek1EXEWHTS0dPY8JqkUfi2MbuoBR2YkSYT
	 nENVxvbGs8bZTe69kgVitASRg4XTP15c6u2soVKs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Oleksij Rempel <o.rempel@pengutronix.de>,
	Paolo Abeni <pabeni@redhat.com>
Subject: [PATCH 6.1 435/568] net: dsa: microchip: lan937x: Fix RGMII delay tuning
Date: Wed,  3 Dec 2025 16:27:17 +0100
Message-ID: <20251203152456.629353188@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251203152440.645416925@linuxfoundation.org>
References: <20251203152440.645416925@linuxfoundation.org>
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

From: Oleksij Rempel <o.rempel@pengutronix.de>

commit 3ceb6ac2116ecda1c5d779bb73271479e70fccb4 upstream.

Correct RGMII delay application logic in lan937x_set_tune_adj().

The function was missing `data16 &= ~PORT_TUNE_ADJ` before setting the
new delay value. This caused the new value to be bitwise-OR'd with the
existing PORT_TUNE_ADJ field instead of replacing it.

For example, when setting the RGMII 2 TX delay on port 4, the
intended TUNE_ADJUST value of 0 (RGMII_2_TX_DELAY_2NS) was
incorrectly OR'd with the default 0x1B (from register value 0xDA3),
leaving the delay at the wrong setting.

This patch adds the missing mask to clear the field, ensuring the
correct delay value is written. Physical measurements on the RGMII TX
lines confirm the fix, showing the delay changing from ~1ns (before
change) to ~2ns.

While testing on i.MX 8MP showed this was within the platform's timing
tolerance, it did not match the intended hardware-characterized value.

Fixes: b19ac41faa3f ("net: dsa: microchip: apply rgmii tx and rx delay in phylink mac config")
Cc: stable@vger.kernel.org
Signed-off-by: Oleksij Rempel <o.rempel@pengutronix.de>
Link: https://patch.msgid.link/20251114090951.4057261-1-o.rempel@pengutronix.de
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/dsa/microchip/lan937x_main.c |    1 +
 1 file changed, 1 insertion(+)

--- a/drivers/net/dsa/microchip/lan937x_main.c
+++ b/drivers/net/dsa/microchip/lan937x_main.c
@@ -328,6 +328,7 @@ static void lan937x_set_tune_adj(struct
 	ksz_pread16(dev, port, reg, &data16);
 
 	/* Update tune Adjust */
+	data16 &= ~PORT_TUNE_ADJ;
 	data16 |= FIELD_PREP(PORT_TUNE_ADJ, val);
 	ksz_pwrite16(dev, port, reg, data16);
 


