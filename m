Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 75B0B13AA2F;
	Tue, 27 Feb 2024 13:37:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709041052; cv=none; b=Y4SLGaSb2JQj4GpgS8hAFu+f2bfbPi5/ghDNuXo4R/cpABaQjsf/d72WPPbPTOC3FE/hgZHPFv4MjuP7SGWqvVRECy/1Y2++4b8blLyabDeUWEkC5V9uMjyezV2Rvk3Gv5RFPCFAjSJVVAHlaCT6pmFDPaMAn2GOwsl087njU3U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709041052; c=relaxed/simple;
	bh=Bf6LFyOttjT/gdql2IMRjlgk4a/aPsJNrmbWXdYX7sQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=gCvb/ExKFgiE07+KSTK/n9NQpmVlBHMeJqXA37kOUiCmeVZku0yarlsgTcRmDxLcSG0yQcjBMWStuG14PcmYGpwetAoThN2EDZXLdhBCndQ6uUOoaHtrAor0F+9cuOnOsXoqbp1oMsvtjfHK5U4QrN+bOgBRbCz0V/Yqdrp9fAE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=O4K/A7Kk; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="O4K/A7Kk"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F0A44C433C7;
	Tue, 27 Feb 2024 13:37:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1709041052;
	bh=Bf6LFyOttjT/gdql2IMRjlgk4a/aPsJNrmbWXdYX7sQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=O4K/A7KkJVN28A0SK0lcrjj7efsjSdxCWmTI9kht5D9jBNpoRajMOwDpNN6M4UoK5
	 qnE+zSiC2kSx+FTzb2NBV3syNC+j7UzS5iQccmd1YelhXSMe1mvLxOpptLeihdcKFJ
	 Ws0dLbtTH4Ed4tRIaPETwjbOnaLdK+3tdaWlHmqU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Lino Sanfilippo <l.sanfilippo@kunbus.com>
Subject: [PATCH 6.7 202/334] serial: stm32: do not always set SER_RS485_RX_DURING_TX if RS485 is enabled
Date: Tue, 27 Feb 2024 14:21:00 +0100
Message-ID: <20240227131637.256631687@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240227131630.636392135@linuxfoundation.org>
References: <20240227131630.636392135@linuxfoundation.org>
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

From: Lino Sanfilippo <l.sanfilippo@kunbus.com>

commit f418ae73311deb901c0110b08d1bbafc20c1820e upstream.

Before commit 07c30ea5861f ("serial: Do not hold the port lock when setting
rx-during-tx GPIO") the SER_RS485_RX_DURING_TX flag was only set if the
rx-during-tx mode was not controlled by a GPIO. Now the flag is set
unconditionally when RS485 is enabled. This results in an incorrect setting
if the rx-during-tx GPIO is not asserted.

Fix this by setting the flag only if the rx-during-tx mode is not
controlled by a GPIO and thus restore the correct behaviour.

Cc: stable@vger.kernel.org # 6.6+
Fixes: 07c30ea5861f ("serial: Do not hold the port lock when setting rx-during-tx GPIO")
Signed-off-by: Lino Sanfilippo <l.sanfilippo@kunbus.com>
Link: https://lore.kernel.org/r/20240216224709.9928-1-l.sanfilippo@kunbus.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/tty/serial/stm32-usart.c |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

--- a/drivers/tty/serial/stm32-usart.c
+++ b/drivers/tty/serial/stm32-usart.c
@@ -251,7 +251,9 @@ static int stm32_usart_config_rs485(stru
 		writel_relaxed(cr3, port->membase + ofs->cr3);
 		writel_relaxed(cr1, port->membase + ofs->cr1);
 
-		rs485conf->flags |= SER_RS485_RX_DURING_TX;
+		if (!port->rs485_rx_during_tx_gpio)
+			rs485conf->flags |= SER_RS485_RX_DURING_TX;
+
 	} else {
 		stm32_usart_clr_bits(port, ofs->cr3,
 				     USART_CR3_DEM | USART_CR3_DEP);


