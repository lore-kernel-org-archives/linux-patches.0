Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795705011;
	b=qchuN6aM7m6qy/fmlYphx5kf7sFWMDEqtjMotYhwtLwUI46jvZU+5qzZmh882jGKFK9q
	 TnJd0v5xKRkizgWkPhSZkbqCqL+MG/FmbHVNMTQA0e0kgOn8GXDJHDBCSTjA8lQKmUXxF
	 5nHqxZHxpB8hlumO2YJXIE7RgkxrB5PhHyZQ0jKOYk3Q1Rn2PYoMzBbr8MT/ydeE2oePS
	 qCU0CIJPXjYnZEES3iGdbqL1oUAlOFdC2jJ33HoAwFz8cGnQTQinrTduRnTXhLjQWWhDv
	 hEf0h5ZGoNBJ/ZVUVTSljeZKo5etGc91+oDXesIfDT2BYSK2Dqz2msKQM/Q4bUWbO4Q==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795705011;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=BLqR954NNUN6iPZ2dCl+knNgLO8tDT04PHP5yOLaKGw=;
	b=spctDalJeFah+D3CBI3lS/FXBt1MjGnuNh+CsDLXDB5ZujsJx0fu6WcpwqLVidawDb7B
	 ez3QXX6QBP7ueIPDbm0PBYeCAhm9LgSgt8trtEGm85qULghGEIbV0I8YaSrdZS38QQNiJ
	 /GdXGm7+qXoLgNTalUjwu+rnWQWALRjEq7avT3MyBly0jVoH7euzhJUj6HpJZ7MUxSTAr
	 tevIYsl6blBzmhZRuJlW+7lLV/GEIHNJkG+DJMUA1VYwWjQsTr8fGhqWCwslJL8D6zKB0
	 B/3W5T56Px0TMU7UsAcndd8MEb2QMT7ib2/RoHlyuY36+s6xRTC0CfHWWa9OtP/yzsQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=RzM2Eb2+;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EFCC6606A338;
	Thu, 26 Nov 2026 14:56:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=RzM2Eb2+
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 325CE1F000C0;
	Thu, 26 Nov 2026 14:56:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795705010;
	bh=BLqR954NNUN6iPZ2dCl+knNgLO8tDT04PHP5yOLaKGw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=RzM2Eb2+XdGKobIuVD4Q2GF+WJqmWqCOO9DP1cu/ngyEU6S9g1o80D0x1wms3Wf7A
	 XRRFkVS5I+R2/o5wRtfRU8gALCsm9u6OiKez6Z3EW+JOxz+iEtHSRZWxPUj7rrc3aS
	 mDHnYtLNi/xzYQuBKWci8bfpZCQ6ZI+pksMdtvGo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Alex Austin <alex.austin@amd.com>,
	Paolo Abeni <pabeni@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 052/319] sfc: ptp: drop the stale frequency reset in efx_ptp_start()
Date: Thu, 26 Nov 2026 15:37:00 +0100
Message-ID: <20261126144007.912748991@linuxfoundation.org>
X-Mailer: git-send-email 2.56.1
In-Reply-To: <20261126144006.732901931@linuxfoundation.org>
References: <20261126144006.732901931@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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



