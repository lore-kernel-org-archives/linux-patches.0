Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6F5F1267386;
	Tue, 26 Aug 2025 11:47:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756208853; cv=none; b=ITNhdWeljcYUmjZcsDPy+M9lKmqKamHOVq1Z2/qkYcS/OeSKiGhJUStxvr9WYYA8flpMVe7BjRDiFR5CN+u7wN1kjHdZnds+RZfDMkMhT8W25pgDcaq2a+PB6D9xKOYBBqx/dASPL13J3EJvhxLJGJKLdKQaWZDOjZ9A9bJEXig=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756208853; c=relaxed/simple;
	bh=x565+mLhXAk/RpQ+XFomNOcT+Z1ADobaJxGxeojc350=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=bbHdEVdzXfxHKZCZcKD09K96SeUwWZ6y+t9WF6fjfaiNdF8HUIlPqHH4RKoN9tbzIcNJhFZB+ut5n+KHpRoCbMWdkeSb3WbxFCkKQyRBmMlW2qXNCPw5mfnF+oPvIz6K9vZOQx124IGp4eJyf0JmCETQlMDL49eDCdHTFun9wjY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=SyM5+Jg6; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="SyM5+Jg6"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F3AECC4CEF4;
	Tue, 26 Aug 2025 11:47:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1756208853;
	bh=x565+mLhXAk/RpQ+XFomNOcT+Z1ADobaJxGxeojc350=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=SyM5+Jg6gVbhnC7cXx/mZy6p+rGP6KOVGLofW7cDjxjHH4JA086lQRzhob5OVtVZ+
	 SZl/gthbQ+C1uEHr/dEsqmjPV9J3o/4KlXjOckqWtzq7DAeMKJ1DjUogZfpkr665VG
	 8xG76pPHGMEAZfHxtGb8MeOixl00UtzXcOHnj9hQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Kalesh AP <kalesh-anakkur.purayil@broadcom.com>,
	Sriharsha Basavapatna <sriharsha.basavapatna@broadcom.com>,
	Leon Romanovsky <leon@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 269/322] RDMA/bnxt_re: Fix a possible memory leak in the driver
Date: Tue, 26 Aug 2025 13:11:24 +0200
Message-ID: <20250826110922.571926668@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250826110915.169062587@linuxfoundation.org>
References: <20250826110915.169062587@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Kalesh AP <kalesh-anakkur.purayil@broadcom.com>

[ Upstream commit ba60a1e8cbbd396c69ff9c8bc3242f5ab133e38a ]

The GID context reuse logic requires the context memory to be
not freed if and when DEL_GID firmware command fails. But, if
there's no subsequent ADD_GID to reuse it, the context memory
must be freed when the driver is unloaded. Otherwise it leads
to a memory leak.

Below is the kmemleak trace reported:

unreferenced object 0xffff88817a4f34d0 (size 8):
  comm "insmod", pid 1072504, jiffies 4402561550
  hex dump (first 8 bytes):
  01 00 00 00 00 00 00 00                          ........
  backtrace (crc ccaa009e):
  __kmalloc_cache_noprof+0x33e/0x400
  0xffffffffc2db9d48
  add_modify_gid+0x5e0/0xb60 [ib_core]
  __ib_cache_gid_add+0x213/0x350 [ib_core]
  update_gid+0xf2/0x180 [ib_core]
  enum_netdev_ipv4_ips+0x3f3/0x690 [ib_core]
  enum_all_gids_of_dev_cb+0x125/0x1b0 [ib_core]
  ib_enum_roce_netdev+0x14b/0x250 [ib_core]
  ib_cache_setup_one+0x2e5/0x540 [ib_core]
  ib_register_device+0x82c/0xf10 [ib_core]
  0xffffffffc2df5ad9
  0xffffffffc2da8b07
  0xffffffffc2db174d
  auxiliary_bus_probe+0xa5/0x120
  really_probe+0x1e4/0x850
  __driver_probe_device+0x18f/0x3d0

Fixes: 4a62c5e9e2e1 ("RDMA/bnxt_re: Do not free the ctx_tbl entry if delete GID fails")
Signed-off-by: Kalesh AP <kalesh-anakkur.purayil@broadcom.com>
Link: https://patch.msgid.link/20250805101000.233310-4-kalesh-anakkur.purayil@broadcom.com
Reviewed-by: Sriharsha Basavapatna <sriharsha.basavapatna@broadcom.com>
Signed-off-by: Leon Romanovsky <leon@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/infiniband/hw/bnxt_re/main.c | 23 +++++++++++++++++++++++
 1 file changed, 23 insertions(+)

diff --git a/drivers/infiniband/hw/bnxt_re/main.c b/drivers/infiniband/hw/bnxt_re/main.c
index 9bd837a5b8a1..b213ecca2854 100644
--- a/drivers/infiniband/hw/bnxt_re/main.c
+++ b/drivers/infiniband/hw/bnxt_re/main.c
@@ -1615,6 +1615,28 @@ static void bnxt_re_free_nqr_mem(struct bnxt_re_dev *rdev)
 	rdev->nqr = NULL;
 }
 
+/* When DEL_GID fails, driver is not freeing GID ctx memory.
+ * To avoid the memory leak, free the memory during unload
+ */
+static void bnxt_re_free_gid_ctx(struct bnxt_re_dev *rdev)
+{
+	struct bnxt_qplib_sgid_tbl *sgid_tbl = &rdev->qplib_res.sgid_tbl;
+	struct bnxt_re_gid_ctx *ctx, **ctx_tbl;
+	int i;
+
+	if (!sgid_tbl->active)
+		return;
+
+	ctx_tbl = sgid_tbl->ctx;
+	for (i = 0; i < sgid_tbl->max; i++) {
+		if (sgid_tbl->hw_id[i] == 0xFFFF)
+			continue;
+
+		ctx = ctx_tbl[i];
+		kfree(ctx);
+	}
+}
+
 static void bnxt_re_dev_uninit(struct bnxt_re_dev *rdev, u8 op_type)
 {
 	u8 type;
@@ -1623,6 +1645,7 @@ static void bnxt_re_dev_uninit(struct bnxt_re_dev *rdev, u8 op_type)
 	if (test_and_clear_bit(BNXT_RE_FLAG_QOS_WORK_REG, &rdev->flags))
 		cancel_delayed_work_sync(&rdev->worker);
 
+	bnxt_re_free_gid_ctx(rdev);
 	if (test_and_clear_bit(BNXT_RE_FLAG_RESOURCES_INITIALIZED,
 			       &rdev->flags))
 		bnxt_re_cleanup_res(rdev);
-- 
2.50.1



