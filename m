Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E264C3101A7;
	Fri,  7 Aug 2026 15:11:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786115472; cv=none; b=sPMXAxBtX12U+LqBn5DdKaghlFEqT/oh9h1yvsaohuHMtgF3CINtqksTGkuGIIGeqfPS8oP0eseB58e8J9EU2t2B28MD8FCD7UuLbr0o5WpCamu83Mu2jsfhSRlfFxMTyN9V7XZQ0WT5cGg82KqjzHGRBbm3aHCBYYUsC5g3EQY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786115472; c=relaxed/simple;
	bh=bkZBog54VyExC+3+6p+6+dfPk0zhYaEHxFfMg5ksNs8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=rCU6AFfM7zOEmC34LOP8goqAJNoQtNaQeHng0ytmXxwjNp6xWAI+5cErVMFwk2F8ZYtbPs7MAg4dBGxPoh54/7i/tLx0wr3IME5POmum6a4kaH74u3fAQxs5maQ+hIbmqCT0BoTbjzGFZEydvvR0YSvCRjcb0/hMtMC82UGXnSA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=bx2grHkQ; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="bx2grHkQ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 453831F000E9;
	Fri,  7 Aug 2026 15:11:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1786115470;
	bh=mM85KS+N0NgZBa8D7IZo6rvJnAXv8vMXjMBhnmua/m8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=bx2grHkQDt7pLQuaSugMziwqNFWZqCzAtyR+Jx5+P6tAoOM4TXg1VOlkgMHeGug0m
	 4/EQ7E+gU+ZDLFJJkH8+DE+8OLpOlZ+OYi/RrI1C+2m6Qs3FE0TmCmWyY0YFKZmwOu
	 EHhqNCaZ9RcEF8wKWDZ2jqHcS4qNL73f94R+CuUg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Christian Brauner (Amutable)" <brauner@kernel.org>
Subject: [PATCH 6.18 234/396] binfmt_misc: dont let an F entry pin its own instance
Date: Fri,  7 Aug 2026 16:36:34 +0200
Message-ID: <20260807143429.305141111@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260807143424.272339768@linuxfoundation.org>
References: <20260807143424.272339768@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Christian Brauner <brauner@kernel.org>

commit 79055d82772b9584f259b747fe40ff56a076678d upstream.

An entry registered with 'F' opens its interpreter at registration time
and holds that file until the entry is freed. Any entry nobody removes
by hand only gets closed once the binfmt_misc superblock is shut down.
If the interpreter lives on a mount that keeps that superblock alive the
two pin each other:

    binfmt_misc sb -> inode -> entry -> interp_file -> vfsmount -> binfmt_misc sb

TL;DR the file is never closed. Once the mount namespace is gone there
is nothing left to unregister through either.

There are two ways to trigger this bug:

- Point the interpreter at the instance itself. Its files are regular
  files owned by the mounter and both bm_get_inode() and
  simple_fill_super() leave i_op at empty_iops. So notify_change() falls
  back to simple_setattr() and chmod +x works. We never set SB_I_NOEXEC
  and so open_exec() accepts it.

- Use the instance as an overlayfs lower layer. The overlay superblock
  holds a clone_private_mount() of every layer until it is destroyed and
  that clone is in no namespace. So umount_tree() never reaches it.

That's a DoS. And it isn't only the superblock that leaks. It pins the
user namespace it was mounted in, so every iteration permanently eats
one of the caller's user namespace charges.

So let's just do the sane thing. SB_I_NOEXEC makes open_exec() fail on
the instance's own files and s_stack_depth makes overlayfs reject the
layer before it ever takes a clone. That also covers the ecryptfs and
fuse passthrough variants. What 'F' promises is unchanged.

The stable tag is narrower than the Fixes tags on purpose. Before
sandboxed mounts this needed global root against the single instance
everyone shares, and the change doesn't apply to those trees anyway.

Note that SB_I_NODEV is implicitly raised for userns mounts but raise it
explicitly here as well.

Link: https://patch.msgid.link/20260728-work-binfmt_misc-selfpin-v1-1-74df5daeca5b@kernel.org
Fixes: 948b701a607f ("binfmt_misc: add persistent opened binary handler for containers")
Fixes: 21ca59b365c0 ("binfmt_misc: enable sandboxed mounts")
Cc: stable@vger.kernel.org # v6.7+
Signed-off-by: Christian Brauner (Amutable) <brauner@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/binfmt_misc.c |    4 ++++
 1 file changed, 4 insertions(+)

--- a/fs/binfmt_misc.c
+++ b/fs/binfmt_misc.c
@@ -956,6 +956,10 @@ static int bm_fill_super(struct super_bl
 	if (WARN_ON(user_ns != current_user_ns()))
 		return -EINVAL;
 
+	/* Never exec off this instance and never let anything stack on it. */
+	sb->s_iflags |= SB_I_NOEXEC | SB_I_NODEV;
+	sb->s_stack_depth = FILESYSTEM_MAX_STACK_DEPTH;
+
 	/*
 	 * Lazily allocate a new binfmt_misc instance for this namespace, i.e.
 	 * do it here during the first mount of binfmt_misc. We don't need to


