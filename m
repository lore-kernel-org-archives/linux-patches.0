Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CA6744E324C;
	Wed, 30 Sep 2026 16:35:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790786128; cv=none; b=HONXpoA1Vv7s18UYJEeKnW5bqV9jAFp8pqfYRBnAPJ5Kr6UxCxiTcLQQme6oiFeV+gOAIfDX15obD7+19sI4KOBH4Ss33bAwY0CUKS0l1DQKAWrjQPVemwKIjQVBE2CxtJZFmpK8CtzYpE0p0er2OIDNq7a3LZIg5qSC2ARUIr0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790786128; c=relaxed/simple;
	bh=29v1yPbS2BUFU9fqZwvZtd1sXvxoS33EoCq1RBif85k=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=TQGt2ZdRKSnJjQDyftMOUFOskS8mT7nV9GIUKBxvq3t+mB7Pp1eNrut4Zd9fTQXYYuOBmAHthJ7meMz/pLe76PzT04Nkv2XJAX9j1UxUrO06WblXT9N5FxD8rHXKNq4TVuPFSLdkq+7LSFNlLWDrWMw1kxN82jD3JvSUacdF520=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=qd9GVSCV; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="qd9GVSCV"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3119E1F000FF;
	Wed, 30 Sep 2026 16:35:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790786126;
	bh=Fr4gPZBpro4zsHIjdWdOnRKf5TYijLtk7b6O4sbGE0U=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=qd9GVSCVD8+PHKMxXUM3o8XTiBuGGeH7zusx+EBoMKnsby2Aot06jpOUQV+s2Lm4u
	 HZ2S9NfeANj0qRM9nQcVA98676A1wTTFKnDdx9LzF97HTyCPbscnhrfqOdflObgPSN
	 kf/yNrjJxpyLOtETqQHr9/DkLB9Vx3asp4lHFP9k=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Felix Gu <ustc.gu@gmail.com>,
	Ulf Hansson <ulfh@kernel.org>
Subject: [PATCH 6.1 735/982] mmc: sdio_uart: fix xmit_fifo leak when the port table is full
Date: Wed, 30 Sep 2026 17:24:31 +0200
Message-ID: <20260930152432.542113094@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260930152416.775402466@linuxfoundation.org>
References: <20260930152416.775402466@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
 


