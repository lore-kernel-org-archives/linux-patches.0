Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C6009349CF2;
	Thu,  2 Jul 2026 16:52:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783011137; cv=none; b=N3WMYmcx1mYEB59dqvnxjx+ce2x3aZu3xf/m+OeuRCQ1n/g1WpYQN+7YI0WcXr+PnuAyjDdrS6o75AjAHu3vuQJ8iJQcneofMkBkykWzAxVfQjZLn9tx7JdzE2Hmhn2le6CBMeMeHKePQN3xzZfRayH++s+S2L2Xz+AHSlARdQI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783011137; c=relaxed/simple;
	bh=32XukIrfM3SQFyj2bLDFztJq27xBYfWqlrFDmUuKkPA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=MOTA+KvuXiY/aRL5fTyNxhTvQb2uaYE0ZwNSBe1fFKSF9JbmT5pqD0zGeGpQLf8jiRDzaRaDaoZU87qgFQIlY26yHtlvraktHQhQIDYTH8M3K4o4wp8In/O/GBIFOcOyP9UnV3VLF9lBvhbiysta8Xqkc1kdA5OyMPxgi5tsZd4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=dNhNbopN; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="dNhNbopN"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 054B31F000E9;
	Thu,  2 Jul 2026 16:52:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1783011136;
	bh=TBSQJBOQqteDfCdhyTnV4N0ITzF8AAS/2hROgzafjtc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=dNhNbopNes5myoyrucdXhsVwp4Nfbx3N5KD8zX6Cu5CX5wPPGm4GegZntxWSFbxdw
	 Cu4D6zj17K8nU8jAA0r5veqTS5pNXBRHRhdCNPzPXHfwQl1+uLKUJHyjnBNteU5wE0
	 lhrbZi3oBW3MmGhjNdtyOq2Nu37JCxvVsaxtUxWo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Bartosz Golaszewski <bartosz.golaszewski@oss.qualcomm.com>,
	Viken Dadhaniya <viken.dadhaniya@oss.qualcomm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 169/175] serial: qcom_geni: Fix RX DMA stall when SE_DMA_RX_LEN_IN is zero
Date: Thu,  2 Jul 2026 18:21:10 +0200
Message-ID: <20260702155119.345964034@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260702155115.766838875@linuxfoundation.org>
References: <20260702155115.766838875@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Viken Dadhaniya <viken.dadhaniya@oss.qualcomm.com>

[ Upstream commit b93062b6d8a1b2d9bad235cac25558a909819026 ]

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
Signed-off-by: Sasha Levin <sashal@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/tty/serial/qcom_geni_serial.c |    9 +++------
 1 file changed, 3 insertions(+), 6 deletions(-)

--- a/drivers/tty/serial/qcom_geni_serial.c
+++ b/drivers/tty/serial/qcom_geni_serial.c
@@ -838,12 +838,9 @@ static void qcom_geni_serial_handle_rx_d
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
 		handle_rx_uart(uport, rx_in, drop);
 
 	ret = geni_se_rx_dma_prep(&port->se, port->rx_buf,


