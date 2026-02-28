Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 074ED37225F;
	Sat, 28 Feb 2026 17:58:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772301510; cv=none; b=iScEnXMZG2cmJ4ELI3NqTpqfYeapcRUdZjLIPguVTSJSoF6aiX5aA26wII1ejBUyemipK7OMXwBO4NqFQS97FpMZEOC2cupHPiVLqXYbRJdqgevsq8LZqBM91rQTIn3HF3AhSlqeiBvYd20lXbyJPpmFyhpZaL8lPglNT1kQ7Aw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772301510; c=relaxed/simple;
	bh=PAoL5jEsBEqiO4796cl0CDVmSwXkHDjdmnPBtrD0VOc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=kqfct+n/vsjDOQh0qD3sJgGtpyAfXn0SVrnesuudY5CgmVLaRxnnaYXhFahtyOV9rtEtJUziZKLCnLiKSJNjVTEupRVeoHhfsdwB9F+YZlk9KXbzGg3wJOo0CBj00pAmZSrmJW5kzZhuUktc6GeJ8B4HT7xTQk2LmSbzpnGjsFk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=MM2HSxNG; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="MM2HSxNG"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 537DBC19425;
	Sat, 28 Feb 2026 17:58:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772301509;
	bh=PAoL5jEsBEqiO4796cl0CDVmSwXkHDjdmnPBtrD0VOc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=MM2HSxNGlDDcncMDGFmo6uDaDtdjSiTa8/JK7H7LyOyyHJhmEf3gzs2mYauYniOC0
	 svcaA+GSR1Fd6anSN8RASOJOu/M3wP+nF/PhL0llSwbwXy6KP7wipTwTK2g//yvBvR
	 Uw6o4dh6CYcFkFi2O3Jj4mRMm8lQ8mpmIS7hvXvnZulr0P1mifcQcxzOqSHqVQ1fGG
	 c8vbybja/EVafouJ4PN3laJuBhM5blXCKkz5oavNexEl4NJtnKGZ1v9EeIJkvJNOVd
	 tLZXnOZkun+IuAIE/KIPET8hGcimrAXRQ0fQQirD079CI4Zpjpp2PRj0BFu4ISDJWZ
	 3wxmmU+93COSQ==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev
Cc: Kevin Hao <haokexin@gmail.com>,
	stable@vger.kernel.org,
	Paolo Abeni <pabeni@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 695/752] net: ti: icssg-prueth: Add optional dependency on HSR
Date: Sat, 28 Feb 2026 12:46:46 -0500
Message-ID: <20260228174750.1542406-695-sashal@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20260228174750.1542406-1-sashal@kernel.org>
References: <20260228174750.1542406-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit

From: Kevin Hao <haokexin@gmail.com>

[ Upstream commit e3998b6e90f875f19bf758053d79ccfd41880173 ]

Commit 95540ad6747c ("net: ti: icssg-prueth: Add support for HSR frame
forward offload") introduced support for offloading HSR frame forwarding,
which relies on functions such as is_hsr_master() provided by the HSR
module. Although HSR provides stubs for configurations with HSR
disabled, this driver still requires an optional dependency on HSR.
Otherwise, build failures will occur when icssg-prueth is built-in
while HSR is configured as a module.
  ld.lld: error: undefined symbol: is_hsr_master
  >>> referenced by icssg_prueth.c:710 (drivers/net/ethernet/ti/icssg/icssg_prueth.c:710)
  >>>               drivers/net/ethernet/ti/icssg/icssg_prueth.o:(icssg_prueth_hsr_del_mcast) in archive vmlinux.a
  >>> referenced by icssg_prueth.c:681 (drivers/net/ethernet/ti/icssg/icssg_prueth.c:681)
  >>>               drivers/net/ethernet/ti/icssg/icssg_prueth.o:(icssg_prueth_hsr_add_mcast) in archive vmlinux.a
  >>> referenced by icssg_prueth.c:1812 (drivers/net/ethernet/ti/icssg/icssg_prueth.c:1812)
  >>>               drivers/net/ethernet/ti/icssg/icssg_prueth.o:(prueth_netdevice_event) in archive vmlinux.a

  ld.lld: error: undefined symbol: hsr_get_port_ndev
  >>> referenced by icssg_prueth.c:712 (drivers/net/ethernet/ti/icssg/icssg_prueth.c:712)
  >>>               drivers/net/ethernet/ti/icssg/icssg_prueth.o:(icssg_prueth_hsr_del_mcast) in archive vmlinux.a
  >>> referenced by icssg_prueth.c:712 (drivers/net/ethernet/ti/icssg/icssg_prueth.c:712)
  >>>               drivers/net/etherneteth_hsr_del_mcast) in archive vmlinux.a
  >>> referenced by icssg_prueth.c:683 (drivers/net/ethernet/ti/icssg/icssg_prueth.c:683)
  >>>               drivers/net/ethernet/ti/icssg/icssg_prueth.o:(icssg_prueth_hsr_add_mcast) in archive vmlinux.a
  >>> referenced 1 more times

Fixes: 95540ad6747c ("net: ti: icssg-prueth: Add support for HSR frame forward offload")
Signed-off-by: Kevin Hao <haokexin@gmail.com>
Cc: stable@vger.kernel.org
Link: https://patch.msgid.link/20260207-icssg-dep-v3-1-8c47c1937f81@gmail.com
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/ti/Kconfig | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/net/ethernet/ti/Kconfig b/drivers/net/ethernet/ti/Kconfig
index fe5b2926d8ab0..c60b04921c62c 100644
--- a/drivers/net/ethernet/ti/Kconfig
+++ b/drivers/net/ethernet/ti/Kconfig
@@ -192,6 +192,7 @@ config TI_ICSSG_PRUETH
 	depends on NET_SWITCHDEV
 	depends on ARCH_K3 && OF && TI_K3_UDMA_GLUE_LAYER
 	depends on PTP_1588_CLOCK_OPTIONAL
+	depends on HSR || !HSR
 	help
 	  Support dual Gigabit Ethernet ports over the ICSSG PRU Subsystem.
 	  This subsystem is available starting with the AM65 platform.
-- 
2.51.0

