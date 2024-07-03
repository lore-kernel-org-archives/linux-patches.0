Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BA21A17966F;
	Wed,  3 Jul 2024 11:20:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1720005602; cv=none; b=UDiSa1hJMqlfZd8LB4Tn+8JdW06VWL3ZSRxk2rNewgWa/tJ2infSu5emdHyf4WhymgsD7GBQixUhlrkKTo1u4z2fFdEjyBjf90gGK31RN4Zz/BXBDxeuP3ah/oJKBP/5iRRMHmav86lhKtRzplPMUI63sC1Fiyb+k+DRNBVdrtA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1720005602; c=relaxed/simple;
	bh=tvF1vvilwRxLzu0YV71ptFq1LQLS85r0kK/G1bGaZtQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=mvacxqmNbw//gfOWTGNxcBX7bVZ5Qibs1Eiaeip9ZC9P3x0FlLmO5bfD+dnvzSiMqSyzKxyGXCzXjNkScsKMSvda+nTsccZOTKRK9c7UE4gY+SWtasTJ+TFqzbt9kwoQ4lSmJQNTrZ94RYHhFipxhI1oyIIIGzqjZoPwBFlhq3o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=B8YQfO/g; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="B8YQfO/g"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3F453C2BD10;
	Wed,  3 Jul 2024 11:20:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1720005602;
	bh=tvF1vvilwRxLzu0YV71ptFq1LQLS85r0kK/G1bGaZtQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=B8YQfO/gXsKJFy9BMKyJ0MGkqp4SMGjIM8CywWo90kokK0AMmkPFGfvFzq478q17X
	 yzDbc0G+TDfBAn00VQAEo8pR1mUAdfJNR7XBx9Rdp/IVR52J2VxT+TX5qaS3Sojdxs
	 nS7zMm93ATkW/XEj7RLAIl3wKvOFM+I4ZRxIz2sA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ryusuke Konishi <konishi.ryusuke@gmail.com>,
	Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH 5.15 134/356] nilfs2: fix potential kernel bug due to lack of writeback flag waiting
Date: Wed,  3 Jul 2024 12:37:50 +0200
Message-ID: <20240703102918.167613298@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240703102913.093882413@linuxfoundation.org>
References: <20240703102913.093882413@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Ryusuke Konishi <konishi.ryusuke@gmail.com>

commit a4ca369ca221bb7e06c725792ac107f0e48e82e7 upstream.

Destructive writes to a block device on which nilfs2 is mounted can cause
a kernel bug in the folio/page writeback start routine or writeback end
routine (__folio_start_writeback in the log below):

 kernel BUG at mm/page-writeback.c:3070!
 Oops: invalid opcode: 0000 [#1] PREEMPT SMP KASAN PTI
 ...
 RIP: 0010:__folio_start_writeback+0xbaa/0x10e0
 Code: 25 ff 0f 00 00 0f 84 18 01 00 00 e8 40 ca c6 ff e9 17 f6 ff ff
  e8 36 ca c6 ff 4c 89 f7 48 c7 c6 80 c0 12 84 e8 e7 b3 0f 00 90 <0f>
  0b e8 1f ca c6 ff 4c 89 f7 48 c7 c6 a0 c6 12 84 e8 d0 b3 0f 00
 ...
 Call Trace:
  <TASK>
  nilfs_segctor_do_construct+0x4654/0x69d0 [nilfs2]
  nilfs_segctor_construct+0x181/0x6b0 [nilfs2]
  nilfs_segctor_thread+0x548/0x11c0 [nilfs2]
  kthread+0x2f0/0x390
  ret_from_fork+0x4b/0x80
  ret_from_fork_asm+0x1a/0x30
  </TASK>

This is because when the log writer starts a writeback for segment summary
blocks or a super root block that use the backing device's page cache, it
does not wait for the ongoing folio/page writeback, resulting in an
inconsistent writeback state.

Fix this issue by waiting for ongoing writebacks when putting
folios/pages on the backing device into writeback state.

Link: https://lkml.kernel.org/r/20240530141556.4411-1-konishi.ryusuke@gmail.com
Fixes: 9ff05123e3bf ("nilfs2: segment constructor")
Signed-off-by: Ryusuke Konishi <konishi.ryusuke@gmail.com>
Tested-by: Ryusuke Konishi <konishi.ryusuke@gmail.com>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/nilfs2/segment.c |    3 +++
 1 file changed, 3 insertions(+)

--- a/fs/nilfs2/segment.c
+++ b/fs/nilfs2/segment.c
@@ -1692,6 +1692,7 @@ static void nilfs_segctor_prepare_write(
 			if (bh->b_page != bd_page) {
 				if (bd_page) {
 					lock_page(bd_page);
+					wait_on_page_writeback(bd_page);
 					clear_page_dirty_for_io(bd_page);
 					set_page_writeback(bd_page);
 					unlock_page(bd_page);
@@ -1705,6 +1706,7 @@ static void nilfs_segctor_prepare_write(
 			if (bh == segbuf->sb_super_root) {
 				if (bh->b_page != bd_page) {
 					lock_page(bd_page);
+					wait_on_page_writeback(bd_page);
 					clear_page_dirty_for_io(bd_page);
 					set_page_writeback(bd_page);
 					unlock_page(bd_page);
@@ -1721,6 +1723,7 @@ static void nilfs_segctor_prepare_write(
 	}
 	if (bd_page) {
 		lock_page(bd_page);
+		wait_on_page_writeback(bd_page);
 		clear_page_dirty_for_io(bd_page);
 		set_page_writeback(bd_page);
 		unlock_page(bd_page);


