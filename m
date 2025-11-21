Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B3042346E6D;
	Fri, 21 Nov 2025 13:49:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763732989; cv=none; b=Nb7FwpMBI/cj49xl+VrfTivVc8ysWdz9R7iX5R6iJrGitHUh1fTZJH2N9AS/mc+Q/PIt1kz82aEyBEk6vhIWjxnVlWs2fIqhKCHthEEI9rInmZn73nRoBgK0o39aX6UwfKKuNUURFB5llLKZhPLmf23z3m+yso0DJY506P435UY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763732989; c=relaxed/simple;
	bh=4z9iwDe1DG80WbQAb4kuBzuC7xNM+PFpHYVkGWcowx8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=fWz576uGKSfl9qqE+6b5J88+zdwukxgoI0LpXgVKftx2ZoDPLLXP89LufRRMi92O0xLhcUhE6shRGFmokJ/MuceinQyUs+w+JejUodHdJeVBIDYmk2c/A5KIQe60/PIPqjH13upkmcqxUdOD/qyMUzn4iQVN0WcjScPaR1+3qiM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=v0EVavO8; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="v0EVavO8"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 36E3AC116C6;
	Fri, 21 Nov 2025 13:49:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1763732989;
	bh=4z9iwDe1DG80WbQAb4kuBzuC7xNM+PFpHYVkGWcowx8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=v0EVavO8bw0icvpwbLX0KMS9fMReL3t0rIv6M8yPHPphVaKCJlE4XziyBFc+2FYQU
	 TPKHok0sMBT6VZJPtRChS46Wk5oH62zy8+fcfW45w7ifUPYkbr3xDlpW0No/4IQLNC
	 HJg3JszZqR/+w5IdSvk8IinktrXkveHUmPhLUYF8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	chuguangqing <chuguangqing@inspur.com>,
	Theodore Tso <tytso@mit.edu>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 279/529] fs: ext4: change GFP_KERNEL to GFP_NOFS to avoid deadlock
Date: Fri, 21 Nov 2025 14:09:38 +0100
Message-ID: <20251121130240.956991886@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251121130230.985163914@linuxfoundation.org>
References: <20251121130230.985163914@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: chuguangqing <chuguangqing@inspur.com>

[ Upstream commit 1534f72dc2a11ded38b0e0268fbcc0ca24e9fd4a ]

The parent function ext4_xattr_inode_lookup_create already uses GFP_NOFS for memory alloction, so the function ext4_xattr_inode_cache_find should use same gfp_flag.

Signed-off-by: chuguangqing <chuguangqing@inspur.com>
Signed-off-by: Theodore Ts'o <tytso@mit.edu>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/ext4/xattr.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/ext4/xattr.c b/fs/ext4/xattr.c
index 66933e55efb3b..307081c994374 100644
--- a/fs/ext4/xattr.c
+++ b/fs/ext4/xattr.c
@@ -1552,7 +1552,7 @@ ext4_xattr_inode_cache_find(struct inode *inode, const void *value,
 	WARN_ON_ONCE(ext4_handle_valid(journal_current_handle()) &&
 		     !(current->flags & PF_MEMALLOC_NOFS));
 
-	ea_data = kvmalloc(value_len, GFP_KERNEL);
+	ea_data = kvmalloc(value_len, GFP_NOFS);
 	if (!ea_data) {
 		mb_cache_entry_put(ea_inode_cache, ce);
 		return NULL;
-- 
2.51.0



