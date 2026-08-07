Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A53593F58C4;
	Fri,  7 Aug 2026 14:49:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786114196; cv=none; b=QxzsWJu8bMUonTaMSoBrhKB8HddGxq0xHbIOrbL1mxv1Iv8vh/Oj04Or+Q1jpLYWhNcVDlmMuYwWw6M5Um+L++wg0angDPw2PHAYdTuTXFXwm9ZfI0stknDlf8BmQ6cXE0l+51vEqWqiLTcfJDKP7HpFnit8cgm6ncxmxzgP3iQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786114196; c=relaxed/simple;
	bh=P4+lfs31hRUhLGiHL/AGfLPvep/tuDKsQ+mv3dgLt+U=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=JfjiAcit2HA8EFtkH3ZKIhuKDXWkEOsTj8/8/TmdmpQwL9zL2PJ0zwBtLbZEr/Jph/nZozuDcrPstcE5uMQBu/67yCycDJGhDU3PhmXDiI/YDZiNBVwkUWmUcEMfNICXEkhA9qhlgMzv1YuZGYLb7LLtpW84O6zWDHyWHyVWmgY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=hYUXzFRt; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="hYUXzFRt"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 02CE01F000E9;
	Fri,  7 Aug 2026 14:49:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1786114195;
	bh=0XhXX9jLAw5ByXHrgaKfMi6+gyKzCDG3AJCYc479RuU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=hYUXzFRt3maOVmQlYYskrLA4HwvM3Ds4/yhDDh749dl568VpFA7Uu4hYxjvVQyyOh
	 QHnI2C8VGXVjudxBXS95Q+8VajoJH8Rd2ywz6lxLBnNX5d3nLivKvYNuHsyrKkmi1J
	 CYfuwd/+bN7h0LQedoiq1cU06ud08eLAWByqNsAE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Christian Brauner (Amutable)" <brauner@kernel.org>
Subject: [PATCH 6.12 179/337] binfmt_misc: dont let an F entry pin its own instance
Date: Fri,  7 Aug 2026 16:36:22 +0200
Message-ID: <20260807143422.441184101@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260807143418.516897842@linuxfoundation.org>
References: <20260807143418.516897842@linuxfoundation.org>
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
@@ -986,6 +986,10 @@ static int bm_fill_super(struct super_bl
 	if (WARN_ON(user_ns != current_user_ns()))
 		return -EINVAL;
 
+	/* Never exec off this instance and never let anything stack on it. */
+	sb->s_iflags |= SB_I_NOEXEC | SB_I_NODEV;
+	sb->s_stack_depth = FILESYSTEM_MAX_STACK_DEPTH;
+
 	/*
 	 * Lazily allocate a new binfmt_misc instance for this namespace, i.e.
 	 * do it here during the first mount of binfmt_misc. We don't need to


