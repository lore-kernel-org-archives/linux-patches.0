Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6E35026FD9B;
	Mon, 29 Dec 2025 16:20:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767025214; cv=none; b=iAS53Gvb2Ke5jP8/Qm1FMGipuRDsDnYIJQ5HLsosOj2vJodCyzczGdPHOAblu/kYy2OL7Puw2+gkJtqw6mGuZi7UfnvW5X3GWd9VF1TTH/ttQFfcXbCXPFLvCBcCV/bhxcZRMA4/HhfW6fSc3CGM/iw7XiClJqJKcIMDxwVNqx4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767025214; c=relaxed/simple;
	bh=mvnHmTmViMtKnhKLwe3Y7tvSr720N5SJgEDWBmt4GXk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=n+1PCZij1+53Ya4HFsi9VXi/RnTJWlDdTKsQKZ3e3Syd7hELeQjcv7GU1HKcfN6/eO84Cs1hI5kciGajmw2cByDLz2VpDEsUPyor+D9VpL8cgg7ea7bWt1wN5jv+p+kSfJgBQKO8IhBsUCoPVouAJ2K9wCKIE9wcnVa1Trpavbw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=bdYHh3bq; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="bdYHh3bq"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 99DD9C4CEF7;
	Mon, 29 Dec 2025 16:20:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1767025214;
	bh=mvnHmTmViMtKnhKLwe3Y7tvSr720N5SJgEDWBmt4GXk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=bdYHh3bqu/2h3rGC8mjfK1N78W99uOWH5ZX5CUvLRSR77+g7kZpLONwog4uVwCFLR
	 lSKdl3QMTjP8cFVRodNKBPDjUG6ks0kNV163WDBNWRzIT3gKAv3cohPk3KKbOd+dyi
	 DzWLmp6bJqdxWUlu5VltCw/I77EV5rABDYqT11dY=
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
Subject: [PATCH 6.18 101/430] net: enetc: do not transmit redirected XDP frames when the link is down
Date: Mon, 29 Dec 2025 17:08:23 +0100
Message-ID: <20251229160728.084929283@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251229160724.139406961@linuxfoundation.org>
References: <20251229160724.139406961@linuxfoundation.org>
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
index 0535e92404e3c..f410c245ea918 100644
--- a/drivers/net/ethernet/freescale/enetc/enetc.c
+++ b/drivers/net/ethernet/freescale/enetc/enetc.c
@@ -1778,7 +1778,8 @@ int enetc_xdp_xmit(struct net_device *ndev, int num_frames,
 	int xdp_tx_bd_cnt, i, k;
 	int xdp_tx_frm_cnt = 0;
 
-	if (unlikely(test_bit(ENETC_TX_DOWN, &priv->flags)))
+	if (unlikely(test_bit(ENETC_TX_DOWN, &priv->flags) ||
+		     !netif_carrier_ok(ndev)))
 		return -ENETDOWN;
 
 	enetc_lock_mdio();
-- 
2.51.0



