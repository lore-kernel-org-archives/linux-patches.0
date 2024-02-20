Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DCF45612D7;
	Tue, 20 Feb 2024 21:19:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708463969; cv=none; b=gT4CkbVXPO9phiZUxpagd6P12jGoWD1gZ97ang+IAd0THanR8+PygiYQ+eTrQJqBAg12mIbh+FeWdjVzkgnhaT0lhhuuXzG44d+kOwemzgHxbQYAjz+3Kr5hLRMyAEBtLa8nitVqRC+ed7Z92sf2KVw/q8eebnTY66NOrKqHi/A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708463969; c=relaxed/simple;
	bh=1isNohZ30zvJ9w03heUyf4z+W4XwNqdcYo7OL9/0DEc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=cugN/7TZzhoxm30XrYX9kfl11xYYAXpKWEeovNGjtKli2+VazqHVRBxag4dhsxiO4K3Repw2eIA7WeWOWiyrpDDu3TF0imhlDbG5ZIXSt4v6dDdY0fb0IDhPXlYyHg1t3ca5g5L5pTqhcO4TYgwQ9srNhqGMCqL+f04gE6ez+Zs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=sZ4Fm+6B; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="sZ4Fm+6B"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 41324C433F1;
	Tue, 20 Feb 2024 21:19:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1708463968;
	bh=1isNohZ30zvJ9w03heUyf4z+W4XwNqdcYo7OL9/0DEc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=sZ4Fm+6BAzk62GOtJI5G86LB/Bw5alliKfZ3ruzC9xvxOSyksH3IRZWnjoYE+9DD6
	 mJ58k03haqvHsv77kV/U/6EFd1xeM3jGtdqcfwHHFlfQPGFhhJhDwWWuK2C2Vn+kJR
	 noEhJE0bmqrEX3VJ6uLVch5ICCPAOGfe3gIN+iNE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Jan=20Kundr=C3=A1t?= <jan.kundrat@cesnet.cz>,
	Hugo Villeneuve <hvilleneuve@dimonoff.com>
Subject: [PATCH 6.6 181/331] serial: max310x: fail probe if clock crystal is unstable
Date: Tue, 20 Feb 2024 21:54:57 +0100
Message-ID: <20240220205643.217645686@linuxfoundation.org>
X-Mailer: git-send-email 2.43.2
In-Reply-To: <20240220205637.572693592@linuxfoundation.org>
References: <20240220205637.572693592@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Hugo Villeneuve <hvilleneuve@dimonoff.com>

commit 8afa6c6decea37e7cb473d2c60473f37f46cea35 upstream.

A stable clock is really required in order to use this UART, so log an
error message and bail out if the chip reports that the clock is not
stable.

Fixes: 4cf9a888fd3c ("serial: max310x: Check the clock readiness")
Cc: stable@vger.kernel.org
Suggested-by: Jan Kundrát <jan.kundrat@cesnet.cz>
Link: https://www.spinics.net/lists/linux-serial/msg35773.html
Signed-off-by: Hugo Villeneuve <hvilleneuve@dimonoff.com>
Link: https://lore.kernel.org/r/20240116213001.3691629-4-hugo@hugovil.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/tty/serial/max310x.c |   12 +++++++++---
 1 file changed, 9 insertions(+), 3 deletions(-)

--- a/drivers/tty/serial/max310x.c
+++ b/drivers/tty/serial/max310x.c
@@ -587,7 +587,7 @@ static int max310x_update_best_err(unsig
 	return 1;
 }
 
-static u32 max310x_set_ref_clk(struct device *dev, struct max310x_port *s,
+static s32 max310x_set_ref_clk(struct device *dev, struct max310x_port *s,
 			       unsigned long freq, bool xtal)
 {
 	unsigned int div, clksrc, pllcfg = 0;
@@ -657,7 +657,8 @@ static u32 max310x_set_ref_clk(struct de
 		} while (!stable && (++try < MAX310X_XTAL_WAIT_RETRIES));
 
 		if (!stable)
-			dev_warn(dev, "clock is not stable yet\n");
+			return dev_err_probe(dev, -EAGAIN,
+					     "clock is not stable\n");
 	}
 
 	return bestfreq;
@@ -1282,7 +1283,7 @@ static int max310x_probe(struct device *
 {
 	int i, ret, fmin, fmax, freq;
 	struct max310x_port *s;
-	u32 uartclk = 0;
+	s32 uartclk = 0;
 	bool xtal;
 
 	for (i = 0; i < devtype->nr; i++)
@@ -1360,6 +1361,11 @@ static int max310x_probe(struct device *
 	}
 
 	uartclk = max310x_set_ref_clk(dev, s, freq, xtal);
+	if (uartclk < 0) {
+		ret = uartclk;
+		goto out_uart;
+	}
+
 	dev_dbg(dev, "Reference clock set to %i Hz\n", uartclk);
 
 	for (i = 0; i < devtype->nr; i++) {


