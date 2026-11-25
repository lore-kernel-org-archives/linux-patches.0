Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795624258;
	b=CBDO2Hngj4/WVPTcNtHKg+oBXutb/bj9Evygz2u1hXnQfS7foi/SGl+utglPkdGf0kn2
	 4XqZcPyuE1a9JgW9RT+nWMJLhhP1CaL+c2TYNuLWQ7aK1d0BnnglUYKr0+OKEyxQlJ9E2
	 GtaqnVvkaC06maezEgvXVuVRONilwcTwQstJ7BVFfPwEn/pquuEDesDA+6xo5qaKbGovd
	 Cf7kNfa1Pyfbum8BI0cfJl9PpZFkk3K1lxZfv8IUYXX7KZ4Eo9MG6attLXEui/AS29WDV
	 UYKD1mwNczvwA+GPiDfocgBXzkRIyH8CZACQy5XiuFvMPxih9+eF61wVlqJ2f12YBXw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795624258;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=6mkhUBkBC3fVNuOzxOQOplMEpavmk0CJBZ3FFHiqlQg=;
	b=xq6921ijSZ33OJwOx8t/ZgxMKcjuTnlJrdbeO+8CJ5qKZvoRPY1Yw4MSPs//L1skwy3J
	 j/trbpoXxmB1hTnul6yO869OPi0HurFqUVZvQTdZ3qKUnE66LY3WYEkttpzv42KS4EySi
	 ZVjwuJwExqRWuQ/was20pOaCUDj2B1KmZm/JenCZDZaV96BykynheFzsG8A0ObKBQ1z22
	 SJrVrsL/MHmXw/Tyze7zE9/nnAgSMbmpKMJkjrP8Rde8+BDaL8riuJPSHzVtbAdzOJNbR
	 G5c2vULs1M8HTbqLjRe5C84yvYc/wWwNsoaI2pi6Z64CYYtMXbN/xNMuQdsbaiYRupw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=CAjyWJgp;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F2F54606A68E;
	Wed, 25 Nov 2026 16:30:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=CAjyWJgp
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 104F81F000D0;
	Wed, 25 Nov 2026 16:30:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795624257;
	bh=6mkhUBkBC3fVNuOzxOQOplMEpavmk0CJBZ3FFHiqlQg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=CAjyWJgp+vd7XOH7p35lmpUsBudUQghP29uSaNKgbjoZBCv6+7roFQ7Nmj3/3iu9h
	 Eb14N3nkAQhpdYXByW07XT4N2j6vVY3M2GtqJjOQzIYggNkaMraOgZ/TjzE3EGeW52
	 uTl9BZF8+FTINIcvt2Mq+WCyhAFm49PR/ZIgtvLY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Alex Austin <alex.austin@amd.com>,
	Paolo Abeni <pabeni@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 128/816] sfc: ptp: drop the stale frequency reset in efx_ptp_start()
Date: Wed, 25 Nov 2026 15:27:56 +0100
Message-ID: <20261125143852.167707512@linuxfoundation.org>
X-Mailer: git-send-email 2.56.1
In-Reply-To: <20261125143849.205329330@linuxfoundation.org>
References: <20261125143849.205329330@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
index aaacdcfa54ae1..5bbd3f1a07647 100644
--- a/drivers/net/ethernet/sfc/ptp.c
+++ b/drivers/net/ethernet/sfc/ptp.c
@@ -1446,7 +1446,6 @@ static int efx_ptp_start(struct efx_nic *efx)
 		goto fail;
 
 	ptp->evt_frag_idx = 0;
-	ptp->current_adjfreq = 0;
 
 	return 0;
 
-- 
2.53.0



