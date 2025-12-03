Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 003C13563E1;
	Wed,  3 Dec 2025 16:17:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764778669; cv=none; b=qQwVS9ys5LPQYfhSebfcwf9vutu/6hmFIwuG5J5QBej877VgThu+FLdt0CyHxARloVseqBZWfCaOW4PE5MvEu9qRb/8V2isZo7/Ebn5ApZP69auG2crrt8+HELXoDsT8k83yTVJ6GVZwBZy+cCAKokOWsE9gUrs5ByjHTW0Gkqk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764778669; c=relaxed/simple;
	bh=A2//YzEb0fh1q9H3gqLCSCGS7Plkq9jpikKMBpxrLzI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=NyXjn9xTT+YiAUiYs9VlntRp2TQYbW2THgfYw1xTvbH49dSIia/2cveFZvGTETkHFiSOixVAQ6Cu7ozwlDKymxHmHCKZXydAWEY6JaSdr1r0evu531LCyB4UHGtYpR+B1N5hFMBbab7um4Vg8CA6xrODutnoUKqMJyu45+raSbI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=TCaMHDwe; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="TCaMHDwe"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5107CC4CEF5;
	Wed,  3 Dec 2025 16:17:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1764778668;
	bh=A2//YzEb0fh1q9H3gqLCSCGS7Plkq9jpikKMBpxrLzI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=TCaMHDwelvBO003Kxeu/SwH2VTe9Vp2eYOvnAHYu7pfRS8Fk3Jd3w48r3TivFr8im
	 o6lSoJD16k1giapBabXOFEpTvjGnwihSJH007Gr+xVEc3RmxBZvoBBbZzs6aYxCQ7l
	 tO/ytxbhZH0SBPNPCe6HpZIOl9hyQdUYug1qYOMI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	stable <stable@kernel.org>,
	Hugo Villeneuve <hvilleneuve@dimonoff.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 023/568] serial: sc16is7xx: remove useless enable of enhanced features
Date: Wed,  3 Dec 2025 16:20:25 +0100
Message-ID: <20251203152441.511937664@linuxfoundation.org>
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

From: Hugo Villeneuve <hvilleneuve@dimonoff.com>

[ Upstream commit 1c05bf6c0262f946571a37678250193e46b1ff0f ]

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
Signed-off-by: Sasha Levin <sashal@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/tty/serial/sc16is7xx.c |    7 -------
 1 file changed, 7 deletions(-)

--- a/drivers/tty/serial/sc16is7xx.c
+++ b/drivers/tty/serial/sc16is7xx.c
@@ -582,13 +582,6 @@ static int sc16is7xx_set_baud(struct uar
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


