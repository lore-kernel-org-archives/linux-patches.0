Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795621184;
	b=IUSIkmCmi6QbwOXFVysBA8R12EG5M1nIcoxP9UX8nbkb/IJ/Syptokkvp2eXD6TX+Sxz
	 x5yy5CNWtYoY2+pOu+ZV4P1syf8XaOYrbe/mxJWOKYRhqLfFUFRuaQdnQjIWZiGheHRjf
	 tC9j9yGK+2M10iKG1Nuw1D6fWJ40qHttLH9Ka/XxHoxD4JSaq2k/N0RC3muinXmHsvYd2
	 A5TxjVxqvALG8gwFYGOK3jE1ZImpFtzJHGoqA+8aHSf9DwkPW2SBBVYBmV8/Yky6RYcRj
	 K5qaB60gs7aM4EdFN4hXrc6ULNFkh0hcYI48x1D++ctXKSGGR4WjNRQRyp7E7/024UQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795621184;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=Rpfq7bvt2pTqQwsNL2+SGNGO+uwmYpzN1SCuDS7UjoQ=;
	b=saRCS8br56/SsWsvCMGb4qLHhgPT2lhwjUUhMCznyCQqI34Gggiu9QhdvpWmBVatUW05
	 kLtuXWj+NiLkBTWWwi/GQWQFzaE2a7iphCY3lBRBLbg8E6hYDa/9FnyRWGFTRDttNbxjE
	 GU26JqIWzqoVLXtaJBLl8XFLNKtUVdxA4s1Mz9pjjD53C1T4NOsIPP9RyIlFUHIW4v8i9
	 P7b5BDKOETE/0P1jGLeuqUGDVQYZVKD0sEc95xQLwHXUZuahr1V5OY8MOYMpImzov0dUr
	 vYE24DLcE5H64s5B+Ojfof8LFFk1kKRMke2GoEZZhVDoMMhRL78EmjVtwQK6+B9Q6IQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=nJLqC9NJ;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A04D2606A329;
	Wed, 25 Nov 2026 15:39:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=nJLqC9NJ
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7F2F11F000CA;
	Wed, 25 Nov 2026 15:39:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795621184;
	bh=Rpfq7bvt2pTqQwsNL2+SGNGO+uwmYpzN1SCuDS7UjoQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=nJLqC9NJVD+s8zq6SR0RKcConmxBugC0bXkBcDHkrIHYraQ7MmZSZf7cTkQcK3mP0
	 65vjTFC+Lg8V0IzLz4WqtRFfPSK399vItEQwUqzfJJchICdWq2W/oiwDB4HV7T9onZ
	 gf98UZiNYYw6ekCouJwKcrh303Pfu/oYV+xNguAo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Alex Austin <alex.austin@amd.com>,
	Paolo Abeni <pabeni@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 147/990] sfc: ptp: drop the stale frequency reset in efx_ptp_start()
Date: Wed, 25 Nov 2026 15:25:14 +0100
Message-ID: <20261125143825.530990306@linuxfoundation.org>
X-Mailer: git-send-email 2.56.1
In-Reply-To: <20261125143822.072087159@linuxfoundation.org>
References: <20261125143822.072087159@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

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
index 4c7222bf26bec..dbd7281f44b3e 100644
--- a/drivers/net/ethernet/sfc/ptp.c
+++ b/drivers/net/ethernet/sfc/ptp.c
@@ -1446,7 +1446,6 @@ static int efx_ptp_start(struct efx_nic *efx)
 		goto fail;
 
 	ptp->evt_frag_idx = 0;
-	ptp->current_adjfreq = 0;
 
 	return 0;
 
-- 
2.53.0



