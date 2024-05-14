Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6563C12C554;
	Tue, 14 May 2024 11:37:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1715686662; cv=none; b=oXlQFt56x7o46XwjywSz0EVSRC/gYeC5hbZJWHXHpST+4ocgdMFeJUyts7/iSCIBcaVPeLz7ChS0x/mzRC9oUpbQZ6tS349mupBz26D0pzRbaL/Buu+wZ2Vcl1NyFCPdJJA4TQdMVSrLlFjV90SJTNWcIVgw18FRSWrjah09v9w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1715686662; c=relaxed/simple;
	bh=QuLm9NjaY11PDi9L7Job+EWVw1F2G3jnvwd1HmDN2R8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=lgysPMTp6pvLl3+kSDNyhG6Jf3ST8tqqgtFxV5+e9H+DOwVYPtHVnNIYkJ88p6jSwe0gmuDmUJA3XLjzOglUva88kETxzU0ySDvWU55omComNa4ASIruTeE0jGhBLqJZ+toYZQ7MGgX5HmKKRKmMupcRTCgafync1Ki7x6DB7Lw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=OhaHRszK; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="OhaHRszK"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E1651C2BD10;
	Tue, 14 May 2024 11:37:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1715686662;
	bh=QuLm9NjaY11PDi9L7Job+EWVw1F2G3jnvwd1HmDN2R8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=OhaHRszKscLfQEj162Ip8GlpD4cPrbeEnYZEpN7++fPJuU4nnZx+Vn0T70/0obCEi
	 jTMixphFofw0eWxagJkePRhU4Fpum/y5z7W2gx2eObyN2KcXUZ8+NI1KXK2ylQCGpM
	 kxXqfkqNDbFDTa39zBxmtN1Br/zG25f88N64YSRo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dmitry Antipov <dmantipov@yandex.ru>,
	David Sterba <dsterba@suse.com>
Subject: [PATCH 6.1 184/236] btrfs: fix kvcalloc() arguments order in btrfs_ioctl_send()
Date: Tue, 14 May 2024 12:19:06 +0200
Message-ID: <20240514101027.350774095@linuxfoundation.org>
X-Mailer: git-send-email 2.45.0
In-Reply-To: <20240514101020.320785513@linuxfoundation.org>
References: <20240514101020.320785513@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Dmitry Antipov <dmantipov@yandex.ru>

commit 6ff09b6b8c2fb6b3edda4ffaa173153a40653067 upstream.

When compiling with gcc version 14.0.0 20231220 (experimental)
and W=1, I've noticed the following warning:

fs/btrfs/send.c: In function 'btrfs_ioctl_send':
fs/btrfs/send.c:8208:44: warning: 'kvcalloc' sizes specified with 'sizeof'
in the earlier argument and not in the later argument [-Wcalloc-transposed-args]
 8208 |         sctx->clone_roots = kvcalloc(sizeof(*sctx->clone_roots),
      |                                            ^

Since 'n' and 'size' arguments of 'kvcalloc()' are multiplied to
calculate the final size, their actual order doesn't affect the result
and so this is not a bug. But it's still worth to fix it.

Signed-off-by: Dmitry Antipov <dmantipov@yandex.ru>
Reviewed-by: David Sterba <dsterba@suse.com>
Signed-off-by: David Sterba <dsterba@suse.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/btrfs/send.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/fs/btrfs/send.c
+++ b/fs/btrfs/send.c
@@ -7955,8 +7955,8 @@ long btrfs_ioctl_send(struct inode *inod
 	sctx->rbtree_new_refs = RB_ROOT;
 	sctx->rbtree_deleted_refs = RB_ROOT;
 
-	sctx->clone_roots = kvcalloc(sizeof(*sctx->clone_roots),
-				     arg->clone_sources_count + 1,
+	sctx->clone_roots = kvcalloc(arg->clone_sources_count + 1,
+				     sizeof(*sctx->clone_roots),
 				     GFP_KERNEL);
 	if (!sctx->clone_roots) {
 		ret = -ENOMEM;


