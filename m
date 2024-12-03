Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EE20B1E3DCF;
	Tue,  3 Dec 2024 16:14:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733242476; cv=none; b=rFZlmPA6JRflx/+0wa466biU1tNJnHTbW9UoktX5aWfcDE6IlMRez9tHnDpugEM/Ojzx5NljVdLF6K3PQWhQfzfJZLALUar+gGFlzv+ITBG0wxp70Gt3oxbpNbcof6i7ALKtPlohaypXE9ZRbk0A9cB4xioI0Q313fwewtb86v4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733242476; c=relaxed/simple;
	bh=B+H6IHQ12EU9QjHr1ZWfVT5C563SY02Plp1AYLCY3/M=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=G7xN+ZtOKRh7lyY7EwAXDZFNl4vR8ADkqRgUjtmdqegdJF45lnD9ZRuSBmBB6jetTzh+BvXiAKmzE3x4F8miu/n82YfL+DKoqcME/MmACFXvruMFX2t/CcgRzXgh3P26idmuaMInJrKTtU5VjfBBWGO1qyXhqoZv/qTyPUt4dC4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=t5IuEy5x; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="t5IuEy5x"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 72C0AC4CED6;
	Tue,  3 Dec 2024 16:14:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1733242475;
	bh=B+H6IHQ12EU9QjHr1ZWfVT5C563SY02Plp1AYLCY3/M=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=t5IuEy5x5DAU6w9mDpLQz9rUxks38uws3f5vKKXwANgEvprqoZyZOW/5L7RX+YmI3
	 eMqgO811JgKxVXsOxI0xikzLzm67Xol6YaHAZxyOb11iqY++e8eWXfcDPDCM698ZRJ
	 tg0D3I4cyCe57cQbwTLZcTB0IxAGLBJKO/+zQmzY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Kartik Rajput <kkartik@nvidia.com>,
	Linus Walleij <linus.walleij@linaro.org>
Subject: [PATCH 6.12 714/826] serial: amba-pl011: Fix RX stall when DMA is used
Date: Tue,  3 Dec 2024 15:47:21 +0100
Message-ID: <20241203144811.614048299@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241203144743.428732212@linuxfoundation.org>
References: <20241203144743.428732212@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
 


