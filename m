Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 042CC502D54;
	Wed, 30 Sep 2026 15:34:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790782456; cv=none; b=uXIEfGn5QvQ1EnL5d7/BTrYEY0vRgUTMiuhToquKI84avKlt0Omn1pb6GbdAg5Mryda6knRwY5SKqtYMBl5R1V65Fl8lpis0hVvtcYLynUpbzYt6N3/Lvi2d4rgVb+qjQ6ANI9kte8kjL5RWUFv0M1UM843cmEs3dpIbthTh97M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790782456; c=relaxed/simple;
	bh=3nkkTjC0yNI7S9JQryEElI8g82MRJTRIWzXvtqWgIoE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=F6G6pS/as3GkgIv+ri9Jlivyg5EJNA+h9KXUT/jnA9vXPrkQUw/4a08GEYcXKCssv5Z9lOti+HtKy/Uio7LIWonvl/0qxmRVG7x09shvuEgz4C2x9wKi4Fz+8mj3QLwS/KS/7lQKQn3tA0nRnX6iuA4HXH9jg2Zxnhs7Hj0jv3k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=kKlNlpL7; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="kKlNlpL7"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A15CA1F00893;
	Wed, 30 Sep 2026 15:34:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790782445;
	bh=DYjTqVpLVumcEQ0ls+H6fB2GuOW/TkxzOQRKWYjxMIo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=kKlNlpL79K+/bhtW3U7wpSjMenaHKeh4rCMN+lR9n1cDxk3Hwr0KSgzgbGgiWcK5E
	 74qDy/1lF/wNM4rl4KhX17593vKpNGdcApWujJZ7Lr29p8pm67AOaPBD2ntluOQgcT
	 kj0h4EFD2yKGljRvsztGdODtkZ3Wh7U2JB7OuwME=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Christoph Hellwig <hch@lst.de>,
	"Christian Brauner (Amutable)" <brauner@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 048/595] omfs: handle set_blocksize failures
Date: Wed, 30 Sep 2026 17:19:01 +0200
Message-ID: <20260930152348.764519005@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260930152347.700140858@linuxfoundation.org>
References: <20260930152347.700140858@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Christoph Hellwig <hch@lst.de>

[ Upstream commit 18c3d6fcb557f920c9143711497625e70153874c ]

omfs uses buffer_heads, which don't handle block size > PAGE_SIZE well.
Without this, mounting we will hit the

        BUG_ON(offset >= folio_size(folio));

in folio_set_bh on the first __bread_gfp call.

Signed-off-by: Christoph Hellwig <hch@lst.de>

Signed-off-by: Christoph Hellwig <hch@lst.de>
Link: https://patch.msgid.link/20260511071701.2456211-11-hch@lst.de
Signed-off-by: Christian Brauner (Amutable) <brauner@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/omfs/inode.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/fs/omfs/inode.c b/fs/omfs/inode.c
index 5abd152406f51..01f8e6f162070 100644
--- a/fs/omfs/inode.c
+++ b/fs/omfs/inode.c
@@ -480,7 +480,8 @@ static int omfs_fill_super(struct super_block *sb, void *data, int silent)
 	sb->s_time_min = 0;
 	sb->s_time_max = U64_MAX / MSEC_PER_SEC;
 
-	sb_set_blocksize(sb, 0x200);
+	if (!sb_set_blocksize(sb, 0x200))
+		goto end;
 
 	bh = sb_bread(sb, 0);
 	if (!bh)
@@ -532,7 +533,8 @@ static int omfs_fill_super(struct super_block *sb, void *data, int silent)
 	 * Use sys_blocksize as the fs block since it is smaller than a
 	 * page while the fs blocksize can be larger.
 	 */
-	sb_set_blocksize(sb, sbi->s_sys_blocksize);
+	if (!sb_set_blocksize(sb, sbi->s_sys_blocksize))
+		goto out_brelse_bh;
 
 	/*
 	 * ...and the difference goes into a shift.  sys_blocksize is always
-- 
2.53.0



