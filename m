Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C115731F9A8;
	Thu,  2 Jul 2026 16:39:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783010385; cv=none; b=bPISD4LtBxx88zG3Enp2gncg+X7gjwIMyu3V88twv45aJ+6/5+rTdpcZPQZ6WYWLPXiiad83s9u5cv9vD/iqxuXoy/PHTjkZ2Vv4LQLicDcxTj5FYAKA9JIBygfqmfjTXv0UcGOzC0oZnaEPY7Mx6I72xfzw85XNU9lKKbgh2uo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783010385; c=relaxed/simple;
	bh=WkoDwvBEIpAH0ug+mM9bHx/+HQfuaQ+hETW2a1dC0Ec=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=BktzIcnMWS9LftGZ9LVeJBuiSVnwGwT2ZfLgnlwSmSrM+Z6Hx5Hp5c4/R9yLhWKNREjtgqPUZ/gMXZJvmanSYd1fVC6tGW/U2ztIpjiNfRyb395H8e7lNUm3f6Vu7bvDPTp0l7TD5+Nk4lErlRKSTk/y2GxL3m2kBRszUcSZRKQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=gfOnb9h8; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="gfOnb9h8"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 33F1A1F000E9;
	Thu,  2 Jul 2026 16:39:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1783010384;
	bh=nRl2SOKToStoO/BOFYLef1kZcWJC5sJhiqcCmFMjZsM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=gfOnb9h8N35rL7HKSSkdrrHridBLKnPClwSkphcyR7cQrI1fJjndbHsYST9+oMBZM
	 fhCN/mToNSAipdsOfFg/tH7TyOhdGRghjugQ0PL6lYHSsMc1oAu8qfZJU7WxJRksRA
	 izav8xvSIc3f5YR7fT1hbtgZzg4nokO3YgI4dWcs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Bartosz Golaszewski <bartosz.golaszewski@oss.qualcomm.com>,
	Viken Dadhaniya <viken.dadhaniya@oss.qualcomm.com>
Subject: [PATCH 6.12 089/204] serial: qcom_geni: Fix RX DMA stall when SE_DMA_RX_LEN_IN is zero
Date: Thu,  2 Jul 2026 18:19:06 +0200
Message-ID: <20260702155120.531552693@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260702155118.667618796@linuxfoundation.org>
References: <20260702155118.667618796@linuxfoundation.org>
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

From: Viken Dadhaniya <viken.dadhaniya@oss.qualcomm.com>

commit b93062b6d8a1b2d9bad235cac25558a909819026 upstream.

In qcom_geni_serial_handle_rx_dma(), geni_se_rx_dma_unprep() clears
port->rx_dma_addr before SE_DMA_RX_LEN_IN is read. If the register is zero,
for example when the RX stale counter fires on an idle line, the handler
returns without calling geni_se_rx_dma_prep().

The next RX DMA interrupt then hits the !port->rx_dma_addr guard and
returns immediately, so the RX DMA buffer is never rearmed and later input
is lost.

Keep the handler on the rearm path when rx_in is zero. Warn about the
unexpected zero-length DMA completion, skip received-data handling, and
always call geni_se_rx_dma_prep().

Fixes: 2aaa43c70778 ("tty: serial: qcom-geni-serial: add support for serial engine DMA")
Cc: stable@vger.kernel.org
Reviewed-by: Bartosz Golaszewski <bartosz.golaszewski@oss.qualcomm.com>
Signed-off-by: Viken Dadhaniya <viken.dadhaniya@oss.qualcomm.com>
Link: https://patch.msgid.link/20260528-serial-rx-0-byte-fix-v2-1-b4195cfe342f@oss.qualcomm.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/tty/serial/qcom_geni_serial.c |    9 +++------
 1 file changed, 3 insertions(+), 6 deletions(-)

--- a/drivers/tty/serial/qcom_geni_serial.c
+++ b/drivers/tty/serial/qcom_geni_serial.c
@@ -867,12 +867,9 @@ static void qcom_geni_serial_handle_rx_d
 	port->rx_dma_addr = 0;
 
 	rx_in = readl(uport->membase + SE_DMA_RX_LEN_IN);
-	if (!rx_in) {
-		dev_warn(uport->dev, "serial engine reports 0 RX bytes in!\n");
-		return;
-	}
-
-	if (!drop)
+	if (!rx_in)
+		dev_warn_ratelimited(uport->dev, "serial engine reports 0 RX bytes in!\n");
+	else if (!drop)
 		handle_rx_uart(uport, rx_in);
 
 	ret = geni_se_rx_dma_prep(&port->se, port->rx_buf,


