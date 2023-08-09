Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AB2041774C
	for <patches@lists.linux.dev>; Wed,  9 Aug 2023 11:11:26 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 30341C433C7;
	Wed,  9 Aug 2023 11:11:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1691579486;
	bh=BHnsoVT4HnXAqTRvJjulU+m0HOthvcowuedN+U2N6fw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=hbWgzyOirkdyjPiiVycEUSM2v2pUwdjv9KG2Ua2x3jnccUtk0HJtJhid2DkXeV3SQ
	 g0pINYPSKqkjv+ATuMKEQWXa/B457eBF6MgXQrLI6jdQsscDlRHP2wDslUeysOnCuQ
	 Hl+3Qq9VZabknuUVpUK1ISvw2o+0isCZsUfvsgsM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yang Lan <lanyang0908@gmail.com>,
	Bob Peterson <rpeterso@redhat.com>,
	Andreas Gruenbacher <agruenba@redhat.com>,
	Dragos-Marian Panait <dragos.panait@windriver.com>
Subject: [PATCH 4.19 001/323] gfs2: Dont deref jdesc in evict
Date: Wed,  9 Aug 2023 12:37:19 +0200
Message-ID: <20230809103658.178990444@linuxfoundation.org>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20230809103658.104386911@linuxfoundation.org>
References: <20230809103658.104386911@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Bob Peterson <rpeterso@redhat.com>

commit 504a10d9e46bc37b23d0a1ae2f28973c8516e636 upstream.

On corrupt gfs2 file systems the evict code can try to reference the
journal descriptor structure, jdesc, after it has been freed and set to
NULL. The sequence of events is:

init_journal()
...
fail_jindex:
   gfs2_jindex_free(sdp); <------frees journals, sets jdesc = NULL
      if (gfs2_holder_initialized(&ji_gh))
         gfs2_glock_dq_uninit(&ji_gh);
fail:
   iput(sdp->sd_jindex); <--references jdesc in evict_linked_inode
      evict()
         gfs2_evict_inode()
            evict_linked_inode()
               ret = gfs2_trans_begin(sdp, 0, sdp->sd_jdesc->jd_blocks);
<------references the now freed/zeroed sd_jdesc pointer.

The call to gfs2_trans_begin is done because the truncate_inode_pages
call can cause gfs2 events that require a transaction, such as removing
journaled data (jdata) blocks from the journal.

This patch fixes the problem by adding a check for sdp->sd_jdesc to
function gfs2_evict_inode. In theory, this should only happen to corrupt
gfs2 file systems, when gfs2 detects the problem, reports it, then tries
to evict all the system inodes it has read in up to that point.

Reported-by: Yang Lan <lanyang0908@gmail.com>
Signed-off-by: Bob Peterson <rpeterso@redhat.com>
Signed-off-by: Andreas Gruenbacher <agruenba@redhat.com>
[DP: adjusted context]
Signed-off-by: Dragos-Marian Panait <dragos.panait@windriver.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/gfs2/super.c |    8 ++++++++
 1 file changed, 8 insertions(+)

--- a/fs/gfs2/super.c
+++ b/fs/gfs2/super.c
@@ -1586,6 +1586,14 @@ static void gfs2_evict_inode(struct inod
 	if (inode->i_nlink || sb_rdonly(sb))
 		goto out;
 
+	/*
+	 * In case of an incomplete mount, gfs2_evict_inode() may be called for
+	 * system files without having an active journal to write to.  In that
+	 * case, skip the filesystem evict.
+	 */
+	if (!sdp->sd_jdesc)
+		goto out;
+
 	if (test_bit(GIF_ALLOC_FAILED, &ip->i_flags)) {
 		BUG_ON(!gfs2_glock_is_locked_by_me(ip->i_gl));
 		gfs2_holder_mark_uninitialized(&gh);


