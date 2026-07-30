Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3508A3C3F4C;
	Thu, 30 Jul 2026 15:12:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785424346; cv=none; b=QEBXn7o/4i0T2nLDtIh7Pet/0NE1Ajp39OE6f9VWvw9/hrYDU6lsby2MoXPq9diyBAUyg3fzd/KBU3tYXZaUBfguvfWH1o6mhpZdBj1qnAZF1HMWmnklnG1HVdxGXQHIwug5YtU1ju8xyC++Dcldo9PWxEv6rzrjjhWeolOgH9M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785424346; c=relaxed/simple;
	bh=tROesbveg7+WA/Q/pBGTgvHRJb+neVubxfavv8kClUA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=YRoQYiKSmbYkxWdFY0GxmXO8wYx5mCpHcjm9yITQhMB4xrVXFoaIMsV7RyvICT6WYOED718vVKqIehSsQ4bSUPONxy/Z475OEG2EU0yuK4z3DctpkJPGrxWm0PQ4CsDI188+zOkjtylnPlstOjEwT6NIwGOLYyrAKze3+pG625g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Ca8j2F2p; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Ca8j2F2p"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 344E31F000E9;
	Thu, 30 Jul 2026 15:12:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1785424344;
	bh=1coZ/1512fG0LxXbw3POzj+z5uditEkl/SF9LUx+ri4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Ca8j2F2pY6sLDlp/uCdvC4iexG4p0cGWCsWqs2IIasgU9E87jCKz8xsF3V01EiY3G
	 E9jKH42IxRkuWcNbN/3ddEB5FWaibTbJJnkRk50uSebiWSLnGf0hk4450u5ANTJ3tU
	 lTydJUw4Z87n4NEoyZQbbcV+EVqyS4E5JSboSVwg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Simon Horman <horms@kernel.org>,
	Lorenzo Bianconi <lorenzo@kernel.org>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 316/675] net: airoha: fix ETS channel derivation in airoha_tc_setup_qdisc_ets()
Date: Thu, 30 Jul 2026 16:10:46 +0200
Message-ID: <20260730141451.843101878@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260730141445.110192266@linuxfoundation.org>
References: <20260730141445.110192266@linuxfoundation.org>
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
index 5efd03c2deea77..64ab34e37c36f9 100644
--- a/drivers/net/ethernet/airoha/airoha_eth.c
+++ b/drivers/net/ethernet/airoha/airoha_eth.c
@@ -2326,8 +2326,7 @@ static int airoha_tc_setup_qdisc_ets(struct airoha_gdm_port *port,
 	if (opt->parent == TC_H_ROOT)
 		return -EINVAL;
 
-	channel = TC_H_MAJ(opt->handle) >> 16;
-	channel = channel % AIROHA_NUM_QOS_CHANNELS;
+	channel = TC_H_MIN(opt->parent) % AIROHA_NUM_QOS_CHANNELS;
 
 	switch (opt->command) {
 	case TC_ETS_REPLACE:
-- 
2.53.0



