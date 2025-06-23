Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1FE2E221DAE;
	Mon, 23 Jun 2025 22:07:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750716449; cv=none; b=ez2tat7E9dlfDT5+H1ZQmQkTK9V5zY0Rq1OCBwMXpgrtXUGn+kMrVroQLBql/gEOqaHVU+Q/ORnk+EF2pglfNimHvzIRvFRJBS7xA51YPIJ7+vh4FVpnbKAilHKIWjC3Y3Y6AwzF/ehCvDh0rmX+Avk1R0L1dgmF0dp6y3g0qH4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750716449; c=relaxed/simple;
	bh=bxQlS+Mmr6ZcP93dG9k2UAM/8hF26b97k6MHP9F0Csc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=C2MbLpt1exscUhgkAGJmwIRkYF/c+W/IkT0oE6MKQbQLpq1MniGJwL3h92Tufytkh/uI2QxyG0rMomp4WmfHoHF+LsGm3ocLsLTVWVCrtAQnMDS6MP0y+8AIfKCvZ3ESnS0ldVstvSgUdOyOqb/4C/Uu1dDqED3BqAooovnneYc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=NAtqEvtQ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="NAtqEvtQ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9FD69C4CEEA;
	Mon, 23 Jun 2025 22:07:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1750716448;
	bh=bxQlS+Mmr6ZcP93dG9k2UAM/8hF26b97k6MHP9F0Csc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=NAtqEvtQZuCRKk+nfB5Kd/FbWNlDfCS3EvTOlZirGgeokw2IWcr/dwkIOljMwDCoe
	 /BlNwChzeUHO340Wa0fLIguy9zj4BZ2pC7tj8pIfaUZwEoFOV0TaHCighLMdmTyFqq
	 C/c3zg5ndGYN1yvZ57SV3z2oAqL3cTSWJ82gyVW8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Alexey Kodanev <aleksei.kodanev@bell-sw.com>,
	Jacob Keller <jacob.e.keller@intel.com>,
	Rengarajan S <rengarajan.s@microchip.com>,
	Paolo Abeni <pabeni@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 264/290] net: lan743x: fix potential out-of-bounds write in lan743x_ptp_io_event_clock_get()
Date: Mon, 23 Jun 2025 15:08:45 +0200
Message-ID: <20250623130634.850468899@linuxfoundation.org>
X-Mailer: git-send-email 2.50.0
In-Reply-To: <20250623130626.910356556@linuxfoundation.org>
References: <20250623130626.910356556@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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



