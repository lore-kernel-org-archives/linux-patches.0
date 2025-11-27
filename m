Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D00491A9B58;
	Thu, 27 Nov 2025 14:47:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764254867; cv=none; b=hXqVfHWXZBj7AD6dZNBbYIplTMHnV20bMJ9Rs7yXQN/oFQ34OML31YyGoseLBkQjKd/bLcoNyNag+A/axu13WhICxHnZkyWY+F79LoADbJ2ZYUcQwFidF5KKvB3PHJNb5wScP4reTNQs5O16LSfW2WF3Zszkw88Z8jVL+eC1DYI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764254867; c=relaxed/simple;
	bh=FOTx/gMebdaxGfn5j2LXiGTFnHtgMy/atZ7I/D7sBzo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ACbZRhBXXBzTwptIX8JrDOVucz6OKwU0K4JsbHXRJsO2dx0O5uUiExdnhk5DNkDVgtOJANleQr7u/j54vetsDAh8wk60myiui4rGXz4bapkhwZnmsnhTkQqEvGhZMV4KeE+D7wyUmrvcZ4+f3elCYjJ1dpupmFm2WoKnh43mGCA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=gX5d9urx; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="gX5d9urx"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4F810C4CEF8;
	Thu, 27 Nov 2025 14:47:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1764254867;
	bh=FOTx/gMebdaxGfn5j2LXiGTFnHtgMy/atZ7I/D7sBzo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=gX5d9urx2GbsjkYf/RjdFgqy53VWCH06Xg7PiOhdrQQv2NQwEs8xLkbk68rqHnJRw
	 vt1P9Hfp7Y5JBfq22yQ4D5KEkBC5hF9YuIrd9jIlHLVTMHkDUkF1h+pHU7T4pa6vLx
	 ZB/ZusGch57WM8TZsT0gBDBDLVVV8aBjQseIhJnk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Oleksij Rempel <o.rempel@pengutronix.de>,
	Paolo Abeni <pabeni@redhat.com>
Subject: [PATCH 6.6 14/86] net: dsa: microchip: lan937x: Fix RGMII delay tuning
Date: Thu, 27 Nov 2025 15:45:30 +0100
Message-ID: <20251127144028.339434354@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251127144027.800761504@linuxfoundation.org>
References: <20251127144027.800761504@linuxfoundation.org>
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
@@ -336,6 +336,7 @@ static void lan937x_set_tune_adj(struct
 	ksz_pread16(dev, port, reg, &data16);
 
 	/* Update tune Adjust */
+	data16 &= ~PORT_TUNE_ADJ;
 	data16 |= FIELD_PREP(PORT_TUNE_ADJ, val);
 	ksz_pwrite16(dev, port, reg, data16);
 


