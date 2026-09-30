Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0ACC93A784F;
	Wed, 30 Sep 2026 17:18:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790788732; cv=none; b=AMOW7pfkDL0kDV6c3WGmpblgOm6ZmeHXYFH3XkHfyfh59pPTUIUlHJY444F6/Y+iDw/Lug0bSKmSNuaRFLrfVplE95r9pWq6QZ4jX7pr/CwloxmnVFYzXjIyN0ckXQoeKDoqyDa4RRIFRwCID9pcudZ6RpcgZnnpeIBuHcN2JEo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790788732; c=relaxed/simple;
	bh=/V+OQ+F11p23f+2lGuRhtwsxxhn1bfPwNod/qPE4BFM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=mclkpdMD/uoH4zxChYtZsleyYr0TkAC5U98Jk22IgmozioCzFQLi4GvjOKv7YEhFAglgpGJnBaGxM9I+h+s5r+bct7Cb78CzjWmlwJaes103HkNTey1fLb3URYMbu3PsAyG7XuHNPSZKXKqr+PU7dvbXgU1KlxZ2K2YkP8akvjI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=qEXlxSPA; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="qEXlxSPA"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1A8401F000FF;
	Wed, 30 Sep 2026 17:18:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790788730;
	bh=65c4kE4q7K/SbWY28Tm+ZnIM7cYUz+NXgiwa5OwYlms=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=qEXlxSPAZu+hqv7ujAjkm+VoTuoAlLHFpd0KSqa4K0J/oru7W0It6/xzOXkO/kEpm
	 ZqxxwAuTPJ4TPQJPWQc2pjKjSiPcvDNyLH4cC+aw2DTQVZR3/bQDuwfVOcEx8b3yZU
	 AHfaT0X952vvGORpXfasg59TkI8T9+2nY+vlQqM4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Felix Gu <ustc.gu@gmail.com>,
	Ulf Hansson <ulfh@kernel.org>
Subject: [PATCH 6.12 228/877] mmc: sdio_uart: fix xmit_fifo leak when the port table is full
Date: Wed, 30 Sep 2026 17:18:59 +0200
Message-ID: <20260930152419.648475060@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260930152414.738996857@linuxfoundation.org>
References: <20260930152414.738996857@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Felix Gu <ustc.gu@gmail.com>

commit 53823e25793a97d07e6e98e0904bbf74cac8bc76 upstream.

sdio_uart_add_port() allocates the transmit fifo before claiming a
slot in sdio_uart_table[].  When all UART_NR slots are taken, it
returns -EBUSY with the fifo still allocated, but the probe error
path only kfree()s the port, leaking the transmit fifo.

Free the fifo in the failure path of sdio_uart_add_port() itself so
the function retains nothing on error.

Fixes: 8b197a5ce7a7 ("sdio_uart: Use kfifo instead of the messy circ stuff")
Signed-off-by: Felix Gu <ustc.gu@gmail.com>
Cc: stable@vger.kernel.org
Signed-off-by: Ulf Hansson <ulfh@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/mmc/core/sdio_uart.c |    3 +++
 1 file changed, 3 insertions(+)

--- a/drivers/mmc/core/sdio_uart.c
+++ b/drivers/mmc/core/sdio_uart.c
@@ -104,6 +104,9 @@ static int sdio_uart_add_port(struct sdi
 	}
 	spin_unlock(&sdio_uart_table_lock);
 
+	if (ret)
+		kfifo_free(&port->xmit_fifo);
+
 	return ret;
 }
 


