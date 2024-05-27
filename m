Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ECFE815FCF9;
	Mon, 27 May 2024 18:58:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1716836330; cv=none; b=pF3mbFF1rUUkXkMnlwA9scnByoM7e6u7eCEW4RtZpHyUG6SqO/2TY164PIEzD2ORKjXv0BmknAm3RhC7Tn4FKmic5MiAG3m69J1mlIhMWNJI2A67LXtV2paq6C3kwaIpATq/tYoJdUqulj1GfJrA1Kgiq0qFv6IVIHw4wXiJJHs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1716836330; c=relaxed/simple;
	bh=PjsxmueGHKDc/IdYU74Uk038dT4Kr3OL6GMYlbICExY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=OqD5HSYdM+XRdZ7tyT3g+GI1i+koRXh9bv/h2ZD/C75jHY+4Uh1aLMUhmtjWsX78A2+u/PWkDxGnhu7edskbuoY9QQmrx7Q2MKDOYIizxCunc41MU067M3b6HSmpl00smki6RcEtLwk2p/qG8DUYISSOruJPZGV3fZaYlUnDcMk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=v553KF+x; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="v553KF+x"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 346E1C2BBFC;
	Mon, 27 May 2024 18:58:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1716836329;
	bh=PjsxmueGHKDc/IdYU74Uk038dT4Kr3OL6GMYlbICExY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=v553KF+x7EkroPE7pbC9b36iSUGw0uWCmXosokAY2H9JscU+IIzgipofgqQMr/fAc
	 Q9BnyN5f84Zouh5u85risW0kaxdWNKrErNtR7tHkeaF79lAEAoTPG+wu6cFJkLpHCO
	 pm7X/hBA5grRWSVQ7MvHwYeGv4Q77sTlm/S9ArXQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Doug Berger <opendmb@gmail.com>,
	Florian Fainelli <florian.fainelli@broadcom.com>
Subject: [PATCH 6.9 012/427] serial: 8250_bcm7271: use default_mux_rate if possible
Date: Mon, 27 May 2024 20:50:59 +0200
Message-ID: <20240527185602.922615864@linuxfoundation.org>
X-Mailer: git-send-email 2.45.1
In-Reply-To: <20240527185601.713589927@linuxfoundation.org>
References: <20240527185601.713589927@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.9-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Doug Berger <opendmb@gmail.com>

commit 614a19b89ca43449196a8af1afac7d55c6781687 upstream.

There is a scenario when resuming from some power saving states
with no_console_suspend where console output can be generated
before the 8250_bcm7271 driver gets the opportunity to restore
the baud_mux_clk frequency. Since the baud_mux_clk is at its
default frequency at this time the output can be garbled until
the driver gets the opportunity to resume.

Since this is only an issue with console use of the serial port
during that window and the console isn't likely to use baud
rates that require alternate baud_mux_clk frequencies, allow the
driver to select the default_mux_rate if it is accurate enough.

Fixes: 41a469482de2 ("serial: 8250: Add new 8250-core based Broadcom STB driver")
Cc: stable@vger.kernel.org
Signed-off-by: Doug Berger <opendmb@gmail.com>
Reviewed-by: Florian Fainelli <florian.fainelli@broadcom.com>
Tested-by: Florian Fainelli <florian.fainelli@broadcom.com>
Link: https://lore.kernel.org/r/20240424222559.1844045-1-opendmb@gmail.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/tty/serial/8250/8250_bcm7271.c |  101 +++++++++++++++++++--------------
 1 file changed, 60 insertions(+), 41 deletions(-)

--- a/drivers/tty/serial/8250/8250_bcm7271.c
+++ b/drivers/tty/serial/8250/8250_bcm7271.c
@@ -675,18 +675,46 @@ static void init_real_clk_rates(struct d
 	clk_set_rate(priv->baud_mux_clk, priv->default_mux_rate);
 }
 
+static u32 find_quot(struct device *dev, u32 freq, u32 baud, u32 *percent)
+{
+	u32 quot;
+	u32 rate;
+	u64 hires_rate;
+	u64 hires_baud;
+	u64 hires_err;
+
+	rate = freq / 16;
+	quot = DIV_ROUND_CLOSEST(rate, baud);
+	if (!quot)
+		return 0;
+
+	/* increase resolution to get xx.xx percent */
+	hires_rate = div_u64((u64)rate * 10000, (u64)quot);
+	hires_baud = (u64)baud * 10000;
+
+	/* get the delta */
+	if (hires_rate > hires_baud)
+		hires_err = (hires_rate - hires_baud);
+	else
+		hires_err = (hires_baud - hires_rate);
+
+	*percent = (unsigned long)DIV_ROUND_CLOSEST_ULL(hires_err, baud);
+
+	dev_dbg(dev, "Baud rate: %u, MUX Clk: %u, Error: %u.%u%%\n",
+		baud, freq, *percent / 100, *percent % 100);
+
+	return quot;
+}
+
 static void set_clock_mux(struct uart_port *up, struct brcmuart_priv *priv,
 			u32 baud)
 {
 	u32 percent;
 	u32 best_percent = UINT_MAX;
 	u32 quot;
+	u32 freq;
 	u32 best_quot = 1;
-	u32 rate;
-	int best_index = -1;
-	u64 hires_rate;
-	u64 hires_baud;
-	u64 hires_err;
+	u32 best_freq = 0;
 	int rc;
 	int i;
 	int real_baud;
@@ -695,44 +723,35 @@ static void set_clock_mux(struct uart_po
 	if (priv->baud_mux_clk == NULL)
 		return;
 
-	/* Find the closest match for specified baud */
-	for (i = 0; i < ARRAY_SIZE(priv->real_rates); i++) {
-		if (priv->real_rates[i] == 0)
-			continue;
-		rate = priv->real_rates[i] / 16;
-		quot = DIV_ROUND_CLOSEST(rate, baud);
-		if (!quot)
-			continue;
-
-		/* increase resolution to get xx.xx percent */
-		hires_rate = (u64)rate * 10000;
-		hires_baud = (u64)baud * 10000;
-
-		hires_err = div_u64(hires_rate, (u64)quot);
-
-		/* get the delta */
-		if (hires_err > hires_baud)
-			hires_err = (hires_err - hires_baud);
-		else
-			hires_err = (hires_baud - hires_err);
-
-		percent = (unsigned long)DIV_ROUND_CLOSEST_ULL(hires_err, baud);
-		dev_dbg(up->dev,
-			"Baud rate: %u, MUX Clk: %u, Error: %u.%u%%\n",
-			baud, priv->real_rates[i], percent / 100,
-			percent % 100);
-		if (percent < best_percent) {
-			best_percent = percent;
-			best_index = i;
-			best_quot = quot;
+	/* Try default_mux_rate first */
+	quot = find_quot(up->dev, priv->default_mux_rate, baud, &percent);
+	if (quot) {
+		best_percent = percent;
+		best_freq = priv->default_mux_rate;
+		best_quot = quot;
+	}
+	/* If more than 1% error, find the closest match for specified baud */
+	if (best_percent > 100) {
+		for (i = 0; i < ARRAY_SIZE(priv->real_rates); i++) {
+			freq = priv->real_rates[i];
+			if (freq == 0 || freq == priv->default_mux_rate)
+				continue;
+			quot = find_quot(up->dev, freq, baud, &percent);
+			if (!quot)
+				continue;
+
+			if (percent < best_percent) {
+				best_percent = percent;
+				best_freq = freq;
+				best_quot = quot;
+			}
 		}
 	}
-	if (best_index == -1) {
+	if (!best_freq) {
 		dev_err(up->dev, "Error, %d BAUD rate is too fast.\n", baud);
 		return;
 	}
-	rate = priv->real_rates[best_index];
-	rc = clk_set_rate(priv->baud_mux_clk, rate);
+	rc = clk_set_rate(priv->baud_mux_clk, best_freq);
 	if (rc)
 		dev_err(up->dev, "Error selecting BAUD MUX clock\n");
 
@@ -741,8 +760,8 @@ static void set_clock_mux(struct uart_po
 		dev_err(up->dev, "Error, baud: %d has %u.%u%% error\n",
 			baud, percent / 100, percent % 100);
 
-	real_baud = rate / 16 / best_quot;
-	dev_dbg(up->dev, "Selecting BAUD MUX rate: %u\n", rate);
+	real_baud = best_freq / 16 / best_quot;
+	dev_dbg(up->dev, "Selecting BAUD MUX rate: %u\n", best_freq);
 	dev_dbg(up->dev, "Requested baud: %u, Actual baud: %u\n",
 		baud, real_baud);
 
@@ -751,7 +770,7 @@ static void set_clock_mux(struct uart_po
 	i += (i / 2);
 	priv->char_wait = ns_to_ktime(i);
 
-	up->uartclk = rate;
+	up->uartclk = best_freq;
 }
 
 static void brcmstb_set_termios(struct uart_port *up,


