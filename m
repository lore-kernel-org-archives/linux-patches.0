Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DDCF137AA65;
	Sat, 12 Sep 2026 09:11:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789204285; cv=none; b=C5Q9qQ5XSIKbgke5T4ESknQFwh+ydXa71knLm+gq0iQ1R8+C0EvlMuZ9qI43G5cxk+fCvGoVR0Gcxolidbew6yTM+MyPSOixrBoQuewjjyvuHYmTTjaE/PMwUPaioj4o6jaY856HfkZI9rw7SKMUCEYpo5SnW3hENsW295Y3q4M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789204285; c=relaxed/simple;
	bh=28ZOUDOyjq5dPGdPR+/fPnLxQzZOtxN8/FEK8ea/riM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=aQe+KFJzzgNXwqzU96ts0T8L1d1aggVVoth6eOIcgb8ebsj6L+KuU6FW1S4ewMSJ3RXM2SHvepJnZiBDDg1brKHAh5uubr5dnKQ69gIc8F64b5dCb+PCndYoZQa59IUOnt1hm8tUJO3y2cz6bIGTLK/0iRek+UTRvbHQpmBUYIA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=hd7MXwkn; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="hd7MXwkn"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DAE131F000FF;
	Sat, 12 Sep 2026 09:11:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789204283;
	bh=nMyKptW7P8llWT0hpbZCOkYh9NZ+LIZnyBVPWkOlhn8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=hd7MXwknUM+OPCbMHDFnpXtL+ZFNrRTmwf3cdBonXf/eAtZGl+QFyEvaRbu2uHJkr
	 k5U1RAXxUAjHP/G2RUfSeNs5OdvCE0WyHB7UHtNVSSdDxNPQ9rK2ZoL6vN/5G5iFOf
	 /5hMSjYrmB7IqlW5BiTW8x9WuQ93mnaJtketosCQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Xiang Mei <xmei5@asu.edu>,
	Weiming Shi <bestswngs@gmail.com>,
	Konstantin Komarov <almaz.alexandrovich@paragon-software.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.2 1581/1815] fs/ntfs3: fix out-of-bounds read in read_log_rec_buf()
Date: Sat, 12 Sep 2026 08:55:31 +0200
Message-ID: <20260912065726.104024178@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065648.999753832@linuxfoundation.org>
References: <20260912065648.999753832@linuxfoundation.org>
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
index 1b96ee8208db5..b05e48b28625a 100644
--- a/fs/ntfs3/fslog.c
+++ b/fs/ntfs3/fslog.c
@@ -2301,7 +2301,15 @@ static int read_log_rec_buf(struct ntfs_log *log,
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



