Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 625692F260C;
	Thu, 28 May 2026 20:25:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779999932; cv=none; b=f4ley78uoi0Yk2VF4/Ejw5xVKPgAmpRsrj7+95+xY3MANvTJM78rHFnY8IY07s2mi7sHWhPmetJcnOljPpYC2Uif/rY7a2vTMqylkXC2uzwOnMgobVcyHKjTSobmHSdudHGfYNGj5mBtutARquYwi8jFKPRSbDYt0PweYCL/nbg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779999932; c=relaxed/simple;
	bh=buFwQvYW73AGUoslnxVRzEyBe+AtUwi/MG+NjcvwkEo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Ru8y34naYhDIGf+p2ZgdHwYg76rub4oG+7AoPgym0ye+gQZRSEHBRKzDlyIk7Dx+BPSETtqhVgWSoV0sMWgiIfVTuBFZfeFWHhM0SOZzh6bW4aP8ym05cCM9MAdY2Dk2diav+7VwZFS3mFwwCXV+NvgswrSs2K03WGJcJIzXU4Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=xA4W5x2z; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="xA4W5x2z"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C4F751F000E9;
	Thu, 28 May 2026 20:25:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1779999931;
	bh=x16ei4IVgwHBtOmaMiVWc88ZapB0GvJ6QLzyTMGoo4Q=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=xA4W5x2zXxnQ3m5QWM8wHXV4zuBZz8mmoMyKrqDF6cj9guyMTpR+JagA+XL9hc3Ta
	 q/1pG6gXWTj4FQYaGuRBvblN/2LT4dS7nZXilPJPQxLDMIJo1MKg4Ww5MhfhGkDSZ8
	 KqAexSXTfP8u4SmaqOgFz0PrywjaMvWFbYaJ+eLs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Steve French <sfrench@samba.org>,
	David Howells <dhowells@redhat.com>,
	"Paulo Alcantara (Red Hat)" <pc@manguebit.org>,
	Matthew Wilcox <willy@infradead.org>,
	netfs@lists.linux.dev,
	linux-fsdevel@vger.kernel.org,
	Christian Brauner <brauner@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 243/377] netfs: Fix early put of sink folio in netfs_read_gaps()
Date: Thu, 28 May 2026 21:48:01 +0200
Message-ID: <20260528194645.420567456@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260528194638.371537336@linuxfoundation.org>
References: <20260528194638.371537336@linuxfoundation.org>
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

From: David Howells <dhowells@redhat.com>

[ Upstream commit 3e5dd91b87a8b1450217b56a336bee315f40da7d ]

Fix netfs_read_gaps() to release the sink page it uses after waiting for
the request to complete.  The way the sink page is used is that an
ITER_BVEC-class iterator is created that has the gaps from the target folio
at either end, but has the sink page tiled over the middle so that a single
read op can fill in both gaps.

The bug was found by KASAN detecting a UAF on the generic/075 xfstest in
the cifsd kernel thread that handles reception of data from the TCP socket:

 BUG: KASAN: use-after-free in _copy_to_iter+0x48a/0xa20
 Write of size 885 at addr ffff888107f92000 by task cifsd/1285
 CPU: 2 UID: 0 PID: 1285 Comm: cifsd Not tainted 7.0.0 #6 PREEMPT(lazy)
 Call Trace:
  dump_stack_lvl+0x5d/0x80
  print_report+0x17f/0x4f1
  kasan_report+0x100/0x1e0
  kasan_check_range+0x10f/0x1e0
  __asan_memcpy+0x3c/0x60
  _copy_to_iter+0x48a/0xa20
  __skb_datagram_iter+0x2c9/0x430
  skb_copy_datagram_iter+0x6e/0x160
  tcp_recvmsg_locked+0xce0/0x1130
  tcp_recvmsg+0xeb/0x300
  inet_recvmsg+0xcf/0x3a0
  sock_recvmsg+0xea/0x100
  cifs_readv_from_socket+0x3a6/0x4d0 [cifs]
  cifs_read_iter_from_socket+0xdd/0x130 [cifs]
  cifs_readv_receive+0xaad/0xb10 [cifs]
  cifs_demultiplex_thread+0x1148/0x1740 [cifs]
  kthread+0x1cf/0x210

Fixes: ee4cdf7ba857 ("netfs: Speed up buffered reading")
Reported-by: Steve French <sfrench@samba.org>
Signed-off-by: David Howells <dhowells@redhat.com>
Link: https://patch.msgid.link/20260512123404.719402-18-dhowells@redhat.com
Reviewed-by: Paulo Alcantara (Red Hat) <pc@manguebit.org>
cc: Paulo Alcantara <pc@manguebit.org>
cc: Matthew Wilcox <willy@infradead.org>
cc: netfs@lists.linux.dev
cc: linux-fsdevel@vger.kernel.org
Signed-off-by: Christian Brauner <brauner@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/netfs/buffered_read.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/fs/netfs/buffered_read.c b/fs/netfs/buffered_read.c
index 3531c19eea97a..762ff928bc878 100644
--- a/fs/netfs/buffered_read.c
+++ b/fs/netfs/buffered_read.c
@@ -456,9 +456,6 @@ static int netfs_read_gaps(struct file *file, struct folio *folio)
 
 	netfs_read_to_pagecache(rreq, NULL);
 
-	if (sink)
-		folio_put(sink);
-
 	ret = netfs_wait_for_read(rreq);
 	if (ret >= 0) {
 		if (group)
@@ -470,6 +467,9 @@ static int netfs_read_gaps(struct file *file, struct folio *folio)
 		flush_dcache_folio(folio);
 		folio_mark_uptodate(folio);
 	}
+
+	if (sink)
+		folio_put(sink);
 	folio_unlock(folio);
 	netfs_put_request(rreq, netfs_rreq_trace_put_return);
 	return ret < 0 ? ret : 0;
-- 
2.53.0



