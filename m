Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795704210;
	b=B9Pjri98+fQ6OFXmmllrlCLnR3fyPqOn7AgA5iea1PjQw5P/Zl+1R4i8u/G4TuZlfhYh
	 wSpcKQtGAveOzO8wN6bXvh24KC9X1VRmJFP96/JHLXiCmxHbjkSvLltM8irL7nGh3LtJ/
	 WdQScvSQhN6aZVCpQJegJNpj5Ba4CjHg5vlWblZwxcZRH3UEELNTvnxlBUkQhuxmo/SUT
	 1xGTU3BBq4cn28YI/XLoIeRS0j2+j1OI7whZOB2P4mIxoCmoNKsssiURkIhYkBoQJlKAT
	 mZpCiX8MA9F9Fqs1wvAhGOCvN4Rb3hZC3PNmpyNetN/imczPH/yLbbkWfN9VLMI27mQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795704210;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=/tVlBPgyHWXHQ4LPafuBuZwi4fuYJ30nJahhGbHoiok=;
	b=Ox1K4C1X/VVvYpNTZYC6q1Phq3iC9OlltPv72NImoua6T3Cs5snCjP4e5NHvSS2MYj5s
	 S64KwwKiDrxEo1qX1kIjzSD90ke/0VGnDSKOKTR4SpuqLA8+VeDp89gCGKR6EB9Qk3aUA
	 ORKN3W8dl5lMnXQCqrVIlPMaCOxG6ZS+N0V7/6lXkAm8C7PD9QzkjQhxvGLgW1DnX+3cI
	 QtYWGpduCQ4osQMxI90h5J1Fdat/aE3lY+JjuLwuDmEoGZutRFGMPXSNV0VhpxbTkEBAf
	 1znlz97AUmcfzHpmBdVDf2zi/NQHXnm2fmcCSdMSOEFnG8LwAkhyiI2TmDq4IWyiMig==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=RvLtPpoY;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DEAC3606A31C;
	Thu, 26 Nov 2026 14:43:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=RvLtPpoY
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BF3231F000C0;
	Thu, 26 Nov 2026 14:43:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795704210;
	bh=/tVlBPgyHWXHQ4LPafuBuZwi4fuYJ30nJahhGbHoiok=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=RvLtPpoYsrD2777rUUzKdpiannqcdqyLdDQtBS8YFVTAPayxumnorpK4TgxM5Sxpf
	 C0xSs9JU6gwbwVlSrY5V+665KlygP28FXwtJQAWLM2kUlrLQ4vRC/eIAx5sdQHWbXF
	 cMaQNnaTHX57YJ/kN2nd9Q47ZyM21bNDE86La7PU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Alex Austin <alex.austin@amd.com>,
	Paolo Abeni <pabeni@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 042/265] sfc: ptp: drop the stale frequency reset in efx_ptp_start()
Date: Thu, 26 Nov 2026 15:36:12 +0100
Message-ID: <20261126143608.053310765@linuxfoundation.org>
X-Mailer: git-send-email 2.56.1
In-Reply-To: <20261126143605.076581697@linuxfoundation.org>
References: <20261126143605.076581697@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Alex Austin <alex.austin@amd.com>

[ Upstream commit 21d4917cfc8b6837c44d8aa186941a6a16ec17a0 ]

FW does not touch the clock frequency state on MC_CMD_PTP_OP_DISABLE or
MC_CMD_PTP_OP_ENABLE, so the driver doesn't need to either. Doing so
just desyncs the driver's cached current_adjfreq from what FW still has
programmed.

Resetting current_adjfreq to 0 here means the first efx_phc_adjtime()
call after efx_ptp_start() reprograms the NIC's clock frequency to 0,
since efx_phc_adjtime() always sends current_adjfreq to FW alongside
the time step. efx_ptp_start() runs on every SIOCSHWTSTAMP mode change,
on ifup, and on the reset_required path in efx_ptp_worker(), so each of
those silently drops any frequency correction the PTP servo had already
applied.

efx_ptp_start() is also reached from reset recovery, but that is fine:
on an FLR or PCIe reset FW does not touch the NIC clock, and on a full
MC reboot the clock is reset to 1970, so a stale current_adjfreq from
before the reset is hardly consequential - especially as it is bound to
MAX_PPB, 1000000 ppb.

Fixes: 7c236c43b838 ("sfc: Add support for IEEE-1588 PTP")
Signed-off-by: Alex Austin <alex.austin@amd.com>
Link: https://patch.msgid.link/20261026123023.3566549-2-alex.austin@amd.com
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/sfc/ptp.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/drivers/net/ethernet/sfc/ptp.c b/drivers/net/ethernet/sfc/ptp.c
index a2b4e3befa591..4505e0ca018c3 100644
--- a/drivers/net/ethernet/sfc/ptp.c
+++ b/drivers/net/ethernet/sfc/ptp.c
@@ -1364,7 +1364,6 @@ static int efx_ptp_start(struct efx_nic *efx)
 		goto fail;
 
 	ptp->evt_frag_idx = 0;
-	ptp->current_adjfreq = 0;
 
 	return 0;
 
-- 
2.53.0



