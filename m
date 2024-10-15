Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 52A8B1EBA1E;
	Tue, 15 Oct 2024 11:39:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728992390; cv=none; b=pHW0DBajqxGlQMC04+EmkVS4HhZP0YYUmDUcS1gHCOUKZX7/19HQ7ygQOQW+9UX/KdtEHSEVSmtb04TzTbcFtRL4QgOtEwA1ki1y7km+/YkzygtcKS4GuS9aHcSNk3TKrITQCsiXEn5zHnxtjSbhYpMraCznbyoC2actcauaMV8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728992390; c=relaxed/simple;
	bh=bH5G7oghYit6j3kIK5C2HKdKwZDxOvlKMo+WxxtChHo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=JrLiKbmyPlnTRsoK3yN13P3Uf/zgzrYUcDo5yVOYTBO/TCPxewVAK3JA6FUEWFFKCrACAZrVaxvZ7oPNmhvgxoWjwgbm2UiNCwVkuwWXNx5wy4yssaW4EaccCJMWHib92w/k2Dy9Ji/yOsBM0v6K99BS74js6IBu8WqmvafMys4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=2J7uvtlz; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="2J7uvtlz"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5ECEBC4CEC6;
	Tue, 15 Oct 2024 11:39:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1728992389;
	bh=bH5G7oghYit6j3kIK5C2HKdKwZDxOvlKMo+WxxtChHo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=2J7uvtlzsYJLMVtiU2M3XeDFr2EcMHm9rFcUnpYwyVZtEn+MTnJVI4hPHbfdrQHdV
	 fX9ALjhGiH7GAeEmSe2xVuOgol0hdUSXhqY43bIttwc5jes5CDaLpAHiyh5Es3nof8
	 C7eFB71N5nFeh2AshZUgQyM11vHpFmVtoDlsrmVE=
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
Subject: [PATCH 5.15 102/691] fs: explicitly unregister per-superblock BDIs
Date: Tue, 15 Oct 2024 13:20:50 +0200
Message-ID: <20241015112444.409203310@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241015112440.309539031@linuxfoundation.org>
References: <20241015112440.309539031@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
index 39d866f7d7c6b..eeb8f745a8bf7 100644
--- a/fs/super.c
+++ b/fs/super.c
@@ -486,6 +486,8 @@ void generic_shutdown_super(struct super_block *sb)
 	spin_unlock(&sb_lock);
 	up_write(&sb->s_umount);
 	if (sb->s_bdi != &noop_backing_dev_info) {
+		if (sb->s_iflags & SB_I_PERSB_BDI)
+			bdi_unregister(sb->s_bdi);
 		bdi_put(sb->s_bdi);
 		sb->s_bdi = &noop_backing_dev_info;
 	}
@@ -1592,6 +1594,7 @@ int super_setup_bdi_name(struct super_block *sb, char *fmt, ...)
 	}
 	WARN_ON(sb->s_bdi != &noop_backing_dev_info);
 	sb->s_bdi = bdi;
+	sb->s_iflags |= SB_I_PERSB_BDI;
 
 	return 0;
 }
diff --git a/include/linux/fs.h b/include/linux/fs.h
index 27da89d0ed5ac..bf35cf9e312a5 100644
--- a/include/linux/fs.h
+++ b/include/linux/fs.h
@@ -1476,6 +1476,7 @@ extern int send_sigurg(struct fown_struct *fown);
 #define SB_I_UNTRUSTED_MOUNTER		0x00000040
 
 #define SB_I_SKIP_SYNC	0x00000100	/* Skip superblock at global sync */
+#define SB_I_PERSB_BDI	0x00000200	/* has a per-sb bdi */
 
 /* Possible states of 'frozen' field */
 enum {
-- 
2.43.0



