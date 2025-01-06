Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2860739FCE;
	Mon,  6 Jan 2025 15:57:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736179025; cv=none; b=UfvS2HvDvn2usJ5nVLsW+cSfltahZ0rQ6TARUhkLrdpW1g35QC/Ac9eW+To6lWaQhJWTjGjRdKHkuHLpSgrzBcynZzS1LdceJ1GPR91nkoADbWBk27aRBp9eR9+IFIiWQb4bR5IrkJouwCPWCZNO7GB1dOqVXzbiOt5QFDehHX0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736179025; c=relaxed/simple;
	bh=/43JuC+WiLBEtPmtnJbm04CyuFYEUWIl9LuHH3E5epI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=rKFqtkwC2Aarf7QfGKW6KHK3DyPhmmO8z2AiM/rhfOk4LsxO78anMxfM/o8gTnfoT7p0/UneySSzP7kL0go5frluAGb/6dZa+1Dkxci0O8msd8aXC6LSlVmxICcW1L6jg6Tz1+EbXuG8JFKaKeR1AkyH66ZVWZJ9aOI4K80NKRo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=lRofcHBj; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="lRofcHBj"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5ADD2C4CED2;
	Mon,  6 Jan 2025 15:57:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1736179024;
	bh=/43JuC+WiLBEtPmtnJbm04CyuFYEUWIl9LuHH3E5epI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=lRofcHBj7MFv7XLTp5IzzMseqoXR2pBiZxiBcAZhtP5E8XEkW2I1dg+Wszptnydx/
	 kzuCTbyg8MxwMKy1gzUED5Zao3QhCUpkFhRmsWcYRa+dK0uHpqK6jx+0P5PSKU1SYv
	 O7YYKbes7kfcfOmCB4UjVDGQ97V1h2OBnuV3KQEY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Li Zhijian <lizhijian@fujitsu.com>,
	Leon Romanovsky <leon@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 139/168] RDMA/rtrs: Ensure ib_sge list is accessible
Date: Mon,  6 Jan 2025 16:17:27 +0100
Message-ID: <20250106151143.686471598@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20250106151138.451846855@linuxfoundation.org>
References: <20250106151138.451846855@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Li Zhijian <lizhijian@fujitsu.com>

[ Upstream commit fb514b31395946022f13a08e06a435f53cf9e8b3 ]

Move the declaration of the 'ib_sge list' variable outside the
'always_invalidate' block to ensure it remains accessible for use
throughout the function.

Previously, 'ib_sge list' was declared within the 'always_invalidate'
block, limiting its accessibility, then caused a
'BUG: kernel NULL pointer dereference'[1].
 ? __die_body.cold+0x19/0x27
 ? page_fault_oops+0x15a/0x2d0
 ? search_module_extables+0x19/0x60
 ? search_bpf_extables+0x5f/0x80
 ? exc_page_fault+0x7e/0x180
 ? asm_exc_page_fault+0x26/0x30
 ? memcpy_orig+0xd5/0x140
 rxe_mr_copy+0x1c3/0x200 [rdma_rxe]
 ? rxe_pool_get_index+0x4b/0x80 [rdma_rxe]
 copy_data+0xa5/0x230 [rdma_rxe]
 rxe_requester+0xd9b/0xf70 [rdma_rxe]
 ? finish_task_switch.isra.0+0x99/0x2e0
 rxe_sender+0x13/0x40 [rdma_rxe]
 do_task+0x68/0x1e0 [rdma_rxe]
 process_one_work+0x177/0x330
 worker_thread+0x252/0x390
 ? __pfx_worker_thread+0x10/0x10

This change ensures the variable is available for subsequent operations
that require it.

[1] https://lore.kernel.org/linux-rdma/6a1f3e8f-deb0-49f9-bc69-a9b03ecfcda7@fujitsu.com/

Fixes: 9cb837480424 ("RDMA/rtrs: server: main functionality")
Signed-off-by: Li Zhijian <lizhijian@fujitsu.com>
Link: https://patch.msgid.link/20241231013416.1290920-1-lizhijian@fujitsu.com
Signed-off-by: Leon Romanovsky <leon@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/infiniband/ulp/rtrs/rtrs-srv.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/infiniband/ulp/rtrs/rtrs-srv.c b/drivers/infiniband/ulp/rtrs/rtrs-srv.c
index 4fa916a8f386..96fe7c97bc71 100644
--- a/drivers/infiniband/ulp/rtrs/rtrs-srv.c
+++ b/drivers/infiniband/ulp/rtrs/rtrs-srv.c
@@ -353,6 +353,7 @@ static int send_io_resp_imm(struct rtrs_srv_con *con, struct rtrs_srv_op *id,
 	struct rtrs_srv_mr *srv_mr;
 	bool need_inval = false;
 	enum ib_send_flags flags;
+	struct ib_sge list;
 	u32 imm;
 	int err;
 
@@ -403,7 +404,6 @@ static int send_io_resp_imm(struct rtrs_srv_con *con, struct rtrs_srv_op *id,
 	imm = rtrs_to_io_rsp_imm(id->msg_id, errno, need_inval);
 	imm_wr.wr.next = NULL;
 	if (always_invalidate) {
-		struct ib_sge list;
 		struct rtrs_msg_rkey_rsp *msg;
 
 		srv_mr = &srv_path->mrs[id->msg_id];
-- 
2.39.5



