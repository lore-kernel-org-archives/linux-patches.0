Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1FAAB36D512;
	Tue, 10 Mar 2026 11:14:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773141299; cv=none; b=S+kn3XXwXoikVXO/t6Vws44j8ChYi3yMrB4z8mltcIGErm2tD4JzIJKqf2CAedMUSVmHMc6fHu8RFeQvcAb9hRMB6VJ2Qy/MwoF1niYnTNqTbpVkaoki5kPW5ITEgnVHEioxKgCASiXFZl8d5ifj97+AEanGadY3xbPGS3Ec8yw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773141299; c=relaxed/simple;
	bh=Sp0LZwnCkUtv7V/KT4tQft0rFMgwsQHFuaScuzbIVss=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=P1uAyayueKRFUIV9FsC31bW6n6U8bEY4ZPiwetO96LeRwqv2t3qKvvw8jZsm1Zi11vMdq/uSac5oyAotEMNUBctOQxszcf3S2VrRiu2tRDIwwLxS+tj8p5jIcL4gwcofr0DdRbhFLv+VIKP4XNZXzdn90hGm3dFoHfnMjOOKhyU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=i54uQ1mI; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="i54uQ1mI"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2C5DEC2BCAF;
	Tue, 10 Mar 2026 11:14:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1773141298;
	bh=Sp0LZwnCkUtv7V/KT4tQft0rFMgwsQHFuaScuzbIVss=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=i54uQ1mISOFVBSRNt/ljoGPWzetIU8KNcpRg6MsO8yXoRNjFaqXYz2gkGLm2GXk2C
	 sSRqGQZfkJTILYMoK90y5e12m7Kd6pO4VguHd3d5ce/dvMJ2kCcACf6gZ3gMeWZ73M
	 1tLgcc9Vga5up1lU8gPtWgnWld6CV2VwhSZl28rlHQQ3n4uhnKrLbkG/Pt/pv3fcBO
	 pafm0eJqCYMl8bbCcJ8Wu349pBxztkyOJA4uNdMNUlxXWD19VxyyvlQDxsQUHJRarK
	 5bkZPWqmIKBfa6CkLB1ZMAPsNtE/tAubipUfzQFLoQXBgNe1dUuogNNR3uDZULXnOo
	 t75s27OeNJOTA==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Larysa Zaremba <larysa.zaremba@intel.com>,
	Aleksandr Loktionov <aleksandr.loktionov@intel.com>,
	Vladimir Oltean <vladimir.oltean@nxp.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.19 303/311] net: enetc: use truesize as XDP RxQ info frag_size
Date: Tue, 10 Mar 2026 07:05:50 -0400
Message-ID: <2f80ed220c883e47c4675b764287f38f84369578.1773140655.git.sashal@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <cover.1773140654.git.sashal@kernel.org>
References: <cover.1773140654.git.sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit

From: Larysa Zaremba <larysa.zaremba@intel.com>

[ Upstream commit f8e18abf183dbd636a8725532c7f5aa58957de84 ]

The only user of frag_size field in XDP RxQ info is
bpf_xdp_frags_increase_tail(). It clearly expects truesize instead of DMA
write size. Different assumptions in enetc driver configuration lead to
negative tailroom.

Set frag_size to the same value as frame_sz.

Fixes: 2768b2e2f7d2 ("net: enetc: register XDP RX queues with frag_size")
Reviewed-by: Aleksandr Loktionov <aleksandr.loktionov@intel.com>
Reviewed-by: Vladimir Oltean <vladimir.oltean@nxp.com>
Signed-off-by: Larysa Zaremba <larysa.zaremba@intel.com>
Link: https://patch.msgid.link/20260305111253.2317394-9-larysa.zaremba@intel.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/freescale/enetc/enetc.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/freescale/enetc/enetc.c b/drivers/net/ethernet/freescale/enetc/enetc.c
index e380a4f398556..9fdd448e602f1 100644
--- a/drivers/net/ethernet/freescale/enetc/enetc.c
+++ b/drivers/net/ethernet/freescale/enetc/enetc.c
@@ -3468,7 +3468,7 @@ static int enetc_int_vector_init(struct enetc_ndev_priv *priv, int i,
 	priv->rx_ring[i] = bdr;
 
 	err = __xdp_rxq_info_reg(&bdr->xdp.rxq, priv->ndev, i, 0,
-				 ENETC_RXB_DMA_SIZE_XDP);
+				 ENETC_RXB_TRUESIZE);
 	if (err)
 		goto free_vector;
 
-- 
2.51.0

