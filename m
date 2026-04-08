Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AD47828C87C;
	Wed,  8 Apr 2026 18:33:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1775673230; cv=none; b=Qk9oQ6HqSpO4Sip5wKx4SK/4BTWmRGvSWjbluhGg8Wp5lYxnJzCYAWqDbOYUSNoLfNA+2e3Wk+MFa4opjI9A18EYRivdQwAujH675vWKPQrPt0uYfylBYyo5SK98CgN888R5ZKMG3tfQnMrbZlOILIJLe4JJZxvbI++3+XBTNos=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1775673230; c=relaxed/simple;
	bh=n94ePdRURFuQ7aw8RLkIOtgIQQjEvLYkmkSgDsUz9SA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=gt4/eyPnEvinvxclnVas8lvLpSUhu9jtsLaKlUz9TK6e9fo76xGEYGBmxapYclmZI/Ec4bBCSvqvpGIlmS7gd/avvOit5pcPVjHflB339V9hbOPL/QBVB+p5XvGBH0LnaXYy35f571C7bNebNuspqGJduLBXSU6PorazvhHtctw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=AAhCM2eG; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="AAhCM2eG"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 45271C19421;
	Wed,  8 Apr 2026 18:33:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1775673230;
	bh=n94ePdRURFuQ7aw8RLkIOtgIQQjEvLYkmkSgDsUz9SA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=AAhCM2eGrsAtw94tRqTr749VxjhDLBXexiHKKPPA77KN27y185vy5SzkgSCIiG6r4
	 uKiw3WyzwtJYZR6pHs78uP3vCi5Le3ocBnUykVZD3zoJNBy+CBMwEqsDBZUZw+0IRq
	 Eh6G2nCqbqKzT4nkKGnsWQHu3dJZIS7PdwyPshxs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Qi Tang <tpluszz77@gmail.com>,
	Jens Axboe <axboe@kernel.dk>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 108/277] io_uring/rsrc: reject zero-length fixed buffer import
Date: Wed,  8 Apr 2026 20:01:33 +0200
Message-ID: <20260408175937.905221900@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260408175933.836769063@linuxfoundation.org>
References: <20260408175933.836769063@linuxfoundation.org>
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

From: Qi Tang <tpluszz77@gmail.com>

[ Upstream commit 111a12b422a8cfa93deabaef26fec48237163214 ]

validate_fixed_range() admits buf_addr at the exact end of the
registered region when len is zero, because the check uses strict
greater-than (buf_end > imu->ubuf + imu->len).  io_import_fixed()
then computes offset == imu->len, which causes the bvec skip logic
to advance past the last bio_vec entry and read bv_offset from
out-of-bounds slab memory.

Return early from io_import_fixed() when len is zero.  A zero-length
import has no data to transfer and should not walk the bvec array
at all.

  BUG: KASAN: slab-out-of-bounds in io_import_reg_buf+0x697/0x7f0
  Read of size 4 at addr ffff888002bcc254 by task poc/103
  Call Trace:
   io_import_reg_buf+0x697/0x7f0
   io_write_fixed+0xd9/0x250
   __io_issue_sqe+0xad/0x710
   io_issue_sqe+0x7d/0x1100
   io_submit_sqes+0x86a/0x23c0
   __do_sys_io_uring_enter+0xa98/0x1590
  Allocated by task 103:
  The buggy address is located 12 bytes to the right of
   allocated 584-byte region [ffff888002bcc000, ffff888002bcc248)

Fixes: 8622b20f23ed ("io_uring: add validate_fixed_range() for validate fixed buffer")
Signed-off-by: Qi Tang <tpluszz77@gmail.com>
Link: https://patch.msgid.link/20260329164936.240871-1-tpluszz77@gmail.com
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 io_uring/rsrc.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/io_uring/rsrc.c b/io_uring/rsrc.c
index 44442bf4827e4..dc87c6a86e346 100644
--- a/io_uring/rsrc.c
+++ b/io_uring/rsrc.c
@@ -1082,6 +1082,10 @@ static int io_import_fixed(int ddir, struct iov_iter *iter,
 		return ret;
 	if (!(imu->dir & (1 << ddir)))
 		return -EFAULT;
+	if (unlikely(!len)) {
+		iov_iter_bvec(iter, ddir, NULL, 0, 0);
+		return 0;
+	}
 
 	offset = buf_addr - imu->ubuf;
 
-- 
2.53.0



