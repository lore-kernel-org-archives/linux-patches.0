Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 60D5F38945E;
	Tue, 10 Mar 2026 11:30:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773142218; cv=none; b=uUnprq4+EeZo3qrTkHTYnwdJrmvy3BmGJ0EzbQvMJIddCr62N08KkmmGSYMYs82PYqaw2fXwto8F5WIUEzn3/NQTG7qxL/sDcBLf0+yR/bH1lBherLfsOvNhXLG5Ya96TSQHpAnU/jtVumH8vL845OB9Pz9FnDp9figqWI5rmCw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773142218; c=relaxed/simple;
	bh=MKdGqjAzOSAZ3NH/kMpJ84kFwnKQ8gTLDhI6gF4QsoY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=E06Yt2GIT8O+I5Q7II+/gKAGBtfcDpXzg8p9RyNSURGKlGwIG6LXJhAhqte/gUgau6us2J4sxVm4RjcLdjxqEm3Ab9/6+em5vShEV3xtXCzoprIHsOAzNln4gy6iQ+klEvhP32/ukWXTwzge8Q2zJarJPOGXAwMHcukA1jTmNXg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=hXVUXeRH; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="hXVUXeRH"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 80EE0C2BCB0;
	Tue, 10 Mar 2026 11:30:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1773142218;
	bh=MKdGqjAzOSAZ3NH/kMpJ84kFwnKQ8gTLDhI6gF4QsoY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=hXVUXeRHLp+dFKx9smRxnx4EUlvcRSMK9dPcJjK1NUwrtAdr6w1dhCocgsO6eG2Xi
	 j8iswB4CWZIc40BUE5E2scbVZy+8iEeS4CovbJQM7zjOXjOuesa8n+AUG7zL2/sqdX
	 XTwGel2ceLR0CaQ+X5A4/qUPJhIUVyVHefmY7DaDvb+R2S62y8HWUX+sxKiACq/yWd
	 QiILurJJ6OQ+TQEHkvArThj7Q2yGKISeniRDbf0x8hd7UGJFUQI0DwjljipvV4mihp
	 8doM0pUZhrjOrypswbZF8bz1Us8BJJ4dQoHXNxLVjACM+z14/e22bgmG16fMtUwNTA
	 wVytWJB8WJzKw==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Larysa Zaremba <larysa.zaremba@intel.com>,
	Aleksandr Loktionov <aleksandr.loktionov@intel.com>,
	Vladimir Oltean <vladimir.oltean@nxp.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 308/314] net: enetc: use truesize as XDP RxQ info frag_size
Date: Tue, 10 Mar 2026 07:19:27 -0400
Message-ID: <b4d3ac99183e22a8b1ba614f9b06fd17b1de779c.1773141556.git.sashal@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <cover.1773141554.git.sashal@kernel.org>
References: <cover.1773141554.git.sashal@kernel.org>
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
index b6e3fb0401619..d97a76718dd89 100644
--- a/drivers/net/ethernet/freescale/enetc/enetc.c
+++ b/drivers/net/ethernet/freescale/enetc/enetc.c
@@ -3458,7 +3458,7 @@ static int enetc_int_vector_init(struct enetc_ndev_priv *priv, int i,
 	priv->rx_ring[i] = bdr;
 
 	err = __xdp_rxq_info_reg(&bdr->xdp.rxq, priv->ndev, i, 0,
-				 ENETC_RXB_DMA_SIZE_XDP);
+				 ENETC_RXB_TRUESIZE);
 	if (err)
 		goto free_vector;
 
-- 
2.51.0

