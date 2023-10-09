Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CA63A22F00
	for <patches@lists.linux.dev>; Mon,  9 Oct 2023 13:35:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="kdASz6iC"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4861CC433C7;
	Mon,  9 Oct 2023 13:35:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1696858512;
	bh=PZYA5LOy7JpDMTisBDYwAn3208G+2StYsy+lS021z44=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=kdASz6iC9Z9oQIcfbZxHbvrGnINh9l7OnSmZAeUdb70ZIRz9XHagByMp4wlggd/VH
	 6mFJxFTNexu7GvXv4ONiODxgNiQODNBWfCOwPlWnsFWkRN31N1ubhgM3l0mjk8kDme
	 v+QOHO/N8ZOeKjmlyH7va3/4vW/2RFXU2JW+skx4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	stable@kernel.org,
	Len Brown <lenb@kernel.org>,
	Dave Chinner <david@fromorbit.com>,
	Jan Kara <jack@suse.cz>,
	Theodore Tso <tytso@mit.edu>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 014/226] ext4: do not let fstrim block system suspend
Date: Mon,  9 Oct 2023 14:59:35 +0200
Message-ID: <20231009130127.101581734@linuxfoundation.org>
X-Mailer: git-send-email 2.42.0
In-Reply-To: <20231009130126.697995596@linuxfoundation.org>
References: <20231009130126.697995596@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jan Kara <jack@suse.cz>

[ Upstream commit 5229a658f6453362fbb9da6bf96872ef25a7097e ]

Len Brown has reported that system suspend sometimes fail due to
inability to freeze a task working in ext4_trim_fs() for one minute.
Trimming a large filesystem on a disk that slowly processes discard
requests can indeed take a long time. Since discard is just an advisory
call, it is perfectly fine to interrupt it at any time and the return
number of discarded blocks until that moment. Do that when we detect the
task is being frozen.

Cc: stable@kernel.org
Reported-by: Len Brown <lenb@kernel.org>
Suggested-by: Dave Chinner <david@fromorbit.com>
References: https://bugzilla.kernel.org/show_bug.cgi?id=216322
Signed-off-by: Jan Kara <jack@suse.cz>
Link: https://lore.kernel.org/r/20230913150504.9054-2-jack@suse.cz
Signed-off-by: Theodore Ts'o <tytso@mit.edu>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/ext4/mballoc.c | 12 ++++++++++--
 1 file changed, 10 insertions(+), 2 deletions(-)

diff --git a/fs/ext4/mballoc.c b/fs/ext4/mballoc.c
index 2907bf57744a8..b35d59d41c896 100644
--- a/fs/ext4/mballoc.c
+++ b/fs/ext4/mballoc.c
@@ -16,6 +16,7 @@
 #include <linux/slab.h>
 #include <linux/nospec.h>
 #include <linux/backing-dev.h>
+#include <linux/freezer.h>
 #include <trace/events/ext4.h>
 
 /*
@@ -5904,6 +5905,11 @@ static ext4_grpblk_t ext4_last_grp_cluster(struct super_block *sb,
 					EXT4_CLUSTER_BITS(sb);
 }
 
+static bool ext4_trim_interrupted(void)
+{
+	return fatal_signal_pending(current) || freezing(current);
+}
+
 static int ext4_try_to_trim_range(struct super_block *sb,
 		struct ext4_buddy *e4b, ext4_grpblk_t start,
 		ext4_grpblk_t max, ext4_grpblk_t minblocks)
@@ -5935,8 +5941,8 @@ static int ext4_try_to_trim_range(struct super_block *sb,
 		free_count += next - start;
 		start = next + 1;
 
-		if (fatal_signal_pending(current))
-			return -ERESTARTSYS;
+		if (ext4_trim_interrupted())
+			return count;
 
 		if (need_resched()) {
 			ext4_unlock_group(sb, e4b->bd_group);
@@ -6063,6 +6069,8 @@ int ext4_trim_fs(struct super_block *sb, struct fstrim_range *range)
 	end = EXT4_CLUSTERS_PER_GROUP(sb) - 1;
 
 	for (group = first_group; group <= last_group; group++) {
+		if (ext4_trim_interrupted())
+			break;
 		grp = ext4_get_group_info(sb, group);
 		if (!grp)
 			continue;
-- 
2.40.1



