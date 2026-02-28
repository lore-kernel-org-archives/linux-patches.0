Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 473BE359A73
	for <patches@lists.linux.dev>; Sat, 28 Feb 2026 18:13:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772302417; cv=none; b=j81t/qDFD7+cPqQwODXFEEhW1w3CBG6A5DnqFlFpkTawE7km6tSYWD1hMQE1HkbOUPSd8OOfwXFZAyn7N6MKhDxhpfh4ZQ7XWah1YnYTBSP9WPvy3f2jHMgKBuYoHMbh1gqEAQlM22EZjy/gzu8JX7VpVyUvucuQKvduxQ1pgrc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772302417; c=relaxed/simple;
	bh=GB8Jb3g9NUDorm0QD8ttfxQ6Pfsvja3Xgi1YQJJJb9Y=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=lG7cOQmZn9kDBjpWYFmIB2aSS+hucvitvrD6KcQmABnF10ldvjs12e4VVvDbN3WxZWCiuTXQPz636iZyh3ykNERwrQ4foFhf9EXLykWdEY22qR0e5qaj17roGcW6mY92haKK0WWnis8mcmVLF7Abk2zOiDozQsRi+dNzP3PwF4g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=pXaE961h; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="pXaE961h"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A6477C19425;
	Sat, 28 Feb 2026 18:13:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772302417;
	bh=GB8Jb3g9NUDorm0QD8ttfxQ6Pfsvja3Xgi1YQJJJb9Y=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=pXaE961hvJ1LlTi7hMUQAQIhfg57LIL/pV5ZyUb9g0TzYR6FR63hJD9JlWxCwP83J
	 vLCIFl1dZ3YOJYHp7++9/x+XYJrIyy/ycFVjwkctVJgnnG9Gx7Gja0LVF9nAg10R8U
	 cALaE+NYrQBv5ft3i7MHO/QKKhN5M6Cc4Yk/VCaVEfOPLUQJI/17skULBOp1PCe/nv
	 D7PH8k5tVvryErguXmwz3CZVYfHnocol/cKjNwS1eLblBsB/dBSQtUhUMyrNVJ4NuV
	 fAWxuV009haPAhcW0DvmNaSeUHjhWY719kZjBnhi9r3Z8bXH9ov6OGl0UNoDLE3c98
	 /Po/HSMeX06yg==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev
Cc: Yi Liu <liuy22@mails.tsinghua.edu.cn>,
	Leon Romanovsky <leon@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 151/232] RDMA/uverbs: Validate wqe_size before using it in ib_uverbs_post_send
Date: Sat, 28 Feb 2026 13:10:04 -0500
Message-ID: <20260228181127.1592657-151-sashal@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20260228181127.1592657-1-sashal@kernel.org>
References: <20260228181127.1592657-1-sashal@kernel.org>
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
index 33e2fe0facd52..2ed51a7df60fd 100644
--- a/drivers/infiniband/core/uverbs_cmd.c
+++ b/drivers/infiniband/core/uverbs_cmd.c
@@ -2030,7 +2030,10 @@ static int ib_uverbs_post_send(struct uverbs_attr_bundle *attrs)
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

