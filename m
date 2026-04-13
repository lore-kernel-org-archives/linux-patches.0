Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8C0F127FB2E;
	Mon, 13 Apr 2026 16:12:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776096738; cv=none; b=SQDywA9Q8gXEI9z2x6DjNpuRrRKBC4nbAVVJdzJsBlkqYMUt5DowuNIgw9EG6W3XQPCkpAOyv0qdcbJM/Ntg8X5PpOftc9QTQLWfonnWtaKEinJNZ9nWmQFnl/b4XWhZFxqWmWM5cm2e37DTvF5R/gUFmPBB9qh3DtAuKJJZUDQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776096738; c=relaxed/simple;
	bh=Lydk9yNkWyUI///9uoAldjWOeM3r1U/JzaA/0pMSu8s=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=raSgH35u1I93m+z/NgvwrLyS9XvEdX/IpLYNxGkOfej/PSn3N10rIvkX3lxFZ4awfUt/lV6nhNEv3m3yTC5eHzxxOUFGpdGWy+AhSzd0MSeAzhSAb7Ge2todDjBP/fr/jjMRzXLM7c/2c821TRNUQwnVYXVQdxsNDEMM7C81qOY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=VpvnfQu8; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="VpvnfQu8"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 23D2CC2BCAF;
	Mon, 13 Apr 2026 16:12:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1776096738;
	bh=Lydk9yNkWyUI///9uoAldjWOeM3r1U/JzaA/0pMSu8s=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=VpvnfQu8rgwujAoVQpyn37ZFV8nP38eqB7nclB76c6w5nwjj3U7/snEEkuoDDRS+1
	 /fsj2vI8h2WnkLXQRvKozbuOafeYdcS4HplffOVKdlmwIRxknJlbyYMyBCrKdK4sts
	 Q2IOsWN+ff34WaTSOsH2qjzOEBw6Jx+DHohR1dNo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Johannes Thumshirn <johannes.thumshirn@wdc.com>,
	Anand Jain <anand.jain@oracle.com>,
	David Sterba <dsterba@suse.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 16/70] btrfs: split waiting from read_extent_buffer_pages(), drop parameter wait
Date: Mon, 13 Apr 2026 18:00:11 +0200
Message-ID: <20260413155728.794973551@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260413155728.181580293@linuxfoundation.org>
References: <20260413155728.181580293@linuxfoundation.org>
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

From: David Sterba <dsterba@suse.com>

[ Upstream commit 248c4ff3935252a82504c55cfd3592e413575bd0 ]

There are only 2 WAIT_* values left for wait parameter, we can encode
this to the function name if the waiting functionality is split.

Reviewed-by: Johannes Thumshirn <johannes.thumshirn@wdc.com>
Reviewed-by: Anand Jain <anand.jain@oracle.com>
Signed-off-by: David Sterba <dsterba@suse.com>
Stable-dep-of: 316fb1b3169e ("btrfs: fix incorrect return value after changing leaf in lookup_extent_data_ref()")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/btrfs/disk-io.c   |  2 +-
 fs/btrfs/extent_io.c | 27 +++++++++++++++++----------
 fs/btrfs/extent_io.h |  7 ++++---
 3 files changed, 22 insertions(+), 14 deletions(-)

diff --git a/fs/btrfs/disk-io.c b/fs/btrfs/disk-io.c
index 05e91ed0af197..5de12f3a679df 100644
--- a/fs/btrfs/disk-io.c
+++ b/fs/btrfs/disk-io.c
@@ -226,7 +226,7 @@ int btrfs_read_extent_buffer(struct extent_buffer *eb,
 
 	while (1) {
 		clear_bit(EXTENT_BUFFER_CORRUPT, &eb->bflags);
-		ret = read_extent_buffer_pages(eb, WAIT_COMPLETE, mirror_num, check);
+		ret = read_extent_buffer_pages(eb, mirror_num, check);
 		if (!ret)
 			break;
 
diff --git a/fs/btrfs/extent_io.c b/fs/btrfs/extent_io.c
index 3bcb368c4127e..0d50f3063d346 100644
--- a/fs/btrfs/extent_io.c
+++ b/fs/btrfs/extent_io.c
@@ -3636,8 +3636,8 @@ static void end_bbio_meta_read(struct btrfs_bio *bbio)
 	bio_put(&bbio->bio);
 }
 
-int read_extent_buffer_pages(struct extent_buffer *eb, int wait, int mirror_num,
-			     const struct btrfs_tree_parent_check *check)
+int read_extent_buffer_pages_nowait(struct extent_buffer *eb, int mirror_num,
+				    const struct btrfs_tree_parent_check *check)
 {
 	struct btrfs_bio *bbio;
 	bool ret;
@@ -3655,7 +3655,7 @@ int read_extent_buffer_pages(struct extent_buffer *eb, int wait, int mirror_num,
 
 	/* Someone else is already reading the buffer, just wait for it. */
 	if (test_and_set_bit(EXTENT_BUFFER_READING, &eb->bflags))
-		goto done;
+		return 0;
 
 	/*
 	 * Between the initial test_bit(EXTENT_BUFFER_UPTODATE) and the above
@@ -3695,14 +3695,21 @@ int read_extent_buffer_pages(struct extent_buffer *eb, int wait, int mirror_num,
 		}
 	}
 	btrfs_submit_bbio(bbio, mirror_num);
+	return 0;
+}
 
-done:
-	if (wait == WAIT_COMPLETE) {
-		wait_on_bit_io(&eb->bflags, EXTENT_BUFFER_READING, TASK_UNINTERRUPTIBLE);
-		if (!test_bit(EXTENT_BUFFER_UPTODATE, &eb->bflags))
-			return -EIO;
-	}
+int read_extent_buffer_pages(struct extent_buffer *eb, int mirror_num,
+			     const struct btrfs_tree_parent_check *check)
+{
+	int ret;
 
+	ret = read_extent_buffer_pages_nowait(eb, mirror_num, check);
+	if (ret < 0)
+		return ret;
+
+	wait_on_bit_io(&eb->bflags, EXTENT_BUFFER_READING, TASK_UNINTERRUPTIBLE);
+	if (!test_bit(EXTENT_BUFFER_UPTODATE, &eb->bflags))
+		return -EIO;
 	return 0;
 }
 
@@ -4434,7 +4441,7 @@ void btrfs_readahead_tree_block(struct btrfs_fs_info *fs_info,
 		return;
 	}
 
-	ret = read_extent_buffer_pages(eb, WAIT_NONE, 0, &check);
+	ret = read_extent_buffer_pages_nowait(eb, 0, &check);
 	if (ret < 0)
 		free_extent_buffer_stale(eb);
 	else
diff --git a/fs/btrfs/extent_io.h b/fs/btrfs/extent_io.h
index efface292a595..f21fd8b50abc8 100644
--- a/fs/btrfs/extent_io.h
+++ b/fs/btrfs/extent_io.h
@@ -261,10 +261,11 @@ struct extent_buffer *find_extent_buffer(struct btrfs_fs_info *fs_info,
 					 u64 start);
 void free_extent_buffer(struct extent_buffer *eb);
 void free_extent_buffer_stale(struct extent_buffer *eb);
-#define WAIT_NONE	0
-#define WAIT_COMPLETE	1
-int read_extent_buffer_pages(struct extent_buffer *eb, int wait, int mirror_num,
+int read_extent_buffer_pages(struct extent_buffer *eb, int mirror_num,
 			     const struct btrfs_tree_parent_check *parent_check);
+int read_extent_buffer_pages_nowait(struct extent_buffer *eb, int mirror_num,
+				    const struct btrfs_tree_parent_check *parent_check);
+
 static inline void wait_on_extent_buffer_writeback(struct extent_buffer *eb)
 {
 	wait_on_bit_io(&eb->bflags, EXTENT_BUFFER_WRITEBACK,
-- 
2.53.0



