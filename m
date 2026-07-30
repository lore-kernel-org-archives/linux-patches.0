Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 13B10443E25;
	Thu, 30 Jul 2026 14:36:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785422176; cv=none; b=cD4ZsW9OkBhoEV1fc/HrMfYmMwPD51quDMMg/4vSRg8PSEjUjuGTZ7DANVpheJpciUOQEI+F7rATmOeujv6u0Lj0Jia3gbLU2oE53WqiTuvJ93/UTIg8//67F1jEpHb/yvVdok9ojWvEYps2m4x87D4Ut0wrbyVYsah4jOmPE3c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785422176; c=relaxed/simple;
	bh=EBBQZwR7AW1WMpE5e62yGke2+kD9Ast67KWG5c6MB7g=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=hUjxooh6/oh3T+hYbJ84Tp+pCPNv6T5Hy1o1WAgrB7JDqedYgWwPbcaYJ7apK35rU5tk1L7GyNSGSHBKTm0qVCxW6WriEhADb3eXE9bYjdxt1afipRnI5RuFAAx4DIGOzGbLXn2RrfZlaR9wLGNx5chWxUsFCWOX4zxY6Txa+SY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Gk/pB0qi; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Gk/pB0qi"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6DAA01F000E9;
	Thu, 30 Jul 2026 14:36:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1785422175;
	bh=V9PiXNK6Kh5x6Tc7JdPvLwUQWJcS9e5jRozsFey4seI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Gk/pB0qiQxZLr/tkna6QI7HXw8Jy/pHNDOxGvM3WtYLvtKcQhsCatDidUeTsnyW/Z
	 4rFdmJXq2C4Yo+FLiIY/+GIIO2pI4/wr7gY9Unn1F6xHuk99KwY076u/HEBRbs0AQ/
	 GZh8l4vONv8m6B29843ppWjeaiCQzZwAoOf13ZIM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Simon Horman <horms@kernel.org>,
	Lorenzo Bianconi <lorenzo@kernel.org>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.1 349/744] net: airoha: fix ETS channel derivation in airoha_tc_setup_qdisc_ets()
Date: Thu, 30 Jul 2026 16:10:22 +0200
Message-ID: <20260730141451.706317936@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260730141444.267951807@linuxfoundation.org>
References: <20260730141444.267951807@linuxfoundation.org>
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

7.1-stable review patch.  If anyone has any objections, please let me know.

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
index 1e361a35ebd490..b03d1b2c820a5a 100644
--- a/drivers/net/ethernet/airoha/airoha_eth.c
+++ b/drivers/net/ethernet/airoha/airoha_eth.c
@@ -2326,8 +2326,7 @@ static int airoha_tc_setup_qdisc_ets(struct net_device *dev,
 	if (opt->parent == TC_H_ROOT)
 		return -EINVAL;
 
-	channel = TC_H_MAJ(opt->handle) >> 16;
-	channel = channel % AIROHA_NUM_QOS_CHANNELS;
+	channel = TC_H_MIN(opt->parent) % AIROHA_NUM_QOS_CHANNELS;
 
 	switch (opt->command) {
 	case TC_ETS_REPLACE:
-- 
2.53.0



