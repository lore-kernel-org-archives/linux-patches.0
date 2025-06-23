Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AB647221543;
	Mon, 23 Jun 2025 22:23:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750717433; cv=none; b=OUJyfK+odJFbw0ulPbx5/IJKP91kPDWO086p0haojvrqvPILwYU6zISmH9uJp371QIeZ6M4hvS3fP7X1Vj5GGk+48kJUBne0E94cMKgD0NbDF+tNYxZ3FZ2tmX+wzxvpYSbC5G++xedIhLK8pGPNz+NbZ5EctFPwJW614idMk+8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750717433; c=relaxed/simple;
	bh=L93Opi6YnP9t+TJNZym9UZUui/9d4qc566iJUy0Nc6M=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=AOHi5xshUSZptlzLcKn/6Zed0shB6lgnjHepBj/MjDz64sRvsauFlf83XUt1OIXqqY5ywgpbKKi1b95slEoFaUgK4l/Wu+BHAJSkvge7n0TawtIp1t/vXrMezMhVP8F61bDwUAvz2EN4T9NBET5sAtxkD/2q5FS9dk9b1rfc/gI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=XYOj2hXA; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="XYOj2hXA"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 45CBCC4CEEA;
	Mon, 23 Jun 2025 22:23:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1750717433;
	bh=L93Opi6YnP9t+TJNZym9UZUui/9d4qc566iJUy0Nc6M=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=XYOj2hXAiZrLuoQiAJWe2Z9A1tiRAbC7Er1aAPvYebpgk2Vfc5WcfKSRLnqwejW33
	 miioo0zsxlvQayy90GrJ0/loXGXfDQUISvbchudGxjIzKakJ8ALBdnj0osCSyA/zcF
	 7SMQ8aTEw8daHqjLgvTlMswkft+In+5p79deO2bo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Alexey Kodanev <aleksei.kodanev@bell-sw.com>,
	Jacob Keller <jacob.e.keller@intel.com>,
	Rengarajan S <rengarajan.s@microchip.com>,
	Paolo Abeni <pabeni@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 386/414] net: lan743x: fix potential out-of-bounds write in lan743x_ptp_io_event_clock_get()
Date: Mon, 23 Jun 2025 15:08:43 +0200
Message-ID: <20250623130651.598804782@linuxfoundation.org>
X-Mailer: git-send-email 2.50.0
In-Reply-To: <20250623130642.015559452@linuxfoundation.org>
References: <20250623130642.015559452@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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



