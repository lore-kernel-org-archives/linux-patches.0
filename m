Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A51B51DFD1;
	Sun,  1 Sep 2024 16:54:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725209650; cv=none; b=TZc3g/11z3/n4Q3oSuZewe2Gq38jKLJ/WAku8g/BOBBCgo/B4Dd9yoTuoYYy17hZxacaUeWeOPKpVm4zjmN5g/1k8En8PEFZAo16bTKCmHwRBSXGSTG4/L+3FwSL9/xIlX52jn9ni02QH/bL7w5pKPN4tyGrxkwHu5FXUYGpjgQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725209650; c=relaxed/simple;
	bh=L8ccglQoQV5reBfw/Xw3q/b2F7TyIcCEqNMFVRzvedg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=RPwjMZiu0Xv5h1c36bHp83ww4/E0JUljuU99jFIbtsGK1a4OvBmFtffOQpwNJRmAJd/tcxVv0ftHoy/P+cCCpTxuwQiSIvkn4C2TYc8oeqjJfnx/rvNJsXqig+mHKGJZ/ZGVwaYiam3aVB2Yd1aYk+UfCAsAVSbVj+6mUnwdk18=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=G9oDpmlh; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="G9oDpmlh"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 29D14C4CEC3;
	Sun,  1 Sep 2024 16:54:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1725209650;
	bh=L8ccglQoQV5reBfw/Xw3q/b2F7TyIcCEqNMFVRzvedg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=G9oDpmlhcljTNFUL0JeQgCdZuv/qTrUeOOYTOuNbpzKIb+ov1KeQzndItYmQKe+v8
	 AYqwLkmb8LLmcA+XgoXF30VdAf0nEZrAeehvy08z9w7CvfdG6y30yP8M75sVfjV0iz
	 z3wJ2YzVZGPccx/fmgx2BexTHsGSnDCBHi6zujtk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Nikolay Aleksandrov <razor@blackwall.org>,
	Hangbin Liu <liuhangbin@gmail.com>,
	Paolo Abeni <pabeni@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 095/151] bonding: fix xfrm state handling when clearing active slave
Date: Sun,  1 Sep 2024 18:17:35 +0200
Message-ID: <20240901160817.688104055@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240901160814.090297276@linuxfoundation.org>
References: <20240901160814.090297276@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Nikolay Aleksandrov <razor@blackwall.org>

[ Upstream commit c4c5c5d2ef40a9f67a9241dc5422eac9ffe19547 ]

If the active slave is cleared manually the xfrm state is not flushed.
This leads to xfrm add/del imbalance and adding the same state multiple
times. For example when the device cannot handle anymore states we get:
 [ 1169.884811] bond0: (slave eni0np1): bond_ipsec_add_sa_all: failed to add SA
because it's filled with the same state after multiple active slave
clearings. This change also has a few nice side effects: user-space
gets a notification for the change, the old device gets its mac address
and promisc/mcast adjusted properly.

Fixes: 18cb261afd7b ("bonding: support hardware encryption offload to slaves")
Signed-off-by: Nikolay Aleksandrov <razor@blackwall.org>
Reviewed-by: Hangbin Liu <liuhangbin@gmail.com>
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/bonding/bond_options.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/bonding/bond_options.c b/drivers/net/bonding/bond_options.c
index fa0bf77870d43..acc6185749945 100644
--- a/drivers/net/bonding/bond_options.c
+++ b/drivers/net/bonding/bond_options.c
@@ -822,7 +822,7 @@ static int bond_option_active_slave_set(struct bonding *bond,
 	/* check to see if we are clearing active */
 	if (!slave_dev) {
 		netdev_dbg(bond->dev, "Clearing current active slave\n");
-		RCU_INIT_POINTER(bond->curr_active_slave, NULL);
+		bond_change_active_slave(bond, NULL);
 		bond_select_active_slave(bond);
 	} else {
 		struct slave *old_active = rtnl_dereference(bond->curr_active_slave);
-- 
2.43.0



