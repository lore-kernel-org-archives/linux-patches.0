Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E64B5255E37;
	Tue, 11 Mar 2025 15:40:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741707654; cv=none; b=hSMoJzOAQ+ejvrT1gV8yTCVZ80QwmzVoO5XCa251qnZ1/aTpdiNIXYk3Mg2DjMmGrDo0evewZWAybESBiq9GRpbBuetNP78V/pQi9atxHFT0hDyLefxVKclB52qzQ4m1KoOuqtuLy+nXkShhvsjQlPHwfK54NaknA5P5TIHNscA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741707654; c=relaxed/simple;
	bh=fMe9vpsv/mX+hArS+k7JbD/vf6kvt1Dw4m6tthuH0Bw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=iAz08t6VsJ3+1UHB9MLnz+so2ZlrMm4nPE4W21b0cs+D8DUv9Zj0EvdVfK8Fb2zy9BtuNgY3K09JfyVQurlsQnqfHZ0vIUVCKjSg/+xVhQalG9tQIHgkDXFykp0grgnwjZETAeXlTaAEDNkMCZfB7NBfnSLZaboiNJ5OaIkBNuI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=gYgJGcB8; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="gYgJGcB8"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6EEF5C4CEE9;
	Tue, 11 Mar 2025 15:40:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1741707653;
	bh=fMe9vpsv/mX+hArS+k7JbD/vf6kvt1Dw4m6tthuH0Bw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=gYgJGcB8kOnibYg7jhD69ZyVPjclBf6vuGXDVN8utIFvTWcH3r7e3H+gIFL9gtCHP
	 NYHCDjgKFv77ajQzYg19uBld3yue+RR5IhD4ofC0lWj2rnJdAAgk3yRbGo1uXsBcpq
	 xEOtcxMNyM95JrsG2deSGDPz+BaWSQUj4D8NXQEI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ryusuke Konishi <konishi.ryusuke@gmail.com>,
	"Matthew Wilcox (Oracle)" <willy@infradead.org>,
	Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH 5.10 447/462] nilfs2: eliminate staggered calls to kunmap in nilfs_rename
Date: Tue, 11 Mar 2025 16:01:53 +0100
Message-ID: <20250311145815.985069859@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250311145758.343076290@linuxfoundation.org>
References: <20250311145758.343076290@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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
@@ -428,13 +428,14 @@ static int nilfs_rename(struct inode *ol
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
 


