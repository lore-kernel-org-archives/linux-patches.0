Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 082854119F8;
	Thu, 30 Jul 2026 14:49:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785422945; cv=none; b=o8UfV7EHQsOfb8QJfPqwtmj8xBSdO23TgPg91VBbQbRfgwRLKJlb7R93pkgFek9ygnqiM1sgVBLtX5mvNd5N8G054fh38WrkVrfd1Ape/CyW5t7wc/tPgLIlht5mrpDF3WVctzk5ychjrkY7dI+w5RIfvn0UIWA51vp+gRbnXYY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785422945; c=relaxed/simple;
	bh=19yEBl0aec3K8E1ZjIJVgPUB/RbaOwYjE/90+fqkEr8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=GtWxLtlU4KxshMSzuPAgDtHWWHL5o4IkyUGAvwCA101sx+Hs2IiQr0+FgeYwsjAR3keHTPXS+DesDFywkWnAtYLnOSs51kfboGZQy5N+fjMBuKb6O9aT62DzD8zfDoCJMPnvaUbpeRLIVhX3uVwbJXQy0Yd5lAt315cHPQOgPKc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=aG2xlSy3; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="aG2xlSy3"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 602381F000E9;
	Thu, 30 Jul 2026 14:49:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1785422943;
	bh=vAWMFYf4RujFxCwVfT8LzM3oIfdzzvLK//gqYZ3WVS8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=aG2xlSy3VAQK8x0tX1fZbJDh8p71jXayRLWwE4F09I5R/pbsMBqsZm9TPkhAnkEj+
	 D5J/t/AIvYKSE8j8WssfqCabcQRL/t0SJTJMlAc5cZihsixBDL5JTmxmBlGMfdVGVp
	 Ln3cYYZ8fQwDBm3Fn5yRHdG8w48F/o9S9ldOGMYE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	David Howells <dhowells@redhat.com>,
	Marc Dionne <marc.dionne@auristor.com>,
	linux-afs@lists.infradead.org,
	linux-fsdevel@vger.kernel.org,
	"Christian Brauner (Amutable)" <brauner@kernel.org>
Subject: [PATCH 7.1 612/744] afs: Fix afs_edit_dir_remove() to get, not find, block 0
Date: Thu, 30 Jul 2026 16:14:45 +0200
Message-ID: <20260730141457.282631073@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260730141444.267951807@linuxfoundation.org>
References: <20260730141444.267951807@linuxfoundation.org>
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

7.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: David Howells <dhowells@redhat.com>

commit 62d9853aa4ce6e9797b6949804891be14b219752 upstream.

Fix afs_edit_dir_remove() to use afs_dir_get_block() to get block 0 rather
than afs_dir_find_block() as the latter caches the found block in the
afs_dir_iter and may[*] switch out the page it's on if another
afs_dir_find_block() is done.  This parallels what afs_edit_dir_add() does.

[*] There's more than one block per page.

Fixes: a5b5beebcf96 ("afs: Use the contained hashtable to search a directory")
Closes: https://sashiko.dev/#/patchset/20260706153408.1231650-1-dhowells%40redhat.com
Signed-off-by: David Howells <dhowells@redhat.com>
Link: https://patch.msgid.link/2380759.1783956175@warthog.procyon.org.uk
cc: Marc Dionne <marc.dionne@auristor.com>
cc: linux-afs@lists.infradead.org
cc: linux-fsdevel@vger.kernel.org
cc: stable@vger.kernel.org
Signed-off-by: Christian Brauner (Amutable) <brauner@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/afs/dir_edit.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/fs/afs/dir_edit.c
+++ b/fs/afs/dir_edit.c
@@ -415,7 +415,7 @@ void afs_edit_dir_remove(struct afs_vnod
 	if (!afs_dir_init_iter(&iter, name))
 		return;
 
-	meta = afs_dir_find_block(&iter, 0);
+	meta = afs_dir_get_block(&iter, 0);
 	if (!meta)
 		return;
 


