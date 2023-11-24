Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5803739FD9;
	Fri, 24 Nov 2023 18:12:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="wZi1HgwN"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7AEAEC433C7;
	Fri, 24 Nov 2023 18:12:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1700849533;
	bh=umujtV0txZCrbd9Cf5KY5GwtRbgvZnX1Oqj2a4OyKZs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=wZi1HgwNQglLUMvCrDgWXFgbppf/rtODH9MBG0PrzXEnIjHqiJcYTPRLmsNJ6GUul
	 9ufWzFNbqQslqn8BqPzftMeS/Ak27PK0tmELAQNi5RONpp+9XboZuzM4gvSQ9YSVXM
	 cfpRnrWGrgKU4+u2/wsru+gnDjc4GTIrQGQl/wPU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jan Kiszka <jan.kiszka@siemens.com>,
	Wojciech Drewek <wojciech.drewek@intel.com>,
	MD Danish Anwar <danishanwar@ti.com>,
	Roger Quadros <rogerq@kernel.org>,
	"David S. Miller" <davem@davemloft.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 185/530] net: ti: icssg-prueth: Add missing icss_iep_put to error path
Date: Fri, 24 Nov 2023 17:45:51 +0000
Message-ID: <20231124172033.707074563@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20231124172028.107505484@linuxfoundation.org>
References: <20231124172028.107505484@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jan Kiszka <jan.kiszka@siemens.com>

[ Upstream commit e409d7346648c9acff84c3cc8d291767ee2d5326 ]

Analogously to prueth_remove, just also taking care for NULL'ing the
iep pointers.

Fixes: 186734c15886 ("net: ti: icssg-prueth: add packet timestamping and ptp support")
Fixes: 443a2367ba3c ("net: ti: icssg-prueth: am65x SR2.0 add 10M full duplex support")
Signed-off-by: Jan Kiszka <jan.kiszka@siemens.com>
Reviewed-by: Wojciech Drewek <wojciech.drewek@intel.com>
Reviewed-by: MD Danish Anwar <danishanwar@ti.com>
Reviewed-by: Roger Quadros <rogerq@kernel.org>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/ti/icssg/icssg_prueth.c | 11 +++++++----
 1 file changed, 7 insertions(+), 4 deletions(-)

diff --git a/drivers/net/ethernet/ti/icssg/icssg_prueth.c b/drivers/net/ethernet/ti/icssg/icssg_prueth.c
index 4914d0ef58e9b..71d3001ec1ef8 100644
--- a/drivers/net/ethernet/ti/icssg/icssg_prueth.c
+++ b/drivers/net/ethernet/ti/icssg/icssg_prueth.c
@@ -2092,10 +2092,7 @@ static int prueth_probe(struct platform_device *pdev)
 	prueth->iep1 = icss_iep_get_idx(np, 1);
 	if (IS_ERR(prueth->iep1)) {
 		ret = dev_err_probe(dev, PTR_ERR(prueth->iep1), "iep1 get failed\n");
-		icss_iep_put(prueth->iep0);
-		prueth->iep0 = NULL;
-		prueth->iep1 = NULL;
-		goto free_pool;
+		goto put_iep0;
 	}
 
 	if (prueth->pdata.quirk_10m_link_issue) {
@@ -2185,6 +2182,12 @@ static int prueth_probe(struct platform_device *pdev)
 exit_iep:
 	if (prueth->pdata.quirk_10m_link_issue)
 		icss_iep_exit_fw(prueth->iep1);
+	icss_iep_put(prueth->iep1);
+
+put_iep0:
+	icss_iep_put(prueth->iep0);
+	prueth->iep0 = NULL;
+	prueth->iep1 = NULL;
 
 free_pool:
 	gen_pool_free(prueth->sram_pool,
-- 
2.42.0



