Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 97B6B6E5ED;
	Wed,  3 Jul 2024 11:27:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1720006066; cv=none; b=IT87d/fb5E1B+5bwLZMquaEHxIt1QHYKQVS813n2wEFP8HTzBTDX/w2DS6BhEa0UTZlJ2yqmuYQfRwm1yDgKNl9RfAWnuo9xMUExxal3TOz1HsmC4uVD+UpO9Jm3VwC0so0e76Tyvej8tMYqQjktya0tFUWYkQZx/0Qf27oeL4A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1720006066; c=relaxed/simple;
	bh=iO3gQu/8k3epDqhKEZ2dOksj8CINph2E4wUgqOcwhNE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=EgYi0NAiMuwp9t3istLRc9jZVxlUWxFW4ucplxqBb4QMUZV50W5+fZ02NG9pu591t0C5mjOkwk990QnY1Se9cOgSnmxHPnhi3Ouvunrat9VJ5egyFjnuXd6y2bxIgqTxYw0F+xIgiLEJzw305xlT0WWSfp0L0nHI8M21RHPt/zQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=zuNCMUt0; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="zuNCMUt0"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1EBF6C2BD10;
	Wed,  3 Jul 2024 11:27:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1720006066;
	bh=iO3gQu/8k3epDqhKEZ2dOksj8CINph2E4wUgqOcwhNE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=zuNCMUt0w9yEtCoQh/Sokd+akoEOZrpHBTSduEG/Ir14qT02nRUZN3xfXM8utT85d
	 mDGS7sNfCn7KFAuyZE0VU33wu6SYHM2IVKmjH5Si6BiiadcgtUUXKk7bNG/urMLg7f
	 tKGWkcf+8oV7PZ9hCtkmpQkm2/k9wScQ9DP/Ee3w=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Wenchao Hao <haowenchao2@huawei.com>,
	Leon Romanovsky <leon@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 290/356] RDMA/restrack: Fix potential invalid address access
Date: Wed,  3 Jul 2024 12:40:26 +0200
Message-ID: <20240703102924.091282889@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240703102913.093882413@linuxfoundation.org>
References: <20240703102913.093882413@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Wenchao Hao <haowenchao2@huawei.com>

[ Upstream commit ca537a34775c103f7b14d7bbd976403f1d1525d8 ]

struct rdma_restrack_entry's kern_name was set to KBUILD_MODNAME
in ib_create_cq(), while if the module exited but forgot del this
rdma_restrack_entry, it would cause a invalid address access in
rdma_restrack_clean() when print the owner of this rdma_restrack_entry.

These code is used to help find one forgotten PD release in one of the
ULPs. But it is not needed anymore, so delete them.

Signed-off-by: Wenchao Hao <haowenchao2@huawei.com>
Link: https://lore.kernel.org/r/20240318092320.1215235-1-haowenchao2@huawei.com
Signed-off-by: Leon Romanovsky <leon@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/infiniband/core/restrack.c | 51 +-----------------------------
 1 file changed, 1 insertion(+), 50 deletions(-)

diff --git a/drivers/infiniband/core/restrack.c b/drivers/infiniband/core/restrack.c
index 01a499a8b88db..438ed35881752 100644
--- a/drivers/infiniband/core/restrack.c
+++ b/drivers/infiniband/core/restrack.c
@@ -37,22 +37,6 @@ int rdma_restrack_init(struct ib_device *dev)
 	return 0;
 }
 
-static const char *type2str(enum rdma_restrack_type type)
-{
-	static const char * const names[RDMA_RESTRACK_MAX] = {
-		[RDMA_RESTRACK_PD] = "PD",
-		[RDMA_RESTRACK_CQ] = "CQ",
-		[RDMA_RESTRACK_QP] = "QP",
-		[RDMA_RESTRACK_CM_ID] = "CM_ID",
-		[RDMA_RESTRACK_MR] = "MR",
-		[RDMA_RESTRACK_CTX] = "CTX",
-		[RDMA_RESTRACK_COUNTER] = "COUNTER",
-		[RDMA_RESTRACK_SRQ] = "SRQ",
-	};
-
-	return names[type];
-};
-
 /**
  * rdma_restrack_clean() - clean resource tracking
  * @dev:  IB device
@@ -60,47 +44,14 @@ static const char *type2str(enum rdma_restrack_type type)
 void rdma_restrack_clean(struct ib_device *dev)
 {
 	struct rdma_restrack_root *rt = dev->res;
-	struct rdma_restrack_entry *e;
-	char buf[TASK_COMM_LEN];
-	bool found = false;
-	const char *owner;
 	int i;
 
 	for (i = 0 ; i < RDMA_RESTRACK_MAX; i++) {
 		struct xarray *xa = &dev->res[i].xa;
 
-		if (!xa_empty(xa)) {
-			unsigned long index;
-
-			if (!found) {
-				pr_err("restrack: %s", CUT_HERE);
-				dev_err(&dev->dev, "BUG: RESTRACK detected leak of resources\n");
-			}
-			xa_for_each(xa, index, e) {
-				if (rdma_is_kernel_res(e)) {
-					owner = e->kern_name;
-				} else {
-					/*
-					 * There is no need to call get_task_struct here,
-					 * because we can be here only if there are more
-					 * get_task_struct() call than put_task_struct().
-					 */
-					get_task_comm(buf, e->task);
-					owner = buf;
-				}
-
-				pr_err("restrack: %s %s object allocated by %s is not freed\n",
-				       rdma_is_kernel_res(e) ? "Kernel" :
-							       "User",
-				       type2str(e->type), owner);
-			}
-			found = true;
-		}
+		WARN_ON(!xa_empty(xa));
 		xa_destroy(xa);
 	}
-	if (found)
-		pr_err("restrack: %s", CUT_HERE);
-
 	kfree(rt);
 }
 
-- 
2.43.0



