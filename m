Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 575853806D9;
	Thu, 30 Jul 2026 15:39:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785425950; cv=none; b=OmOk1DFGcg4kEHYs6Bdwd5qybHGNKeeVuFPq+Iw4WX77kIIN0wFv/y+8k0pDf15Sr3qgLKCLwHoRO2vYhrKDM4Y2GMWnS5z01I+F1l9U7tIR5HI9OYGyFgEcK/J6tzsbpR+rQi7fVtEZKdpfsQQL0CdS9JW7nbZoH0Q7vvHv3JQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785425950; c=relaxed/simple;
	bh=aLgiFyNFWxGAKVkaRo9znooKF048RxLZeT120ICislk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=CLMTiFMjGCTd6+ELvAB8n6Tnt+D82zINEGEKLj+nFAUffPSGT0L8zPBPVEbR3HUJNLOIpcGyEZRkCK/2nzWygu5O2P0DaR3ctzDGYAFVNdknbmiiCZ0dK/vYB1PMQxfObYy736ylz7c+1hTkWB2a3RqlQXv7+sLw6GLY2ovrdl0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=RIYRcNiL; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="RIYRcNiL"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B12731F000E9;
	Thu, 30 Jul 2026 15:39:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1785425949;
	bh=g7EQ0L0b0bRNY502509SR6ct1tZUCpzmSfPENR6aIHo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=RIYRcNiLQREtXSrfXVeh4LGpJiCNjQpWbXOBxQ6nb482eHYikECacsbFGxntASnc2
	 9JnyydSW4IG4j7sJCspKWqxhu1WFQDpeOwLp32H5fT1NKMd/5K1ns/b+q57Zj3hH74
	 wV1s8zkuSvyBKHnJrlbrm8nLllnVbUyc4b+AznLI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Simon Horman <horms@kernel.org>,
	Lorenzo Bianconi <lorenzo@kernel.org>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 249/602] net: airoha: fix ETS channel derivation in airoha_tc_setup_qdisc_ets()
Date: Thu, 30 Jul 2026 16:10:41 +0200
Message-ID: <20260730141441.205061820@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260730141435.976815864@linuxfoundation.org>
References: <20260730141435.976815864@linuxfoundation.org>
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

From: Lorenzo Bianconi <lorenzo@kernel.org>

[ Upstream commit 649ea07fc25a17aa51bff710baac1ab161022a7c ]

Derive the hardware QoS channel from opt->parent instead of opt->handle
in airoha_tc_setup_qdisc_ets(). The ETS qdisc handle is either
user-specified or auto-allocated by qdisc_alloc_handle() and bears no
relation to the HTB leaf classid that identifies the hardware channel.
HTB derives the channel from TC_H_MIN(opt->classid), and ETS is always
attached as a child of an HTB leaf, so its opt->parent matches that
classid. Using opt->handle instead can cause two ETS qdiscs on different
HTB leaves to collide on the same hardware channel, corrupting scheduler
configuration and stats.

Fixes: 20bf7d07c956 ("net: airoha: Add sched ETS offload support")
Reviewed-by: Simon Horman <horms@kernel.org>
Signed-off-by: Lorenzo Bianconi <lorenzo@kernel.org>
Link: https://patch.msgid.link/20260720-airoha-ets-handle-fix-v2-1-6f7129ddc06f@kernel.org
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/airoha/airoha_eth.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/airoha/airoha_eth.c b/drivers/net/ethernet/airoha/airoha_eth.c
index db4b87c17a2864..58e5791e9cd4d4 100644
--- a/drivers/net/ethernet/airoha/airoha_eth.c
+++ b/drivers/net/ethernet/airoha/airoha_eth.c
@@ -2803,8 +2803,7 @@ static int airoha_tc_setup_qdisc_ets(struct airoha_gdm_port *port,
 	if (opt->parent == TC_H_ROOT)
 		return -EINVAL;
 
-	channel = TC_H_MAJ(opt->handle) >> 16;
-	channel = channel % AIROHA_NUM_QOS_CHANNELS;
+	channel = TC_H_MIN(opt->parent) % AIROHA_NUM_QOS_CHANNELS;
 
 	switch (opt->command) {
 	case TC_ETS_REPLACE:
-- 
2.53.0



