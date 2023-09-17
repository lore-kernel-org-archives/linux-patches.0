Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 646546FCC
	for <patches@lists.linux.dev>; Sun, 17 Sep 2023 19:52:51 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C4085C433C8;
	Sun, 17 Sep 2023 19:52:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1694980371;
	bh=3/uGjJZnpnKuWRnwPcOzHwvgcOuwtEsiVUQvsJ+mNFM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=pbjCZ4Z5KrRZw0ypgwak7yv9yNzFyBJWJfEzcVCQXmnsILnLaCf+KcoW+s1/AUGzo
	 McASjJZQZae0J4WMZ9iAHXq1YmX3JefZpQH5ZOlRKf6EVQ8eYM/WZPDJi1HhYAWHJI
	 ERvpERcNLDNvWlMV0o9LCF3XYEEDKYVK06RwZdyI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dan Carpenter <dan.carpenter@linaro.org>,
	Vladimir Oltean <vladimir.oltean@nxp.com>,
	Simon Horman <horms@kernel.org>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.5 173/285] net: enetc: distinguish error from valid pointers in enetc_fixup_clear_rss_rfs()
Date: Sun, 17 Sep 2023 21:12:53 +0200
Message-ID: <20230917191057.624969051@linuxfoundation.org>
X-Mailer: git-send-email 2.42.0
In-Reply-To: <20230917191051.639202302@linuxfoundation.org>
References: <20230917191051.639202302@linuxfoundation.org>
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

6.5-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Vladimir Oltean <vladimir.oltean@nxp.com>

[ Upstream commit 1b36955cc048c8ff6ba448dbf4be0e52f59f2963 ]

enetc_psi_create() returns an ERR_PTR() or a valid station interface
pointer, but checking for the non-NULL quality of the return code blurs
that difference away. So if enetc_psi_create() fails, we call
enetc_psi_destroy() when we shouldn't. This will likely result in
crashes, since enetc_psi_create() cleans up everything after itself when
it returns an ERR_PTR().

Fixes: f0168042a212 ("net: enetc: reimplement RFS/RSS memory clearing as PCI quirk")
Reported-by: Dan Carpenter <dan.carpenter@linaro.org>
Closes: https://lore.kernel.org/netdev/582183ef-e03b-402b-8e2d-6d9bb3c83bd9@moroto.mountain/
Suggested-by: Dan Carpenter <dan.carpenter@linaro.org>
Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
Reviewed-by: Simon Horman <horms@kernel.org>
Link: https://lore.kernel.org/r/20230906141609.247579-1-vladimir.oltean@nxp.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/freescale/enetc/enetc_pf.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/freescale/enetc/enetc_pf.c b/drivers/net/ethernet/freescale/enetc/enetc_pf.c
index e0a4cb7e3f501..c153dc083aff0 100644
--- a/drivers/net/ethernet/freescale/enetc/enetc_pf.c
+++ b/drivers/net/ethernet/freescale/enetc/enetc_pf.c
@@ -1402,7 +1402,7 @@ static void enetc_fixup_clear_rss_rfs(struct pci_dev *pdev)
 		return;
 
 	si = enetc_psi_create(pdev);
-	if (si)
+	if (!IS_ERR(si))
 		enetc_psi_destroy(pdev);
 }
 DECLARE_PCI_FIXUP_FINAL(PCI_VENDOR_ID_FREESCALE, ENETC_DEV_ID_PF,
-- 
2.40.1



