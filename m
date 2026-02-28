Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0448C345752
	for <patches@lists.linux.dev>; Sat, 28 Feb 2026 18:04:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772301858; cv=none; b=eqc0Mtkcs0YT+//ZPWyXxm/WVPRgqaELBsrvPFZ86VHYcEpGhb7OUKm6IvhSsX45lSRNeax4179PjULdI+2DwmG/vID++Hqdr+0QntOPu5675DPkVWHaWxRcG8/4OVjwVMNn0GOd+YdJ5JwgXRcGKy+4SRp6UtuJuvfjOb7evJU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772301858; c=relaxed/simple;
	bh=uM4pQmbTJsRiLHgF6NXNd0EYxAtnU4WF9gmIOO8SioM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=YDv7rf/uTQ2DxAD1y0qJ1KB5T2fImoIe8GvDEm0jQccY5BJCnYhGzEQHaWDI7WOspznTxs6AKhwBlljuBqWGuMVSUp88rAIU86mc7gWYA78eudyv6nFuP329DE7Kkq2cxuEyRHlsQ2nw6aWlRk6dtBDiUTn/39jAQ867qhA9528=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=PcK+7aiy; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="PcK+7aiy"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6614BC19424;
	Sat, 28 Feb 2026 18:04:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772301857;
	bh=uM4pQmbTJsRiLHgF6NXNd0EYxAtnU4WF9gmIOO8SioM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=PcK+7aiyTPcUN/wbTsU4woTs2JOQ35H2nCCAaGGtobi8zbdNF0mNYfSRarjl2eqwJ
	 wYiOhaahRGsCi/elqstmWAlnLVY37oHYEWU3D5hlmSj5RgxfV00uvpnMJYmRgcGpYr
	 TT5N5VfkRObiZQzy0+CkIgfilWeu3Qgm5XjHbK2A+MIQPqsJ28Ax+RDn948qHp1Q22
	 JwQnZF1COGv2t0AvZ8g/fB2AzyXUVy92OA+4dWkipfXXnP26/u5fucR8EFIqz43Vxx
	 qp344cTwh2pToLUlsH6fwv1E1hY/1Wytb1lV52kqwF/6jRQ16Rnqh9A1aW6TXQUVqQ
	 BhlW2LY921qYA==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev
Cc: Yi Liu <liuy22@mails.tsinghua.edu.cn>,
	Leon Romanovsky <leon@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 279/385] RDMA/uverbs: Validate wqe_size before using it in ib_uverbs_post_send
Date: Sat, 28 Feb 2026 12:58:21 -0500
Message-ID: <20260228180011.1568201-279-sashal@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20260228180011.1568201-1-sashal@kernel.org>
References: <20260228180011.1568201-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit

From: Yi Liu <liuy22@mails.tsinghua.edu.cn>

[ Upstream commit 1956f0a74ccf5dc9c3ef717f2985c3ed3400aab0 ]

ib_uverbs_post_send() uses cmd.wqe_size from userspace without any
validation before passing it to kmalloc() and using the allocated
buffer as struct ib_uverbs_send_wr.

If a user provides a small wqe_size value (e.g., 1), kmalloc() will
succeed, but subsequent accesses to user_wr->opcode, user_wr->num_sge,
and other fields will read beyond the allocated buffer, resulting in
an out-of-bounds read from kernel heap memory. This could potentially
leak sensitive kernel information to userspace.

Additionally, providing an excessively large wqe_size can trigger a
WARNING in the memory allocation path, as reported by syzkaller.

This is inconsistent with ib_uverbs_unmarshall_recv() which properly
validates that wqe_size >= sizeof(struct ib_uverbs_recv_wr) before
proceeding.

Add the same validation for ib_uverbs_post_send() to ensure wqe_size
is at least sizeof(struct ib_uverbs_send_wr).

Fixes: c3bea3d2dc53 ("RDMA/uverbs: Use the iterator for ib_uverbs_unmarshall_recv()")
Signed-off-by: Yi Liu <liuy22@mails.tsinghua.edu.cn>
Link: https://patch.msgid.link/20260122142900.2356276-2-liuy22@mails.tsinghua.edu.cn
Signed-off-by: Leon Romanovsky <leon@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/infiniband/core/uverbs_cmd.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/drivers/infiniband/core/uverbs_cmd.c b/drivers/infiniband/core/uverbs_cmd.c
index 535bb99ed9f5f..2c1eb8a45f673 100644
--- a/drivers/infiniband/core/uverbs_cmd.c
+++ b/drivers/infiniband/core/uverbs_cmd.c
@@ -2031,7 +2031,10 @@ static int ib_uverbs_post_send(struct uverbs_attr_bundle *attrs)
 	if (ret)
 		return ret;
 
-	user_wr = kmalloc(cmd.wqe_size, GFP_KERNEL);
+	if (cmd.wqe_size < sizeof(struct ib_uverbs_send_wr))
+		return -EINVAL;
+
+	user_wr = kmalloc(cmd.wqe_size, GFP_KERNEL | __GFP_NOWARN);
 	if (!user_wr)
 		return -ENOMEM;
 
-- 
2.51.0

