Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1D2471170E
	for <patches@lists.linux.dev>; Mon, 11 Sep 2023 14:17:43 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 91854C433C7;
	Mon, 11 Sep 2023 14:17:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1694441862;
	bh=I4yCv0c86we53uiBjo7XrMn40w09rmWvsPY2UvFFg/0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=fT8VYHgjQuaL6V3jbsdEJqx7aXIT8tIEgTIrNPcyBDU2gVh68kCEa4QKh4bRJdruy
	 Cv6D+BGGsGWJI/b3l7X0AjpQ2YjRN0MJC2Kj4aTxHOz4vsn1cnfJf8PESHv8wQR8G3
	 7gVy1c9HdYeoDK624WeQXDs9VxbcmB0CMQmZFvfA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Chao Yu <chao@kernel.org>,
	Jaegeuk Kim <jaegeuk@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.5 563/739] Revert "f2fs: do not issue small discard commands during checkpoint"
Date: Mon, 11 Sep 2023 15:46:02 +0200
Message-ID: <20230911134706.804052817@linuxfoundation.org>
X-Mailer: git-send-email 2.42.0
In-Reply-To: <20230911134650.921299741@linuxfoundation.org>
References: <20230911134650.921299741@linuxfoundation.org>
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

6.5-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Chao Yu <chao@kernel.org>

[ Upstream commit 005abf9e5e0d4dcfce318ae5dbcac32b7bf6b647 ]

Previously, we have two mechanisms to cache & submit small discards:

a) set max small discard number in /sys/fs/f2fs/vdb/max_small_discards,
and checkpoint will cache small discard candidates w/ configured maximum
number.

b) call FITRIM ioctl, also, checkpoint in f2fs_trim_fs() will cache small
discard candidates w/ configured discard granularity, but w/o limitation
of number. FSTRIM interface is asynchronized, so it won't submit discard
directly.

Finally, discard thread will submit them in background periodically.

However, after commit 9ac00e7cef10 ("f2fs: do not issue small discard
commands during checkpoint"), the mechanism a) is broken, since no matter
how we configure the sysfs entry /sys/fs/f2fs/vdb/max_small_discards,
checkpoint will not cache small discard candidates any more.

echo 0 > /sys/fs/f2fs/vdb/max_small_discards
xfs_io -f /mnt/f2fs/file -c "pwrite 0 2m" -c "fsync"
xfs_io /mnt/f2fs/file -c "fpunch 0 4k"
sync
cat /proc/fs/f2fs/vdb/discard_plist_info |head -2

echo 100 > /sys/fs/f2fs/vdb/max_small_discards
rm /mnt/f2fs/file
xfs_io -f /mnt/f2fs/file -c "pwrite 0 2m" -c "fsync"
xfs_io /mnt/f2fs/file -c "fpunch 0 4k"
sync
cat /proc/fs/f2fs/vdb/discard_plist_info |head -2

Before the patch:
Discard pend list(Show diacrd_cmd count on each entry, .:not exist):
  0         .       .       .       .       .       .       .       .
Discard pend list(Show diacrd_cmd count on each entry, .:not exist):
  0         3       1       .       .       .       .       .       .

After the patch:
Discard pend list(Show diacrd_cmd count on each entry, .:not exist):
  0         .       .       .       .       .       .       .       .
Discard pend list(Show diacrd_cmd count on each entry, .:not exist):
  0         .       .       .       .       .       .       .       .

This patch reverts commit 9ac00e7cef10 ("f2fs: do not issue small discard
commands during checkpoint") in order to fix this issue.

Fixes: 9ac00e7cef10 ("f2fs: do not issue small discard commands during checkpoint")
Signed-off-by: Chao Yu <chao@kernel.org>
Signed-off-by: Jaegeuk Kim <jaegeuk@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/f2fs/segment.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/f2fs/segment.c b/fs/f2fs/segment.c
index a31a47b066d1d..be08be6f4bfd6 100644
--- a/fs/f2fs/segment.c
+++ b/fs/f2fs/segment.c
@@ -2211,7 +2211,7 @@ void f2fs_clear_prefree_segments(struct f2fs_sb_info *sbi,
 			len = next_pos - cur_pos;
 
 			if (f2fs_sb_has_blkzoned(sbi) ||
-					!force || len < cpc->trim_minlen)
+			    (force && len < cpc->trim_minlen))
 				goto skip;
 
 			f2fs_issue_discard(sbi, entry->start_blkaddr + cur_pos,
-- 
2.40.1



