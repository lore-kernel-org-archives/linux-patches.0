Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D71C7225417;
	Mon, 23 Jun 2025 22:11:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750716683; cv=none; b=qZi2Q61ru6cxqS+FcpyVPWvuPP1s7704GbSFNsPfQ27BdyY4sqT5sA80tfx18CiEzB4NxNplrB4FzvLaAxQeG9Ov3NPd5E2eF/vKpSNPjWiOn768mbr/bAJxX//2UQXk4HiHXk5u3OHkDmebs8Lfv0C+pITGFu8fwh5HoPrTSLA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750716683; c=relaxed/simple;
	bh=Ep6RQpVeg8C26Fvv/3TCbG4OURvcxiEFjCjBRLbi6Ok=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=lh1E2fTf3KZsjimQXWLw/HzmO3xVI7mPOsnvs9PqIfYiH/+CrQW5z2TZ4WmnEfdn3kQ66ZvvOB8q/9ydbRQ8FHQL1azTIUQdsgruiuyNnqx/o1M6RLc8XaqRiFP16zemtahUhyxpxkkiKPyXsr89bHvib77r0OKrEoB6yY6V7IA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Q7nmP0sG; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Q7nmP0sG"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7071DC4CEEA;
	Mon, 23 Jun 2025 22:11:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1750716683;
	bh=Ep6RQpVeg8C26Fvv/3TCbG4OURvcxiEFjCjBRLbi6Ok=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Q7nmP0sGljqb+8sWtjGGYAUMi6uk9f5eKCs+x8HSm0oIv8633V6A3rPxUTDFWi9o+
	 hvUPSestuNrNWFMe60Kbb1/q0WjY0Z5QGCyZRs75CdlkJEahPbyF5pnfgJeIyjKMrr
	 Zk7fi4bgz/cc4d+zN3Js9j4FxDdSF85cCIExIccM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Alexey Kodanev <aleksei.kodanev@bell-sw.com>,
	Jacob Keller <jacob.e.keller@intel.com>,
	Rengarajan S <rengarajan.s@microchip.com>,
	Paolo Abeni <pabeni@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.15 547/592] net: lan743x: fix potential out-of-bounds write in lan743x_ptp_io_event_clock_get()
Date: Mon, 23 Jun 2025 15:08:25 +0200
Message-ID: <20250623130713.452918674@linuxfoundation.org>
X-Mailer: git-send-email 2.50.0
In-Reply-To: <20250623130700.210182694@linuxfoundation.org>
References: <20250623130700.210182694@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Alexey Kodanev <aleksei.kodanev@bell-sw.com>

[ Upstream commit e353b0854d3a1a31cb061df8d022fbfea53a0f24 ]

Before calling lan743x_ptp_io_event_clock_get(), the 'channel' value
is checked against the maximum value of PCI11X1X_PTP_IO_MAX_CHANNELS(8).
This seems correct and aligns with the PTP interrupt status register
(PTP_INT_STS) specifications.

However, lan743x_ptp_io_event_clock_get() writes to ptp->extts[] with
only LAN743X_PTP_N_EXTTS(4) elements, using channel as an index:

    lan743x_ptp_io_event_clock_get(..., u8 channel,...)
    {
        ...
        /* Update Local timestamp */
        extts = &ptp->extts[channel];
        extts->ts.tv_sec = sec;
        ...
    }

To avoid an out-of-bounds write and utilize all the supported GPIO
inputs, set LAN743X_PTP_N_EXTTS to 8.

Detected using the static analysis tool - Svace.
Fixes: 60942c397af6 ("net: lan743x: Add support for PTP-IO Event Input External Timestamp (extts)")
Signed-off-by: Alexey Kodanev <aleksei.kodanev@bell-sw.com>
Reviewed-by: Jacob Keller <jacob.e.keller@intel.com>
Acked-by: Rengarajan S <rengarajan.s@microchip.com>
Link: https://patch.msgid.link/20250616113743.36284-1-aleksei.kodanev@bell-sw.com
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/microchip/lan743x_ptp.h | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/microchip/lan743x_ptp.h b/drivers/net/ethernet/microchip/lan743x_ptp.h
index 0d29914cd4606..225e8232474d7 100644
--- a/drivers/net/ethernet/microchip/lan743x_ptp.h
+++ b/drivers/net/ethernet/microchip/lan743x_ptp.h
@@ -18,9 +18,9 @@
  */
 #define LAN743X_PTP_N_EVENT_CHAN	2
 #define LAN743X_PTP_N_PEROUT		LAN743X_PTP_N_EVENT_CHAN
-#define LAN743X_PTP_N_EXTTS		4
-#define LAN743X_PTP_N_PPS		0
 #define PCI11X1X_PTP_IO_MAX_CHANNELS	8
+#define LAN743X_PTP_N_EXTTS		PCI11X1X_PTP_IO_MAX_CHANNELS
+#define LAN743X_PTP_N_PPS		0
 #define PTP_CMD_CTL_TIMEOUT_CNT		50
 
 struct lan743x_adapter;
-- 
2.39.5



