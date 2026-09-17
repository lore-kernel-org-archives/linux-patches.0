Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 449033B1ED7;
	Thu, 17 Sep 2026 16:51:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789663869; cv=none; b=Gs/K9nzSDTdOSphBmuvpv0nhedtFXchE1ZtxQLUpf9+seNPyXQSTOC1kVX5v5t4k1LdNClJKytnOI0TKb68eeOadKkb5JBG/+5M7UrzKbnwHIGEZ53mQcR/k9o1C05REjUpbYHP8I68Rb6nzJWQKMg6+U4S6TMSFw28dEfAvsBY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789663869; c=relaxed/simple;
	bh=qL7tHhNIEzZPJAZxySx+Dbgix/1hXvSrCixz8zlQ7KU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=hT8Rtsce+JeTunOCLuCxS10oE273YlSVUnRYaA+AblAEkrvjC/+H/M1zu4FtehLydazrAMyQzvqxLG80quHP7D0ZoC/vaIGxBDAJrn5Hy6RaWi6uTIpIW8OQC1sPxm2WV8RqB+HigJiNChhq0dPu+LJEsb/BlCzZpTVO6glbJno=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=s0G8YVKu; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="s0G8YVKu"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8A21A1F000FF;
	Thu, 17 Sep 2026 16:51:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789663868;
	bh=E4Xmp2Q+f/YGTUyQSBekz6kKOJ3iu5qmotb4ov3eOe8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=s0G8YVKupqmcwbfbO/MV/nfPlTIEZGgUD73MpkVvjc9GgfeEJoarkYlkkG/Ji+rT4
	 FYzgJKo3NMcYPP4r1qN59lgFRax3ledNRZOqNHt/xwfkELaf+XapZ0sELkBJkSzrv8
	 oCHKsLHcI9X4ZCyWY5YCqvodTscaxn6YL2PWM2Cc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Christoph Hellwig <hch@lst.de>,
	"Christian Brauner (Amutable)" <brauner@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0182/1250] omfs: handle set_blocksize failures
Date: Thu, 17 Sep 2026 15:59:37 +0100
Message-ID: <20260917151557.042587021@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260917151551.901433442@linuxfoundation.org>
References: <20260917151551.901433442@linuxfoundation.org>
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
index 31218d89b7580..14369efc70d81 100644
--- a/fs/omfs/inode.c
+++ b/fs/omfs/inode.c
@@ -477,7 +477,8 @@ static int omfs_fill_super(struct super_block *sb, struct fs_context *fc)
 	sb->s_time_min = 0;
 	sb->s_time_max = U64_MAX / MSEC_PER_SEC;
 
-	sb_set_blocksize(sb, 0x200);
+	if (!sb_set_blocksize(sb, 0x200))
+		goto end;
 
 	bh = sb_bread(sb, 0);
 	if (!bh)
@@ -529,7 +530,8 @@ static int omfs_fill_super(struct super_block *sb, struct fs_context *fc)
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



