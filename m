Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 348A0270545
	for <patches@lists.linux.dev>; Sat, 28 Feb 2026 18:09:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772302189; cv=none; b=Lt5aIaqZ5E1RaA1n4WJjRYS11mHLc2VJw5GvIeKpohqZhAxE0iF+nTvLFFj318dQuUio+XJkEVsJ+PcYn9v9EbngWN2tGc79mb5fa8QIn2IXsFUg9kNIKydSwWLwEvRRhWiJMcVs2JnIOyGhFlOs3Vp0G7b6SNLgvggSmi/gDSY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772302189; c=relaxed/simple;
	bh=GB8Jb3g9NUDorm0QD8ttfxQ6Pfsvja3Xgi1YQJJJb9Y=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=qv6UkbV/jchcNZAjqvzeZPXpOiCncPpyv/NHG9rfBWKn4F3hftLyyRppwr4sQa8fMYLrab26l6bllanaUPRXzSEdo/LrhE94WI92nH2lMPZlofwzHH8oDCb7Xs7vZWcoA2eeqVHvGjQNbkg0irSeHLyCBHbzBbAS60PsjpwsUoY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=cdz8SWlp; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="cdz8SWlp"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 950D2C19424;
	Sat, 28 Feb 2026 18:09:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772302189;
	bh=GB8Jb3g9NUDorm0QD8ttfxQ6Pfsvja3Xgi1YQJJJb9Y=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=cdz8SWlpA+ZWYbOAmkAWiu80aGUH4LVTFPwV5nKXZJ7fURrXgGAFtagV/0SmEX8cV
	 vke+Ea2MR98+P2xeJLuRfO7ZpGSoHhF092/HbLem2woRLWn7h6rQhv3tSQ6Xz18QZc
	 BFC0LEmHGOdS/AbRaiNOXr9xpjifizWN93HEHlYPKrBMCQGw3yz85I8hr5Qdm4FsJZ
	 DDAaGwdEYVpPUpOS4KM4R2xwOf6ia0T1Bnd7jaawtmLXy01JEit7HxIQedoxD9BLy1
	 2WbvwdgG6BVDRNtxcaN70qbT/iKDIOxENLqPb6SV8ENB2GMWiLs2act8SA5d0P4Hdz
	 0VtAgkXUD3q5g==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev
Cc: Yi Liu <liuy22@mails.tsinghua.edu.cn>,
	Leon Romanovsky <leon@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 190/283] RDMA/uverbs: Validate wqe_size before using it in ib_uverbs_post_send
Date: Sat, 28 Feb 2026 13:05:32 -0500
Message-ID: <20260228180709.1583486-190-sashal@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20260228180709.1583486-1-sashal@kernel.org>
References: <20260228180709.1583486-1-sashal@kernel.org>
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

