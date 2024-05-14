Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EA8D52B9AD;
	Tue, 14 May 2024 11:50:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1715687440; cv=none; b=Tils6iYg7hDbvsZvmQE7QYsuXy9Svd1+QDbhGDil2UqLgAdNODUbo55eG5wrhn5g9yXffm3AWmvOUrDrMcAQlJueOJ05/M9+zVNpIZgvAou90m9KC00kTZjH5T2W7S45qSdQ/6Fy9gcys7zBcCtaDLtAR2GplOQ/C2fyirJ+lzU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1715687440; c=relaxed/simple;
	bh=X73BQ/SqrrdAwB9c33BZmUhqPpFqkJ5fxffnEbc5qqg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=i/bsrDVtCk8zGiMgcxXKF93nueeB2VCf7R0MViHU9T1HQ08VmGmHIAYfNJxipvNNPqTG8WnQVtWHdH2ixMAakkHqv36SJ13D+4BtUY8YqdyWrwMommVuh4VGpFVsktKZSj4rhtbRTo9qiZ4ksQwGWMEf8vYkOjrQGEmhviPd8UM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=SSyrDyGI; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="SSyrDyGI"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2ABF4C2BD10;
	Tue, 14 May 2024 11:50:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1715687439;
	bh=X73BQ/SqrrdAwB9c33BZmUhqPpFqkJ5fxffnEbc5qqg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=SSyrDyGIZOdXWTDdh/1yxk347bDrMkJipGNHIVC3zJATSWiz/bzsTCb+kQ3BT/0St
	 Mqvrp2Be0DOxDZe3L9cE3M63l2il7mktho6Y5iTky7Z7tCKwuoBRLhvFRALhH5p8KS
	 2DmVXQEI2BoG/tow8Vvk1t4QgnxjAW8SSdS3QPeY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dmitry Antipov <dmantipov@yandex.ru>,
	David Sterba <dsterba@suse.com>
Subject: [PATCH 5.10 089/111] btrfs: fix kvcalloc() arguments order in btrfs_ioctl_send()
Date: Tue, 14 May 2024 12:20:27 +0200
Message-ID: <20240514101000.512490395@linuxfoundation.org>
X-Mailer: git-send-email 2.45.0
In-Reply-To: <20240514100957.114746054@linuxfoundation.org>
References: <20240514100957.114746054@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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
@@ -7339,8 +7339,8 @@ long btrfs_ioctl_send(struct file *mnt_f
 	sctx->waiting_dir_moves = RB_ROOT;
 	sctx->orphan_dirs = RB_ROOT;
 
-	sctx->clone_roots = kvcalloc(sizeof(*sctx->clone_roots),
-				     arg->clone_sources_count + 1,
+	sctx->clone_roots = kvcalloc(arg->clone_sources_count + 1,
+				     sizeof(*sctx->clone_roots),
 				     GFP_KERNEL);
 	if (!sctx->clone_roots) {
 		ret = -ENOMEM;


