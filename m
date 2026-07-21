Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 93007430CDC;
	Tue, 21 Jul 2026 19:46:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784663190; cv=none; b=KxBkp3FPp7b7zcc6HjDzZXeNvpblDUpDGZHvRYI5aWLmi9j50PaDu4Dxlk5ujfhL6QBpglO1gpjT9Zb/7J6qSmvBXTqz55WVJBdFE2YSEjahmHutDH1vvJ96jqRS+eUSic0nMCE9tWIUd3qrvrOS5/fgXsvT5cO8RtTZxoFXPh8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784663190; c=relaxed/simple;
	bh=+b9tPBTcyjDl+K8TDbJ8h3G9G/KxgB77IZUhfXgSBSk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ZcfB0HfiCAXuEGF1O/Iw/8Aevdnx7CzyHQejETCN0EAyXtWdgkg7gKF7Apa483KAIUugMBiV5xYxbp3Grn5sdJEuTCD4drzW6IRT9gLQfU4m08czxg2y5xmRXXPvf3fMxndNs4wbF17UwL7+bxEkat+vmJAJXh5YQx+ewLsMsC4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=nROdkAuR; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="nROdkAuR"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EF24F1F000E9;
	Tue, 21 Jul 2026 19:46:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784663189;
	bh=2tjIz61bL7t1ROpmeNWxvQAePT1/IsGxDRyf+Affy2w=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=nROdkAuRSylTqowbN3VQIS8KBmMd4qGI4+/WPLS/1+iJ6fhF5/2hCyGhOqQb9e/dc
	 bRxYCkz1PZjfDPjVSq7I2rmN6yilGNq6/crkFwDEOfSXR6SkSJQARJElsnzn9oUiVO
	 7LjUbVJLfe5W1OdjPr1qLmOzd97yAZdBaKMWtS2I=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	David Howells <dhowells@redhat.com>,
	Marc Dionne <marc.dionne@auristor.com>,
	linux-afs@lists.infradead.org,
	"Christian Brauner (Amutable)" <brauner@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 0728/1276] afs: Fix double netfs initialisation in afs_root_iget()
Date: Tue, 21 Jul 2026 17:19:31 +0200
Message-ID: <20260721152502.375295712@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152446.065700225@linuxfoundation.org>
References: <20260721152446.065700225@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: David Howells <dhowells@redhat.com>

[ Upstream commit 733a984a4ee7345325e47efb505eebfe67b299bc ]

Fix afs_root_iget() to leave initialisation of the netfs_inode part of the
afs_vnode to afs_inode_init_from_status().

Fixes: bc899ee1c898 ("netfs: Add a netfs inode context")
Closes: https://sashiko.dev/#/patchset/20260609081738.770127-1-dhowells%40redhat.com
Signed-off-by: David Howells <dhowells@redhat.com>
Link: https://patch.msgid.link/20260622090856.2746629-5-dhowells@redhat.com
cc: Marc Dionne <marc.dionne@auristor.com>
cc: linux-afs@lists.infradead.org
Signed-off-by: Christian Brauner (Amutable) <brauner@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/afs/inode.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/fs/afs/inode.c b/fs/afs/inode.c
index a95e77670b4945..c4f92aaa252759 100644
--- a/fs/afs/inode.c
+++ b/fs/afs/inode.c
@@ -546,7 +546,6 @@ struct inode *afs_root_iget(struct super_block *sb, struct key *key)
 
 	vnode = AFS_FS_I(inode);
 	vnode->cb_v_check = atomic_read(&as->volume->cb_v_break);
-	afs_set_netfs_context(vnode);
 
 	op = afs_alloc_operation(key, as->volume);
 	if (IS_ERR(op)) {
-- 
2.53.0



