Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EC91A38DD8;
	Mon, 24 Feb 2025 14:44:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1740408258; cv=none; b=GSIau1gFIOp7A4MsEEmwgoMXdjJZ8LxnJWuMD+9Do4T1Sd4PVjfIL0RzhiMNigVi9+H4g7hpq4iq/fQp3L3VBL7KTEMXVvrzfiMcdXApIftBfVUvvOG8jP63favTh2n7oPtJcUdjZWP5fYykIit66qotITkIl6WVUuOLIQPMaBw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1740408258; c=relaxed/simple;
	bh=9FynCXkbJoTnFZLUArnjGreLXew0Hq/iAfAQG7Z5lzw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=e4WEURgB0rGdutrkzmFKW5AvHUJg74eAnyMasIiq++VDyZwG1sRPaYt+IrQi0orgR1Dr1PiQFtCxGJAUdnbDmUlkYx1LfcqRb8lSRMEvmH4rXBNepOSo0ms9lCv3C16qWZflRAtXO/iGtco5Bh9BYh7ycjOeFNlSeKcr/yS97YI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=SGG25LHP; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="SGG25LHP"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 593FCC4CEE9;
	Mon, 24 Feb 2025 14:44:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1740408257;
	bh=9FynCXkbJoTnFZLUArnjGreLXew0Hq/iAfAQG7Z5lzw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=SGG25LHPSN2I6GiEvpxSPvEeQGGm28aABwP77ZqD0FVWRHyn2PmBO2f2FGh7fFkqe
	 I1ECxVZfkz2KFLRK430Rmzqn593bcP9BGiFhrXLmkAlq7GZSBuHW6sWIgF7gvKXB93
	 M4v0d+Z+eTl/4i6yI+ex9O3zhmtnlKDXXK06fbuw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Andrew Morton <akpm@linux-foundation.org>,
	Ryusuke Konishi <konishi.ryusuke@gmail.com>,
	"Matthew Wilcox (Oracle)" <willy@infradead.org>
Subject: [PATCH 6.6 138/140] nilfs2: eliminate staggered calls to kunmap in nilfs_rename
Date: Mon, 24 Feb 2025 15:35:37 +0100
Message-ID: <20250224142608.431744743@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250224142602.998423469@linuxfoundation.org>
References: <20250224142602.998423469@linuxfoundation.org>
User-Agent: quilt/0.68
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

From: Ryusuke Konishi <konishi.ryusuke@gmail.com>

commit 8cf57c6df818f58fdad16a909506be213623a88e upstream.

In nilfs_rename(), calls to nilfs_put_page() to release pages obtained
with nilfs_find_entry() or nilfs_dotdot() are alternated in the normal
path.

When replacing the kernel memory mapping method from kmap to
kmap_local_{page,folio}, this violates the constraint on the calling order
of kunmap_local().

Swap the order of nilfs_put_page calls where the kmap sections of multiple
pages overlap so that they are nested, allowing direct replacement of
nilfs_put_page() -> unmap_and_put_page().

Without this reordering, that replacement will cause a kernel WARNING in
kunmap_local_indexed() on architectures with high memory mapping.

Link: https://lkml.kernel.org/r/20231127143036.2425-3-konishi.ryusuke@gmail.com
Signed-off-by: Ryusuke Konishi <konishi.ryusuke@gmail.com>
Reviewed-by: Matthew Wilcox (Oracle) <willy@infradead.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Stable-dep-of: ee70999a988b ("nilfs2: handle errors that nilfs_prepare_chunk() may return")
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/nilfs2/namei.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/fs/nilfs2/namei.c
+++ b/fs/nilfs2/namei.c
@@ -431,13 +431,14 @@ static int nilfs_rename(struct mnt_idmap
 	inode_set_ctime_current(old_inode);
 
 	nilfs_delete_entry(old_de, old_page);
-	nilfs_put_page(old_page);
 
 	if (dir_de) {
 		nilfs_set_link(old_inode, dir_de, dir_page, new_dir);
 		nilfs_put_page(dir_page);
 		drop_nlink(old_dir);
 	}
+	nilfs_put_page(old_page);
+
 	nilfs_mark_inode_dirty(old_dir);
 	nilfs_mark_inode_dirty(old_inode);
 


