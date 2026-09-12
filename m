Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 952AF47ECFE;
	Sat, 12 Sep 2026 13:26:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789219575; cv=none; b=IFFKjChcb0KrQF2+3YroWtvUGR5neR5sApdbwG+3k4M/+PgDu/ui/4+HAMHBWjiQBfOQmlh9YxHRCGt2T1M1oX2nebwaHT1ODJShuB3PcNvhOWb3I18VO22o33u+rmqMRocsrxMJk0vPdPyaCNDMovDitLFXkvx7gMaKVtMDVkY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789219575; c=relaxed/simple;
	bh=KWltJp6prHph5YHVDhj4vNdZZdCp+ZL7jeM+TVooRs8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=AWssBEgoVKf1xlI7lRBvF2CzeKxKCSQVpmf3au6a2ybWrcVTDzjeNi7Pm+lE+84KshH9sEhRk7cbtQfUyoDYkKsR/+aPliJawLJ5G7+bfptH6jn5SR9K37lYn2j4ZivFQBkr7pPxdpYV1dTWuKWxJAC0qHK2V0F0hvK3CU486Gk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=XDKcXsxH; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="XDKcXsxH"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0321E1F000FF;
	Sat, 12 Sep 2026 13:26:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789219573;
	bh=vJVfETZsZ+0LiSgCghxBP1lA/qIAisgvtGBYaUN5hm8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=XDKcXsxHCpcVQ8RW5AKUSsejz8O1pecqjtVnJ6/5+0Yf02H1TJJhiG7pu4oEsWzRS
	 KJSD/fzbBfMGeKwcEL/euLofp5NymqeASAcEbJPF/hh97swjga8LoT0t8cO+GTlcQd
	 8gplNeDJ8m0yGF9Q60egImWcEsSoCBch35Y+pyt0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Xiao Ni <xni@redhat.com>,
	Yu Kuai <yukuai3@huawei.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 1343/1376] md: keep recovery_cp in mdp_superblock_s
Date: Sat, 12 Sep 2026 09:02:49 +0200
Message-ID: <20260912065637.463434175@linuxfoundation.org>
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

From: Xiao Ni <xni@redhat.com>

[ Upstream commit c27973211ffcdf0a092eec265d5993e64b89adaf ]

commit 907a99c314a5 ("md: rename recovery_cp to resync_offset") replaces
recovery_cp with resync_offset in mdp_superblock_s which is in md_p.h.
md_p.h is used in userspace too. So mdadm building fails because of this.
This patch revert this change.

Fixes: 907a99c314a5 ("md: rename recovery_cp to resync_offset")
Signed-off-by: Xiao Ni <xni@redhat.com>
Link: https://lore.kernel.org/linux-raid/20250815040028.18085-1-xni@redhat.com
Signed-off-by: Yu Kuai <yukuai3@huawei.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/md/md.c                | 6 +++---
 include/uapi/linux/raid/md_p.h | 2 +-
 2 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/md/md.c b/drivers/md/md.c
index 79ca70ca797db..f51ad1c84ef30 100644
--- a/drivers/md/md.c
+++ b/drivers/md/md.c
@@ -1372,7 +1372,7 @@ static int super_90_validate(struct mddev *mddev, struct md_rdev *freshest, stru
 		else {
 			if (sb->events_hi == sb->cp_events_hi &&
 				sb->events_lo == sb->cp_events_lo) {
-				mddev->resync_offset = sb->resync_offset;
+				mddev->resync_offset = sb->recovery_cp;
 			} else
 				mddev->resync_offset = 0;
 		}
@@ -1500,13 +1500,13 @@ static void super_90_sync(struct mddev *mddev, struct md_rdev *rdev)
 	mddev->minor_version = sb->minor_version;
 	if (mddev->in_sync)
 	{
-		sb->resync_offset = mddev->resync_offset;
+		sb->recovery_cp = mddev->resync_offset;
 		sb->cp_events_hi = (mddev->events>>32);
 		sb->cp_events_lo = (u32)mddev->events;
 		if (mddev->resync_offset == MaxSector)
 			sb->state = (1<< MD_SB_CLEAN);
 	} else
-		sb->resync_offset = 0;
+		sb->recovery_cp = 0;
 
 	sb->layout = mddev->layout;
 	sb->chunk_size = mddev->chunk_sectors << 9;
diff --git a/include/uapi/linux/raid/md_p.h b/include/uapi/linux/raid/md_p.h
index b139462872775..ac74133a47688 100644
--- a/include/uapi/linux/raid/md_p.h
+++ b/include/uapi/linux/raid/md_p.h
@@ -173,7 +173,7 @@ typedef struct mdp_superblock_s {
 #else
 #error unspecified endianness
 #endif
-	__u32 resync_offset;	/* 11 resync checkpoint sector count	      */
+	__u32 recovery_cp;	/* 11 resync checkpoint sector count	      */
 	/* There are only valid for minor_version > 90 */
 	__u64 reshape_position;	/* 12,13 next address in array-space for reshape */
 	__u32 new_level;	/* 14 new level we are reshaping to	      */
-- 
2.53.0



