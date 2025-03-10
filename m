Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ADCB823372A;
	Mon, 10 Mar 2025 17:31:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741627864; cv=none; b=oFk0Xh/YFV71vVaT+y7njOMK9SrgbMZr64h4sQrBLNUT5HyRZsUnI2IT0vzMQIdd1isFUeBce+wbzGOxyn0wLxM4ZZgpPRbi883MucdByPcp0tiH7yM6Mkh6Rs8d+1n9ySDva8z/wvByNV6/3PzJf1GwyIqbpcGoEwCRAoPF00s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741627864; c=relaxed/simple;
	bh=5e2VdwWeigS6wtyZWOzOLEcLNY7fuYRUxY+ekOSN+fU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=hKJD9PJ/Wbkc8V4Z4WHNJhTCUMyDGXlwHeNPvK06r1T2tZ/wWIX5n+a5XFYERFDlXMzRdVS+e3dm/TmIN2UCozH9MXOnok80+dpZJ0xe/+qdKW0sFSMrT1StzmLAlTS9HgCNaU+C2XAf941KQp49+V/0ztWP0f5yYXSD+IkAPoE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=VYM9Lwvk; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="VYM9Lwvk"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3737FC4CEE5;
	Mon, 10 Mar 2025 17:31:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1741627864;
	bh=5e2VdwWeigS6wtyZWOzOLEcLNY7fuYRUxY+ekOSN+fU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=VYM9Lwvk7KDAF00gTeGwAtACQwh+JH9Bd3Gf5a3E/r8X+w5ie8DYtX8jdVM/t5o/n
	 P18+9RBPBbhyFBFKIdxvkCpTxX6JeI1yywrxA3zW6ucnad/5GhJquO+4BtbXhWnb1Q
	 k5Bw4sUIP9x9aEpRV2U6my44C4Hnr1l8aPuPWjsY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Max Kellermann <max.kellermann@ionos.com>,
	David Howells <dhowells@redhat.com>
Subject: [PATCH 6.12 257/269] fs/netfs/read_collect: fix crash due to uninitialized `prev` variable
Date: Mon, 10 Mar 2025 18:06:50 +0100
Message-ID: <20250310170508.037317379@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250310170457.700086763@linuxfoundation.org>
References: <20250310170457.700086763@linuxfoundation.org>
User-Agent: quilt/0.68
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

From: Max Kellermann <max.kellermann@ionos.com>

[ Just like the other two netfs patches I sent yesterday, this one
  doesn't apply to v6.14 as it was obsoleted by commit e2d46f2ec332
  ("netfs: Change the read result collector to only use one work item").  ]

When checking whether the edges of adjacent subrequests touch, the
`prev` variable is deferenced, but it might not have been initialized.
This causes crashes like this one:

 BUG: unable to handle page fault for address: 0000000181343843
 #PF: supervisor read access in kernel mode
 #PF: error_code(0x0000) - not-present page
 PGD 8000001c66db0067 P4D 8000001c66db0067 PUD 0
 Oops: Oops: 0000 [#1] SMP PTI
 CPU: 1 UID: 33333 PID: 24424 Comm: php-cgi8.2 Kdump: loaded Not tainted 6.13.2-cm4all0-hp+ #427
 Hardware name: HP ProLiant DL380 Gen9/ProLiant DL380 Gen9, BIOS P89 11/23/2021
 RIP: 0010:netfs_consume_read_data.isra.0+0x5ef/0xb00
 Code: fe ff ff 48 8b 83 88 00 00 00 48 8b 4c 24 30 4c 8b 43 78 48 85 c0 48 8d 51 70 75 20 48 8b 73 30 48 39 d6 74 17 48 8b 7c 24 40 <48> 8b 4f 78 48 03 4f 68 48 39 4b 68 0f 84 ab 02 00 00 49 29 c0 48
 RSP: 0000:ffffc90037adbd00 EFLAGS: 00010283
 RAX: 0000000000000000 RBX: ffff88811bda0600 RCX: ffff888620e7b980
 RDX: ffff888620e7b9f0 RSI: ffff88811bda0428 RDI: 00000001813437cb
 RBP: 0000000000000000 R08: 0000000000004000 R09: 0000000000000000
 R10: ffffffff82e070c0 R11: 0000000007ffffff R12: 0000000000004000
 R13: ffff888620e7bb68 R14: 0000000000008000 R15: ffff888620e7bb68
 FS:  00007ff2e0e7ddc0(0000) GS:ffff88981f840000(0000) knlGS:0000000000000000
 CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
 CR2: 0000000181343843 CR3: 0000001bc10ba006 CR4: 00000000001706f0
 Call Trace:
  <TASK>
  ? __die+0x1f/0x60
  ? page_fault_oops+0x15c/0x450
  ? search_extable+0x22/0x30
  ? netfs_consume_read_data.isra.0+0x5ef/0xb00
  ? search_module_extables+0xe/0x40
  ? exc_page_fault+0x5e/0x100
  ? asm_exc_page_fault+0x22/0x30
  ? netfs_consume_read_data.isra.0+0x5ef/0xb00
  ? intel_iommu_unmap_pages+0xaa/0x190
  ? __pfx_cachefiles_read_complete+0x10/0x10
  netfs_read_subreq_terminated+0x24f/0x390
  cachefiles_read_complete+0x48/0xf0
  iomap_dio_bio_end_io+0x125/0x160
  blk_update_request+0xea/0x3e0
  scsi_end_request+0x27/0x190
  scsi_io_completion+0x43/0x6c0
  blk_complete_reqs+0x40/0x50
  handle_softirqs+0xd1/0x280
  irq_exit_rcu+0x91/0xb0
  common_interrupt+0x3b/0xa0
  asm_common_interrupt+0x22/0x40
 RIP: 0033:0x55fe8470d2ab
 Code: 00 00 3c 7e 74 3b 3c b6 0f 84 dd 03 00 00 3c 1e 74 2f 83 c1 01 48 83 c2 38 48 83 c7 30 44 39 d1 74 3e 48 63 42 08 85 c0 79 a3 <49> 8b 46 48 8b 04 38 f6 c4 04 75 0b 0f b6 42 30 83 e0 0c 3c 04 75
 RSP: 002b:00007ffca5ef2720 EFLAGS: 00000216
 RAX: 0000000000000023 RBX: 0000000000000008 RCX: 000000000000001b
 RDX: 00007ff2e0cdb6f8 RSI: 0000000000000006 RDI: 0000000000000510
 RBP: 00007ffca5ef27a0 R08: 00007ffca5ef2720 R09: 0000000000000001
 R10: 000000000000001e R11: 00007ff2e0c10d08 R12: 0000000000000001
 R13: 0000000000000120 R14: 00007ff2e0cb1ed0 R15: 00000000000000b0
  </TASK>

Fixes: ee4cdf7ba857 ("netfs: Speed up buffered reading")
Cc: stable@vger.kernel.org
Signed-off-by: Max Kellermann <max.kellermann@ionos.com>
Signed-off-by: David Howells <dhowells@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/netfs/read_collect.c |   21 +++++++++++----------
 1 file changed, 11 insertions(+), 10 deletions(-)

--- a/fs/netfs/read_collect.c
+++ b/fs/netfs/read_collect.c
@@ -258,17 +258,18 @@ donation_changed:
 	 */
 	if (!subreq->consumed &&
 	    !prev_donated &&
-	    !list_is_first(&subreq->rreq_link, &rreq->subrequests) &&
-	    subreq->start == prev->start + prev->len) {
+	    !list_is_first(&subreq->rreq_link, &rreq->subrequests)) {
 		prev = list_prev_entry(subreq, rreq_link);
-		WRITE_ONCE(prev->next_donated, prev->next_donated + subreq->len);
-		subreq->start += subreq->len;
-		subreq->len = 0;
-		subreq->transferred = 0;
-		trace_netfs_donate(rreq, subreq, prev, subreq->len,
-				   netfs_trace_donate_to_prev);
-		trace_netfs_sreq(subreq, netfs_sreq_trace_donate_to_prev);
-		goto remove_subreq_locked;
+		if (subreq->start == prev->start + prev->len) {
+			WRITE_ONCE(prev->next_donated, prev->next_donated + subreq->len);
+			subreq->start += subreq->len;
+			subreq->len = 0;
+			subreq->transferred = 0;
+			trace_netfs_donate(rreq, subreq, prev, subreq->len,
+					   netfs_trace_donate_to_prev);
+			trace_netfs_sreq(subreq, netfs_sreq_trace_donate_to_prev);
+			goto remove_subreq_locked;
+		}
 	}
 
 	/* If we can't donate down the chain, donate up the chain instead. */


