Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D3029168AF
	for <patches@lists.linux.dev>; Mon, 22 May 2023 19:17:32 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 510D5C433D2;
	Mon, 22 May 2023 19:17:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1684783052;
	bh=fvggIfwE4DYJULyIHUQCishCUS8+oRGIdCElfL9i1Oc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=NDyWvuZy8afvmaa3luTC7RYurTlQWfZ7t6kUbh8iwoNtRsVsZXbWRNRZUZ7c34Etr
	 6KGmvuTnYfKY7dOlSEDe0/xOE10hPQr/FTB3+5VXq0DIKkuE3WhzCEy5NxgR8QCGWa
	 FJh+3QKyQQ7rtClhX5AoO0+1l0D+FGb3Zf+v0SRI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jia-Ju Bai <baijiaju1990@gmail.com>,
	TOTE Robot <oslab@tsinghua.edu.cn>,
	Konstantin Komarov <almaz.alexandrovich@paragon-software.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 095/203] fs/ntfs3: Fix a possible null-pointer dereference in ni_clear()
Date: Mon, 22 May 2023 20:08:39 +0100
Message-Id: <20230522190357.618295734@linuxfoundation.org>
X-Mailer: git-send-email 2.40.1
In-Reply-To: <20230522190354.935300867@linuxfoundation.org>
References: <20230522190354.935300867@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Jia-Ju Bai <baijiaju1990@gmail.com>

[ Upstream commit ec275bf9693d19cc0fdce8436f4c425ced86f6e7 ]

In a previous commit c1006bd13146, ni->mi.mrec in ni_write_inode()
could be NULL, and thus a NULL check is added for this variable.

However, in the same call stack, ni->mi.mrec can be also dereferenced
in ni_clear():

ntfs_evict_inode(inode)
  ni_write_inode(inode, ...)
    ni = ntfs_i(inode);
    is_rec_inuse(ni->mi.mrec) -> Add a NULL check by previous commit
  ni_clear(ntfs_i(inode))
    is_rec_inuse(ni->mi.mrec) -> No check

Thus, a possible null-pointer dereference may exist in ni_clear().
To fix it, a NULL check is added in this function.

Signed-off-by: Jia-Ju Bai <baijiaju1990@gmail.com>
Reported-by: TOTE Robot <oslab@tsinghua.edu.cn>
Signed-off-by: Konstantin Komarov <almaz.alexandrovich@paragon-software.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/ntfs3/frecord.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/ntfs3/frecord.c b/fs/ntfs3/frecord.c
index 95556515ded3d..d24e12d348d49 100644
--- a/fs/ntfs3/frecord.c
+++ b/fs/ntfs3/frecord.c
@@ -101,7 +101,7 @@ void ni_clear(struct ntfs_inode *ni)
 {
 	struct rb_node *node;
 
-	if (!ni->vfs_inode.i_nlink && is_rec_inuse(ni->mi.mrec))
+	if (!ni->vfs_inode.i_nlink && ni->mi.mrec && is_rec_inuse(ni->mi.mrec))
 		ni_delete_all(ni);
 
 	al_destroy(ni);
-- 
2.39.2



