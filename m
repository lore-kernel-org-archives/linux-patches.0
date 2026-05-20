Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E04153A4526;
	Wed, 20 May 2026 17:22:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779297778; cv=none; b=QTAOFXR36fAomSFDTxWEOFUS3GNzhn6giuT0i5AzZIPkDy3DgBaHYQFX7dUeXCQkcNufMXrxVdDUOjI27LhXX/B8Nsa90O9h/oTPEf7egUAXDpnXeS5MusHys9KYkJF7/uqh328CoCWt0C1FVWb0v0QjMP42Rsjx29K5Tr8ODSI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779297778; c=relaxed/simple;
	bh=af78msRUnOj3Gm7baFO69QMjDuPUBb/l/kCwrJaIncw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=FvYcmgDVFBICFqVQk5fsDUqHUvsFUC2nv+7kn1zx9mdZp/705UA8BqevDhBDEhkR7V1ko73sgmNzkVpWyBSi81HMcHa/GFqlKTZf4MSkCevy5Cd6i/vfwoIV0lRgzZvfnadhCpwrLxGFZqJM+xlkQBiyWnFQyMJXhYu5ThOP0Hs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=RCkkv2oj; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="RCkkv2oj"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 523181F000E9;
	Wed, 20 May 2026 17:22:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1779297777;
	bh=Q14yXiqkRor6tdBKWT/czMv3D1w2IMLiVtfoHdc9iMs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=RCkkv2ojVmX62Vwei+15LlCz/8OmrRRLFXt+9SpytE65phy2GLjCnWMEK8nYEa2JU
	 ludsZ6lB/8U9+9XJxj5eq1RfJSmFmCLb1ZZza3jnJLAngqLiA0NtVsUYz4jB+aidBv
	 Y7LnBpDO/JzsBXkaNtfrPMXvAqDukPcwH8SGygLo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Erni Sri Satya Vennela <ernis@linux.microsoft.com>,
	Simon Horman <horms@kernel.org>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 159/957] net: mana: Move current_speed debugfs file to mana_init_port()
Date: Wed, 20 May 2026 18:10:42 +0200
Message-ID: <20260520162137.998302034@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260520162134.554764788@linuxfoundation.org>
References: <20260520162134.554764788@linuxfoundation.org>
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

From: Erni Sri Satya Vennela <ernis@linux.microsoft.com>

[ Upstream commit 3b7c7fc97aea7b4048001d12f45777201c74a17f ]

Move the current_speed debugfs file creation from mana_probe_port() to
mana_init_port(). The file was previously created only during initial
probe, but mana_cleanup_port_context() removes the entire vPort debugfs
directory during detach/attach cycles. Since mana_init_port() recreates
the directory on re-attach, moving current_speed here ensures it survives
these cycles.

Fixes: 75cabb46935b ("net: mana: Add support for net_shaper_ops")
Signed-off-by: Erni Sri Satya Vennela <ernis@linux.microsoft.com>
Reviewed-by: Simon Horman <horms@kernel.org>
Link: https://patch.msgid.link/20260408081224.302308-3-ernis@linux.microsoft.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/microsoft/mana/mana_en.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/microsoft/mana/mana_en.c b/drivers/net/ethernet/microsoft/mana/mana_en.c
index 8277a1ac0ad74..c770fb86fd2d3 100644
--- a/drivers/net/ethernet/microsoft/mana/mana_en.c
+++ b/drivers/net/ethernet/microsoft/mana/mana_en.c
@@ -3038,6 +3038,8 @@ static int mana_init_port(struct net_device *ndev)
 	eth_hw_addr_set(ndev, apc->mac_addr);
 	sprintf(vport, "vport%d", port_idx);
 	apc->mana_port_debugfs = debugfs_create_dir(vport, gc->mana_pci_debugfs);
+	debugfs_create_u32("current_speed", 0400, apc->mana_port_debugfs,
+			   &apc->speed);
 	return 0;
 
 reset_apc:
@@ -3310,8 +3312,6 @@ static int mana_probe_port(struct mana_context *ac, int port_idx,
 
 	netif_carrier_on(ndev);
 
-	debugfs_create_u32("current_speed", 0400, apc->mana_port_debugfs, &apc->speed);
-
 	return 0;
 
 free_indir:
-- 
2.53.0



