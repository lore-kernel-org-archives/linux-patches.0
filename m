Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2AA4F1DE4CA;
	Wed,  6 Nov 2024 12:59:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730897943; cv=none; b=O0/HqrPVbbXT9fnSLeSmejX/SdhjnryUsHS5t3pIOlDXV84BFX/zQ39opMZMA56/ctZ83IG+38yYHvFAeSQxHlAYpWLJEYdvBewgS1r2C8A8LLFuYiRbp48fijk440/SwKTx8PBaT6oRAcM9q84QZYIP407s6mZ20STh+s4Oq9g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730897943; c=relaxed/simple;
	bh=n/QNAnz1FQcSmi93Av0vUlfWIBPTX4ckwWJx6w7Pqzs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=XN6mRdHUAu2QC1vTXwbJyi0huQqJygc+bKwAA7iO1Wm4YEFYsRgcZ2dPfnrrYOuxcEfcoOsZh0VyyrQoihK3yBfXpzZ23hpENYVy1DAS6drvPsShgDH71yR8lTVuOLBnrLfekVAWLT6fu75LEPVJyTp74/kwJ8nyB+xeInsfteA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=WBJWK2ah; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="WBJWK2ah"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3451BC4CECD;
	Wed,  6 Nov 2024 12:59:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1730897942;
	bh=n/QNAnz1FQcSmi93Av0vUlfWIBPTX4ckwWJx6w7Pqzs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=WBJWK2ahrWPmoQuHsVPGwgieVRGo8x3MJ8n/XddE7arxhJuAyF9UDmyiBPCoOU+nR
	 pQU4+2zGnhtlPG0B/JE0tV0QjFsvzGF8qlCLMgm91oH1euWo8dBisIh5d4AkU8NZBi
	 Kq+q32ht1tsnBCo0U3AHMVUM8KreQQicJ8RuYzIA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Christoph Hellwig <hch@lst.de>,
	Jan Kara <jack@suse.cz>,
	Miquel Raynal <miquel.raynal@bootlin.com>,
	Richard Weinberger <richard@nod.at>,
	Vignesh Raghavendra <vigneshr@ti.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Linus Torvalds <torvalds@linux-foundation.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 035/462] fs: explicitly unregister per-superblock BDIs
Date: Wed,  6 Nov 2024 12:58:48 +0100
Message-ID: <20241106120332.387329940@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241106120331.497003148@linuxfoundation.org>
References: <20241106120331.497003148@linuxfoundation.org>
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

5.4-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Christoph Hellwig <hch@lst.de>

[ Upstream commit 0b3ea0926afb8dde70cfab00316ae0a70b93a7cc ]

Add a new SB_I_ flag to mark superblocks that have an ephemeral bdi
associated with them, and unregister it when the superblock is shut
down.

Link: https://lkml.kernel.org/r/20211021124441.668816-4-hch@lst.de
Signed-off-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Jan Kara <jack@suse.cz>
Cc: Miquel Raynal <miquel.raynal@bootlin.com>
Cc: Richard Weinberger <richard@nod.at>
Cc: Vignesh Raghavendra <vigneshr@ti.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Stable-dep-of: 4bcda1eaf184 ("mount: handle OOM on mnt_warn_timestamp_expiry")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/super.c         | 3 +++
 include/linux/fs.h | 1 +
 2 files changed, 4 insertions(+)

diff --git a/fs/super.c b/fs/super.c
index 47ca7dc0e6c3d..8edf44a2d3dcc 100644
--- a/fs/super.c
+++ b/fs/super.c
@@ -475,6 +475,8 @@ void generic_shutdown_super(struct super_block *sb)
 	spin_unlock(&sb_lock);
 	up_write(&sb->s_umount);
 	if (sb->s_bdi != &noop_backing_dev_info) {
+		if (sb->s_iflags & SB_I_PERSB_BDI)
+			bdi_unregister(sb->s_bdi);
 		bdi_put(sb->s_bdi);
 		sb->s_bdi = &noop_backing_dev_info;
 	}
@@ -1622,6 +1624,7 @@ int super_setup_bdi_name(struct super_block *sb, char *fmt, ...)
 	}
 	WARN_ON(sb->s_bdi != &noop_backing_dev_info);
 	sb->s_bdi = bdi;
+	sb->s_iflags |= SB_I_PERSB_BDI;
 
 	return 0;
 }
diff --git a/include/linux/fs.h b/include/linux/fs.h
index d4f5fcc60744d..b21fdce37c37a 100644
--- a/include/linux/fs.h
+++ b/include/linux/fs.h
@@ -1407,6 +1407,7 @@ extern int send_sigurg(struct fown_struct *fown);
 #define SB_I_UNTRUSTED_MOUNTER		0x00000040
 
 #define SB_I_SKIP_SYNC	0x00000100	/* Skip superblock at global sync */
+#define SB_I_PERSB_BDI	0x00000200	/* has a per-sb bdi */
 
 /* Possible states of 'frozen' field */
 enum {
-- 
2.43.0



