Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DF5D530566D;
	Fri, 15 May 2026 16:20:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778862012; cv=none; b=beqiQCk74FZ5RuV9vTH3JJ4IyMYqmvjbjRpVJNsBX8pY0wZcduEuiIT2ItSu5e+E2K6FrIM/q8YmcFeE9bibA0sU6slNya12TpLXTGh29lhytekCteDvPvkGF3cKu1anyatwL1+n0w4rXur7CvBpgJGSnZ20j+/cnC7kkLrr64I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778862012; c=relaxed/simple;
	bh=Khi/k2+ygvdqExinGFj2A0h7ZekVoON+CYIX3WUGxGs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=tkawyM0rZxQe/4pw0320Ch+Dfm5o/SpbYvla9lytRQ8Hx6NZ0o4ANvkQmsxMtxgF+06mL3DOLQPiOM4VGV7BxZYDNytEIArh55/UvNYN2NiMvNmkqfwEbrqFTBjtiD7fPyDIwGr1c+GCdqYO1YJZLsDPtjKXDcapEmx3E31Of18=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=U2nnWb5p; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="U2nnWb5p"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3E9DEC2BCB0;
	Fri, 15 May 2026 16:20:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1778862012;
	bh=Khi/k2+ygvdqExinGFj2A0h7ZekVoON+CYIX3WUGxGs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=U2nnWb5poYRIAIAaIXzSMmMqkdnSr/sEDWQOmjUjUdODDQ8y6QnalORyt85WLYWJK
	 pkCp7wZ4o2/eUHFK2jiRojWPLA6S8zzQJp2+NRhFp0qOA2oPt+DraLJhIzk/H+nIA9
	 7ALqhU/slRB1oJRT2mIMJXL0p3CNESoAzdYXCKcA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	William Zhang <william.zhang@broadcom.com>,
	Johan Hovold <johan@kernel.org>,
	Mark Brown <broonie@kernel.org>
Subject: [PATCH 6.18 075/188] spi: bcmbca-hsspi: fix controller deregistration
Date: Fri, 15 May 2026 17:48:12 +0200
Message-ID: <20260515154658.946235328@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260515154657.309489048@linuxfoundation.org>
References: <20260515154657.309489048@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Johan Hovold <johan@kernel.org>

commit c3d97c3320b9a1ebbd6119857341be034f7b3efc upstream.

Make sure to deregister the controller before disabling underlying
resources like interrupts during driver unbind to allow SPI drivers to
do I/O during deregistration.

Note that clocks were also disabled before the recent commit
e532e21a246d ("spi: bcm63xx-hsspi: Simplify clock handling with
devm_clk_get_enabled()").

Fixes: a38a2233f23b ("spi: bcmbca-hsspi: Add driver for newer HSSPI controller")
Cc: stable@vger.kernel.org	# 6.3: deb269e0394f
Cc: stable@vger.kernel.org	# 6.3
Cc: William Zhang <william.zhang@broadcom.com>
Signed-off-by: Johan Hovold <johan@kernel.org>
Link: https://patch.msgid.link/20260409120419.388546-8-johan@kernel.org
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/spi/spi-bcmbca-hsspi.c |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

--- a/drivers/spi/spi-bcmbca-hsspi.c
+++ b/drivers/spi/spi-bcmbca-hsspi.c
@@ -550,7 +550,7 @@ static int bcmbca_hsspi_probe(struct pla
 	}
 
 	/* register and we are done */
-	ret = devm_spi_register_controller(dev, host);
+	ret = spi_register_controller(host);
 	if (ret)
 		goto out_sysgroup_disable;
 
@@ -572,6 +572,8 @@ static void bcmbca_hsspi_remove(struct p
 	struct spi_controller *host = platform_get_drvdata(pdev);
 	struct bcmbca_hsspi *bs = spi_controller_get_devdata(host);
 
+	spi_unregister_controller(host);
+
 	/* reset the hardware and block queue progress */
 	__raw_writel(0, bs->regs + HSSPI_INT_MASK_REG);
 	clk_disable_unprepare(bs->pll_clk);


