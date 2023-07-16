Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 91DE48F57
	for <patches@lists.linux.dev>; Sun, 16 Jul 2023 20:49:59 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 11B82C433C7;
	Sun, 16 Jul 2023 20:49:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1689540599;
	bh=aYFIyF4lF9UfaJ/GskV3fQtES6jdTktAb2fzE5Eu/ik=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=cyeDquEkMzjg8Y+jX42LRVx+GEiuEVXUkVZ89BhD0AuisJV951g3yapmI+tZ1oP1y
	 vIXKe/XkL2ugIbFTayd5TwS5r8Yxn8lA4sCodrrzC9G9Th7Cg2rOdrgTLKHLi/LlYw
	 64RPrCW5xX9TyDgMDN/QqbVG0Nj3wxH4tFBLXFyY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Muchun Song <songmuchun@bytedance.com>,
	Tejun Heo <tj@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 420/591] kernfs: fix missing kernfs_idr_lock to remove an ID from the IDR
Date: Sun, 16 Jul 2023 21:49:19 +0200
Message-ID: <20230716194934.782207995@linuxfoundation.org>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20230716194923.861634455@linuxfoundation.org>
References: <20230716194923.861634455@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Muchun Song <songmuchun@bytedance.com>

[ Upstream commit 30480b988f88c279752f3202a26b6fee5f586aef ]

The root->ino_idr is supposed to be protected by kernfs_idr_lock, fix
it.

Fixes: 488dee96bb62 ("kernfs: allow creating kernfs objects with arbitrary uid/gid")
Signed-off-by: Muchun Song <songmuchun@bytedance.com>
Acked-by: Tejun Heo <tj@kernel.org>
Link: https://lore.kernel.org/r/20230523024017.24851-1-songmuchun@bytedance.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/kernfs/dir.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/fs/kernfs/dir.c b/fs/kernfs/dir.c
index f33b3baad07cb..44842e6cf0a9b 100644
--- a/fs/kernfs/dir.c
+++ b/fs/kernfs/dir.c
@@ -652,7 +652,9 @@ static struct kernfs_node *__kernfs_new_node(struct kernfs_root *root,
 	return kn;
 
  err_out3:
+	spin_lock(&kernfs_idr_lock);
 	idr_remove(&root->ino_idr, (u32)kernfs_ino(kn));
+	spin_unlock(&kernfs_idr_lock);
  err_out2:
 	kmem_cache_free(kernfs_node_cache, kn);
  err_out1:
-- 
2.39.2



