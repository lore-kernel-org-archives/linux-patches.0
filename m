Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0CB69F9D4;
	Tue, 14 May 2024 11:58:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1715687882; cv=none; b=itqg8fBcn2ZYKoTINkbMkSUh/f8heIxXJehOdoaZvmV+K9S1dzKVOe8lHTESQgFcbdi73H1gNGRBO8Yhjjnh93bAg4+wpkQ5nh3izobr9poG1mps+XaTVqHhDcVLRnBO9WWVWyHnQskDriYy94w1sS7ImEwWV/PZBZxDagSevrU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1715687882; c=relaxed/simple;
	bh=9ToNT/SmeeIQajBW1g7pOnWk5HoQdk5qVLEfhVNWcC0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=OffRzS97++jjREMKe4ZFOHl8O17Me93Hom6eSpOhiZZA71yOklYM9djS9D2sSEi+GEMgStHYEgBGzEbXyaJQLhJBfrlFOaOD7VgqOe9vonaqpSWjEiSYfo3ld7dnYAQozXBB8N8TAGKYveCv4lNnqAFUUM5Clde2ASgvgFu2YeM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=HS+m729T; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="HS+m729T"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 87546C2BD10;
	Tue, 14 May 2024 11:58:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1715687881;
	bh=9ToNT/SmeeIQajBW1g7pOnWk5HoQdk5qVLEfhVNWcC0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=HS+m729Tcb9LtFhcqpcSTtYwdoOUcbqwOgssQ29esfLVIqNMjg5YkwO4JeNpmkP0k
	 aRfrJ7pWuDiR5MOzSCFFSMg8IabO/E6OS4fWumhIZpV3REAuaSwICg1fM+Pl9/GOs6
	 1B9pPbKQslGR0Smjee1spMpjlcb/1VOrBvzUlzEU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dmitry Antipov <dmantipov@yandex.ru>,
	David Sterba <dsterba@suse.com>
Subject: [PATCH 5.15 137/168] btrfs: fix kvcalloc() arguments order in btrfs_ioctl_send()
Date: Tue, 14 May 2024 12:20:35 +0200
Message-ID: <20240514101011.857810000@linuxfoundation.org>
X-Mailer: git-send-email 2.45.0
In-Reply-To: <20240514101006.678521560@linuxfoundation.org>
References: <20240514101006.678521560@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
@@ -7612,8 +7612,8 @@ long btrfs_ioctl_send(struct file *mnt_f
 	sctx->waiting_dir_moves = RB_ROOT;
 	sctx->orphan_dirs = RB_ROOT;
 
-	sctx->clone_roots = kvcalloc(sizeof(*sctx->clone_roots),
-				     arg->clone_sources_count + 1,
+	sctx->clone_roots = kvcalloc(arg->clone_sources_count + 1,
+				     sizeof(*sctx->clone_roots),
 				     GFP_KERNEL);
 	if (!sctx->clone_roots) {
 		ret = -ENOMEM;


