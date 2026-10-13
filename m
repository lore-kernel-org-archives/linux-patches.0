Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8E1DF4FD269;
	Tue, 13 Oct 2026 12:52:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791895935; cv=none; b=Nnae/572xLKdR7/8zKl+yeHAKtYP/x6krF1BYlXptEOUyVY12VoNaWEj180gtoajzNapPNoQsiwxW/pUi56i5fwlNnqyTqdYwZ6At4bxmRR5lVI8pLKG+g8jQTYBnuyF9w5E1ig4Q2Wqdm44b8Gp6pOZPqJmAZKJYT7a3fh0W5k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791895935; c=relaxed/simple;
	bh=D/aRxmCDwBOo5EbpKWCQi7FSmzdbyJdhogFN3QhF6XE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=aRdgzW6Myv6Wta+SNOcCtoCZw3vnZ+faU2dDfsrmisdobpEsYRzInjGfvJPa6cUfLh4LGsiWDIRfPOEbJmwUUC0kOtBOlQIu0u7pG4G7/il/dnaIFF5koyJZW6PCZUtXwISNvfGCil/6PWGmnMDnNb5WH8QLTTBQjr2omsTcBAI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=1dOu+Rfw; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="1dOu+Rfw"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E65E51F000FF;
	Tue, 13 Oct 2026 12:52:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1791895934;
	bh=Mi4YF6EikS8XX7s0DkC6l86ZpzughloX53tHvmm5psQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=1dOu+RfwZ8cCo0+2bhvjXt8pPU4R9NUZPhuZWdOCJBDqEHLIJb+pIqHEVCU6vpZ9W
	 A39w8gMUp6k2jd08BA/AnlAFMIpRUfHFD5t5cxik86tLQI4fy0/P3Y73xhkGboLHf1
	 b4u1f4lIFNBlq88HcaKSM+w8fJqvu0qiMb4RPKvM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Christian Brauner (Amutable)" <brauner@kernel.org>
Subject: [PATCH 6.12 442/497] namespace: dont let a pseudo dentry become the root of a mount
Date: Tue, 13 Oct 2026 13:40:09 +0200
Message-ID: <20261013112918.375306271@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261013112907.864180619@linuxfoundation.org>
References: <20261013112907.864180619@linuxfoundation.org>
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

commit b138e16fb1e81376cea89f727dda7bfccd140de4 upstream.

d_alloc_pseudo() hands out dentries for pipes, sockets and other files
that are never anyone's child or parent. They carry DCACHE_NORCU and
dentry_free() frees them right away because no lockless path walk can
ever reach them. That holds as long as such a dentry isn't the root of
a mount. But bind mounting /proc/self/fd/<fd> of such a file does
exactly that.

Most callers of alloc_file_pseudo() put their files on kernel-internal
mounts and may_copy_tree() refuses those. bpf_token_create() doesn't. It
places the token file on the bpffs mount the caller handed it and that
mount is in the caller's mount namespace so the clone goes through:

  mount --bind /proc/self/fd/<token> <file>
  open_tree(tokfd, "", AT_EMPTY_PATH | OPEN_TREE_CLONE) + move_mount()

__follow_mount_rcu() then loads ->mnt_root of that mount, reads d_seq
and d_flags of the dentry and only then checks mount_lock. The dentry
can be gone by then. The final mntput() of an unmounted parent unhooks
a child that stayed attached to it under mount_lock alone. When the
child's holder does the final put right after that the root is dput()
and freed immediately while a walker that found the mount hashed still
looks at it.

Refuse to clone a mount with a DCACHE_NORCU dentry as its root. Nothing
sensible can be done with a bind mount of a bpf token anyway.

Fixes: 35f96de04127 ("bpf: Introduce BPF token object")
Cc: stable@vger.kernel.org # v6.9+
Link: https://patch.msgid.link/20260930-work-mount-fixes-3-v1-17-be34c83956ae@kernel.org
Signed-off-by: Christian Brauner (Amutable) <brauner@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/namespace.c |    4 ++++
 1 file changed, 4 insertions(+)

--- a/fs/namespace.c
+++ b/fs/namespace.c
@@ -2792,6 +2792,10 @@ static struct mount *__do_loopback(struc
 	if (!check_mnt(old) && old_path->dentry->d_op != &ns_dentry_operations)
 		return mnt;
 
+	/* a pseudo dentry is freed without an RCU delay, no walk may find it */
+	if (old_path->dentry->d_flags & DCACHE_NORCU)
+		return ERR_PTR(-EINVAL);
+
 	if (recurse && !old->mnt_ns)
 		return ERR_PTR(-EINVAL);
 


