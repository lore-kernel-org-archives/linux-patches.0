Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B15B74C6A
	for <patches@lists.linux.dev>; Mon, 14 Nov 2022 13:02:11 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 313F0C433C1;
	Mon, 14 Nov 2022 13:02:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1668430931;
	bh=34Wk49HVKcwF2lN/tlVHYxZ7GOBEaNRd7oT/I07x0kU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=fxsLomWYHGF3c2XG3UCtGCjxYyRqXz3G0v6AZH81spI0wsKPBy84EVnTsMAGYQGum
	 0CcZv0TbHy5LNZpMeEhg52idSdQgGB/ZgS77oC8hiT/FVY4FQeViIBZwudt1WWtidb
	 ApcPKCcU3nsONsx9YTn7vPHv/55V/7sMHCobKAFI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sabrina Dubroca <sd@queasysnail.net>,
	Antoine Tenart <atenart@kernel.org>,
	Leon Romanovsky <leonro@nvidia.com>,
	"David S. Miller" <davem@davemloft.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.0 037/190] macsec: fix detection of RXSCs when toggling offloading
Date: Mon, 14 Nov 2022 13:44:21 +0100
Message-Id: <20221114124500.399467852@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221114124458.806324402@linuxfoundation.org>
References: <20221114124458.806324402@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Sabrina Dubroca <sd@queasysnail.net>

[ Upstream commit 80df4706357a5a06bbbc70273bf2611df1ceee04 ]

macsec_is_configured incorrectly uses secy->n_rx_sc to check if some
RXSCs exist. secy->n_rx_sc only counts the number of active RXSCs, but
there can also be inactive SCs as well, which may be stored in the
driver (in case we're disabling offloading), or would have to be
pushed to the device (in case we're trying to enable offloading).

As long as RXSCs active on creation and never turned off, the issue is
not visible.

Fixes: dcb780fb2795 ("net: macsec: add nla support for changing the offloading selection")
Signed-off-by: Sabrina Dubroca <sd@queasysnail.net>
Reviewed-by: Antoine Tenart <atenart@kernel.org>
Reviewed-by: Leon Romanovsky <leonro@nvidia.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/macsec.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/macsec.c b/drivers/net/macsec.c
index 6caab70efdb8..2add76c8064b 100644
--- a/drivers/net/macsec.c
+++ b/drivers/net/macsec.c
@@ -2599,7 +2599,7 @@ static bool macsec_is_configured(struct macsec_dev *macsec)
 	struct macsec_tx_sc *tx_sc = &secy->tx_sc;
 	int i;
 
-	if (secy->n_rx_sc > 0)
+	if (secy->rx_sc)
 		return true;
 
 	for (i = 0; i < MACSEC_NUM_AN; i++)
-- 
2.35.1



