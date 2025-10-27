Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1329130DEA2;
	Mon, 27 Oct 2025 19:03:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761591796; cv=none; b=N+vs+pHmrOk5+djx3sk9ZHOtFd+0+KmHbbBqMiCYgisSqj6QgJbRLa8iN+D+voizCgPGx4NJpKzULX25yBQ8JpXvhM1YBI1v9qPoYVseryoS+8NkxHD8UEVg9JGVf4sp53bxq1RoRLAPGI/N/Z7NXqQyt/OMFJJogJvhP5UT4tQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761591796; c=relaxed/simple;
	bh=1rrQ7DEFPe/Hp7sMlEKxEx6u6bcJCpHhkZrLHJejV4Q=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=uFUyVzyOWHZj+4XvwJk678T8jVhsyE/h2kB9zIKyddwCe9hG8SaeWyE25a5lRqpdoBQj0M0WkQqTIRZB/YPFzFFsfAs1BlF+6yGDSwahK7PTXuJmHjCkTQFnzCSoK73VRqNkCzK/Dyym15YWf8txok5Rc+4OicvT1s7c+PjZowI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=gQY2n7tP; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="gQY2n7tP"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2F84EC4CEF1;
	Mon, 27 Oct 2025 19:03:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1761591795;
	bh=1rrQ7DEFPe/Hp7sMlEKxEx6u6bcJCpHhkZrLHJejV4Q=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=gQY2n7tPN3kEedQ02VCeGp4jJNrvajWbDaItyaJd4s6xbV5j6OgWUkZwhkjZq7/3z
	 mrIAKMn3icUusMv4Shp7SZkAVJUmxte8TJXw7tB9zswJIvd/nttCUjXF7J92phFdWZ
	 IB89XTERpsp/nIKk/Lim6nrgQfLB3o1NB660T/Zc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Li Jinlin <lijinlin3@huawei.com>,
	"Darrick J. Wong" <djwong@kernel.org>,
	Dan Williams <dan.j.williams@intel.com>
Subject: [PATCH 5.10 332/332] fsdax: Fix infinite loop in dax_iomap_rw()
Date: Mon, 27 Oct 2025 19:36:25 +0100
Message-ID: <20251027183533.663068880@linuxfoundation.org>
X-Mailer: git-send-email 2.51.1
In-Reply-To: <20251027183524.611456697@linuxfoundation.org>
References: <20251027183524.611456697@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Li Jinlin <lijinlin3@huawei.com>

commit 17d9c15c9b9e7fb285f7ac5367dfb5f00ff575e3 upstream.

I got an infinite loop and a WARNING report when executing a tail command
in virtiofs.

  WARNING: CPU: 10 PID: 964 at fs/iomap/iter.c:34 iomap_iter+0x3a2/0x3d0
  Modules linked in:
  CPU: 10 PID: 964 Comm: tail Not tainted 5.19.0-rc7
  Call Trace:
  <TASK>
  dax_iomap_rw+0xea/0x620
  ? __this_cpu_preempt_check+0x13/0x20
  fuse_dax_read_iter+0x47/0x80
  fuse_file_read_iter+0xae/0xd0
  new_sync_read+0xfe/0x180
  ? 0xffffffff81000000
  vfs_read+0x14d/0x1a0
  ksys_read+0x6d/0xf0
  __x64_sys_read+0x1a/0x20
  do_syscall_64+0x3b/0x90
  entry_SYSCALL_64_after_hwframe+0x63/0xcd

The tail command will call read() with a count of 0. In this case,
iomap_iter() will report this WARNING, and always return 1 which casuing
the infinite loop in dax_iomap_rw().

Fixing by checking count whether is 0 in dax_iomap_rw().

Fixes: ca289e0b95af ("fsdax: switch dax_iomap_rw to use iomap_iter")
Signed-off-by: Li Jinlin <lijinlin3@huawei.com>
Reviewed-by: Darrick J. Wong <djwong@kernel.org>
Link: https://lore.kernel.org/r/20220725032050.3873372-1-lijinlin3@huawei.com
Signed-off-by: Dan Williams <dan.j.williams@intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/dax.c |    3 +++
 1 file changed, 3 insertions(+)

--- a/fs/dax.c
+++ b/fs/dax.c
@@ -1219,6 +1219,9 @@ dax_iomap_rw(struct kiocb *iocb, struct
 	loff_t done = 0;
 	int ret;
 
+	if (!iomi.len)
+		return 0;
+
 	if (iov_iter_rw(iter) == WRITE) {
 		lockdep_assert_held_write(&iomi.inode->i_rwsem);
 		iomi.flags |= IOMAP_WRITE;


