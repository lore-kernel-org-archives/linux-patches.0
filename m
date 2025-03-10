Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AAFB222D4C3;
	Mon, 10 Mar 2025 17:42:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741628561; cv=none; b=GKaCX758j7CDzxdbeU+xo+x0tr2F6qKO8jBt+E6Jy8kXE6fXCG//5TtX+KBaV5n1XEpgbbfjUhXGRCR+un6bTzZrOJJwN5B01TtifF+2oSqPHlDw06m7l4WNQd/2IpeYQ2+yzv+GrphW7gziWOqhwl/f6PL8PVaS8yfcA0CGGKk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741628561; c=relaxed/simple;
	bh=jr1eb4A9dFrvoC2F7DEWC+Qn3iWPyTnwf2r9aSizjHA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=TYWZfRbEXoKRqxp45rtOYZEL3VxmFz3AcubB4aZq1sSNpcpmqpV2OuXPYApNi/jQLiaPQejR2mHxKOE8/qp0xq9oHHjCyuoWMlLeYHPFC/KCfMw+O8FZssfHYOxxita9sR3eykMqT4lc/5TbCpUTDDVJpodb/I7tVhygHBW2ssA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=uyMDlSAl; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="uyMDlSAl"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C6773C4CEE5;
	Mon, 10 Mar 2025 17:42:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1741628561;
	bh=jr1eb4A9dFrvoC2F7DEWC+Qn3iWPyTnwf2r9aSizjHA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=uyMDlSAl4YK5S/BukoFC5/Pr/IpG55Oagg9IDbyjSR/cctlr5hWX/GhbZMBkL9M2/
	 4vV022lJZ9LvwVZpXRolxN8FAbhkEyDf0kIp5AX7s2jbhqXd7HnN0ZdrvL1qgV60+F
	 LcSp+Sgn1e06XtZjzHsbYRd+ehDt8ZuXn8N0IR7A=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ryusuke Konishi <konishi.ryusuke@gmail.com>,
	"Matthew Wilcox (Oracle)" <willy@infradead.org>,
	Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH 6.1 101/109] nilfs2: eliminate staggered calls to kunmap in nilfs_rename
Date: Mon, 10 Mar 2025 18:07:25 +0100
Message-ID: <20250310170431.577551426@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250310170427.529761261@linuxfoundation.org>
References: <20250310170427.529761261@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
@@ -431,13 +431,14 @@ static int nilfs_rename(struct user_name
 	old_inode->i_ctime = current_time(old_inode);
 
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
 


