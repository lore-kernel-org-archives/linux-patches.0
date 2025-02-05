Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 62E1B18732B;
	Wed,  5 Feb 2025 14:41:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738766483; cv=none; b=tzMSr7h9EIPXUpqiL5tanlmlCYSfhxRJX5F4LdBFXTYlQlhPGrfrbecxAn1gNhJszLJPp0GtU6EXBvS+QmTsxHA+7s0xpP4IC/JIPJIdITfiXs6tX/R8t8xX0XeXe7tB7oiDhNSxUE6aCC1XxlH68MhnzprHLp8EjSTJhG7RMII=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738766483; c=relaxed/simple;
	bh=j58eF9bOpuxNVPaZkKZYn7oJaMeYQhtxxJmB/MN7Luo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=edvodFh3N9wkiVaRatPlTr15wqonEbG6UXENuWtg0p2TAs4d8h/RMfGKkjWVLbYLBr8xY0nP5kRdFPqHS+UJKjzOWqaJ/zmtXY2xZjLQPBalk5+MbkcKOyxNkYJvvs7ROUuMjY+dQhuIJfBOxo/kpjw10NwTqQ5YH8lmUce+XS0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=p4hZsybd; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="p4hZsybd"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 564D8C4CEE2;
	Wed,  5 Feb 2025 14:41:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1738766482;
	bh=j58eF9bOpuxNVPaZkKZYn7oJaMeYQhtxxJmB/MN7Luo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=p4hZsybdU/SqAFb0CnV2XzUZTTD83DQXutChB9LyiWUHE3MYD28xdC/1pXx0msndy
	 NrnM3l0QX3/91xw+liDSVKrG69VyhzsZFSNTrZv9ogHXPuPA725Rdwbj4kdrxSCBJW
	 B2BVn1cgYglo5zM92jzMeRTyc+3l0tEHYF8jO6r4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	zhenwei pi <pizhenwei@bytedance.com>,
	Leon Romanovsky <leon@kernel.org>,
	Sasha Levin <sashal@kernel.org>,
	Zhu Yanjun <yanjun.zhu@linux.dev>
Subject: [PATCH 6.12 328/590] RDMA/rxe: Fix mismatched max_msg_sz
Date: Wed,  5 Feb 2025 14:41:23 +0100
Message-ID: <20250205134507.822967728@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250205134455.220373560@linuxfoundation.org>
References: <20250205134455.220373560@linuxfoundation.org>
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

From: zhenwei pi <pizhenwei@bytedance.com>

[ Upstream commit db03b70969aab4ef111a3369cfd90ea4da3a6aa0 ]

User mode queries max_msg_sz as 0x800000 by command 'ibv_devinfo -v',
however ibv_post_send/ibv_post_recv has a limit of 2^31. Fix this
mismatched information.

Signed-off-by: zhenwei pi <pizhenwei@bytedance.com>
Fixes: f605f26ea196 ("RDMA/rxe: Protect QP state with qp->state_lock")
Fixes: 5bf944f24129 ("RDMA/rxe: Add error messages")
Link: https://patch.msgid.link/20241216121953.765331-1-pizhenwei@bytedance.com
Review-by: Zhu Yanjun <yanjun.zhu@linux.dev>
Signed-off-by: Leon Romanovsky <leon@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/infiniband/sw/rxe/rxe_param.h | 2 +-
 drivers/infiniband/sw/rxe/rxe_verbs.c | 5 ++---
 2 files changed, 3 insertions(+), 4 deletions(-)

diff --git a/drivers/infiniband/sw/rxe/rxe_param.h b/drivers/infiniband/sw/rxe/rxe_param.h
index d2f57ead78ad1..003f681e5dc02 100644
--- a/drivers/infiniband/sw/rxe/rxe_param.h
+++ b/drivers/infiniband/sw/rxe/rxe_param.h
@@ -129,7 +129,7 @@ enum rxe_device_param {
 enum rxe_port_param {
 	RXE_PORT_GID_TBL_LEN		= 1024,
 	RXE_PORT_PORT_CAP_FLAGS		= IB_PORT_CM_SUP,
-	RXE_PORT_MAX_MSG_SZ		= 0x800000,
+	RXE_PORT_MAX_MSG_SZ		= (1UL << 31),
 	RXE_PORT_BAD_PKEY_CNTR		= 0,
 	RXE_PORT_QKEY_VIOL_CNTR		= 0,
 	RXE_PORT_LID			= 0,
diff --git a/drivers/infiniband/sw/rxe/rxe_verbs.c b/drivers/infiniband/sw/rxe/rxe_verbs.c
index 8a5fc20fd1869..589ac0d8489db 100644
--- a/drivers/infiniband/sw/rxe/rxe_verbs.c
+++ b/drivers/infiniband/sw/rxe/rxe_verbs.c
@@ -696,7 +696,7 @@ static int validate_send_wr(struct rxe_qp *qp, const struct ib_send_wr *ibwr,
 		for (i = 0; i < ibwr->num_sge; i++)
 			length += ibwr->sg_list[i].length;
 
-		if (length > (1UL << 31)) {
+		if (length > RXE_PORT_MAX_MSG_SZ) {
 			rxe_err_qp(qp, "message length too long\n");
 			break;
 		}
@@ -980,8 +980,7 @@ static int post_one_recv(struct rxe_rq *rq, const struct ib_recv_wr *ibwr)
 	for (i = 0; i < num_sge; i++)
 		length += ibwr->sg_list[i].length;
 
-	/* IBA max message size is 2^31 */
-	if (length >= (1UL<<31)) {
+	if (length > RXE_PORT_MAX_MSG_SZ) {
 		err = -EINVAL;
 		rxe_dbg("message length too long\n");
 		goto err_out;
-- 
2.39.5



