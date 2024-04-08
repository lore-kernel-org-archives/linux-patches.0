Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0F10B7C097;
	Mon,  8 Apr 2024 13:11:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712581876; cv=none; b=CuOU8xGhIouVDp2ui2K/mAku099d2zP80ff7px4Yyd4vMBv/sG79oKRqJBuGUVgV6GBMnnVZ0C/v3Qou2z9/SEBa2WP0DPvnM7/W06GAu6hb0S+LOKusQxjPwtH3skVuZ2PKOHsj7HywGk3NgkOMQYjgImUAC7w50IjctmBxvuM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712581876; c=relaxed/simple;
	bh=vWBjfW/Izxa1Qm0wFj8gmQIwJ9cO6e5eiKA9sSCUZOA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Diqg+/7rK5V5U/kiPkv9i0rbjTZDWxkBvFlgZQcrrD87qrEJ1LUP/pccxmEmWXuud/LmR7yPk6TRW24xtT2/3YS90QCNR/CjZW5fQhTWxPPWlube6L/6mjQ/Qg7/+e9LJuDGKqzMIMJiXIBQ3DfdWdTXZDg2+M977hNUDjq6jtU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=B4XKwI5H; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="B4XKwI5H"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 89067C433C7;
	Mon,  8 Apr 2024 13:11:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1712581875;
	bh=vWBjfW/Izxa1Qm0wFj8gmQIwJ9cO6e5eiKA9sSCUZOA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=B4XKwI5HfSZJNGwGl6H/CD8TEHpuirP9OPil3cQXyofw6jtVfA/OZ0nsl7CsTGmBy
	 5NdvPosMFtps316SKX0ES92scOEsxrbyo3Nz08sii9KrFFDwSynVQ5Cp3RJCkZJfZD
	 lQ0VdlINL9L2xFjeHFcAIiJrr2fS343CKnTQZoYU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ravi Gunasekaran <r-gunasekaran@ti.com>,
	Jiri Pirko <jiri@nvidia.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.8 027/273] net: hsr: hsr_slave: Fix the promiscuous mode in offload mode
Date: Mon,  8 Apr 2024 14:55:02 +0200
Message-ID: <20240408125310.134184263@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240408125309.280181634@linuxfoundation.org>
References: <20240408125309.280181634@linuxfoundation.org>
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

6.8-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Ravi Gunasekaran <r-gunasekaran@ti.com>

[ Upstream commit b11c81731c810efe592e510bb0110e0db6877419 ]

commit e748d0fd66ab ("net: hsr: Disable promiscuous mode in
offload mode") disables promiscuous mode of slave devices
while creating an HSR interface. But while deleting the
HSR interface, it does not take care of it. It decreases the
promiscuous mode count, which eventually enables promiscuous
mode on the slave devices when creating HSR interface again.

Fix this by not decrementing the promiscuous mode count while
deleting the HSR interface when offload is enabled.

Fixes: e748d0fd66ab ("net: hsr: Disable promiscuous mode in offload mode")
Signed-off-by: Ravi Gunasekaran <r-gunasekaran@ti.com>
Reviewed-by: Jiri Pirko <jiri@nvidia.com>
Link: https://lore.kernel.org/r/20240322100447.27615-1-r-gunasekaran@ti.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/hsr/hsr_slave.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/net/hsr/hsr_slave.c b/net/hsr/hsr_slave.c
index e5742f2a2d522..1b6457f357bdb 100644
--- a/net/hsr/hsr_slave.c
+++ b/net/hsr/hsr_slave.c
@@ -220,7 +220,8 @@ void hsr_del_port(struct hsr_port *port)
 		netdev_update_features(master->dev);
 		dev_set_mtu(master->dev, hsr_get_max_mtu(hsr));
 		netdev_rx_handler_unregister(port->dev);
-		dev_set_promiscuity(port->dev, -1);
+		if (!port->hsr->fwd_offloaded)
+			dev_set_promiscuity(port->dev, -1);
 		netdev_upper_dev_unlink(port->dev, master->dev);
 	}
 
-- 
2.43.0



