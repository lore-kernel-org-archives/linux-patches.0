Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4256017AA6
	for <patches@lists.linux.dev>; Wed,  9 Aug 2023 11:27:35 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B8A79C433CA;
	Wed,  9 Aug 2023 11:27:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1691580455;
	bh=yr8KPD87HHrbVkXz6Lxl2lpLdcIynT1od3rUjJpr9Oc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=XovtVR6mxNjsEjiO++LPIwMsDV3/7GzoQ2e1TRZ8HwLR5/xfxiVnaocZ/GDaCBrVs
	 t7AdzL9aof6WOx2rwvsVFG9OWSBH6zzyUzgPJPFTrvhQNTR0T8PCk3chE3B0mkyrGk
	 0irGZMZUvbNhVAKWU/nTcuvz0o7+FHWZWuBEII2k=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	stable@kernel.org,
	Chao Yu <chao@kernel.org>,
	Theodore Tso <tytso@mit.edu>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 031/154] ext4: fix to check return value of freeze_bdev() in ext4_shutdown()
Date: Wed,  9 Aug 2023 12:41:02 +0200
Message-ID: <20230809103638.029514999@linuxfoundation.org>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20230809103636.887175326@linuxfoundation.org>
References: <20230809103636.887175326@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Chao Yu <chao@kernel.org>

[ Upstream commit c4d13222afd8a64bf11bc7ec68645496ee8b54b9 ]

freeze_bdev() can fail due to a lot of reasons, it needs to check its
reason before later process.

Fixes: 783d94854499 ("ext4: add EXT4_IOC_GOINGDOWN ioctl")
Cc: stable@kernel.org
Signed-off-by: Chao Yu <chao@kernel.org>
Link: https://lore.kernel.org/r/20230606073203.1310389-1-chao@kernel.org
Signed-off-by: Theodore Ts'o <tytso@mit.edu>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/ext4/ioctl.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/fs/ext4/ioctl.c b/fs/ext4/ioctl.c
index 306ad7d0003bb..ae47505964c4b 100644
--- a/fs/ext4/ioctl.c
+++ b/fs/ext4/ioctl.c
@@ -573,6 +573,7 @@ static int ext4_shutdown(struct super_block *sb, unsigned long arg)
 {
 	struct ext4_sb_info *sbi = EXT4_SB(sb);
 	__u32 flags;
+	struct super_block *ret;
 
 	if (!capable(CAP_SYS_ADMIN))
 		return -EPERM;
@@ -591,7 +592,9 @@ static int ext4_shutdown(struct super_block *sb, unsigned long arg)
 
 	switch (flags) {
 	case EXT4_GOING_FLAGS_DEFAULT:
-		freeze_bdev(sb->s_bdev);
+		ret = freeze_bdev(sb->s_bdev);
+		if (IS_ERR(ret))
+			return PTR_ERR(ret);
 		set_bit(EXT4_FLAGS_SHUTDOWN, &sbi->s_ext4_flags);
 		thaw_bdev(sb->s_bdev, sb);
 		break;
-- 
2.39.2



