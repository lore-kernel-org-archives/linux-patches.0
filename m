Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DD5F7168AD
	for <patches@lists.linux.dev>; Mon,  8 May 2023 11:23:09 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 46013C4339E;
	Mon,  8 May 2023 11:23:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1683544989;
	bh=ZWSsbtjvn51hD3F/mhWjOTtUVCLJaFCrwRlHmU/IgJo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=qhh/d9z5VGvzXWHpS7pNQN0CJzofVlGxud51s0FSaltjtKFiOBqdoakCJCxCjvh/X
	 QJdV2F0VsLR8iVEPVrq7mivR19aK8BFctThROfUW6/l4AvsxGoSs3nKOOwDpiPeGuR
	 7MgiYl/2i7FXCmfNXNcshNHacsbRE30ULSWGCNDo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Bob Pearson <rpearsonhpe@gmail.com>,
	Jason Gunthorpe <jgg@nvidia.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.3 589/694] RDMA/rxe: Replace exists by rxe in rxe.c
Date: Mon,  8 May 2023 11:47:04 +0200
Message-Id: <20230508094454.181637121@linuxfoundation.org>
X-Mailer: git-send-email 2.40.1
In-Reply-To: <20230508094432.603705160@linuxfoundation.org>
References: <20230508094432.603705160@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Bob Pearson <rpearsonhpe@gmail.com>

[ Upstream commit 9168d125ea032ad199275193493c13cb077da5cc ]

'exists' looks like a boolean. This patch replaces it by the
normal name used for the rxe device, 'rxe', which should be a
little less confusing. The second rxe_dbg() message is
incorrect since rxe is known to be NULL and this will cause a
seg fault if this message were ever sent. Replace it by pr_debug
for the moment.

Fixes: c6aba5ea0055 ("RDMA/rxe: Replace pr_xxx by rxe_dbg_xxx in rxe.c")
Link: https://lore.kernel.org/r/20230303221623.8053-2-rpearsonhpe@gmail.com
Signed-off-by: Bob Pearson <rpearsonhpe@gmail.com>
Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/infiniband/sw/rxe/rxe.c | 12 ++++++------
 1 file changed, 6 insertions(+), 6 deletions(-)

diff --git a/drivers/infiniband/sw/rxe/rxe.c b/drivers/infiniband/sw/rxe/rxe.c
index 136c2efe34660..a3f05fdd9fac2 100644
--- a/drivers/infiniband/sw/rxe/rxe.c
+++ b/drivers/infiniband/sw/rxe/rxe.c
@@ -175,7 +175,7 @@ int rxe_add(struct rxe_dev *rxe, unsigned int mtu, const char *ibdev_name)
 
 static int rxe_newlink(const char *ibdev_name, struct net_device *ndev)
 {
-	struct rxe_dev *exists;
+	struct rxe_dev *rxe;
 	int err = 0;
 
 	if (is_vlan_dev(ndev)) {
@@ -184,17 +184,17 @@ static int rxe_newlink(const char *ibdev_name, struct net_device *ndev)
 		goto err;
 	}
 
-	exists = rxe_get_dev_from_net(ndev);
-	if (exists) {
-		ib_device_put(&exists->ib_dev);
-		rxe_dbg(exists, "already configured on %s\n", ndev->name);
+	rxe = rxe_get_dev_from_net(ndev);
+	if (rxe) {
+		ib_device_put(&rxe->ib_dev);
+		rxe_dbg(rxe, "already configured on %s\n", ndev->name);
 		err = -EEXIST;
 		goto err;
 	}
 
 	err = rxe_net_add(ibdev_name, ndev);
 	if (err) {
-		rxe_dbg(exists, "failed to add %s\n", ndev->name);
+		pr_debug("failed to add %s\n", ndev->name);
 		goto err;
 	}
 err:
-- 
2.39.2



