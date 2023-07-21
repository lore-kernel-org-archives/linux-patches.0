Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6BA7420F8F
	for <patches@lists.linux.dev>; Fri, 21 Jul 2023 19:21:44 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E3699C433CA;
	Fri, 21 Jul 2023 19:21:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1689967304;
	bh=Ij3guzWuR5zhjAcKtqawVZrPABOE2c4qt7iQXyH4+lI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=if+7wdN2CoXrZ3c8VPaiV82pnap9nDotMHRLh7J/N5avRE1NbFeV40AE+ZWmtSywv
	 f3Eguv32+6dDEK2ADTvOjxnTp5lig0u8fkU/ByktX5adDbl9frjofYO7Lxd+CPX8lh
	 qkUnFR3FuBK6dIoFKYu+CAanBY3L8XNkQe4wYkbM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	stable@kernel.org,
	Chao Yu <chao@kernel.org>,
	Theodore Tso <tytso@mit.edu>
Subject: [PATCH 6.1 108/223] ext4: fix to check return value of freeze_bdev() in ext4_shutdown()
Date: Fri, 21 Jul 2023 18:06:01 +0200
Message-ID: <20230721160525.475623850@linuxfoundation.org>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20230721160520.865493356@linuxfoundation.org>
References: <20230721160520.865493356@linuxfoundation.org>
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

commit c4d13222afd8a64bf11bc7ec68645496ee8b54b9 upstream.

freeze_bdev() can fail due to a lot of reasons, it needs to check its
reason before later process.

Fixes: 783d94854499 ("ext4: add EXT4_IOC_GOINGDOWN ioctl")
Cc: stable@kernel.org
Signed-off-by: Chao Yu <chao@kernel.org>
Link: https://lore.kernel.org/r/20230606073203.1310389-1-chao@kernel.org
Signed-off-by: Theodore Ts'o <tytso@mit.edu>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/ext4/ioctl.c |    5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

--- a/fs/ext4/ioctl.c
+++ b/fs/ext4/ioctl.c
@@ -800,6 +800,7 @@ static int ext4_shutdown(struct super_bl
 {
 	struct ext4_sb_info *sbi = EXT4_SB(sb);
 	__u32 flags;
+	int ret;
 
 	if (!capable(CAP_SYS_ADMIN))
 		return -EPERM;
@@ -818,7 +819,9 @@ static int ext4_shutdown(struct super_bl
 
 	switch (flags) {
 	case EXT4_GOING_FLAGS_DEFAULT:
-		freeze_bdev(sb->s_bdev);
+		ret = freeze_bdev(sb->s_bdev);
+		if (ret)
+			return ret;
 		set_bit(EXT4_FLAGS_SHUTDOWN, &sbi->s_ext4_flags);
 		thaw_bdev(sb->s_bdev);
 		break;


