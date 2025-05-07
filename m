Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 86F082116E9;
	Wed,  7 May 2025 18:54:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746644091; cv=none; b=FKiNl1zVx1Nhje2NKAOPGXhfFHCoKGcxfZFRHU1wQHPNt0vcw/H6PGO4gXEm2z/JWzpF3ok1yBOw5UBOQR9mv5UNbKYxe4HANUB7omRRxgu2wTmCr3xl/M+L2J4inQGZ0AngKVfoxopM5TZIQAOApxIAkLw062rewFqhHP6wZQE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746644091; c=relaxed/simple;
	bh=v4Iez7PyRQw6ZUKGgMnAuKh1eVaFYZoNTDkw26gNFGE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=uP6CvuBiIfcNmCz893wKn6jHUGC+0tK/Yg2/U9oLO8gkgqfvs0PgmDWb9lLpbpktqEoArKL1gv7Po/PquXaB8EzCrQFerFC4gcxu1EVS2EYZNpbMFFDP4TQMoTZt3s30pdGtvSIwv5DF6+nCPSlSfOF7mzJj88btgYimDF5wdiY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=lrqv0WkF; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="lrqv0WkF"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EAB52C4CEE2;
	Wed,  7 May 2025 18:54:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1746644091;
	bh=v4Iez7PyRQw6ZUKGgMnAuKh1eVaFYZoNTDkw26gNFGE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=lrqv0WkFRYvemenuh7NxktXpxaTp5nQgImeFgTE5F7WRGF2TiQa1da8hsH1r43WUv
	 8esF3VTKsjdZ5TtpaBlruuCAgY5KMqSDtU5uwBl5XulEZmhj+tbsJVum2ZnnJgvB9g
	 iP+wVxF57aZgebtqKAxlBl0BmrbBjeITDpq5jtPE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sathesh B Edara <sedara@marvell.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.14 087/183] octeon_ep_vf: Resolve netdevice usage count issue
Date: Wed,  7 May 2025 20:38:52 +0200
Message-ID: <20250507183828.352208416@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250507183824.682671926@linuxfoundation.org>
References: <20250507183824.682671926@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.14-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Sathesh B Edara <sedara@marvell.com>

[ Upstream commit 8548c84c004be3da4ffbe35ed0589041a4050c03 ]

The netdevice usage count increases during transmit queue timeouts
because netdev_hold is called in ndo_tx_timeout, scheduling a task
to reinitialize the card. Although netdev_put is called at the end
of the scheduled work, rtnl_unlock checks the reference count during
cleanup. This could cause issues if transmit timeout is called on
multiple queues.

Fixes: cb7dd712189f ("octeon_ep_vf: Add driver framework and device initialization")
Signed-off-by: Sathesh B Edara <sedara@marvell.com>
Link: https://patch.msgid.link/20250424133944.28128-1-sedara@marvell.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/marvell/octeon_ep_vf/octep_vf_main.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/marvell/octeon_ep_vf/octep_vf_main.c b/drivers/net/ethernet/marvell/octeon_ep_vf/octep_vf_main.c
index 18c922dd5fc64..ccb69bc5c9529 100644
--- a/drivers/net/ethernet/marvell/octeon_ep_vf/octep_vf_main.c
+++ b/drivers/net/ethernet/marvell/octeon_ep_vf/octep_vf_main.c
@@ -835,7 +835,9 @@ static void octep_vf_tx_timeout(struct net_device *netdev, unsigned int txqueue)
 	struct octep_vf_device *oct = netdev_priv(netdev);
 
 	netdev_hold(netdev, NULL, GFP_ATOMIC);
-	schedule_work(&oct->tx_timeout_task);
+	if (!schedule_work(&oct->tx_timeout_task))
+		netdev_put(netdev, NULL);
+
 }
 
 static int octep_vf_set_mac(struct net_device *netdev, void *p)
-- 
2.39.5



