Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B66ED136658;
	Tue, 23 Jan 2024 00:28:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1705969703; cv=none; b=iar0wiBNpHP0OBrc0ireldY7lEVasqlzTsA5dnXkwf4RfZ+N+SyA8IreI06eeZX1whQ+oQRCU9L1wVBR21yc7ONgOUI2GLmZWokc4liBokD83qCT6tNSTJlqY/LeGbd6sWrXenCiTCyspgYN5/O4ZIalV4tg9Wi6SxcHkDa/AVg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1705969703; c=relaxed/simple;
	bh=5pIdF8HLwHJEDYqBPAWc8X+NuY31VWW6j+0HPZPTWMU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Yzm+3Hsq3b8cBwbKL3hpZ7vIGkEiYFoR8zlrkfyj1tTiEi86o6E8gzE7aCJnDk4ycWNMq8sIgV9MqQvLvwPi5ZpyVrmKyDgih7dDEjqobZqpL0D4Qll9pLCGMSfjW82wfgFpuLHXZP+fDGoW44UBXiUf7hHoC7khXoYZaSwQag4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=pwjOOs66; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="pwjOOs66"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4070FC433F1;
	Tue, 23 Jan 2024 00:28:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1705969703;
	bh=5pIdF8HLwHJEDYqBPAWc8X+NuY31VWW6j+0HPZPTWMU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=pwjOOs66vqI7kCs1o3KX45yL7hZcIcKW9ArmHARF46BSRFBUHp1EljjAiS8vVQkjO
	 amxnw7AanSLqLf0odViccOhh4A5Fzix+rwSWWOJ2OPBlT1L9aA6s9FtxOQnJokGfxs
	 R6bUjc5vUnq977FunflXYlfSle9I2n7mEsj2TQRI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	stable <stable@kernel.org>,
	Stefan Wahren <wahrenst@gmx.net>,
	Florian Fainelli <florian.fainelli@broadcom.com>
Subject: [PATCH 6.7 413/641] serial: 8250_bcm2835aux: Restore clock error handling
Date: Mon, 22 Jan 2024 15:55:17 -0800
Message-ID: <20240122235830.898809657@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240122235818.091081209@linuxfoundation.org>
References: <20240122235818.091081209@linuxfoundation.org>
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

6.7-stable review patch.  If anyone has any objections, please let me know.

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


