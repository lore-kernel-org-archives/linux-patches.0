Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9BD691836CB;
	Wed,  3 Jul 2024 10:45:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1720003547; cv=none; b=ag2Ly6tpclI8rJW9jIvUb2XLtwASy66/PVu1wSJXwFh8R9EGEHl9yto8hR5xznD8Jxya4QS69twRIyvYZECtUnaaNZd/+TSoZUVeoV3mU3Hbi321eMD0wGCioovFaT+ACyzpFCpvx2DQ9Sntj3X5lZ3Uw+iTNw/8Z1ZXqla6qkE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1720003547; c=relaxed/simple;
	bh=imGZ1Na2M5Sz6Yj3PmR7AfHftcz/TiVL3Byg2KWbes4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=CWPlLB7o3dJnihd3qKvrOBc7eHEHoQz404X0Ss0rYirHy3ak8LLbXqO8y5QBh5lj0p5miJS1BbvCnF0zxqzN452uRVB5o2DI0oTqpa4EsMlJDCa5LH2oDSo/pb0H7lXjg0MZTAAeTovU+WRAGJQ46z1tBBtNYW7liOeOjq3S4Kg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=i/QDtNzs; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="i/QDtNzs"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 150F9C2BD10;
	Wed,  3 Jul 2024 10:45:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1720003547;
	bh=imGZ1Na2M5Sz6Yj3PmR7AfHftcz/TiVL3Byg2KWbes4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=i/QDtNzsWsK29aCzoZ+NyMCk7VF9fTMtsZYdDuWCst0BsvY+m4QhP1Y3VxFYTvtDY
	 0TeL9KDjUTOz01LU+xD7oUUwlhw3/Oz2v/CtKOWadziVw7Awc915VQ22QkqTmKwtJ2
	 Afd7U1ZUIwXppsITFZmVQyPVp/P/riVEXIoaopdE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ryusuke Konishi <konishi.ryusuke@gmail.com>,
	Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH 4.19 057/139] nilfs2: fix potential kernel bug due to lack of writeback flag waiting
Date: Wed,  3 Jul 2024 12:39:14 +0200
Message-ID: <20240703102832.592271743@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240703102830.432293640@linuxfoundation.org>
References: <20240703102830.432293640@linuxfoundation.org>
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

4.19-stable review patch.  If anyone has any objections, please let me know.

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


