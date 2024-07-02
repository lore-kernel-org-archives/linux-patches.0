Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5DE8D16B394;
	Tue,  2 Jul 2024 17:29:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719941373; cv=none; b=RfAippIExZWUg4LPzaJYH5HxcxcMxjvVLtwhwEIjZdHuBb9tusAD3Hb61LEJkVgnk+vcrKEwVPlqHdzosavy/lLiVO9i0bi1ryrK2kcFR4AiXWwp8HmjPyb9uwSrYV3Xs6Ros3CTLp3MBjCCOBuN5DJesRHSIHzcKo8e1QJEWsA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719941373; c=relaxed/simple;
	bh=MZXnwV/si+ydrkNSG70296+OXMhSJ5aK6WkEVMF6wtc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=CWmxFkzKEeqLffrCI8jUAVKBuaUoKs5xhucQnt6acwmaQ6/3Kkg/hfFI1MyGF8PxChgSi5X4al7r6vo6RpVl7oif8Hu+sJWxlrqhY96rbJW3S+QZkd6x9rj+XyWFa3g1ecHitpju8W/mnQ99tw3824SccgGTj7jRSqyWW+O3yNw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=H/tsRnQ6; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="H/tsRnQ6"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C46A5C116B1;
	Tue,  2 Jul 2024 17:29:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1719941373;
	bh=MZXnwV/si+ydrkNSG70296+OXMhSJ5aK6WkEVMF6wtc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=H/tsRnQ63uXIUs4SSf4aojLkLOfveisx44RXhFNgn0hZmKpYsGQITxiQRXQHIX8R/
	 39wuMJvXKpWLH7X1jxmsZmtoS2pEFZNKHyVB5KuDoR+/O/6BeKSHoNvoUvIv/isKtD
	 m3E6HpDgmgXmB2fMX+2ggKBCFWz2bZMg4vmMF/Vo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Wenchao Hao <haowenchao2@huawei.com>,
	Leon Romanovsky <leon@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 045/128] RDMA/restrack: Fix potential invalid address access
Date: Tue,  2 Jul 2024 19:04:06 +0200
Message-ID: <20240702170227.938440198@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240702170226.231899085@linuxfoundation.org>
References: <20240702170226.231899085@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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



