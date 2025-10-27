Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8D37832143D;
	Mon, 27 Oct 2025 19:32:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761593563; cv=none; b=ni1RaZdx3qHbQy5z+z1gifBVBL2I6prVm5X1jLHTMqQTj39ogCBIYDg594009f/tYY4lc1IGiwpWVbs5BBiyHBWzZAmp5Xg/q0rapLJEZT4FQxTMmA0VUxJqrQiK7ypQioSqrSnKSHkf1QIthY9crasqaztUMYVSMMr6gxLvc0g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761593563; c=relaxed/simple;
	bh=pomrp2rdKfcKuK03fQroTvWiesRfHNhPwmwPVKB+lek=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=WM9NjB0b9HuMHn/+E7dry8FkwIWvl1KfjHFEOWxpOfbaTBFJtufpt8lxo27tMPe960ZK44cGRST4FBO5mi6DaBtlXYb72yrwHMlnIdTH3y1rR1/C/x5juEoG0yypifAV8i9XFXjfYruFg5p11DgTU+2hToadBkw8+e/dOeFahjw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=W7XTLeMC; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="W7XTLeMC"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0D125C4CEF1;
	Mon, 27 Oct 2025 19:32:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1761593563;
	bh=pomrp2rdKfcKuK03fQroTvWiesRfHNhPwmwPVKB+lek=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=W7XTLeMCMk+EDBjL6/37sWpQfYU78p1gdGxFIA4E+ntQ6srJbtWQ1m3O/YN8t1/Jd
	 wDYdAx9l2crZfQcNjP/1Eguj6po38dbyDKolDH/OTXFXjYe1yH4ctPxKdr44Cll9EP
	 NNYImboIcC7mgtwmOXNUjzdA5NMYU902ABNDg1/g=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	stable <stable@kernel.org>,
	Hugo Villeneuve <hvilleneuve@dimonoff.com>
Subject: [PATCH 6.17 173/184] serial: sc16is7xx: remove useless enable of enhanced features
Date: Mon, 27 Oct 2025 19:37:35 +0100
Message-ID: <20251027183519.582336430@linuxfoundation.org>
X-Mailer: git-send-email 2.51.1
In-Reply-To: <20251027183514.934710872@linuxfoundation.org>
References: <20251027183514.934710872@linuxfoundation.org>
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

From: Hugo Villeneuve <hvilleneuve@dimonoff.com>

commit 1c05bf6c0262f946571a37678250193e46b1ff0f upstream.

Commit 43c51bb573aa ("sc16is7xx: make sure device is in suspend once
probed") permanently enabled access to the enhanced features in
sc16is7xx_probe(), and it is never disabled after that.

Therefore, remove re-enable of enhanced features in
sc16is7xx_set_baud(). This eliminates a potential useless read + write
cycle each time the baud rate is reconfigured.

Fixes: 43c51bb573aa ("sc16is7xx: make sure device is in suspend once probed")
Cc: stable <stable@kernel.org>
Signed-off-by: Hugo Villeneuve <hvilleneuve@dimonoff.com>
Link: https://patch.msgid.link/20251006142002.177475-1-hugo@hugovil.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/tty/serial/sc16is7xx.c |    7 -------
 1 file changed, 7 deletions(-)

--- a/drivers/tty/serial/sc16is7xx.c
+++ b/drivers/tty/serial/sc16is7xx.c
@@ -588,13 +588,6 @@ static int sc16is7xx_set_baud(struct uar
 		div /= prescaler;
 	}
 
-	/* Enable enhanced features */
-	sc16is7xx_efr_lock(port);
-	sc16is7xx_port_update(port, SC16IS7XX_EFR_REG,
-			      SC16IS7XX_EFR_ENABLE_BIT,
-			      SC16IS7XX_EFR_ENABLE_BIT);
-	sc16is7xx_efr_unlock(port);
-
 	/* If bit MCR_CLKSEL is set, the divide by 4 prescaler is activated. */
 	sc16is7xx_port_update(port, SC16IS7XX_MCR_REG,
 			      SC16IS7XX_MCR_CLKSEL_BIT,


