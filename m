Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BC6A6646;
	Tue,  3 Dec 2024 15:30:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733239826; cv=none; b=AsC1F6NFIsUxsC9SpVE3LOzR831z0jdC7CxJN/7bhn+JNEGjm9dzui+ra0fIxFnpN9zbkL+Sg2tOMc/7z2DZLsnOQmzdNrilW/Jbm61nT7/m8uBzuHVjns5W2bKQpXTVjxQ2nJpIZE8MBE3pwdoduQ1kg1RkkkeGNkKOKDgwAIg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733239826; c=relaxed/simple;
	bh=IvyaFagk1EquxhlXYpuzzRiCznZj1qdGzd6XDZVKNq4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=PcsiMrOkAwkEN3+o7De1/CteOLMgp+9wUBdrYyxkalzVm4B8LKGM8WIDvMCio7e6ZnihChFoK9Nf90axXOA4e0VOk5vFi1vWvODBRXYluDs/kJI12fEuKjUPxpZGmqTEFCoIPo0h/AQrVfpGCHATpN1J09z6/NS6F57+DHdiD5I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=YDjIEHtf; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="YDjIEHtf"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3CEA8C4CECF;
	Tue,  3 Dec 2024 15:30:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1733239826;
	bh=IvyaFagk1EquxhlXYpuzzRiCznZj1qdGzd6XDZVKNq4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=YDjIEHtfNdlOhIxEacvSlKqfCWVoP9TQaG13Y53rsBKD9jZA/O9nHmAjFgkzIWkdC
	 0fOVy1XkSuEp6A+MtZQdpyYJbnp9ETiGb9Q+j3xDVQ/Vp9L8Oz5mvJd2X7UwU2yZNb
	 XzsrtNED78Uy8QLHShAfcEdxnZWuOLwgpnI8WOL0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Kartik Rajput <kkartik@nvidia.com>,
	Linus Walleij <linus.walleij@linaro.org>
Subject: [PATCH 6.11 716/817] serial: amba-pl011: Fix RX stall when DMA is used
Date: Tue,  3 Dec 2024 15:44:48 +0100
Message-ID: <20241203144023.940840262@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241203143955.605130076@linuxfoundation.org>
References: <20241203143955.605130076@linuxfoundation.org>
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

6.11-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Kartik Rajput <kkartik@nvidia.com>

commit 2bcacc1c87acf9a8ebc17de18cb2b3cfeca547cf upstream.

Function pl011_throttle_rx() calls pl011_stop_rx() to disable RX, which
also disables the RX DMA by clearing the RXDMAE bit of the DMACR
register. However, to properly unthrottle RX when DMA is used, the
function pl011_unthrottle_rx() is expected to set the RXDMAE bit of
the DMACR register, which it currently lacks. This causes RX to stall
after the throttle API is called.

Set RXDMAE bit in the DMACR register while unthrottling RX if RX DMA is
used.

Fixes: 211565b10099 ("serial: pl011: UPSTAT_AUTORTS requires .throttle/unthrottle")
Cc: stable@vger.kernel.org
Signed-off-by: Kartik Rajput <kkartik@nvidia.com>
Reviewed-by: Linus Walleij <linus.walleij@linaro.org>
Link: https://lore.kernel.org/r/20241113092629.60226-1-kkartik@nvidia.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/tty/serial/amba-pl011.c |    5 +++++
 1 file changed, 5 insertions(+)

--- a/drivers/tty/serial/amba-pl011.c
+++ b/drivers/tty/serial/amba-pl011.c
@@ -1819,6 +1819,11 @@ static void pl011_unthrottle_rx(struct u
 
 	pl011_write(uap->im, uap, REG_IMSC);
 
+	if (uap->using_rx_dma) {
+		uap->dmacr |= UART011_RXDMAE;
+		pl011_write(uap->dmacr, uap, REG_DMACR);
+	}
+
 	uart_port_unlock_irqrestore(&uap->port, flags);
 }
 


