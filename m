Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1FBDC481A81;
	Sat, 12 Sep 2026 19:12:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789240345; cv=none; b=qcmWKUciP4FvtygaeHn1SLhTdXuKTTLyMVHYc6/dYT1fRx7A8D00i51iKze7CLvlNUavRTx4Xt9hRkLbaYyeF2ScwLcVKnR/gIdLuYQBlFOYWh1t0OePl+OobAEFlhIEx8N0K+h/0TYpdhvTRh6ML7aowi7kGNcWUXtv+azgi2I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789240345; c=relaxed/simple;
	bh=P3XM05Ng96AMTaLYPLV8BiASewK5IMgNVbUbHvQv2pI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=aPy+Z/kYg+LJbwmqmSjA2uLvLgHvkRGJLhll8IM7DotNSsSBzJbTCHo5PRmqHy48bXBEqp06kUqgyfZl4Tv5Qs7D2WmLVm0aoxC29Pxl9hVJ44m6q8cHnrl76jjypywrWdDiAWjYC1joecucAM03yhm3LVbEYlM2K/h0Z6kfJ1g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=nytis+Vw; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="nytis+Vw"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 27CB81F00898;
	Sat, 12 Sep 2026 19:12:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789240344;
	bh=lVo//3qyRR+8uZREMDmEyMKx7URBUEApoqY0tb+Rys0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=nytis+VwEX+e0CXTqafsm5AYobxWKHzt6mr8RH4RP35PiJB4nionJWJ+GimGcByCY
	 I2mQzLePDBdF6x449drwTqSn+dy949l98xGn8J5msRUKquqFIYdr7/AXL960gvcJHS
	 9109EBRbEqIwUbJR579x2xpe08K48zkT7f3wgvLA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Xiang Mei <xmei5@asu.edu>,
	Weiming Shi <bestswngs@gmail.com>,
	Konstantin Komarov <almaz.alexandrovich@paragon-software.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 848/935] fs/ntfs3: fix out-of-bounds read in read_log_rec_buf()
Date: Sat, 12 Sep 2026 09:04:38 +0200
Message-ID: <20260912065546.278701262@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065526.833703348@linuxfoundation.org>
References: <20260912065526.833703348@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Konstantin Komarov <almaz.alexandrovich@paragon-software.com>

[ Upstream commit de603b9d377fab57a5e6432fa84a9f36b32c1636 ]

read_log_rec_buf() copies a log record into a caller buffer starting at

	u32 off = lsn_to_page_off(log, lsn) + log->record_header_len;

log->record_header_len (and log->data_off, used for the following pages)
comes verbatim from the on-disk restart area and is only checked for
8-byte alignment in is_rst_area_valid(), so off can exceed
log->page_size. "tail = log->page_size - off" then underflows and
memcpy() reads past the page_size-sized buffer returned by
read_log_page(), spilling adjacent slab memory into the replay buffer.

This is reachable by mounting a crafted NTFS image:

 BUG: KASAN: slab-out-of-bounds in read_log_rec_buf+0x216/0x580
 Read of size 64 at addr ffff88800a877ff8 by task exploit/127
  read_log_rec_buf fs/ntfs3/fslog.c:2299
  log_replay fs/ntfs3/fslog.c:4216
  ntfs_loadlog_and_replay fs/ntfs3/fsntfs.c:324
  ntfs_fill_super fs/ntfs3/super.c:1392
  get_tree_bdev_flags fs/super.c:1694
  __x64_sys_mount fs/namespace.c:4360
 The buggy address is located 4088 bytes to the right of
 the 4096-byte region [ffff88800a876000, ffff88800a877000)

Reject an in-page offset outside the current page before the copy.

Fixes: b46acd6a6a62 ("fs/ntfs3: Add NTFS journal")
Assisted-by: Claude:claude-opus-4-8
Reported-by: Xiang Mei <xmei5@asu.edu>
Signed-off-by: Weiming Shi <bestswngs@gmail.com>
[almaz.alexandrovich@paragon-software.com: replaced the >= sign with >]
Signed-off-by: Konstantin Komarov <almaz.alexandrovich@paragon-software.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/ntfs3/fslog.c | 10 +++++++++-
 1 file changed, 9 insertions(+), 1 deletion(-)

diff --git a/fs/ntfs3/fslog.c b/fs/ntfs3/fslog.c
index d0f2fa1a6f91d..f9a7e17031b04 100644
--- a/fs/ntfs3/fslog.c
+++ b/fs/ntfs3/fslog.c
@@ -2303,7 +2303,15 @@ static int read_log_rec_buf(struct ntfs_log *log,
 	 */
 	for (;;) {
 		bool usa_error;
-		u32 tail = log->page_size - off;
+		u32 tail;
+
+		/* off comes from the on-disk restart area; bound it. */
+		if (off > log->page_size) {
+			err = -EINVAL;
+			goto out;
+		}
+
+		tail = log->page_size - off;
 
 		if (tail >= data_len)
 			tail = data_len;
-- 
2.53.0



