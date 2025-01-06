Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6CCAE1DEFDA;
	Mon,  6 Jan 2025 15:46:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736178418; cv=none; b=JdTvAUqTIUciYKd8vi9HCvKSZy2YWYVihD9dA1GxXrLAuhtvdlenpPIW7Q7QcKs6QyWg4QLJIgRj4+GQak1VZC6Tp3Ov5/KtIITWGnt437cERWcVFpIcSXPo270o+iVLBNI5us7kCw6YivxCqooV8W7QRJJvCjuLGFbuGELcl9o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736178418; c=relaxed/simple;
	bh=yAGYYyZCxdvAU4I9SGs9j5EK7LGots+tMmwrE6ZTqlg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=YTTh3DA7GTII7VK+YFftgd/dcHEthC9CkfDVZjmK+uild+pzMfQa7eCDXrWpzSUtgsNZSyrAbOrziiXZllhw/+uwQd4RZAqqd2Cp1OydVw4GwTeQwoKtuxKJdX2KR3xCeBnwr750C6d/vzA/gkkTGpKiapcfQJCO/EvFWvyziR4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ZrEYYxpW; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ZrEYYxpW"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C55EBC4CED2;
	Mon,  6 Jan 2025 15:46:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1736178418;
	bh=yAGYYyZCxdvAU4I9SGs9j5EK7LGots+tMmwrE6ZTqlg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ZrEYYxpWwcnNKB3r+M1XwIpNFHPnUVs+p583K0vZo/PZPTpMPbS/VMZGnXTIiSeID
	 V+2qG4Q0mKL9BmLstV1jrtkjYONLJgLciQxsOxCYMZkNYGGZl7N8RoAxIr5kQcxwR0
	 S/3GXzONl/9VxihhJ2+g/DM6yxfIPuI8c9A/7S38=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Li Zhijian <lizhijian@fujitsu.com>,
	Leon Romanovsky <leon@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 111/138] RDMA/rtrs: Ensure ib_sge list is accessible
Date: Mon,  6 Jan 2025 16:17:15 +0100
Message-ID: <20250106151137.430529782@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20250106151133.209718681@linuxfoundation.org>
References: <20250106151133.209718681@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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
index b152a742cd3c..2b315974f478 100644
--- a/drivers/infiniband/ulp/rtrs/rtrs-srv.c
+++ b/drivers/infiniband/ulp/rtrs/rtrs-srv.c
@@ -381,6 +381,7 @@ static int send_io_resp_imm(struct rtrs_srv_con *con, struct rtrs_srv_op *id,
 	struct rtrs_srv_mr *srv_mr;
 	bool need_inval = false;
 	enum ib_send_flags flags;
+	struct ib_sge list;
 	u32 imm;
 	int err;
 
@@ -431,7 +432,6 @@ static int send_io_resp_imm(struct rtrs_srv_con *con, struct rtrs_srv_op *id,
 	imm = rtrs_to_io_rsp_imm(id->msg_id, errno, need_inval);
 	imm_wr.wr.next = NULL;
 	if (always_invalidate) {
-		struct ib_sge list;
 		struct rtrs_msg_rkey_rsp *msg;
 
 		srv_mr = &sess->mrs[id->msg_id];
-- 
2.39.5



