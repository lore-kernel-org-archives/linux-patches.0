Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 011D2319601;
	Thu, 16 Jul 2026 14:09:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784210953; cv=none; b=PDEMKi4YIYsEUrLkLuYdywXLr5ZQM1AmwPo9FSzh68c9eGNmhmuhbraLrNzcAIBV/byBtiHAwXcIwlqinJTTqYA+8Z8MXqRgDvx8UWtzY1lKn4/kvK4+hnLz9Oy72TSX+gA/U6YwerBKtKhXuFFDdnz1W5VhwWx7S1r9osqnUHg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784210953; c=relaxed/simple;
	bh=t8snrNzG5IiqGmqjAA1/CYa4A5SZKrSwVMu0eR9XjBM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=lnXaaSdlileINqDpEEVGDY0+xVf2BI9q4fpTQJ65YcfI3RD5ZOlAnOUAW2iGo4bLBAHphrpb90X9Ig0qiH+rNSuv8YJng3tPcbDYmyNNQaSVyM/RVn4W5uYNO7DLGM3zzz3ufMjeW5EvQ6GVnKtyZTsRQKJJyA4piwwsy/d50yo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=VO3qswuk; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="VO3qswuk"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 667891F00A3E;
	Thu, 16 Jul 2026 14:09:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784210951;
	bh=G8NGwg21AmPSnSp/Bm/88X9D4cDLy0KvX6Skc1BYnGQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=VO3qswuk9Bt9lMZfNr/hTuDd8kSTiRTarkVAIuwxM//J5ojRRLrCXBxm5V6TuVAFF
	 VPlHWlMfT7i2fTVzp2Ok9qTqtSN6ML2T6u11GogGhRrXMXDqWygMTwLS6Op3WqZAEg
	 +gv9bf+4By4ux+2+KRVY8GOyoCeANi+oqsmpX4os=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Christoph Hellwig <hch@infradead.org>,
	John Hubbard <jhubbard@nvidia.com>,
	"Christian Brauner (Amutable)" <brauner@kernel.org>
Subject: [PATCH 6.18 244/480] libfs: set SB_I_NOEXEC and SB_I_NODEV by default in init_pseudo()
Date: Thu, 16 Jul 2026 15:29:51 +0200
Message-ID: <20260716133050.098474420@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260716133044.672218725@linuxfoundation.org>
References: <20260716133044.672218725@linuxfoundation.org>
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

From: John Hubbard <jhubbard@nvidia.com>

commit 6de2aeffabaafaeda819e60ec8d04f199711e11a upstream.

Since commit 1e7ab6f67824 ("anon_inode: rework assertions"),
path_noexec() warns when an anonymous-inode file is mmap'd from a
superblock that has not set SB_I_NOEXEC. dma-buf backs its files this
way and never set the flag, so mmap of any exported buffer trips the
warning on a CONFIG_DEBUG_VFS=y kernel:

  WARNING: CPU: 11 PID: 121813 at fs/exec.c:118 path_noexec+0x47/0x50
   do_mmap+0x2b5/0x680
   vm_mmap_pgoff+0x129/0x210
   ksys_mmap_pgoff+0x177/0x240
   __x64_sys_mmap+0x33/0x70

init_pseudo() sets up internal SB_NOUSER mounts that are never
path-reachable. Set both flags here so every pseudo filesystem gets
them by default instead of each caller setting them.

SB_I_NODEV is inert for unreachable mounts. SB_I_NOEXEC has one
visible effect: an executable mapping of a pseudo-fs fd, such as a
dma-buf, now fails with -EPERM, which is the invariant the assertion
enforces. No in-tree caller maps these executable.

Reproduce on CONFIG_DEBUG_VFS=y:

  make -C tools/testing/selftests/dmabuf-heaps
  sudo ./tools/testing/selftests/dmabuf-heaps/dmabuf-heap -t system

Fixes: 1e7ab6f67824 ("anon_inode: rework assertions")
Suggested-by: Christoph Hellwig <hch@infradead.org>
Cc: stable@vger.kernel.org
Signed-off-by: John Hubbard <jhubbard@nvidia.com>
Link: https://patch.msgid.link/20260604025315.245910-2-jhubbard@nvidia.com
Signed-off-by: Christian Brauner (Amutable) <brauner@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/libfs.c |    1 +
 1 file changed, 1 insertion(+)

--- a/fs/libfs.c
+++ b/fs/libfs.c
@@ -721,6 +721,7 @@ struct pseudo_fs_context *init_pseudo(st
 		fc->fs_private = ctx;
 		fc->ops = &pseudo_fs_context_ops;
 		fc->sb_flags |= SB_NOUSER;
+		fc->s_iflags |= SB_I_NOEXEC | SB_I_NODEV;
 		fc->global = true;
 	}
 	return ctx;


