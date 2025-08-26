Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 619D92BE653;
	Tue, 26 Aug 2025 11:31:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756207905; cv=none; b=S8iI4hd0LQry1I8ag7Jt6crcXFrZH16PU2k9cHXsXZU4BqEf6+A4QjRjTvXeAcQJigRl1O7VAJx6quJ9UlG61k0vXTQkhM092cGnZwOpLe9l0rWy16T6qva1RzOT2HeNbD+JqmxcvvB114hxRakzULQcM9RyQF2z1KGv7nC2RDk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756207905; c=relaxed/simple;
	bh=G5HGdxerMr20fvPw/jLWfpg4taL7G6dHxyLfKmdZy3s=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=VGLz9i09B9AbpmqH+9y/0wfKUCbuePJ18kxPaY8pGwOeUL9BBCNi0b5h2/Tlw6oCVy2b3b0ocyPG7suTUZhP5sKRXCdX7aiOmB/sv+evtlHIHb8k71VS9zWwdKyeVmvWy1ITXP0+rnaWVSsu97HWcGKRFaTut1e5nBE3qY/ZMwo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=wdJPeM6T; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="wdJPeM6T"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E6FCCC4CEF1;
	Tue, 26 Aug 2025 11:31:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1756207905;
	bh=G5HGdxerMr20fvPw/jLWfpg4taL7G6dHxyLfKmdZy3s=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=wdJPeM6Tb3e+sa1oB7b5CBYmqlDl8QKJoBTR/CevhczbOUxzDZD43kTcs2dZKi1K0
	 ePYgyU+MewxWZXNzQ3NI/Dnk9i8rvIi11NBEmMVdDs2x0zojfp3RdiGdqpfpMWS/Vh
	 YUDJHHKUUVcRzURERZ8DnBmipwbd7g7vFoiN2bws=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Kalesh AP <kalesh-anakkur.purayil@broadcom.com>,
	Sriharsha Basavapatna <sriharsha.basavapatna@broadcom.com>,
	Leon Romanovsky <leon@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.16 363/457] RDMA/bnxt_re: Fix a possible memory leak in the driver
Date: Tue, 26 Aug 2025 13:10:47 +0200
Message-ID: <20250826110946.281246411@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250826110937.289866482@linuxfoundation.org>
References: <20250826110937.289866482@linuxfoundation.org>
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

6.16-stable review patch.  If anyone has any objections, please let me know.

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
index 293b0a96c8e3..df7cf8d68e27 100644
--- a/drivers/infiniband/hw/bnxt_re/main.c
+++ b/drivers/infiniband/hw/bnxt_re/main.c
@@ -2017,6 +2017,28 @@ static void bnxt_re_free_nqr_mem(struct bnxt_re_dev *rdev)
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
@@ -2030,6 +2052,7 @@ static void bnxt_re_dev_uninit(struct bnxt_re_dev *rdev, u8 op_type)
 	if (test_and_clear_bit(BNXT_RE_FLAG_QOS_WORK_REG, &rdev->flags))
 		cancel_delayed_work_sync(&rdev->worker);
 
+	bnxt_re_free_gid_ctx(rdev);
 	if (test_and_clear_bit(BNXT_RE_FLAG_RESOURCES_INITIALIZED,
 			       &rdev->flags))
 		bnxt_re_cleanup_res(rdev);
-- 
2.50.1



