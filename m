Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4BEAB427FB7;
	Sat, 12 Sep 2026 13:15:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789218944; cv=none; b=jEFyi8Ab/O7FfjhU/tNdLVxMVuYE3txd9nBLARzm7El2cJeNAccXI2fSkyjfgrD+W+sUyiAfLg9lN32nwGMeVZRfkuIGWcTPKvymh0jwZTYf8C0d6iYDWYhDvkc97g8iWHPQ9o8ltdsufKNAsrv2iPmeL5Dx2Ma5sjiZepkSML4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789218944; c=relaxed/simple;
	bh=g/a8M9qNjIZi1eFwQC3K7NJYUvC/FmYNaFpUP34uhm0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=JVyTeTytM3saENmGn8fqC2VW8YHc7scE1IudvYTMuZbpbzCh9gqahWkB3iUSkY/YPhjgX6bO4rh9Mc3NLVWV0W+MQIe6AmmwNljodEBk3o3YSpvfGHCjOrm8FaPGPriJIq7s/+v+BNhGEdNrINlbkj5z3O9JOQamqYbVcMwEghs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=o4zxCVdj; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="o4zxCVdj"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 05AAF1F000FF;
	Sat, 12 Sep 2026 13:15:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789218942;
	bh=w9TuAiKPMm5uPl/cPsqOIES1K6bX9eUA3sE/vY7A8bg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=o4zxCVdjrlY1f8conNdujCbxWSodLTr2B/BMGnrDfJiTCQfgAx2D+2YxeyZG8hgwm
	 6fk4U0flhKV1EfWburOgrID2kVH1p1oPrC5K0zE8BYwDmPPLZ+mBG1FHpqjUc03zZE
	 Uu10ZRCZl0CfCVqqmHIc+7l3aRQtseYVlqb7QKs8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Xiang Mei <xmei5@asu.edu>,
	Weiming Shi <bestswngs@gmail.com>,
	Konstantin Komarov <almaz.alexandrovich@paragon-software.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 1206/1376] fs/ntfs3: fix out-of-bounds read in read_log_rec_buf()
Date: Sat, 12 Sep 2026 09:00:32 +0200
Message-ID: <20260912065634.427751066@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065607.535295758@linuxfoundation.org>
References: <20260912065607.535295758@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
index 09dc29e434e3b..f7fa1471d6b98 100644
--- a/fs/ntfs3/fslog.c
+++ b/fs/ntfs3/fslog.c
@@ -2299,7 +2299,15 @@ static int read_log_rec_buf(struct ntfs_log *log,
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



