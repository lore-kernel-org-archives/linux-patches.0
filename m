Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DE6F9328B77;
	Mon, 27 Oct 2025 19:24:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761593085; cv=none; b=t8ebet/4tzG0Ckrr3uvmdZq2O27sdBiQCyQhlL/9m3ovqOgjpj6ii3fHg/15VuR5rIeV2sHLSGBl6aGujEZi2vsbZC3HL+YF6Ln+KwvN1XGUrr+XYezdYUHJucSDOUL354YqjIIomxZ4/drp8K+Zja7jA0JtPzu1HxhkdK7nHaU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761593085; c=relaxed/simple;
	bh=iOEWFGINnCyPrPhdSXDcb3Dw6RVO0xcDJ1H025bC2E8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=cnJPwAkHi4p5F1Y7QQcMZG+yuKPgtmxVfw6THI//g3i2H7I4gu7OyjtipNFokp0YC5vLGRmBzSwTcTyh3x0hJJKhG7Ho/3q2usZiuVGB2yBuqwyPsNM9oHBbtVSlwFpvct3lBauqM9naLd7d2RrG7EOAtVYUcNyWdFF0to5rc+Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=rfSrg7wN; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="rfSrg7wN"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6A63CC4CEFD;
	Mon, 27 Oct 2025 19:24:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1761593084;
	bh=iOEWFGINnCyPrPhdSXDcb3Dw6RVO0xcDJ1H025bC2E8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=rfSrg7wNfd7N6XnBbnNsdw9jv70k5SUekeTrIXj+h+xOMWLHEyxoRQmPLbhNEXy3X
	 KrcRKto9vsE1izLNTHhGIBq5k6/1ZhH3S0JIBzGJIwa8AVW1hPL8thZdP55xfdtzCl
	 Rb3kkRiCVJzqfGAfufg82RRbs29CTsC9tDxoLhrQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	stable <stable@kernel.org>,
	Hugo Villeneuve <hvilleneuve@dimonoff.com>
Subject: [PATCH 6.12 114/117] serial: sc16is7xx: remove useless enable of enhanced features
Date: Mon, 27 Oct 2025 19:37:20 +0100
Message-ID: <20251027183457.112874530@linuxfoundation.org>
X-Mailer: git-send-email 2.51.1
In-Reply-To: <20251027183453.919157109@linuxfoundation.org>
References: <20251027183453.919157109@linuxfoundation.org>
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
@@ -585,13 +585,6 @@ static int sc16is7xx_set_baud(struct uar
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


