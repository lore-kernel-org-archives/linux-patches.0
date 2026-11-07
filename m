Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794062204;
	b=iTRT29DdDZSfMIcKn6/xhVbA2rUiYcoXK0rAo3pFN5nFZQmUuDK5n1vosbsUonTZypKK
	 1dX2mrWw50qAczFU1GFTod95BNv/BrSAOZ5OhbURDLD2QqX892+HRB42a5UeFV+9T0YOU
	 5qLR99H1GFcMYWqetwEjHhVw0Z1dLGOyIezubCxhpr1LRn4Fnq3jqNl2ChRGDLGyfvrYW
	 xxngCk0MU38f2KiExdd4ay1tAE7UuXNkCz3nRQjJT8D7ph8nuPfvK1kJX/PTkQ0CU1QZj
	 j1xqF/gGkI1LP8NIWgRgaV9wcYbwv42RI15c/QQ63L6bzK9H8WrSDq+bVIYC73tUoTg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794062204;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=4pDTXK69TMpBq6sE4eGM/hgO/5MWfyFGk1InXLQXB78=;
	b=A/D4XV5j5HWq/G/ge2071pMj6sa81pqKJYJU/U8rznAjANtzGBUMwX8by6tmDw0aT4tf
	 7UhZXXJNGtqHVi48LqENkSIdtUNJ00ok8DgbJiMcGQGHzWO4bFD6HegfKj+/yhvgl7s9J
	 vkzIQ7z77ux0JtjjwoUArj2mUWwqKbmucWdB+jS4CRiWUE0KTPB/h1MllEbqrmpbqJiQ+
	 opYN4p0LF1XZ6w6jM+n/UhtiWgQqXegpRNhDEktzUmh+GtjpcSWM+MJssGFAEBuzeX2+T
	 /6L8qAPZrhBswbXO0suV2/kVOYJIZLkT/hgZNRwDuix6o4oZgt+IRLlTevSwD7lj6JQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=UKiLn2ZE;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3A4A0606A326;
	Sat,  7 Nov 2026 14:36:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=UKiLn2ZE
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9957B1F008A2;
	Sat,  7 Nov 2026 14:36:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794062203;
	bh=4pDTXK69TMpBq6sE4eGM/hgO/5MWfyFGk1InXLQXB78=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=UKiLn2ZElg3EOiBkMS5M7WmCf2RWLMaLF40rUNpmV9t2Z/IavR5jmsrdrslLpucCp
	 rhL73J9RpedkYQWdc1FFO64nkLjkWb1jfcCBSSH+r7QoAgF59vgYEsbaxJLOwr1T0M
	 0+O+rHXtlAtGXe+M6lF3hXYF5SYGV1UWJ5csrE24=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ryusuke Konishi <konishi.ryusuke@gmail.com>,
	Viacheslav Dubeyko <slava@dubeyko.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 1111/1536] nilfs2: clear dirty flag on bdev buffers on log write failure
Date: Sat,  7 Nov 2026 08:52:07 -0500
Message-ID: <20261107135028.912539378@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261107134957.653319350@linuxfoundation.org>
References: <20261107134957.653319350@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
index c598c2a4262a1..063400f8a73c2 100644
--- a/fs/nilfs2/segment.c
+++ b/fs/nilfs2/segment.c
@@ -1820,6 +1820,7 @@ static void nilfs_abort_logs(struct list_head *logs, int err)
 	list_for_each_entry(segbuf, logs, sb_list) {
 		list_for_each_entry(bh, &segbuf->sb_segsum_buffers,
 				    b_assoc_buffers) {
+			clear_buffer_dirty(bh);
 			clear_buffer_uptodate(bh);
 			if (bh->b_folio != bd_folio) {
 				if (bd_folio)
@@ -1831,6 +1832,7 @@ static void nilfs_abort_logs(struct list_head *logs, int err)
 		list_for_each_entry(bh, &segbuf->sb_payload_buffers,
 				    b_assoc_buffers) {
 			if (bh == segbuf->sb_super_root) {
+				clear_buffer_dirty(bh);
 				clear_buffer_uptodate(bh);
 				if (bh->b_folio != bd_folio) {
 					folio_end_writeback(bd_folio);
-- 
2.53.0



