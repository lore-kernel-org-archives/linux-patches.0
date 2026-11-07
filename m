Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794063056;
	b=plzpXtP1P2r2IyB5Bl3qMWG6A9wbEIA4vkb8DynDsRXsSizGFWOXOXnYp/pNwK4N5kD4
	 lYlNab3uwEMx04nDQcGTyxEAN56k7DBh3TOPVtib2AdTX/H4uTFv9MJQdHvEb3Fh3C8Co
	 716QjWKXLo7BT4u56KXe0YC5jDfz6JrE2bxybwoDJEQu6bgqPLvB27dxaVjZjYpTVeY3h
	 js4KEOn4zVmHU9QPI0LwrptAGZOeVinEXV8RqmXKYuUTS5xuKrJ+bT/NDLqXuifJYuOkD
	 vFWTfpBttrHwHQXZ1RBZfrgy2yzjVtQadqUR2NF7YDwjJ0icXH+Iq1wdQYYVGwK/kFw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794063056;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=6p+dT2wdl9DuT9BkpI0gz7CUXWF8Otlc5YHwWFzj8mw=;
	b=cUg9hBFMvp+JSlv7VDACwBb6vdXVxFOXWczdSlM+jj3WHirjr5EErux0mjsX9sOScfUb
	 TYjLTyswrACmVDRW6lhN9mAdOIGtxsxh4kRlIruoGjhxIrddcp0SLWsGwtpINCxgNNagl
	 9W6C8eSySdgd08EbfoMtz38+6gdMY9v0x1szoef55q+QaDpZy16vTz8w4RuEbSdfldt3u
	 +CjVhCn6BMq1Qt9hgg2AFL7x9slAKS5WdBZhkGZAxA2HX89Twpbe8Cz9shGN/1bMTeFAd
	 5LLg8LwNgkA0wjJ4QXxpDJax6yfejWzfw8pP70HNdybFf7jQMXYd3ekiCusXmYMLsxQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=ueYq36Vg;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7BFA5606A331;
	Sat,  7 Nov 2026 14:50:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=ueYq36Vg
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1CF271F0089F;
	Sat,  7 Nov 2026 14:50:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794063056;
	bh=6p+dT2wdl9DuT9BkpI0gz7CUXWF8Otlc5YHwWFzj8mw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ueYq36VgOMkMP6SXESNwt7EGhx2jRSiOrhPMP7LoN/4hr7dlN2ehL6AXmtU9bzgQh
	 PySizfZal2YyyVKahjdP4Z1dEscKCk3VG+p+glGiq/U/g7hZhpo8DLNg7aUjkMmHrV
	 C9RTsu8JC528R7Q7rAEdMDK90LbCUIhZwio9DQTo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ryusuke Konishi <konishi.ryusuke@gmail.com>,
	Viacheslav Dubeyko <slava@dubeyko.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 299/869] nilfs2: clear dirty flag on bdev buffers on log write failure
Date: Sat,  7 Nov 2026 08:49:41 -0500
Message-ID: <20261107134902.655960525@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261107134852.069646174@linuxfoundation.org>
References: <20261107134852.069646174@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Ryusuke Konishi <konishi.ryusuke@gmail.com>

[ Upstream commit 6faad04a002603d800134398fcd042b403b32d35 ]

Since the commit referenced in the Fixes tag stopped directly calling
inode_attach_wb(), a dirty flag is set on buffers (with
mark_buffer_dirty()) allocated to the backing device for segment
summaries and the super root block during log writes.

While this dirty flag is cleared upon a successful log write, it remains
uncleared if the log write fails.

Consequently, when a log write fails, these backing device buffers are
left in an inconsistent state where their uptodate flag and the dirty
flag of the containing page/folio are cleared, but the buffer's dirty
flag remains as stale garbage.

Particularly when the block size is smaller than the page size, if other
buffers on the same page/folio become dirty, this buffer unexpectedly
becomes a target for writeback again.  As a result, if the block is
later reused for other data or metadata, that contents risks being
corrupted.

Fix this issue by calling clear_buffer_dirty() for the backing device
buffers when aborting log writes in nilfs_abort_logs().

Fixes: 68142cb628f7 ("nilfs2: do not call inode_attach_wb() directly")
Cc: stable@vger.kernel.org
Signed-off-by: Ryusuke Konishi <konishi.ryusuke@gmail.com>
Signed-off-by: Viacheslav Dubeyko <slava@dubeyko.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/nilfs2/segment.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/fs/nilfs2/segment.c b/fs/nilfs2/segment.c
index c20340f4e0dc3..f1f26647d7b3d 100644
--- a/fs/nilfs2/segment.c
+++ b/fs/nilfs2/segment.c
@@ -1825,6 +1825,7 @@ static void nilfs_abort_logs(struct list_head *logs, int err)
 	list_for_each_entry(segbuf, logs, sb_list) {
 		list_for_each_entry(bh, &segbuf->sb_segsum_buffers,
 				    b_assoc_buffers) {
+			clear_buffer_dirty(bh);
 			clear_buffer_uptodate(bh);
 			if (bh->b_folio != bd_folio) {
 				if (bd_folio)
@@ -1836,6 +1837,7 @@ static void nilfs_abort_logs(struct list_head *logs, int err)
 		list_for_each_entry(bh, &segbuf->sb_payload_buffers,
 				    b_assoc_buffers) {
 			if (bh == segbuf->sb_super_root) {
+				clear_buffer_dirty(bh);
 				clear_buffer_uptodate(bh);
 				if (bh->b_folio != bd_folio) {
 					folio_end_writeback(bd_folio);
-- 
2.53.0



