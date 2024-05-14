Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 287A92943F;
	Tue, 14 May 2024 11:21:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1715685660; cv=none; b=rNrRSOax5aXXqt8kkbdOBcd5naWva32CkibcvCwnf5ihgVrid4gAt6ZWi7lRzmXHlElEpFHvHMwel4rvj9j+glR5PajQ1kevQp6iWyw3rkx2nxNQL40ykVfAMpVeBqCbhzg5AxgPFhb3gr+9Cs7aDIGuhuzc88e1Z0THINLZ8AA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1715685660; c=relaxed/simple;
	bh=+axa3usUiILB0xzyeGZeVIaT6ZTohAVv3RQjQnZ+HPg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=dCo6Sxy8JM6R7JTokA0f8tuaRElZa4OuQmynrOFK8AI2l0/g4bEvjgloNvH5BQZmNy8KYNFTnrbOgUcS2VJPdiZvUi1JBEEHFhp+3YIERJTjC3JqoLqVoclhsWo8Qup9RDzjG6Xl4U/0ZrJ9bWH1gGbr1DsBHh5YxGsRyNT89ww=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=uIZzktpd; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="uIZzktpd"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 42DF5C2BD10;
	Tue, 14 May 2024 11:20:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1715685660;
	bh=+axa3usUiILB0xzyeGZeVIaT6ZTohAVv3RQjQnZ+HPg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=uIZzktpdeSUdXkECktlqk3wVQFHd3t+8OeZd4nhodtCXuTHbozPeS2UrVkUyVaZSm
	 TFX4xjA5+N9KCpGWG1gINOZz3rx3MYT17ckUIcchWju5Fc6NCOZUILuBCTlZXJ/I3K
	 6QoDaZKcs8dpkz3kwi/TC1MToQnhbDTVXcvxXLXU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dmitry Antipov <dmantipov@yandex.ru>,
	David Sterba <dsterba@suse.com>
Subject: [PATCH 6.6 222/301] btrfs: fix kvcalloc() arguments order in btrfs_ioctl_send()
Date: Tue, 14 May 2024 12:18:13 +0200
Message-ID: <20240514101040.638866522@linuxfoundation.org>
X-Mailer: git-send-email 2.45.0
In-Reply-To: <20240514101032.219857983@linuxfoundation.org>
References: <20240514101032.219857983@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
@@ -8222,8 +8222,8 @@ long btrfs_ioctl_send(struct inode *inod
 		goto out;
 	}
 
-	sctx->clone_roots = kvcalloc(sizeof(*sctx->clone_roots),
-				     arg->clone_sources_count + 1,
+	sctx->clone_roots = kvcalloc(arg->clone_sources_count + 1,
+				     sizeof(*sctx->clone_roots),
 				     GFP_KERNEL);
 	if (!sctx->clone_roots) {
 		ret = -ENOMEM;


