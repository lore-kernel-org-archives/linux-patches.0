Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EE0AD2F9D83;
	Wed, 25 Feb 2026 06:57:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772002628; cv=none; b=RrKA9bZV90Fk1IKR9EOLBqYf6E2zbRtTl+giKsnrCLdAmkap4VTCVSSv/EvckprV0TmzfkKYtj5Fi5xJXPDiy2KQ4AQxU06sXcQofesLaHUbD86ZSul0PCDAsj2w/yBLdVtOSGegQRNL+7IYYAyG0qC+FqrDoAqIyl0+Na0Ga6c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772002628; c=relaxed/simple;
	bh=Z/yHBie1pYNB+9z+diaxmweAkYXtZCpqVQh+yH4UUUw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=h5WZG5R++N5VmxSg6qgZxzgqMkmjRh/RJ8ZVfpVQY0t/wvpqjpa8jj6mQF5RxN2g787KugzNCk9JqQqYiuL03i1IpI4/oWag6tAS/0vbyhjH5J8l1ERWwdMnqWjGKi+aRe1/0QZpQh00Z/qEwlUOISGU1SYRdOliOEyVN4KQmZI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=sYLd2dtr; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="sYLd2dtr"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C86BDC116D0;
	Wed, 25 Feb 2026 06:57:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1772002627;
	bh=Z/yHBie1pYNB+9z+diaxmweAkYXtZCpqVQh+yH4UUUw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=sYLd2dtr56TouyzYW4iDKfOCJadaawXwUhbZS7mhSQbLkQm2MK68kb6+yTkKXGP33
	 k9wwVtCh8yE9oRm8dMyga6pxMZCnRoobWFMGqk4iRgLLpkw5SrcpZHLAs2cOirjdRe
	 bXjVgM9hu1FA/r7vLQMNH86//dl94ou4C+2fTK0Q=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yi Liu <liuy22@mails.tsinghua.edu.cn>,
	Leon Romanovsky <leon@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 389/641] RDMA/uverbs: Add __GFP_NOWARN to ib_uverbs_unmarshall_recv() kmalloc
Date: Tue, 24 Feb 2026 17:21:55 -0800
Message-ID: <20260225012358.006150881@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260225012348.915798704@linuxfoundation.org>
References: <20260225012348.915798704@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Yi Liu <liuy22@mails.tsinghua.edu.cn>

[ Upstream commit 58b604dfc7bb753f91bc0ccd3fa705e14e6edfb4 ]

Since wqe_size in ib_uverbs_unmarshall_recv() is user-provided and already
validated, but can still be large, add __GFP_NOWARN to suppress memory
allocation warnings for large sizes, consistent with the similar fix in
ib_uverbs_post_send().

Fixes: 67cdb40ca444 ("[IB] uverbs: Implement more commands")
Signed-off-by: Yi Liu <liuy22@mails.tsinghua.edu.cn>
Link: https://patch.msgid.link/20260129094900.3517706-1-liuy22@mails.tsinghua.edu.cn
Signed-off-by: Leon Romanovsky <leon@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/infiniband/core/uverbs_cmd.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/infiniband/core/uverbs_cmd.c b/drivers/infiniband/core/uverbs_cmd.c
index 3259e9848cc79..f4616deeca545 100644
--- a/drivers/infiniband/core/uverbs_cmd.c
+++ b/drivers/infiniband/core/uverbs_cmd.c
@@ -2242,7 +2242,7 @@ ib_uverbs_unmarshall_recv(struct uverbs_req_iter *iter, u32 wr_count,
 	if (ret)
 		return ERR_PTR(ret);
 
-	user_wr = kmalloc(wqe_size, GFP_KERNEL);
+	user_wr = kmalloc(wqe_size, GFP_KERNEL | __GFP_NOWARN);
 	if (!user_wr)
 		return ERR_PTR(-ENOMEM);
 
-- 
2.51.0



