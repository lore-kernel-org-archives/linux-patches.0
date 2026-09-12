Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0F7F7479876;
	Sat, 12 Sep 2026 12:16:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789215421; cv=none; b=ShLtDocgOT+YUOlQyQCUDkxPGml0a5CkaRPhKv5XInCTf3LlfPG5X+lAAOVOtTSBdl1352WG00q5f0kHRGcuGDhnzd5+s03UlKOhvaCfGnZ4Fm34EikzNNt8QThXIjOzPq9p+P1x9mREAV//zbdz9lppnqcmoUX/5DCJml9++Rw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789215421; c=relaxed/simple;
	bh=0OLtTvEIc95yCLvZ6ToZVxp/GXVu7rahrJfEirQG5Qc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=l+3z+tjIdTWUuKdXScR3/w89qOyxTwAFPEBVJevMTNRBmQzK2mYskoHYsS9RIntNTH4AJlhf/6JkxBJXF6GZikZiM8Vxqy+vcXmUZ7x34fMBw5buRYmnP3ra+AzODPRBXCkl62Gqx93WHE5K6eIbjhOK9hLvnr5wIonM5lOsJKI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=BxW9mTBK; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="BxW9mTBK"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6790F1F00898;
	Sat, 12 Sep 2026 12:16:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789215414;
	bh=t+c8kRfFYOqA/H44ef0i5J6a8vIFyrlAQS+O1MGeyIw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=BxW9mTBK+mg1BmdazJskwInL8MRzJS4v7er1yzRQWkvGVYDr6mE63wdkZR8EZ34rp
	 aSI4X/MKyKgnj5O5WDLJFU+7yuo7cvZ3j4jnwQldPiZ4P/O0w1C2EnxmhOS/d6N4ut
	 uFukO6OCHIhZzNx3c735xiR61TqLVdFEKwnNkVMs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	syzbot+83c9dd5c0dcf6184fdbf@syzkaller.appspotmail.com,
	Nirbhay Sharma <nirbhay.lkd@gmail.com>,
	Konstantin Komarov <almaz.alexandrovich@paragon-software.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 0528/1376] fs/ntfs3: fix KMSAN uninit-value in ni_create_attr_list
Date: Sat, 12 Sep 2026 08:49:14 +0200
Message-ID: <20260912065619.305317825@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065607.535295758@linuxfoundation.org>
References: <20260912065607.535295758@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Nirbhay Sharma <nirbhay.lkd@gmail.com>

[ Upstream commit 5f33da04e6ceee849e76e6592cc283c72fef7af9 ]

The call to kmalloc() to allocate the attribute list buffer is given a
size of al_aligned(rs). This size can be larger than the data
subsequently copied into the buffer, leaving trailing bytes uninitialized.

This can trigger a KMSAN "uninit-value" warning if that memory is
later accessed.

Fix this by using kzalloc() instead, which ensures the entire
allocated buffer is zero-initialized, preventing the warning.

Reported-by: syzbot+83c9dd5c0dcf6184fdbf@syzkaller.appspotmail.com
Closes: https://syzkaller.appspot.com/bug?extid=83c9dd5c0dcf6184fdbf
Signed-off-by: Nirbhay Sharma <nirbhay.lkd@gmail.com>
Signed-off-by: Konstantin Komarov <almaz.alexandrovich@paragon-software.com>
Stable-dep-of: 7c4841e2a627 ("fs/ntfs3: fix slab-out-of-bounds write in ni_create_attr_list()")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/ntfs3/frecord.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/ntfs3/frecord.c b/fs/ntfs3/frecord.c
index b2791327af22f..162a6c038000e 100644
--- a/fs/ntfs3/frecord.c
+++ b/fs/ntfs3/frecord.c
@@ -826,7 +826,7 @@ int ni_create_attr_list(struct ntfs_inode *ni)
 	 * Skip estimating exact memory requirement.
 	 * Looks like one record_size is always enough.
 	 */
-	le = kmalloc(al_aligned(rs), GFP_NOFS);
+	le = kzalloc(al_aligned(rs), GFP_NOFS);
 	if (!le)
 		return -ENOMEM;
 
-- 
2.53.0



