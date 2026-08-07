Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AE621432E85;
	Fri,  7 Aug 2026 15:42:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786117362; cv=none; b=THNF21We9/SHWUug06ApOe1HI7bg/DltXWCzfGTQYf9lBKPEVC3ekPiG0EiJ20nyjQpkEOkEX9musl51jGtyqMlUE1RgvCnwaAKjGm+lvgFme1WK7e/Pb8rF5IcPsb7nwcyhh5aKqEKdWz1L6zHo8/WMlEAvjepxnHgLF4EkzC8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786117362; c=relaxed/simple;
	bh=Y8LFSVpVBayPu14StAxTf/wDPaAAPX3b+vki4VclDpI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=MdHCYLsryUyEYGbgcRbo8zaBTGV5/0+LNRmSdEwdr0moU9uagqggxAJftYOOOunEtL78Sxx8xE9wf6cOTf9YQsd2Wjd6iMPBdv/zUMu2giCj2S01S04FUlENpAecd3vihEWNodpPiBIz0znxSVNw9m0+KBRyZs+TUJ7S0n99Xmo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=sLa5u4XO; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="sLa5u4XO"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 083E41F000E9;
	Fri,  7 Aug 2026 15:42:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1786117361;
	bh=XKCTJQ1CQq7eQ0y71hDRinKOsGEKhg4bNaUIZamxa1A=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=sLa5u4XOwBP2NIjagXuCrW0xsnroi4BR3L7KMKiLkANbf3E8SpFoRZ7Z27Q+pBfWS
	 tECuLUwvFFnhIv4VOqS52c3w3ifGtoDXN2HG0nz1QPdyab7SF+7RnREjQgXH5aNKTM
	 l1hdOgKBSUcSx5bZBQ6rMbkdiQ9s9bs0GzB8I1F8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Christian Brauner (Amutable)" <brauner@kernel.org>
Subject: [PATCH 7.1 291/438] binfmt_misc: dont let an F entry pin its own instance
Date: Fri,  7 Aug 2026 16:38:07 +0200
Message-ID: <20260807143434.179126635@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260807143428.008222056@linuxfoundation.org>
References: <20260807143428.008222056@linuxfoundation.org>
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
@@ -949,6 +949,10 @@ static int bm_fill_super(struct super_bl
 	if (WARN_ON(user_ns != current_user_ns()))
 		return -EINVAL;
 
+	/* Never exec off this instance and never let anything stack on it. */
+	sb->s_iflags |= SB_I_NOEXEC | SB_I_NODEV;
+	sb->s_stack_depth = FILESYSTEM_MAX_STACK_DEPTH;
+
 	/*
 	 * Lazily allocate a new binfmt_misc instance for this namespace, i.e.
 	 * do it here during the first mount of binfmt_misc. We don't need to


