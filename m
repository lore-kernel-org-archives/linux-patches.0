Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4A5AC4848A7;
	Thu, 17 Sep 2026 15:30:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789659047; cv=none; b=bXslVGHWNlC8YWWT+sDniC5lyshvBgKGIpy8l+ZzM+xa5LNlOqbBvEBYBrH3I6QgA0Cdz1tFTSTqOd91g9ybTDb3Tdg2NXZTqUFchLv0WWFn15+fXEk5gYFbNGwB01++MVooPN+WAxOMEe8f789KjwIeUXArJLmvmcSGe0ghj3s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789659047; c=relaxed/simple;
	bh=rqcwpfESluKYTw2ta/k6WgrtYixvHl2UnI0lZG2Iv8s=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=aw8G469n/D+9Os4+PR8uXN8g1oZMVk5lF+hWef8eQcIoLDsaJE8/+mZhUtMBZ5w90+lfbNE9+40EPewSNqMyB+43ZlANY3oE8N6qKS+4oZ2La3WuAvLOI3OCovvQw53K058L+vL+xjC7dtMS/JfRIxwDph+7DMXS/vsmWMmx8qM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=LzSOfI+w; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="LzSOfI+w"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A9BF11F00899;
	Thu, 17 Sep 2026 15:30:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789659040;
	bh=RVMV5o/7e3OieygLaUqcdbszT/LbQnV5Y7hU7jKS8JE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=LzSOfI+w10qiZdByVaTeF2g20abu5LsOcbhfSkoRTXlfppRUZuUiLhBiWM61RLD60
	 QWajDYjDjQoFRXI6q+D+ACj7+6FIJuIXEHwdkYmfAS5oHs3APptuHuWyDE8WHwjse0
	 wPUnww6r/Fq0jMhEIfilxehoJDgmHXZrfJ4tvtbM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	syzbot+6a13fc77eb6f0802be2d@syzkaller.appspotmail.com,
	Edward Adam Davis <eadavis@qq.com>,
	David Howells <dhowells@redhat.com>,
	Paulo Alcantara <pc@manguebit.org>,
	"Christian Brauner (Amutable)" <brauner@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.2 084/733] netfs: break unbuffered write when netfs_alloc_subrequest() fails
Date: Thu, 17 Sep 2026 16:06:32 +0100
Message-ID: <20260917151352.991967570@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260917151350.597953846@linuxfoundation.org>
References: <20260917151350.597953846@linuxfoundation.org>
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

7.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Edward Adam Davis <eadavis@qq.com>

[ Upstream commit 8fb45a934661419c04a44d4cfea1e0df7dcf2805 ]

syzbot reported a null-ptr-deref below [1] following a fault injection in
netfs_alloc_subrequest(). [0]

When netfs_alloc_subrequest() fails, subreq is NULL.
Later, netfs_prepare_write() tries to initialize members of
subreq(e.g., source), the issue in [1] is triggered.

Let's handle the error of netfs_prepare_write() properly.

[0]
FAULT_INJECTION: forcing a failure.
name failslab, interval 1, probability 0, space 0, times 0
Call Trace:
 netfs_alloc_subrequest+0x116/0x3f0
 netfs_prepare_write+0x76/0x7b0
 netfs_unbuffered_write+0x75c/0x2020
 netfs_unbuffered_write_iter_locked+0x7d6/0xa80
 netfs_unbuffered_write_iter+0x442/0x720
 v9fs_file_write_iter+0xbf/0x100
 vfs_write+0x6ac/0x1050

[1]
KASAN: null-ptr-deref in range [0x00000000000000a8-0x00000000000000af]
RIP: 0010:netfs_prepare_write+0xbc/0x7b0 fs/netfs/write_issue.c:173
Call Trace:
 netfs_unbuffered_write+0x75c/0x2020 fs/netfs/direct_write.c:111
 netfs_unbuffered_write_iter_locked+0x7d6/0xa80 fs/netfs/direct_write.c:290
 netfs_unbuffered_write_iter+0x442/0x720 fs/netfs/direct_write.c:382
 v9fs_file_write_iter+0xbf/0x100 fs/9p/vfs_file.c:409
 new_sync_write fs/read_write.c:595 [inline]

Fixes: 288ace2f57c9 ("netfs: New writeback implementation")
Reported-by: syzbot+6a13fc77eb6f0802be2d@syzkaller.appspotmail.com
Closes: https://syzkaller.appspot.com/bug?extid=6a13fc77eb6f0802be2d
Tested-by: syzbot+6a13fc77eb6f0802be2d@syzkaller.appspotmail.com
Signed-off-by: Edward Adam Davis <eadavis@qq.com>
Signed-off-by: David Howells <dhowells@redhat.com>
Link: https://patch.msgid.link/20260827134304.2075713-7-dhowells@redhat.com
Acked-by: Paulo Alcantara <pc@manguebit.org>
Signed-off-by: Christian Brauner (Amutable) <brauner@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/netfs/direct_write.c | 5 +++++
 fs/netfs/write_issue.c  | 2 ++
 2 files changed, 7 insertions(+)

diff --git a/fs/netfs/direct_write.c b/fs/netfs/direct_write.c
index 86beeb337ed7f..982b78d7bdb98 100644
--- a/fs/netfs/direct_write.c
+++ b/fs/netfs/direct_write.c
@@ -110,6 +110,11 @@ static int netfs_unbuffered_write(struct netfs_io_request *wreq)
 		if (!subreq) {
 			netfs_prepare_write(wreq, stream, wreq->start + wreq->transferred);
 			subreq = stream->construct;
+			if (!subreq) {
+				wreq->error = -ENOMEM;
+				ret = -ENOMEM;
+				break;
+			}
 			stream->construct = NULL;
 		}
 
diff --git a/fs/netfs/write_issue.c b/fs/netfs/write_issue.c
index 2d9cfcd43658f..851f6f93ad45a 100644
--- a/fs/netfs/write_issue.c
+++ b/fs/netfs/write_issue.c
@@ -170,6 +170,8 @@ void netfs_prepare_write(struct netfs_io_request *wreq,
 		rolling_buffer_make_space(&wreq->buffer, wreq->gfp);
 
 	subreq = netfs_alloc_subrequest(wreq);
+	if (!subreq)
+		return;
 	subreq->source		= stream->source;
 	subreq->start		= start;
 	subreq->stream_nr	= stream->stream_nr;
-- 
2.53.0



