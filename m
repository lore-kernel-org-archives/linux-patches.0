Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4DA20301EE4
	for <patches@lists.linux.dev>; Sat, 28 Feb 2026 17:56:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772301408; cv=none; b=oSBBlFD/ow3ovnaw8j/YcRZg/y5v8tfK/vEupZYxOwx7a+o/7NraoNOP9JCb5l6V7iEFkptCxTkuY0fSlsNWyCj2EFMpPsxGSA90o8sAa/N9cJSSZcMeBGIR0+y9zxAeVWyZPztF42tCJof+gjVAAhdAsFqrN81XSUsPuo+Ic3A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772301408; c=relaxed/simple;
	bh=pC5QG1l/bE6I4C1vnl30URd/Rzo8ssJRGcMFuJ7TZNw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=GBXc/5dWFujgtNx0RpPk+EkMKJyKAamLGYJOpCh0dm9Ds0823cFvp4b2KZQc1SkUYPGIJs0EHSjlmfvyl6NjJPPo1K2a5wmSj9Thwt0PoMamHmhPw0gakT8aUXDAVTxkamJru4f39I3qizBo2jdSfXI7iLg65sxJrMRZKGMw6tM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=P9kHfEX/; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="P9kHfEX/"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8207FC116D0;
	Sat, 28 Feb 2026 17:56:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772301408;
	bh=pC5QG1l/bE6I4C1vnl30URd/Rzo8ssJRGcMFuJ7TZNw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=P9kHfEX/bx5skZr9NT6ZR1GqdccwqnAIAsVCMb0gdcHcFKwzvJojb34EGsbtfqcwE
	 QYPsvBb98moYqsMPg0kDk+gqTmgn6mLVHnaDGuGJcIApF9d7GV2BaKg9lL+U9kPd4Q
	 AxlW1B1dzXxJ/NU9q1upvuewI6A3kEVnJwSwt49JJYuLi3DIIIKhSUA4Ms/xn7qtxH
	 4Y96/1aAFbH1U2TmSPmxQ6oabtWCdbQwHh+JB62uu0mFFGYqmLcS+HzMKA7JsAYcIP
	 MPHXhrAqk1gFpavynBugRAdP6qbBmd3xu4Dni86ghXxwkhEDTFTj35XVyGTAZyXZ6A
	 jSWZ2fyN/zX+g==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev
Cc: Gao Xiang <hsiangkao@linux.alibaba.com>,
	stable@kernel.org,
	Hongbo Li <lihongbo22@huawei.com>,
	Chao Yu <chao@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 597/752] erofs: fix incorrect early exits in volume label handling
Date: Sat, 28 Feb 2026 12:45:08 -0500
Message-ID: <20260228174750.1542406-597-sashal@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20260228174750.1542406-1-sashal@kernel.org>
References: <20260228174750.1542406-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit

From: Gao Xiang <hsiangkao@linux.alibaba.com>

[ Upstream commit 3afa4da38802a4cba1c23848a32284e7e57b831b ]

Crafted EROFS images containing valid volume labels can trigger
incorrect early returns, leading to folio reference leaks.

However, this does not cause system crashes or other severe issues.

Fixes: 1cf12c717741 ("erofs: Add support for FS_IOC_GETFSLABEL")
Cc: stable@kernel.org
Reviewed-by: Hongbo Li <lihongbo22@huawei.com>
Reviewed-by: Chao Yu <chao@kernel.org>
Signed-off-by: Gao Xiang <hsiangkao@linux.alibaba.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/erofs/super.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/fs/erofs/super.c b/fs/erofs/super.c
index b54083128e0f4..ee37628ec99fb 100644
--- a/fs/erofs/super.c
+++ b/fs/erofs/super.c
@@ -347,8 +347,10 @@ static int erofs_read_superblock(struct super_block *sb)
 	if (dsb->volume_name[0]) {
 		sbi->volume_name = kstrndup(dsb->volume_name,
 					    sizeof(dsb->volume_name), GFP_KERNEL);
-		if (!sbi->volume_name)
-			return -ENOMEM;
+		if (!sbi->volume_name) {
+			ret = -ENOMEM;
+			goto out;
+		}
 	}
 
 	/* parse on-disk compression configurations */
-- 
2.51.0

