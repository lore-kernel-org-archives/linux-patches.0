Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6395D168AD
	for <patches@lists.linux.dev>; Mon,  8 May 2023 10:17:07 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D250DC433D2;
	Mon,  8 May 2023 10:17:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1683541027;
	bh=z68mJqRInk+pcesD3Pww50pW2B9wZJjCKfYA9GNFuts=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=2PhFyr7tYJbgF4zejXjHCKoBIWkbD6ykLSfjU7TmXHCQxs4thYRILYuHCZ9XkIPw/
	 rgHtzYZQKRirmIidQeOS/UAlDSSPFrRW3gxThHfAWn1Bkj9lhVy2ywY9whjMHJwED6
	 +3AeOCrVplKfjwDkDZTfhdG4DaswRe7n+vQig5Bc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	David Howells <dhowells@redhat.com>,
	Marc Dionne <marc.dionne@auristor.com>,
	linux-afs@lists.infradead.org,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 557/611] afs: Fix getattr to report server i_size on dirs, not local size
Date: Mon,  8 May 2023 11:46:39 +0200
Message-Id: <20230508094440.088196358@linuxfoundation.org>
X-Mailer: git-send-email 2.40.1
In-Reply-To: <20230508094421.513073170@linuxfoundation.org>
References: <20230508094421.513073170@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: David Howells <dhowells@redhat.com>

[ Upstream commit 45f66fa03ba9943cca5af88d691399332b8bde08 ]

Fix afs_getattr() to report the server's idea of the file size of a
directory rather than the local size.  The local size may differ as we edit
the local copy to avoid having to redownload it and we may end up with a
differently structured blob of a different size.

However, if the directory is discarded from the pagecache we then download
it again and the user may see the directory file size apparently change.

Fixes: 63a4681ff39c ("afs: Locally edit directory data for mkdir/create/unlink/...")
Signed-off-by: David Howells <dhowells@redhat.com>
cc: Marc Dionne <marc.dionne@auristor.com>
cc: linux-afs@lists.infradead.org
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/afs/inode.c | 9 ++++++++-
 1 file changed, 8 insertions(+), 1 deletion(-)

diff --git a/fs/afs/inode.c b/fs/afs/inode.c
index 52d040ffde35f..5921dd3687e39 100644
--- a/fs/afs/inode.c
+++ b/fs/afs/inode.c
@@ -450,7 +450,7 @@ static void afs_get_inode_cache(struct afs_vnode *vnode)
 				    0 : FSCACHE_ADV_SINGLE_CHUNK,
 				    &key, sizeof(key),
 				    &aux, sizeof(aux),
-				    vnode->status.size));
+				    i_size_read(&vnode->netfs.inode)));
 #endif
 }
 
@@ -766,6 +766,13 @@ int afs_getattr(struct user_namespace *mnt_userns, const struct path *path,
 		if (test_bit(AFS_VNODE_SILLY_DELETED, &vnode->flags) &&
 		    stat->nlink > 0)
 			stat->nlink -= 1;
+
+		/* Lie about the size of directories.  We maintain a locally
+		 * edited copy and may make different allocation decisions on
+		 * it, but we need to give userspace the server's size.
+		 */
+		if (S_ISDIR(inode->i_mode))
+			stat->size = vnode->netfs.remote_i_size;
 	} while (need_seqretry(&vnode->cb_lock, seq));
 
 	done_seqretry(&vnode->cb_lock, seq);
-- 
2.39.2



