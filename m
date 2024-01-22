Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 24ADE657A9;
	Tue, 23 Jan 2024 00:59:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1705971577; cv=none; b=M5MgtLRPSYDomDkdh74I8KD8nYe3S9SmPH8vocZHSsXMF2OCptGq6nmkWN7dERXRdLSJaZZRpMGXO3KqhpUUJujpSi8AJJHbXiHq+1wwuivYbIVftt6VqiaTz3iBbZyJ7rzyxctmkOkR3c756PuV9CfdwrAQzz3VypSB2qiHuCc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1705971577; c=relaxed/simple;
	bh=1n1pVs0gj1Ow+mSJRKRV1ftwF0pZ6l34bkROLTYOsCc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=YC9kpSRaXI1muMdGHXXXkYc/Xv1Ov5BCq9tWESf697WxuIZEYtbLNwnuLKWsN1ZydebbuTwMXLXq3Qu3jwLlAVYXTxqoh9BhehnQyCmMH9akZ5yHJ6WWcBRwLgKsUc0QyF1ptgCgEYTD90RoTSjTog61Qfx3sXROOA5Ar1OsTvU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=YtQkMhKX; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="YtQkMhKX"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C5A7EC433C7;
	Tue, 23 Jan 2024 00:59:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1705971577;
	bh=1n1pVs0gj1Ow+mSJRKRV1ftwF0pZ6l34bkROLTYOsCc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=YtQkMhKXyjPlDJpjcEcYQCJKVyV48YdUL+a5uucidaxr051CQQ1SaF5DcZnV4NWQS
	 EJRBz/DJt7tJogD8jcIg6ue2Rz/vp8A+wLEGE6CvoNBZoRclyFngJ1moZHnB1t1abM
	 kjOfnbOJUkdCpINLBUQoBbTeKrDYBh+QPf67IF+0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	stable <stable@kernel.org>,
	Stefan Wahren <wahrenst@gmx.net>,
	Florian Fainelli <florian.fainelli@broadcom.com>
Subject: [PATCH 6.1 272/417] serial: 8250_bcm2835aux: Restore clock error handling
Date: Mon, 22 Jan 2024 15:57:20 -0800
Message-ID: <20240122235801.271905340@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240122235751.480367507@linuxfoundation.org>
References: <20240122235751.480367507@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Stefan Wahren <wahrenst@gmx.net>

commit 83e571f054cd742eb9a46d46ef05193904adf53f upstream.

The commit fcc446c8aa63 ("serial: 8250_bcm2835aux: Add ACPI support")
dropped the error handling for clock acquiring. But even an optional
clock needs this.

Fixes: fcc446c8aa63 ("serial: 8250_bcm2835aux: Add ACPI support")
Cc: stable <stable@kernel.org>
Signed-off-by: Stefan Wahren <wahrenst@gmx.net>
Reviewed-by: Florian Fainelli <florian.fainelli@broadcom.com>
Link: https://lore.kernel.org/r/20231220114334.4712-1-wahrenst@gmx.net
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/tty/serial/8250/8250_bcm2835aux.c |    2 ++
 1 file changed, 2 insertions(+)

--- a/drivers/tty/serial/8250/8250_bcm2835aux.c
+++ b/drivers/tty/serial/8250/8250_bcm2835aux.c
@@ -119,6 +119,8 @@ static int bcm2835aux_serial_probe(struc
 
 	/* get the clock - this also enables the HW */
 	data->clk = devm_clk_get_optional(&pdev->dev, NULL);
+	if (IS_ERR(data->clk))
+		return dev_err_probe(&pdev->dev, PTR_ERR(data->clk), "could not get clk\n");
 
 	/* get the interrupt */
 	ret = platform_get_irq(pdev, 0);


