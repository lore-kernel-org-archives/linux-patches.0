Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5BAF71DFD1;
	Sun,  1 Sep 2024 16:54:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725209641; cv=none; b=e5T7nx5bhKj0vlCqXWwdmUL9vIohnjNg7KOvPxejzrSB6Yv7O3fWAql+1Bzbv2bfpwoFRRbH2mbos/SYsZkI92LYjthVVgceddDanlmPF02a5M+Cy+cmh7WGEU6ezXfeepgUBE7XbOMt3ccxLzVgC5mO46kMsC+ARxxKURnwGbY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725209641; c=relaxed/simple;
	bh=60i4SP3bpa1LPWGGTYFBHQpBqUtAZe4ukJckt1cYHSw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=YK5/d5T6KS05XSIzYlMiZob9aLrxIv9EAoLUzhgICyCnFF0PsKa1D2b/He4s6n8LF2LIDwqR52nGShnN+gbDkvNDm1jUbTKrWCPkOW2YfYcFPA/A7BPsAyZV2UFZ1gZ5nrutYspecTFsWvj9Ouu3FMiz5lJSiBy2a9OFlDRPpFw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=aD2sZ86G; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="aD2sZ86G"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7EB03C4CEC3;
	Sun,  1 Sep 2024 16:54:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1725209640;
	bh=60i4SP3bpa1LPWGGTYFBHQpBqUtAZe4ukJckt1cYHSw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=aD2sZ86GoWJHIURAr3L/7HmklhqRrqiF2WU36y1lvJSMQZvrYUQyQ9Op4fgup8Aaf
	 jjXMJxI6jGNzHNg2eu0BCBFYXLksOlsFi/p+5k3H+RmCBdDI8pIoydmfBw8XvLj9nf
	 buvGa/XJIl9lDPa+HdvY99Rmt2uhQogGWAUEWZz4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Zhiguo Niu <zhiguo.niu@unisoc.com>,
	Chao Yu <chao@kernel.org>,
	Jaegeuk Kim <jaegeuk@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 068/151] f2fs: fix to do sanity check in update_sit_entry
Date: Sun,  1 Sep 2024 18:17:08 +0200
Message-ID: <20240901160816.676434794@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240901160814.090297276@linuxfoundation.org>
References: <20240901160814.090297276@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Zhiguo Niu <zhiguo.niu@unisoc.com>

[ Upstream commit 36959d18c3cf09b3c12157c6950e18652067de77 ]

If GET_SEGNO return NULL_SEGNO for some unecpected case,
update_sit_entry will access invalid memory address,
cause system crash. It is better to do sanity check about
GET_SEGNO just like update_segment_mtime & locate_dirty_segment.

Also remove some redundant judgment code.

Signed-off-by: Zhiguo Niu <zhiguo.niu@unisoc.com>
Reviewed-by: Chao Yu <chao@kernel.org>
Signed-off-by: Jaegeuk Kim <jaegeuk@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/f2fs/segment.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/fs/f2fs/segment.c b/fs/f2fs/segment.c
index 134a78179e6ff..6fcc83637b153 100644
--- a/fs/f2fs/segment.c
+++ b/fs/f2fs/segment.c
@@ -2215,6 +2215,8 @@ static void update_sit_entry(struct f2fs_sb_info *sbi, block_t blkaddr, int del)
 #endif
 
 	segno = GET_SEGNO(sbi, blkaddr);
+	if (segno == NULL_SEGNO)
+		return;
 
 	se = get_seg_entry(sbi, segno);
 	new_vblocks = se->valid_blocks + del;
@@ -3391,8 +3393,7 @@ void f2fs_allocate_data_block(struct f2fs_sb_info *sbi, struct page *page,
 	 * since SSR needs latest valid block information.
 	 */
 	update_sit_entry(sbi, *new_blkaddr, 1);
-	if (GET_SEGNO(sbi, old_blkaddr) != NULL_SEGNO)
-		update_sit_entry(sbi, old_blkaddr, -1);
+	update_sit_entry(sbi, old_blkaddr, -1);
 
 	if (!__has_curseg_space(sbi, curseg)) {
 		if (from_gc)
-- 
2.43.0



