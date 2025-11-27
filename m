Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 621103126C0;
	Thu, 27 Nov 2025 14:59:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764255555; cv=none; b=RSGZN5LsctUeU4UKyCmThZzcDi0BkmrrVTnDTNMWbvkLeYokuL/zmhWVoZEf2xZO9HTnNJ7w2YDCBttuBJ81oYJ0Im2819s7D8vLBK6oZaF5x2qKhvIkPHL22RCAu397875+EERpMu7rocHbIpTci14d7bRHOE85b38jeQXdjy0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764255555; c=relaxed/simple;
	bh=eR6oiTmfuKiIDoiLSDp+OZQrymE1gMRJXlKb8Y+58lQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=jDCtmMFj5lkMbnXOOYRssKZyAEEF8DxrtAmBs643uSLfGtWTxUmQVXMzZGD3CdJA1Qrec7sPfXDZvuMDtH4mhqcGtsbZqmqDUluuU4h5O6py2rC0imRNFLo6X3ZDDtu57cwvlOh4S4p+oxsKIdJrgUkNMKoSVaag12HVCnb9EVE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=wKIat4QP; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="wKIat4QP"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DA773C4CEF8;
	Thu, 27 Nov 2025 14:59:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1764255555;
	bh=eR6oiTmfuKiIDoiLSDp+OZQrymE1gMRJXlKb8Y+58lQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=wKIat4QPGaI6of8d0iOrgwb8vy8kwlHsAd2U6FcgpztzF7CDP2ztGkReiEV7PCGqK
	 R6C8eMFexmuoKKhWDdGCV0Jplqummwpyzrkfxs+xMVbBKOrhSfa+OwGRYl3b768BLy
	 th83OIbqSxkRcPFOIf1BcfDqs370BkhBvfcLBR3I=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Oleksij Rempel <o.rempel@pengutronix.de>,
	Paolo Abeni <pabeni@redhat.com>
Subject: [PATCH 6.17 034/175] net: dsa: microchip: lan937x: Fix RGMII delay tuning
Date: Thu, 27 Nov 2025 15:44:47 +0100
Message-ID: <20251127144044.212768253@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251127144042.945669935@linuxfoundation.org>
References: <20251127144042.945669935@linuxfoundation.org>
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

6.17-stable review patch.  If anyone has any objections, please let me know.

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
@@ -540,6 +540,7 @@ static void lan937x_set_tune_adj(struct
 	ksz_pread16(dev, port, reg, &data16);
 
 	/* Update tune Adjust */
+	data16 &= ~PORT_TUNE_ADJ;
 	data16 |= FIELD_PREP(PORT_TUNE_ADJ, val);
 	ksz_pwrite16(dev, port, reg, data16);
 


