Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2036C34CFB9;
	Tue,  6 Jan 2026 17:20:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767720008; cv=none; b=tQ7ca1DWEjAFfEmjb2z8aNA4hp4wnyWKTlBP35yR8r00vWN4zTEehJ6mzkjCxXh7kItiGw7eGZm2KPCvlZeKHQTELHkUVjJ//YrivUgUoKgF+ZEmebsoMVAXbhlwPddJrmroO329fpUNpa3pLjJoFM5YL0T7P7NiqBtzgW8L6Sc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767720008; c=relaxed/simple;
	bh=F4Z1C8g37HJwgLeKIwjwKOG1cfmi2DYmFxSUUSlMIGw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=F8xpVOaRL5AMserjqau0Pesht48rdK/TIAEgAHLBfuBBrWwTDk9+oFH0J8Mm+L7Hk6gr3p5ysUj9hHuTwhqi9NEl/So0ticaHDJ+Wd8Psl0NNmTp562h+hztgAPyeVGpPKiISsks8evN1eDqCwKH2gfyWDo3xLdUi9ZutNNPj9c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=wrt9yRoG; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="wrt9yRoG"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9FDDDC19423;
	Tue,  6 Jan 2026 17:20:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1767720008;
	bh=F4Z1C8g37HJwgLeKIwjwKOG1cfmi2DYmFxSUUSlMIGw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=wrt9yRoG4ozXC6bfYMp3KF+TdG3fQBxOJ5XO6w+Egu4a+E3ZbWXRpIedsX01bhCmi
	 d/cCWSvBhl2OgVPbXkwaC+mJbQOk5rqDY0U8l3ICvNlDyHX0PJoGB6Y3gE8QbgEGcj
	 BCczopyvG15ODYloxpzGuHuDt9AP98HUERlKMIyI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Wei Fang <wei.fang@nxp.com>,
	Frank Li <Frank.Li@nxp.com>,
	Hariprasad Kelam <hkelam@marvell.com>,
	Vladimir Oltean <vladimir.oltean@nxp.com>,
	Paolo Abeni <pabeni@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 074/567] net: enetc: do not transmit redirected XDP frames when the link is down
Date: Tue,  6 Jan 2026 17:57:36 +0100
Message-ID: <20260106170454.071502549@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260106170451.332875001@linuxfoundation.org>
References: <20260106170451.332875001@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Wei Fang <wei.fang@nxp.com>

[ Upstream commit 2939203ffee818f1e5ebd60bbb85a174d63aab9c ]

In the current implementation, the enetc_xdp_xmit() always transmits
redirected XDP frames even if the link is down, but the frames cannot
be transmitted from TX BD rings when the link is down, so the frames
are still kept in the TX BD rings. If the XDP program is uninstalled,
users will see the following warning logs.

fsl_enetc 0000:00:00.0 eno0: timeout for tx ring #6 clear

More worse, the TX BD ring cannot work properly anymore, because the
HW PIR and CIR are not equal after the re-initialization of the TX
BD ring. At this point, the BDs between CIR and PIR are invalid,
which will cause a hardware malfunction.

Another reason is that there is internal context in the ring prefetch
logic that will retain the state from the first incarnation of the ring
and continue prefetching from the stale location when we re-initialize
the ring. The internal context is only reset by an FLR. That is to say,
for LS1028A ENETC, software cannot set the HW CIR and PIR when
initializing the TX BD ring.

It does not make sense to transmit redirected XDP frames when the link is
down. Add a link status check to prevent transmission in this condition.
This fixes part of the issue, but more complex cases remain. For example,
the TX BD ring may still contain unsent frames when the link goes down.
Those situations require additional patches, which will build on this
one.

Fixes: 9d2b68cc108d ("net: enetc: add support for XDP_REDIRECT")
Signed-off-by: Wei Fang <wei.fang@nxp.com>
Reviewed-by: Frank Li <Frank.Li@nxp.com>
Reviewed-by: Hariprasad Kelam <hkelam@marvell.com>
Reviewed-by: Vladimir Oltean <vladimir.oltean@nxp.com>
Link: https://patch.msgid.link/20251211020919.121113-1-wei.fang@nxp.com
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/freescale/enetc/enetc.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/freescale/enetc/enetc.c b/drivers/net/ethernet/freescale/enetc/enetc.c
index 749b65aab14a9..c58e44144c2fa 100644
--- a/drivers/net/ethernet/freescale/enetc/enetc.c
+++ b/drivers/net/ethernet/freescale/enetc/enetc.c
@@ -1429,7 +1429,8 @@ int enetc_xdp_xmit(struct net_device *ndev, int num_frames,
 	int xdp_tx_bd_cnt, i, k;
 	int xdp_tx_frm_cnt = 0;
 
-	if (unlikely(test_bit(ENETC_TX_DOWN, &priv->flags)))
+	if (unlikely(test_bit(ENETC_TX_DOWN, &priv->flags) ||
+		     !netif_carrier_ok(ndev)))
 		return -ENETDOWN;
 
 	enetc_lock_mdio();
-- 
2.51.0



