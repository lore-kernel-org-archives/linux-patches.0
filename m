Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9E2691D546
	for <patches@lists.linux.dev>; Wed,  4 Oct 2023 18:10:31 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1EAD7C433C7;
	Wed,  4 Oct 2023 18:10:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1696443031;
	bh=NVjvh6VvZPysf0WA+oUd5qksFBLGg0McsKmElP91bAA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=NrfCVq53GL/ngZPYgPCot+THdIsi7RRIScHE4Vms+qMhjWVEiyS1we9nQhLLFBRpt
	 EgGBQ/ZcGI/K23uoCw0N4aDzkSgVtvOvl5Y1nuKccAvMwlvyoCaH+U7OVhsTXvmXBF
	 YHlqZjAdsq5apv5Kiv84/dn99SQqaeHw0y85jZrI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dave Wysochanski <dwysocha@redhat.com>,
	Jeff Layton <jlayton@kernel.org>,
	David Howells <dhowells@redhat.com>,
	Linus Torvalds <torvalds@linux-foundation.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 012/259] netfs: Only call folio_start_fscache() one time for each folio
Date: Wed,  4 Oct 2023 19:53:05 +0200
Message-ID: <20231004175217.992708642@linuxfoundation.org>
X-Mailer: git-send-email 2.42.0
In-Reply-To: <20231004175217.404851126@linuxfoundation.org>
References: <20231004175217.404851126@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Dave Wysochanski <dwysocha@redhat.com>

[ Upstream commit df1c357f25d808e30b216188330e708e09e1a412 ]

If a network filesystem using netfs implements a clamp_length()
function, it can set subrequest lengths smaller than a page size.

When we loop through the folios in netfs_rreq_unlock_folios() to
set any folios to be written back, we need to make sure we only
call folio_start_fscache() once for each folio.

Otherwise, this simple testcase:

  mount -o fsc,rsize=1024,wsize=1024 127.0.0.1:/export /mnt/nfs
  dd if=/dev/zero of=/mnt/nfs/file.bin bs=4096 count=1
  1+0 records in
  1+0 records out
  4096 bytes (4.1 kB, 4.0 KiB) copied, 0.0126359 s, 324 kB/s
  echo 3 > /proc/sys/vm/drop_caches
  cat /mnt/nfs/file.bin > /dev/null

will trigger an oops similar to the following:

  page dumped because: VM_BUG_ON_FOLIO(folio_test_private_2(folio))
  ------------[ cut here ]------------
  kernel BUG at include/linux/netfs.h:44!
  ...
  CPU: 5 PID: 134 Comm: kworker/u16:5 Kdump: loaded Not tainted 6.4.0-rc5
  ...
  RIP: 0010:netfs_rreq_unlock_folios+0x68e/0x730 [netfs]
  ...
  Call Trace:
    netfs_rreq_assess+0x497/0x660 [netfs]
    netfs_subreq_terminated+0x32b/0x610 [netfs]
    nfs_netfs_read_completion+0x14e/0x1a0 [nfs]
    nfs_read_completion+0x2f9/0x330 [nfs]
    rpc_free_task+0x72/0xa0 [sunrpc]
    rpc_async_release+0x46/0x70 [sunrpc]
    process_one_work+0x3bd/0x710
    worker_thread+0x89/0x610
    kthread+0x181/0x1c0
    ret_from_fork+0x29/0x50

Fixes: 3d3c95046742 ("netfs: Provide readahead and readpage netfs helpers"
Link: https://bugzilla.redhat.com/show_bug.cgi?id=2210612
Signed-off-by: Dave Wysochanski <dwysocha@redhat.com>
Reviewed-by: Jeff Layton <jlayton@kernel.org>
Signed-off-by: David Howells <dhowells@redhat.com>
Link: https://lore.kernel.org/r/20230608214137.856006-1-dwysocha@redhat.com/ # v1
Link: https://lore.kernel.org/r/20230915185704.1082982-1-dwysocha@redhat.com/ # v2
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/netfs/buffered_read.c | 6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

diff --git a/fs/netfs/buffered_read.c b/fs/netfs/buffered_read.c
index 7679a68e81930..caa0a053e8a9d 100644
--- a/fs/netfs/buffered_read.c
+++ b/fs/netfs/buffered_read.c
@@ -47,12 +47,14 @@ void netfs_rreq_unlock_folios(struct netfs_io_request *rreq)
 	xas_for_each(&xas, folio, last_page) {
 		loff_t pg_end;
 		bool pg_failed = false;
+		bool folio_started;
 
 		if (xas_retry(&xas, folio))
 			continue;
 
 		pg_end = folio_pos(folio) + folio_size(folio) - 1;
 
+		folio_started = false;
 		for (;;) {
 			loff_t sreq_end;
 
@@ -60,8 +62,10 @@ void netfs_rreq_unlock_folios(struct netfs_io_request *rreq)
 				pg_failed = true;
 				break;
 			}
-			if (test_bit(NETFS_SREQ_COPY_TO_CACHE, &subreq->flags))
+			if (!folio_started && test_bit(NETFS_SREQ_COPY_TO_CACHE, &subreq->flags)) {
 				folio_start_fscache(folio);
+				folio_started = true;
+			}
 			pg_failed |= subreq_failed;
 			sreq_end = subreq->start + subreq->len - 1;
 			if (pg_end < sreq_end)
-- 
2.40.1



