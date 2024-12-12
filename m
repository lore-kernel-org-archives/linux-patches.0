Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7D12D2EAE5;
	Thu, 12 Dec 2024 15:01:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734015695; cv=none; b=i4f9AYC/KN+IxCicfopmEbOhVXwLczX13A/ga5Jre9weCoS+UznnJ0t8zvtAjKB4nHixX3/5NrQeP/n5/MfR5Zzyo1kiCuR+F9n+6NdfiBCBAXZ1hzeysL5qj6lMD7Os3dHAjRHp212PEIuqxuCAgkdUaIeCav50C6lFzMz7l1A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734015695; c=relaxed/simple;
	bh=SrrF88wAVHdcilgVPYj4jFbLv9ux4ODxsTwxg9X3y8c=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=UhM+PgoHx08Wtg56gjjEiAzXxDfJJGppUhljxGp+tUbHXeiAPxEdgIIW2bP36DHARjVpKwT/23dqcVN74M66q2IBWdpnJrsp1YxScnUcDKOiYk0tXeXtdaumCJ2mbv9/dC420m7VAtRhUhb3BMvqJEn9v3aRa4WRvEjJyS5En20=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=XN/PBGO+; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="XN/PBGO+"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8F074C4CED0;
	Thu, 12 Dec 2024 15:01:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1734015694;
	bh=SrrF88wAVHdcilgVPYj4jFbLv9ux4ODxsTwxg9X3y8c=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=XN/PBGO+/kNzwfqdAtYgjO+xUnN3MHY4wGxtVbU/ICeltE5qYOyQxkE4kUkT6OLuI
	 BZd3QDPE6j19Wqj8C2seuCTJDeFn9J7uwSvGthUBkeVTuf3JDQUh22R0MeL02IO0bX
	 e6QHijRED4Hok+SZqXfGwDe78IaZT4zBwfF+Ni3M=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Wei Fang <wei.fang@nxp.com>,
	Vladimir Oltean <vladimir.oltean@nxp.com>,
	Frank Li <Frank.Li@nxp.com>,
	"David S. Miller" <davem@davemloft.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 020/466] net: enetc: Do not configure preemptible TCs if SIs do not support
Date: Thu, 12 Dec 2024 15:53:09 +0100
Message-ID: <20241212144307.490997840@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241212144306.641051666@linuxfoundation.org>
References: <20241212144306.641051666@linuxfoundation.org>
User-Agent: quilt/0.67
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

[ Upstream commit b2420b8c81ec674552d00c55d46245e5c184b260 ]

Both ENETC PF and VF drivers share enetc_setup_tc_mqprio() to configure
MQPRIO. And enetc_setup_tc_mqprio() calls enetc_change_preemptible_tcs()
to configure preemptible TCs. However, only PF is able to configure
preemptible TCs. Because only PF has related registers, while VF does not
have these registers. So for VF, its hw->port pointer is NULL. Therefore,
VF will access an invalid pointer when accessing a non-existent register,
which will cause a crash issue. The simplified log is as follows.

root@ls1028ardb:~# tc qdisc add dev eno0vf0 parent root handle 100: \
mqprio num_tc 4 map 0 0 1 1 2 2 3 3 queues 1@0 1@1 1@2 1@3 hw 1
[  187.290775] Unable to handle kernel paging request at virtual address 0000000000001f00
[  187.424831] pc : enetc_mm_commit_preemptible_tcs+0x1c4/0x400
[  187.430518] lr : enetc_mm_commit_preemptible_tcs+0x30c/0x400
[  187.511140] Call trace:
[  187.513588]  enetc_mm_commit_preemptible_tcs+0x1c4/0x400
[  187.518918]  enetc_setup_tc_mqprio+0x180/0x214
[  187.523374]  enetc_vf_setup_tc+0x1c/0x30
[  187.527306]  mqprio_enable_offload+0x144/0x178
[  187.531766]  mqprio_init+0x3ec/0x668
[  187.535351]  qdisc_create+0x15c/0x488
[  187.539023]  tc_modify_qdisc+0x398/0x73c
[  187.542958]  rtnetlink_rcv_msg+0x128/0x378
[  187.547064]  netlink_rcv_skb+0x60/0x130
[  187.550910]  rtnetlink_rcv+0x18/0x24
[  187.554492]  netlink_unicast+0x300/0x36c
[  187.558425]  netlink_sendmsg+0x1a8/0x420
[  187.606759] ---[ end trace 0000000000000000 ]---

In addition, some PFs also do not support configuring preemptible TCs,
such as eno1 and eno3 on LS1028A. It won't crash like it does for VFs,
but we should prevent these PFs from accessing these unimplemented
registers.

Fixes: 827145392a4a ("net: enetc: only commit preemptible TCs to hardware when MM TX is active")
Signed-off-by: Wei Fang <wei.fang@nxp.com>
Suggested-by: Vladimir Oltean <vladimir.oltean@nxp.com>
Reviewed-by: Frank Li <Frank.Li@nxp.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/freescale/enetc/enetc.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/net/ethernet/freescale/enetc/enetc.c b/drivers/net/ethernet/freescale/enetc/enetc.c
index c09370eab319b..16a7908c79f70 100644
--- a/drivers/net/ethernet/freescale/enetc/enetc.c
+++ b/drivers/net/ethernet/freescale/enetc/enetc.c
@@ -28,6 +28,9 @@ EXPORT_SYMBOL_GPL(enetc_port_mac_wr);
 static void enetc_change_preemptible_tcs(struct enetc_ndev_priv *priv,
 					 u8 preemptible_tcs)
 {
+	if (!(priv->si->hw_features & ENETC_SI_F_QBU))
+		return;
+
 	priv->preemptible_tcs = preemptible_tcs;
 	enetc_mm_commit_preemptible_tcs(priv);
 }
-- 
2.43.0



