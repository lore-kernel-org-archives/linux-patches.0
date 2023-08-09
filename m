Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0C4AB1775C
	for <patches@lists.linux.dev>; Wed,  9 Aug 2023 11:23:32 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 81B4AC433C7;
	Wed,  9 Aug 2023 11:23:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1691580211;
	bh=ztpTZHdijMJ7h56IE/k/SOoHjqmOdEGQuEbhc57dzvE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=u1gCg/1sca26rJAqrv+5dI5Ouufh/sIjj/W1hh+DxWajTYISSC5lU/oMo+uTvxXDu
	 cbxfUpxftBHrBayQIIzzhYdJ0TgIJ0cDdY6tYe74nU303Cti6eLvwkfAEerMu3qoya
	 7bq8NA9qWbzRQR5yDLRT4tyYyuEU2S2Lp11lwptM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	stable@kernel.org,
	Chao Yu <chao@kernel.org>,
	Theodore Tso <tytso@mit.edu>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 237/323] ext4: fix to check return value of freeze_bdev() in ext4_shutdown()
Date: Wed,  9 Aug 2023 12:41:15 +0200
Message-ID: <20230809103708.927197533@linuxfoundation.org>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20230809103658.104386911@linuxfoundation.org>
References: <20230809103658.104386911@linuxfoundation.org>
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
index b930e8d559d41..43e036f0b661d 100644
--- a/fs/ext4/ioctl.c
+++ b/fs/ext4/ioctl.c
@@ -561,6 +561,7 @@ static int ext4_shutdown(struct super_block *sb, unsigned long arg)
 {
 	struct ext4_sb_info *sbi = EXT4_SB(sb);
 	__u32 flags;
+	struct super_block *ret;
 
 	if (!capable(CAP_SYS_ADMIN))
 		return -EPERM;
@@ -579,7 +580,9 @@ static int ext4_shutdown(struct super_block *sb, unsigned long arg)
 
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



