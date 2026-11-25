Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795622332;
	b=kLk48Wet725VHVVLuTcDHrGpth/URmz01hiKvRjOW4o87UQfYtiyyhQMicfvzfdlcmnr
	 1FE06LBuruSpVtTtje2f4hNAtUwX/UDlPVg1z23c68wfKBb3HD7KYtsfUvxCQAWrC1mBL
	 9cOEQstMjuy1dFpJ1semwqILgSn2Wde002X4lOX/b0bP8ZZQJ3hc2K7g7V0iLVibl97Om
	 NaHsI1Y7GsoFO1bhYqtoz/gjoAhBksjfxcAA7oc0ESqMxir0whloOnSC703j+BGsRQ1Sf
	 wK6rQW7h9TwuYKUEMMEEe0Ma42UBV8ughsbV2hoKx/tahDAzM/Ev/XpEHDUDDJkRzVQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795622332;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=VK0yYkipPnMmmEk2xI+oLad2NP5bi09/8kvNaqBqxI4=;
	b=F/myJ+89RFrO9LMM3V5P6KSFAeEkIqeUTCVffb4MovqHAS7brJdQso8C7Ov5auX5EQzI
	 pFd5g98Xbcddpa8qgRFQl+F9kKBkLgNjtiPNiBr18j0rSyGRlzw/tNN91BSarVGIOtr79
	 gvyLkpcRnXem/xF6dIInCB1kr4wXwWfQBhRmbxXK/wPwe4rZjrVIuEXLHQLI6gUayjV6B
	 +/b4Hgr/QzEKkY3EekVw4jgwqE6xaOQP7b0A1eXPEGvplmD5ipq2bHnNqUXLeMFSoM9cg
	 tIhRTnsAd4frce8LY5zFJmrmkGAk5vgCmLzjUMlZ9iJocmpv+9wJzD4du4iG1HwrwoQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=1Dg0slXq;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8C0A7606A323;
	Wed, 25 Nov 2026 15:58:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=1Dg0slXq
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D1E521F000C0;
	Wed, 25 Nov 2026 15:58:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795622332;
	bh=VK0yYkipPnMmmEk2xI+oLad2NP5bi09/8kvNaqBqxI4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=1Dg0slXqkF+j1d6xxW8Rau4wAObGygDois/a4yj6bIh/ARJTO8Li9C8wJl8tl7Gg3
	 S42d2QiJH0leLtUtr+S6PSbjxSI2ulYoG0xsjSj4PIUUWxso4vyRZwwIYy7MGNUnuc
	 7N3PmLyaXlAD6Yf7dj6No6mq7NnJpU0NUhbCl5f4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Horst Birthelmer <hbirthelmer@ddn.com>,
	Jingbo Xu <jefflexu@linux.alibaba.com>,
	Miklos Szeredi <mszeredi@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 505/990] fuse: dont bump attr_version for async direct read completion
Date: Wed, 25 Nov 2026 15:31:12 +0100
Message-ID: <20261125143833.930319235@linuxfoundation.org>
X-Mailer: git-send-email 2.56.1
In-Reply-To: <20261125143822.072087159@linuxfoundation.org>
References: <20261125143822.072087159@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jingbo Xu <jefflexu@linux.alibaba.com>

[ Upstream commit fc60668db85584da911e5d0a65c8698628f98bba ]

The attr_version counter should only be incremented when cached
attributes are actually modified (as documented in commit 1fb69e781729
("fuse: fix race between getattr and write")).  Async direct reads do not
modify any cached inode attributes (size, mtime, ctime), so bumping
attr_version in fuse_aio_complete() for reads is incorrect.

This unconditional bump causes a livelock when auto_inval_data is
enabled together with writeback_cache: fuse_cache_read_iter() issues a
FUSE_GETATTR before every read, but by the time the response arrives,
an async DIO read completion has already incremented fi->attr_version
past the snapshot taken before the request.  The GETATTR result is then
discarded (attr_version race), fi->i_time is never refreshed, and every
subsequent read triggers yet another GETATTR -- creating an infinite
loop of useless round-trips.

Fix this by only bumping attr_version for write completions, consistent
with the synchronous DIO write path (fuse_write_update_attr) and the
cached write path.

Fixes: 01e9d11a3e79 ("fuse: add support of async IO")
Reviewed-by: Horst Birthelmer <hbirthelmer@ddn.com>
Signed-off-by: Jingbo Xu <jefflexu@linux.alibaba.com>
Signed-off-by: Miklos Szeredi <mszeredi@redhat.com>
[ sashal: Adjusted context: this tree declares inode inside the if block and has no mapping variable, so only the io->write condition was changed. ]
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/fuse/file.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/fuse/file.c b/fs/fuse/file.c
index dc61efd829cc2..238de178611b6 100644
--- a/fs/fuse/file.c
+++ b/fs/fuse/file.c
@@ -668,7 +668,7 @@ static void fuse_aio_complete(struct fuse_io_priv *io, int err, ssize_t pos)
 	if (!left && !io->blocking) {
 		ssize_t res = fuse_get_res_by_io(io);
 
-		if (res >= 0) {
+		if (res >= 0 && io->write) {
 			struct inode *inode = file_inode(io->iocb->ki_filp);
 			struct fuse_conn *fc = get_fuse_conn(inode);
 			struct fuse_inode *fi = get_fuse_inode(inode);
-- 
2.53.0



