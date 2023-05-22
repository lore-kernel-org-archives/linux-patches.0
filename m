Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 56D04168B6
	for <patches@lists.linux.dev>; Mon, 22 May 2023 19:13:18 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D87F1C433EF;
	Mon, 22 May 2023 19:13:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1684782798;
	bh=16YV59Y5TWHm0xMUgJjSMPqUjND4p5xiiAKBu0eMgTg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=hzZ3mxHJqwEgD974E6fhYYMUst6SNIoq6LttNX+/pyaAO/sdccLZ42iqf9zL2Hmyf
	 de0mXjs4GtPqee4P30k0Z9/bYdrnp3eIKCS4KWCCoXFCKb/6qoMhRBMoKFFDgzbIMs
	 j+zBtSgieMPS9kyoadBBgpNvoz5qN61e33skhPjs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Austin Kim <austindh.kim@gmail.com>,
	Jan Kara <jack@suse.cz>,
	Theodore Tso <tytso@mit.edu>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 024/203] ext4: remove an unused variable warning with CONFIG_QUOTA=n
Date: Mon, 22 May 2023 20:07:28 +0100
Message-Id: <20230522190355.631183227@linuxfoundation.org>
X-Mailer: git-send-email 2.40.1
In-Reply-To: <20230522190354.935300867@linuxfoundation.org>
References: <20230522190354.935300867@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Austin Kim <austindh.kim@gmail.com>

[ Upstream commit 3bbef91bdd2180c67407285ba160b023eb4d5306 ]

The 'enable_quota' variable is only used in an CONFIG_QUOTA.
With CONFIG_QUOTA=n, compiler causes a harmless warning:

fs/ext4/super.c: In function ‘ext4_remount’:
fs/ext4/super.c:5840:6: warning: variable ‘enable_quota’ set but not used
  [-Wunused-but-set-variable]
  int enable_quota = 0;
              ^~~~~

Move 'enable_quota' into the same #ifdef CONFIG_QUOTA block
to remove an unused variable warning.

Signed-off-by: Austin Kim <austindh.kim@gmail.com>
Reviewed-by: Jan Kara <jack@suse.cz>
Link: https://lore.kernel.org/r/20210824034929.GA13415@raspberrypi
Signed-off-by: Theodore Ts'o <tytso@mit.edu>
Stable-dep-of: a44be64bbecb ("ext4: don't clear SB_RDONLY when remounting r/w until quota is re-enabled")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/ext4/super.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/fs/ext4/super.c b/fs/ext4/super.c
index e6cd2bf9508e4..ca0997fcd1215 100644
--- a/fs/ext4/super.c
+++ b/fs/ext4/super.c
@@ -5742,10 +5742,10 @@ static int ext4_remount(struct super_block *sb, int *flags, char *data)
 	struct ext4_sb_info *sbi = EXT4_SB(sb);
 	unsigned long old_sb_flags, vfs_flags;
 	struct ext4_mount_options old_opts;
-	int enable_quota = 0;
 	ext4_group_t g;
 	int err = 0;
 #ifdef CONFIG_QUOTA
+	int enable_quota = 0;
 	int i, j;
 	char *to_free[EXT4_MAXQUOTAS];
 #endif
@@ -5951,7 +5951,9 @@ static int ext4_remount(struct super_block *sb, int *flags, char *data)
 					err = -EROFS;
 					goto restore_opts;
 				}
+#ifdef CONFIG_QUOTA
 			enable_quota = 1;
+#endif
 		}
 	}
 
-- 
2.39.2



