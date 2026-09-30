Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1673A3E9C18;
	Wed, 30 Sep 2026 16:22:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790785375; cv=none; b=csg90/gRNBNE29xOKIAVIETd7P2MHerpCk4rJ+OoDNrrRxdR92Ei5lj4jfaLOvSdX4s6e/SYhpXt3GxViYhyd+z4vTsaZ/GL40NQplYW8WQvUlIrMmmdgeQukFwHUwSFNgJe5DcGqbCBXFLSPMh9ve2Mwe2W+g5z+YUTusFHj3E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790785375; c=relaxed/simple;
	bh=Q3+NYC/sxombaAWPhPvKiq9A4vN/LSXjuytoXgxJV3w=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=P62454TmI2n/krgwWbPQXCQfiuJ1bRR9M/HXcWYALG3flBhyXhMtJARo0dtRH+HKCo5FVx1x31r9O0ElqaLx8YXroxn3UWPs94+seYIGO0dlZZIUmNC+fUGoerY52PF34j3/0ziu7H4Ie41eqNj9gWVoJoc7tgH+zfbvO07X2AQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=WvTCfHxi; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="WvTCfHxi"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CCF551F000FF;
	Wed, 30 Sep 2026 16:22:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790785370;
	bh=Ypi/MJnE2LMjSPV+nAEGqr6hYfoJmm+9i6OmmmV6Nto=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=WvTCfHxiyBmQJ35bCBuQsF+y0GM8bFkVG2ip8WtA5/rtz2nqfsax9Ldm8+ccpaxKx
	 EeuInaVrdlz72WCij6xHNHiijhcBOxi1UC1tSTnb1gMYOIDmUKOoAtR3VwoH0+94hU
	 ozAuHR/mWkkj/T8OAZ215yX/VEQNxg3mNRx2O/kE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Joe Damato <joe@dama.to>,
	Linus Walleij <linusw@kernel.org>,
	Paolo Abeni <pabeni@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 448/982] net: ethernet: cortina: Finish RX updates before NAPI completion
Date: Wed, 30 Sep 2026 17:19:44 +0200
Message-ID: <20260930152426.417632515@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260930152416.775402466@linuxfoundation.org>
References: <20260930152416.775402466@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Linus Walleij <linusw@kernel.org>

[ Upstream commit baa26841cb9a2cdc7e0e99d6854a4e3359bf7393 ]

napi_complete_done() releases ownership of the NAPI instance, but the
Gemini poll keeps the RX statistics writer section open and updates the
free queue after calling it. A new poll can therefore start while the old
writer is still active.

Finish the statistics and free queue updates before releasing ownership.
Only re-enable RX interrupts when napi_complete_done() reports successful
completion.

Fixes: 4d5ae32f5e1e ("net: ethernet: Add a driver for Gemini gigabit ethernet")
Suggested-by: Joe Damato <joe@dama.to>
Assisted-by: LLM
Signed-off-by: Linus Walleij <linusw@kernel.org>
Link: https://patch.msgid.link/20260903-gemini-ethernet-fixes-v2-2-2bbbd598ca6e@kernel.org
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/cortina/gemini.c | 12 ++++++------
 1 file changed, 6 insertions(+), 6 deletions(-)

diff --git a/drivers/net/ethernet/cortina/gemini.c b/drivers/net/ethernet/cortina/gemini.c
index b8e4045d9821c..1092f558bc34f 100644
--- a/drivers/net/ethernet/cortina/gemini.c
+++ b/drivers/net/ethernet/cortina/gemini.c
@@ -1586,12 +1586,10 @@ static int gmac_napi_poll(struct napi_struct *napi, int budget)
 	u64_stats_update_begin(&port->rx_stats_syncp);
 
 	received = gmac_rx(napi->dev, budget);
-	if (received < budget) {
-		napi_gro_flush(napi, false);
-		napi_complete_done(napi, received);
-		gmac_enable_rx_irq(napi->dev, 1);
+	if (received < budget)
 		++port->rx_napi_exits;
-	}
+
+	u64_stats_update_end(&port->rx_stats_syncp);
 
 	port->freeq_refill += received;
 	if (port->freeq_refill > freeq_threshold) {
@@ -1599,7 +1597,9 @@ static int gmac_napi_poll(struct napi_struct *napi, int budget)
 		geth_fill_freeq(geth, true);
 	}
 
-	u64_stats_update_end(&port->rx_stats_syncp);
+	if (received < budget && napi_complete_done(napi, received))
+		gmac_enable_rx_irq(napi->dev, 1);
+
 	return received;
 }
 
-- 
2.53.0



