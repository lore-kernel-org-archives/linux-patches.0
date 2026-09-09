Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A6072563FA1;
	Wed,  9 Sep 2026 14:08:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788962932; cv=none; b=TjxqqDIFdqGAjLPJqjBXFVA/nVlNWPxLeE+MF4NpaWjj8T/jitAg2trOEqHGG3DnxTEPnpcZxMNnG8es1GoTM1/ruvLJXWGR5siCYECrdqzZOQp6xLW+8kxECmW8eXyeSN5bG07xbCeXUR+2Mk0+h3OV+pMPgJV4kmM4kP22MY4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788962932; c=relaxed/simple;
	bh=2rHJt4s/Q1h9m0ZS0pUKV3b7vmRkz/mNr7wrbcGVoLk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=HX7S7v/B09yJrYqgwt5qtlOygpVnQApySLvIl7u60ZLi30T+yIXWP/agY1DYGxP/Wpvnt8xCgAVJEMzIDzHyo6iblX1uibvFQ1dqj/V55hkxoWJkolnxmNN7p00B6a/h0RoixL/teDIftyjWv6eY6/aEU7eJ9b8B64CxIoGXQsk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=vibnx0sp; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="vibnx0sp"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id ECB681F00A3D;
	Wed,  9 Sep 2026 14:08:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1788962931;
	bh=pOorHh0uT8RqxyF06l2ow/ROLhUaEWPDgHg3YM5Am6c=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=vibnx0spt08J5SCF6ohXQknDLxyQjL742+CMVPuJkTStgQrWGGmM5r8fE6SNk/APR
	 4/HW3HojdJnJRKAdn/s1yT/N2B3MePtcW6Bg+wrw4tkK5kLJJDwnX5+cGqZAPAeI3n
	 wEI78rv5Y4MgmieUeXiBhwochARUOzevdRqAlXOo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	stable@kernel.org,
	Chao Yu <chao@kernel.org>,
	Jaegeuk Kim <jaegeuk@kernel.org>
Subject: [PATCH 7.2 462/556] f2fs: fix to avoid potential deadloop in f2fs_fsync_node_pages()
Date: Wed,  9 Sep 2026 15:42:22 +0200
Message-ID: <20260909134246.818694207@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260909134230.441546314@linuxfoundation.org>
References: <20260909134230.441546314@linuxfoundation.org>
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

7.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Chao Yu <chao@kernel.org>

commit ce366bfa821ec81dd45bde547ee31e659306cc61 upstream.

There is potential deadloop in race condition:

Thread A				Thread B
- fsync
 - f2fs_do_sync_file
  - f2fs_fsync_node_pages
   - last_fsync_dnode
    - folio_get(last_folio)
					- f2fs_setattr
					 - f2fs_truncate
					  - f2fs_truncate_blocks
					   - f2fs_do_truncate_blocks
					    - f2fs_truncate_inode_blocks
					     - truncate_dnode
					      - truncate_node
					       - invalidate_mapping_pages
					        - folio->mapping = NULL
   - is_node_folio alwasy return false
   - atomic && !marked is always true,
     then goto retry

Cc: stable@kernel.org
Fixes: 608514deba38 ("f2fs: set fsync mark only for the last dnode")
Signed-off-by: Chao Yu <chao@kernel.org>
Signed-off-by: Jaegeuk Kim <jaegeuk@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/f2fs/node.c |    5 +++++
 1 file changed, 5 insertions(+)

--- a/fs/f2fs/node.c
+++ b/fs/f2fs/node.c
@@ -2009,6 +2009,11 @@ continue_unlock:
 		f2fs_debug(sbi, "Retry to write fsync mark: ino=%u, idx=%lx",
 			   ino, last_folio->index);
 		folio_lock(last_folio);
+		if (unlikely(!is_node_folio(last_folio))) {
+			f2fs_folio_put(last_folio, true);
+			ret = -EAGAIN;
+			goto out;
+		}
 		f2fs_folio_wait_writeback(last_folio, NODE, true, true);
 		folio_mark_dirty(last_folio);
 		folio_unlock(last_folio);


