Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A4D1739B976
	for <patches@lists.linux.dev>; Sat, 28 Feb 2026 18:16:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772302600; cv=none; b=W5bIQaOy62hJEx0hYeiY1OphRZHnZLUB0pfh0LsC9r1SIX+03xG5JnSO7PJKQL8gcldJuwLF3q21AoQj06mI2vOnNdLq1gNLftmdpz4HK7dkCqHLecusUNsGz4cSwaeZh8itZndOjEaJzQVbWotusg05+v3NEkbfoSizv7fM8V8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772302600; c=relaxed/simple;
	bh=hVacj3sOnX3GrC8V8N647jrbToA3Eh05OE29+190GE0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=aem7dXqjZTPyy2wbZvwwNFzZ8oKhgHJMIJbGnu+eVJlh0QvPrXSaHFT8qw1mMVQuXTzMEppDiK1cnK7oXk3R0gAPlG9LHwlFXPw/nPaZjFsWG05sClAlVjQ8rVi+iI37LEOG8dZEhZ1ntnZu8i0Q0nGHk12frVMiq+w41vpOmGg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=ihZKB6hm; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="ihZKB6hm"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 155B5C116D0;
	Sat, 28 Feb 2026 18:16:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772302600;
	bh=hVacj3sOnX3GrC8V8N647jrbToA3Eh05OE29+190GE0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ihZKB6hm5O4fytziCZDRT5RyYKDq24HMIv0rUp7KXgbzDrfEsCNSWmNdlmPLdeXPI
	 AjzRtHQar+IuIy6q4AjNIalHr4xo1xUAbj5OwX5ScFz9EpiWMn1LxZZTB9/HGo4Z4n
	 iZPdy8tMULNINP6hS5z2s4A4KmdfWpt9/E5QnCE5fq6VbV4EQ3A/PzOIF++ylqDsDp
	 Q5E2ttOp39Lt2ogc73z5w7Ocu/JaeizYPo7+L3ROIAa7EoHDO7cxSUk75zG8vfHQIV
	 R13bPpI1mVn0LA3YKNvCYhCqQQYoJXDTbAlo+43gzUmzMYAHbmP8ZLAx7fxJvVX7vZ
	 icnUcJzn6H9GA==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev
Cc: Yi Liu <liuy22@mails.tsinghua.edu.cn>,
	Leon Romanovsky <leon@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 113/164] RDMA/uverbs: Validate wqe_size before using it in ib_uverbs_post_send
Date: Sat, 28 Feb 2026 13:14:12 -0500
Message-ID: <20260228181505.1600663-113-sashal@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20260228181505.1600663-1-sashal@kernel.org>
References: <20260228181505.1600663-1-sashal@kernel.org>
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
index de631a6abe48d..754a00e2828bb 100644
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

