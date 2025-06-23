Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5C57424169B;
	Mon, 23 Jun 2025 13:12:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750684348; cv=none; b=OSAokR1vfWzgabR6fNFPjFkoWzYkWmtGLJYqJkBiqHwRL56rOa5StGT7fgO8aFhpkQuh7CISQrfv3X55B46MOEJadfwHnIhlRZFfIINB0YoCcF9IXzV+GYZOf7ITuWSHf7/uvOMZHhfWXzQ5x5Ifu3fRiB+kraPpXyDzWBw/4j8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750684348; c=relaxed/simple;
	bh=cFHNjNvj2Fh6ioNTVyUDOwPU9sGDj5zRc7n00DyV9W4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=CmJDrK/oLz443M30xHCOcQiq4Pp1LrPvczOuUdqCdyil5IveN2keY/E5QglHd5Q67ilsyz6Sz3oaCKuhukMDeZkcIIopPViNtilHHiVmftIW963UyTWI08teBTilJLxKw/zLh6LFJBD+MKX5+keSTeMubHxB5psMZMFN0Kios+U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=mZxo7206; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="mZxo7206"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E6645C4CEEA;
	Mon, 23 Jun 2025 13:12:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1750684348;
	bh=cFHNjNvj2Fh6ioNTVyUDOwPU9sGDj5zRc7n00DyV9W4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=mZxo7206OWZahWTRKsXs6YXzKJGocyv3+mn4zdHxrwpYUjEG+PCeV/vzzgA2aaglQ
	 ORiUI8v29zmt2smCtJFfHlzt4NSQKpA+uWx70udXmASzVrcefDZsZXMyiMvgfZoI0m
	 YPWSCph7QagYiCvG8pHxTAJlc+e4APucmlnxogF8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jeff Layton <jlayton@kernel.org>,
	Christian Brauner <brauner@kernel.org>
Subject: [PATCH 6.15 035/592] anon_inode: raise SB_I_NODEV and SB_I_NOEXEC
Date: Mon, 23 Jun 2025 14:59:53 +0200
Message-ID: <20250623130701.082161969@linuxfoundation.org>
X-Mailer: git-send-email 2.50.0
In-Reply-To: <20250623130700.210182694@linuxfoundation.org>
References: <20250623130700.210182694@linuxfoundation.org>
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

6.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Christian Brauner <brauner@kernel.org>

commit 1ed95281c0c77dbb1540f9855cd3c5f19900f7a5 upstream.

It isn't possible to execute anonymous inodes because they cannot be
opened in any way after they have been created. This includes execution:

execveat(fd_anon_inode, "", NULL, NULL, AT_EMPTY_PATH)

Anonymous inodes have inode->f_op set to no_open_fops which sets
no_open() which returns ENXIO. That means any call to do_dentry_open()
which is the endpoint of the do_open_execat() will fail. There's no
chance to execute an anonymous inode. Unless a given subsystem overrides
it ofc.

However, we should still harden this and raise SB_I_NODEV and
SB_I_NOEXEC on the superblock itself so that no one gets any creative
ideas.

Link: https://lore.kernel.org/20250407-work-anon_inode-v1-5-53a44c20d44e@kernel.org
Reviewed-by: Jeff Layton <jlayton@kernel.org>
Cc: stable@vger.kernel.org # all LTS kernels
Signed-off-by: Christian Brauner <brauner@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/anon_inodes.c |    2 ++
 1 file changed, 2 insertions(+)

--- a/fs/anon_inodes.c
+++ b/fs/anon_inodes.c
@@ -86,6 +86,8 @@ static int anon_inodefs_init_fs_context(
 	struct pseudo_fs_context *ctx = init_pseudo(fc, ANON_INODE_FS_MAGIC);
 	if (!ctx)
 		return -ENOMEM;
+	fc->s_iflags |= SB_I_NOEXEC;
+	fc->s_iflags |= SB_I_NODEV;
 	ctx->dops = &anon_inodefs_dentry_operations;
 	return 0;
 }


