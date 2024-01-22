Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3B3826EB61;
	Tue, 23 Jan 2024 02:03:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1705975415; cv=none; b=ZjjtG4+Ma9XQM6MO7S+uhZZhAN0c3uS1LVxfgQbkilDbgZTkRmeCazdvIQqZzTXPfUKp8SP+qQjsxLczFzK2247+nRi6lR/pBwwM/czdiFOlYUvzW8vanQty/S8gOIfz0FYzAhk8SOp0O+zg4HETrrMUB823luc+D5j/jO7SUEc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1705975415; c=relaxed/simple;
	bh=bYRbOENQmGngJbpJMuXm4hTkMIskLdM4iooO9a+6fPA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Zyh1flnEQ6/kcme+HdjsXUzNBhjahC7zryb4pfxOIUq33ONB4NXy+gZJNImdxHSh+g6RMJ07TbgQrLF3jVf7DlF8mIt5OXF8wgHPCMs8FL8iTeVE6QJiJQRbrYOROmykTXOpzMPu8LfdGFroNO1C3+4lrzyhoFUMFRj1sZ/+KKM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=l68/HmNd; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="l68/HmNd"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F3634C43399;
	Tue, 23 Jan 2024 02:03:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1705975415;
	bh=bYRbOENQmGngJbpJMuXm4hTkMIskLdM4iooO9a+6fPA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=l68/HmNd0jKWOG27bC7LbY7ngGFQbkaSKR3NKmz4xomNCmvbHnDwwxyUc1Q74ejnv
	 YKRma9bxagp0Br2P7WAEX4UGpTrZ/wTQVrON3oXvqbE58oFPWvsAMoeYA4IQ4JAk2E
	 xdbAArGFIN6QtGt2oE0njl1QqT2MaOrXGxYHiHRw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	stable <stable@kernel.org>,
	Stefan Wahren <wahrenst@gmx.net>,
	Florian Fainelli <florian.fainelli@broadcom.com>
Subject: [PATCH 6.6 374/583] serial: 8250_bcm2835aux: Restore clock error handling
Date: Mon, 22 Jan 2024 15:57:05 -0800
Message-ID: <20240122235823.455221411@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240122235812.238724226@linuxfoundation.org>
References: <20240122235812.238724226@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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


