Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7DB2D1DA4D;
	Tue, 16 Jul 2024 15:59:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1721145576; cv=none; b=r+kE8ameS7TjhzDgCbcY3STyx2OYMxUyPcc6JJRWKBYcT6iCrKAP37coHTn0A+ir9bFhOXJpacRO9YREH2Ww7OVZ6lj7gaOVRsV/Jhll2D3T9VPu/5aU3F0ToW/JKAU5pxe3CzQdbD11AMWxZ69sfTB2ZDEKqm2cVn633bGulyk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1721145576; c=relaxed/simple;
	bh=GJuOkDDtkFp6oVc6xjUBlabRTRzn/gNFYkgolQWMaYM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=On90/272ug7Hs2qF6OMopYGxWqv2ncQ9a4ugpMpe2DDmBEgSWvMlm0cvSnSdzlYDnx0T1MzDYPq7ef4Q5d3AcgbJIymYx7bfsBRcDCVOM5PObHjeVJy/s1EhHbnECNoSTyPqj0BoWtKm/4C4ZQbCZzb7TdREcOD12A2MjgCE12M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=vcNaK8nx; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="vcNaK8nx"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id ED5ADC116B1;
	Tue, 16 Jul 2024 15:59:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1721145576;
	bh=GJuOkDDtkFp6oVc6xjUBlabRTRzn/gNFYkgolQWMaYM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=vcNaK8nxYWCelvjqv473ImDK9Tr/Xuz/0J98kZBxhmjDTy7grh3yXccFQ0ig6znj+
	 9+DccKzgzwA03x0gNe9u7h/3+RoVlddSRtZ3BPpBKYSqbfRF9ge+NwReFCczNWPQUn
	 ViVSWknN2Usy9hKk5Gvvbqwk0VRz72PX3ckI81T0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	linke li <lilinke99@qq.com>,
	Jan Kara <jack@suse.cz>,
	Christian Brauner <brauner@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 015/121] fs/dcache: Re-use value stored to dentry->d_flags instead of re-reading
Date: Tue, 16 Jul 2024 17:31:17 +0200
Message-ID: <20240716152751.908144647@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240716152751.312512071@linuxfoundation.org>
References: <20240716152751.312512071@linuxfoundation.org>
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

From: linke li <lilinke99@qq.com>

[ Upstream commit 8bfb40be31ddea0cb4664b352e1797cfe6c91976 ]

Currently, the __d_clear_type_and_inode() writes the value flags to
dentry->d_flags, then immediately re-reads it in order to use it in a if
statement. This re-read is useless because no other update to
dentry->d_flags can occur at this point.

This commit therefore re-use flags in the if statement instead of
re-reading dentry->d_flags.

Signed-off-by: linke li <lilinke99@qq.com>
Link: https://lore.kernel.org/r/tencent_5E187BD0A61BA28605E85405F15228254D0A@qq.com
Reviewed-by: Jan Kara <jack@suse.cz>
Signed-off-by: Christian Brauner <brauner@kernel.org>
Stable-dep-of: aabfe57ebaa7 ("vfs: don't mod negative dentry count when on shrinker list")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/dcache.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/dcache.c b/fs/dcache.c
index 9ae808fba517b..fca3e7490d091 100644
--- a/fs/dcache.c
+++ b/fs/dcache.c
@@ -356,7 +356,7 @@ static inline void __d_clear_type_and_inode(struct dentry *dentry)
 	flags &= ~(DCACHE_ENTRY_TYPE | DCACHE_FALLTHRU);
 	WRITE_ONCE(dentry->d_flags, flags);
 	dentry->d_inode = NULL;
-	if (dentry->d_flags & DCACHE_LRU_LIST)
+	if (flags & DCACHE_LRU_LIST)
 		this_cpu_inc(nr_dentry_negative);
 }
 
-- 
2.43.0



