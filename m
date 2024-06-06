Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 85E2D1BD4E9;
	Thu,  6 Jun 2024 14:18:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717683520; cv=none; b=Emu/uvzpjl0uJH0oUx/pAbltrA12gmLifln73z2nVcMA/MSLitb1eVvdgT/M2sCkLaMG3kZ7AiSrX+O6w7nU5oVXe2ouM1QjStgjk787X0EzMVb+K8LLD6FFiETpHqGGYZdRh9EWHbhu/VMYNt1SrTFbqZjpxFVMnnVpoCmvIw8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717683520; c=relaxed/simple;
	bh=k3JoYouU28J8KQdj9+7YAfoekFe1EL8jSnySqlHfWPg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Z1M1EsaTXJp9guuLohYFOxEWidEh06JOJ17+hmnnxogQZK16z0xe6KFoT0NF/yiBmr3ib8k0TBbTQPeT2rE+gOMG1TfiLkivId96mzexBZgyhOzSNQ0Adwqj+ht6ismPL4A1Yi+CVsFGH33oq9mq84zOCULSdJx8YayeoANzLRE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=H07Ys3pQ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="H07Ys3pQ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 141A7C4AF08;
	Thu,  6 Jun 2024 14:18:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1717683520;
	bh=k3JoYouU28J8KQdj9+7YAfoekFe1EL8jSnySqlHfWPg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=H07Ys3pQhsrM6/KvC5fo/NxtSgzHRykHRIRdRKsGO4WLQnTOLVIQC9xo6PFK2fZi8
	 2DZyuOG9Rgx36bOVqfP0gLkV0ojg4zZ5dfC4WgAkBYL9Ylo/YxfoldYGri3Z7NA7JJ
	 2CdLpS1zEipy5ynqigCfD6yV9Uz2qZ4ygIvVBsE0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jan Kara <jack@suse.cz>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 461/744] udf: Remove GFP_NOFS allocation in udf_expand_file_adinicb()
Date: Thu,  6 Jun 2024 16:02:13 +0200
Message-ID: <20240606131747.258243194@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240606131732.440653204@linuxfoundation.org>
References: <20240606131732.440653204@linuxfoundation.org>
User-Agent: quilt/0.67
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

From: Jan Kara <jack@suse.cz>

[ Upstream commit 38f8af2a7191e5da21c557210d810c6d0d34f6c4 ]

udf_expand_file_adinicb() is called under inode->i_rwsem and
mapping->invalidate_lock. i_rwsem is safe wrt fs reclaim,
invalidate_lock on this inode is safe as well (we hold inode reference
so reclaim will not touch it, furthermore even lockdep should not
complain as invalidate_lock is acquired from udf_evict_inode() only when
truncating inode which should not happen from fs reclaim).

Signed-off-by: Jan Kara <jack@suse.cz>
Stable-dep-of: db6754090a4f ("udf: Convert udf_expand_file_adinicb() to use a folio")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/udf/inode.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/udf/inode.c b/fs/udf/inode.c
index a17a6184cc39e..7f7610dddcba1 100644
--- a/fs/udf/inode.c
+++ b/fs/udf/inode.c
@@ -357,7 +357,7 @@ int udf_expand_file_adinicb(struct inode *inode)
 		return 0;
 	}
 
-	page = find_or_create_page(inode->i_mapping, 0, GFP_NOFS);
+	page = find_or_create_page(inode->i_mapping, 0, GFP_KERNEL);
 	if (!page)
 		return -ENOMEM;
 
-- 
2.43.0



