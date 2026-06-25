Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4722B2D5412;
	Thu, 25 Jun 2026 13:08:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782392921; cv=none; b=Tk5LwcXYFua6RdybCTHoviE1/AfCAny0My9FoAikfE9FDboAlSSJBp3Pr8UTivcfr3d6xsgKzb8mOuspxt4uOsqI1vVB2u0G8Xi3xdU1eYrwEEgZeo+wqI48CiZs97n4bnA+DosxVm2ozMv1p/GBMec57T0XpjeSn2ol0hfVarc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782392921; c=relaxed/simple;
	bh=qkkdZO9y4eI9YWUbq0eIexhWNlQgx6suOjZwY3Z73VM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=f/xQpQRQxJy4Ojg2iyRzuzQnvvr7N6h2eSeC42oTkRKsY6ayV+IWkil4KOx35F/eKIjmfsfZmkQvdpcEUj+0ZcJr3YXc0dHD/c0Lx2OtO0MQ3seJnn0CgJvMXRdr5BumQguCxstizvZqyo9P5j2o/AxaEzI6VJpLhWrkfARFoK8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=wvl+woJZ; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="wvl+woJZ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 71F591F000E9;
	Thu, 25 Jun 2026 13:08:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1782392919;
	bh=6z+AJt0/KBOWHLWnl1TLFkbEoB5OYQy606dx0tCJwoQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=wvl+woJZlbZl8VFcRppmgknvMyGIqxUtiIGiaLAcLBiSp5TrlSRp0/RwMyEKGXp0N
	 aqc/iWNlDBea2T7QzcBGWA11Jlops46g2Z21gSkPM4DgedsC91ZLYqDZtoE9SCYX+v
	 bLYsX1wBs1J5AqNAbzwPBFY6GMJwErw5oSoakHZo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Bartosz Golaszewski <bartosz.golaszewski@oss.qualcomm.com>,
	Viken Dadhaniya <viken.dadhaniya@oss.qualcomm.com>
Subject: [PATCH 6.18 55/60] serial: qcom_geni: Fix RX DMA stall when SE_DMA_RX_LEN_IN is zero
Date: Thu, 25 Jun 2026 14:03:40 +0100
Message-ID: <20260625125653.771532369@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260625125645.554579168@linuxfoundation.org>
References: <20260625125645.554579168@linuxfoundation.org>
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
@@ -896,12 +896,9 @@ static void qcom_geni_serial_handle_rx_d
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


