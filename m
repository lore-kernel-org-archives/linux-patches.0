Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793830903;
	b=PLMFZpyfZ/K+feQ/34GN3btQ6MMSWQrpgzBldpSvMuH758CfW15jfWBdmzYYItqI0ibC
	 64AUXr5hWHrEASfnPUCz0tf8/AEpPNi7Vt+tzwy9NOU1bzjJlvyYBtrxLsMGW0sEwH/i+
	 hYW0vMNUrGe3yutJM16PWlQOhVEk9AF2sS/kDZBgjpfEdH2vAlzTuAv4a69dSFYSr0gTn
	 rp4VAujiCzrlJtkCg4eKIZH39m+eA1vZ/iNhjZghEGctFJodK48r+zNXH17x6ZmWkKoS+
	 69TXaIr/TFivr0Yqzi/zp/SEBWIXh3bqBPWYpAQ9/EYbitodrtuiwzL5+qd+H1V5s9g==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793830903;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=HaBigxdhsxC/YsQYSUSSKBjbs/KuiGwhVL8je74i59E=;
	b=tSbYzg2Yc0XHfBUPgg4VQ/nn1dmniTJ0GstlPvh3SqURFw22ruz4fQbEZUsXLo9mnTif
	 S7CLN6fUjkS42aspGofvLSBN2q90pq1Wzbv+mO7VRDP6aEEOEg0HyEaBG4PHUX4id6WGz
	 9SrQ5oEQypO208iiQQxpCVtw1iuMzFX/A/PQPlU/cgLekozf2fNOoLR66LhYj595oGgkB
	 LmfxT92VjKEulh4lneWWs9XSVck/jCSCOYqXj+dZWh9PsuH0ihz640WMzAx8dHjOH0Dfr
	 2UHH+6rM2uP3UbzgzNIzm1sNA2PLArreZlQVGUld/xbSfSaHi7R7UQliOkXqvMSfoPA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=XP9o7yTt;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6186A606D817;
	Wed,  4 Nov 2026 22:21:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=XP9o7yTt
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E2BA51F00A15;
	Wed,  4 Nov 2026 22:21:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793830899;
	bh=HaBigxdhsxC/YsQYSUSSKBjbs/KuiGwhVL8je74i59E=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=XP9o7yTtAiF/oRwnT3gLWAqFy2364gLLTDo3xOhVZ4Pc16sst2HKXs5doZhz3/WTs
	 5tjp2z2rqpjU88e0WXIoet7e5TgukGbd/cJNEXty1QJBM3YDA6MGtPTrmHyDW1XRZo
	 cH8HUNWoEA3zMPY9s4bUK7kxUJcSCKAFJI0COEFI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Michail Tatas <michail.tatas@gmail.com>,
	Corey Minyard <corey@minyard.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0390/1005] ipmi: Fix leak in __ipmi_bmc_register
Date: Wed,  4 Nov 2026 16:02:03 -0500
Message-ID: <20261104211055.003934335@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261104211043.516122098@linuxfoundation.org>
References: <20261104211043.516122098@linuxfoundation.org>
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

From: Michail Tatas <michail.tatas@gmail.com>

[ Upstream commit 18e633dd9674c8bf118ea8583bb5a531edc2728a ]

In case that ida_alloc(&ipmi_bmc_ida,...) succeeds and then
platform_device_register() fails, ipmi_bmc_ida is leaked.
Fix by freeing the error path

Signed-off-by: Michail Tatas <michail.tatas@gmail.com>
Message-ID: <anUK_HOy_pCgvsBm@michalis-linux>
Signed-off-by: Corey Minyard <corey@minyard.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/char/ipmi/ipmi_msghandler.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/char/ipmi/ipmi_msghandler.c b/drivers/char/ipmi/ipmi_msghandler.c
index 0247079db185e..dc4704b067b94 100644
--- a/drivers/char/ipmi/ipmi_msghandler.c
+++ b/drivers/char/ipmi/ipmi_msghandler.c
@@ -3306,6 +3306,7 @@ static int __ipmi_bmc_register(struct ipmi_smi *intf,
 	list_del(&intf->bmc_link);
 	mutex_unlock(&bmc->dyn_mutex);
 	intf->bmc = &intf->tmp_bmc;
+	ida_free(&ipmi_bmc_ida, bmc->pdev.id);
 	put_device(&bmc->pdev.dev);
 	goto out;
 }
-- 
2.53.0



