Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D3A7417A93F;
	Tue, 16 Jul 2024 15:49:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1721144986; cv=none; b=HMYY5/rxm1tg2Ku6F0fs5yeisHFSs81PTPSmvAKm3mOGtJp2yoIwI2lOsnRMVfWDe8LBwkOUBqtxY5M1AnLFxN7xcYGMTmcpre5Vjit+/xrKGULtadSUF/Zi/ItdRIFOOgEAtomhVE3pw7KpO8UVcmyX1QXYqjUgF0xF6hoGfFs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1721144986; c=relaxed/simple;
	bh=p1YOKKeJtI1MPqRb7JDE11ZytjHTbbvIP7/ar16VsR8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Xex6zUnBLM0dQdt8erjQNNkS9J5qeZxGsJQn8cKZSKEaz6+uIHlqVS38n7njD4+TRklOnskoD51TYMNGd6AK+SlPU2EqlL3f1WRbA8h6hRk8L3qlugKBH8+QpWCQMzSClPQd4FPuaJsRDZjM9AJCwb4yGUtcUY+FzMLNeFmVpq4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=AjNY8Sns; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="AjNY8Sns"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 08577C4AF0D;
	Tue, 16 Jul 2024 15:49:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1721144986;
	bh=p1YOKKeJtI1MPqRb7JDE11ZytjHTbbvIP7/ar16VsR8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=AjNY8SnsymeEtREQs2gsetbpoNB1ElfYUOU+U+NEWn3Mp9exRf9eE6Upwiid5/rOE
	 Vx+vjXC5jQByoVg51T+GLhfD6B0fOpNEc7EwoPmbjniyM1FNZ+xBLhfNY+PWPc5+Nh
	 4iNiZv9w+FvZho+hcmM+3Gk0D1V5rTihQ6INpRUA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Matthew Wilcox (Oracle)" <willy@infradead.org>,
	Christian Brauner <brauner@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.9 030/143] minixfs: Fix minixfs_rename with HIGHMEM
Date: Tue, 16 Jul 2024 17:30:26 +0200
Message-ID: <20240716152757.151980295@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240716152755.980289992@linuxfoundation.org>
References: <20240716152755.980289992@linuxfoundation.org>
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

6.9-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Matthew Wilcox (Oracle) <willy@infradead.org>

[ Upstream commit 3d1bec293378700dddc087d4d862306702276c23 ]

minixfs now uses kmap_local_page(), so we can't call kunmap() to
undo it.  This one call was missed as part of the commit this fixes.

Fixes: 6628f69ee66a (minixfs: Use dir_put_page() in minix_unlink() and minix_rename())
Signed-off-by: Matthew Wilcox (Oracle) <willy@infradead.org>
Link: https://lore.kernel.org/r/20240709195841.1986374-1-willy@infradead.org
Signed-off-by: Christian Brauner <brauner@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/minix/namei.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/fs/minix/namei.c b/fs/minix/namei.c
index d6031acc34f0c..a944a0f17b537 100644
--- a/fs/minix/namei.c
+++ b/fs/minix/namei.c
@@ -213,8 +213,7 @@ static int minix_rename(struct mnt_idmap *idmap,
 		if (!new_de)
 			goto out_dir;
 		err = minix_set_link(new_de, new_page, old_inode);
-		kunmap(new_page);
-		put_page(new_page);
+		unmap_and_put_page(new_page, new_de);
 		if (err)
 			goto out_dir;
 		inode_set_ctime_current(new_inode);
-- 
2.43.0



