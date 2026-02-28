Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 397D035AC28
	for <patches@lists.linux.dev>; Sat, 28 Feb 2026 18:18:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772302736; cv=none; b=iA282uucHnzEUSnBD2HtYGVFWgogm9jifRYFn73RWhjwQSn+zOCvagHcXSi3XJtbciNcpa7m+I8sBLGkYeCR2qe846aiKER1DGMtQfL5M7dw4imR4zk+4Evc+OrXaGb5qldwqNbKnj2TRDKEbhzAmPOtVoMU6Vk7tmuULrpluLY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772302736; c=relaxed/simple;
	bh=SRVzYUSnhSJZM8KQCaBXUXUwWJef5QUJ8Nl814c1hHk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=uw4Y8FybFtYbfjQ//NWdQ/DOK/TDIaugLPbwJRredCRYb3iibqdgwZqfR0q9Jqo6GxC81iCspglm2AQfZ+pd4ZcvqJZtcK+sV+vgt7Zus1d7fmp5etsGfhnTk2MOnsQpBw1jeDarATZIc3d6k7ZTKWZya6b8RBZynRiGjHw3oaA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=BzKpZ5Ne; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="BzKpZ5Ne"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9E726C19423;
	Sat, 28 Feb 2026 18:18:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772302736;
	bh=SRVzYUSnhSJZM8KQCaBXUXUwWJef5QUJ8Nl814c1hHk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=BzKpZ5Ne8V6Xz8HLw1EV4nzGbwis8ChJMG+VatYq9N8ZmSLhIKUB1Vcb2Qy1EQHXW
	 pzbGqaoelabV0kDkni5Hy/zBhtNnHrYwTiKokgngNiEsloD7bYK2Uo8mWDO7qWd4Eu
	 TsQhMBOVXGOr4fGPPyV+rpRSi773dIxm40KlVXJ2x1T6Mz8NGdV2U4VGVsFc2w7pT7
	 qYheMipBOgcQP04Ra2cO0f0C9W6tNJbdbi1rmJUqvYZ6KG8LtkSwsZWXsU//tqFDnV
	 8kmPVZcLhIS5BUdo0Nl/cCdt/4Ko5MQrjpCDkshgHdUwIkbYjYLX2uiMj8CU7fP9Sl
	 Noli4u5P+HXNQ==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev
Cc: Yi Liu <liuy22@mails.tsinghua.edu.cn>,
	Leon Romanovsky <leon@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 099/147] RDMA/uverbs: Validate wqe_size before using it in ib_uverbs_post_send
Date: Sat, 28 Feb 2026 13:16:47 -0500
Message-ID: <20260228181736.1605592-99-sashal@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20260228181736.1605592-1-sashal@kernel.org>
References: <20260228181736.1605592-1-sashal@kernel.org>
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
index 6658de58b5144..cdcdafee07f68 100644
--- a/drivers/infiniband/core/uverbs_cmd.c
+++ b/drivers/infiniband/core/uverbs_cmd.c
@@ -2017,7 +2017,10 @@ static int ib_uverbs_post_send(struct uverbs_attr_bundle *attrs)
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

