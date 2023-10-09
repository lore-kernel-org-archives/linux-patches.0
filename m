Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 66DDB1A582
	for <patches@lists.linux.dev>; Mon,  9 Oct 2023 13:12:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="zvdm4iVT"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D2B32C433C9;
	Mon,  9 Oct 2023 13:12:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1696857131;
	bh=l/bRcSSg57C8EjWpl/jE7rdkEkLtJOJO5q1haSwjhGE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=zvdm4iVTBbdaIvjmzK+Egi8fGh/dgxJHF/D/el9lFYqreA0OsKnpENyJRgthCl0Ak
	 oTl3uXxqr5GvI5vGE4C26odJI1rJl89nAwZeVmOnchhKrvrCcrFUaqoxpFyh49ooES
	 MFS3lBUHqgmZr0bVh4gdgmJWdHeBoTphXrhYwPVE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Al Viro <viro@zeniv.linux.org.uk>,
	Amir Goldstein <amir73il@gmail.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.5 107/163] ovl: move freeing ovl_entry past rcu delay
Date: Mon,  9 Oct 2023 15:01:11 +0200
Message-ID: <20231009130126.980225511@linuxfoundation.org>
X-Mailer: git-send-email 2.42.0
In-Reply-To: <20231009130124.021290599@linuxfoundation.org>
References: <20231009130124.021290599@linuxfoundation.org>
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

6.5-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Al Viro <viro@zeniv.linux.org.uk>

[ Upstream commit d9e8319a6e3538b430f692b5625a76ffa0758adc ]

... into ->free_inode(), that is.

Fixes: 0af950f57fef "ovl: move ovl_entry into ovl_inode"
Signed-off-by: Al Viro <viro@zeniv.linux.org.uk>
Signed-off-by: Amir Goldstein <amir73il@gmail.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/overlayfs/super.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/fs/overlayfs/super.c b/fs/overlayfs/super.c
index cc8977498c483..8e9c1cf83df24 100644
--- a/fs/overlayfs/super.c
+++ b/fs/overlayfs/super.c
@@ -164,6 +164,7 @@ static void ovl_free_inode(struct inode *inode)
 	struct ovl_inode *oi = OVL_I(inode);
 
 	kfree(oi->redirect);
+	kfree(oi->oe);
 	mutex_destroy(&oi->lock);
 	kmem_cache_free(ovl_inode_cachep, oi);
 }
@@ -173,7 +174,7 @@ static void ovl_destroy_inode(struct inode *inode)
 	struct ovl_inode *oi = OVL_I(inode);
 
 	dput(oi->__upperdentry);
-	ovl_free_entry(oi->oe);
+	ovl_stack_put(ovl_lowerstack(oi->oe), ovl_numlower(oi->oe));
 	if (S_ISDIR(inode->i_mode))
 		ovl_dir_cache_free(inode);
 	else
-- 
2.40.1



