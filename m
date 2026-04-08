Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3AFC1347503;
	Wed,  8 Apr 2026 18:12:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1775671923; cv=none; b=d7gftm1rzBKO9kJ1hNBwwIlH7rOPoBa25DwpxEWSw9XQQo7R1KZ/9Z46fsJtOVe3KHoXwkAMpoYNPA1sCxModDlkrwIF4CaDhjYjT8TML5xxVFNA9d+jP/3XDpFXjPrXcFTDoPmvBf8g+FgZ5YYnDhXE0qeX513y16kjts9OaHY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1775671923; c=relaxed/simple;
	bh=oVAjcOHEHrYfCjz1m3+NLxn688oXI0cXYko3sMMzqAA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=QFfKHYanDNkzgo0wwHMKjg1KESRDTT5rCboG8qf0FANKOfKVO6DfPOhHBR88jEC/5D2Guc51CBP5LxBkFEf6epRSIq7YnZyWp/kPlUQizaWTNC2Q83dj/3bK1J78Y94ezYQAomGsnay03SeFaOYTU6nEGviNk+9jq+afaG7fbeI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=uWDALDUl; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="uWDALDUl"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C3BC1C19421;
	Wed,  8 Apr 2026 18:12:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1775671923;
	bh=oVAjcOHEHrYfCjz1m3+NLxn688oXI0cXYko3sMMzqAA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=uWDALDUlPUeO7HbxfIGUrt85zx4zI39HYvvqAYRL9IAiq2YUOriApKFtnm30SzGSo
	 /zF+6o8kCIEOu7K3ucnHa4jEm+HbU2nnX6x514I2DEm39qb15jNTKkIDgbXDOJlyhU
	 ibtBzXZ4xzVfCy7HpQmdlhTj5HdGIHxrPj6rQbsg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Theodore Tso <tytso@mit.edu>,
	stable@kernel.org
Subject: [PATCH 6.1 119/312] ext4: always drain queued discard work in ext4_mb_release()
Date: Wed,  8 Apr 2026 20:00:36 +0200
Message-ID: <20260408175938.213306110@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260408175933.715315542@linuxfoundation.org>
References: <20260408175933.715315542@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Theodore Ts'o <tytso@mit.edu>

commit 9ee29d20aab228adfb02ca93f87fb53c56c2f3af upstream.

While reviewing recent ext4 patch[1], Sashiko raised the following
concern[2]:

> If the filesystem is initially mounted with the discard option,
> deleting files will populate sbi->s_discard_list and queue
> s_discard_work. If it is then remounted with nodiscard, the
> EXT4_MOUNT_DISCARD flag is cleared, but the pending s_discard_work is
> neither cancelled nor flushed.

[1] https://lore.kernel.org/r/20260319094545.19291-1-qiang.zhang@linux.dev/
[2] https://sashiko.dev/#/patchset/20260319094545.19291-1-qiang.zhang%40linux.dev

The concern was valid, but it had nothing to do with the patch[1].
One of the problems with Sashiko in its current (early) form is that
it will detect pre-existing issues and report it as a problem with the
patch that it is reviewing.

In practice, it would be hard to hit deliberately (unless you are a
malicious syzkaller fuzzer), since it would involve mounting the file
system with -o discard, and then deleting a large number of files,
remounting the file system with -o nodiscard, and then immediately
unmounting the file system before the queued discard work has a change
to drain on its own.

Fix it because it's a real bug, and to avoid Sashiko from raising this
concern when analyzing future patches to mballoc.c.

Signed-off-by: Theodore Ts'o <tytso@mit.edu>
Fixes: 55cdd0af2bc5 ("ext4: get discard out of jbd2 commit kthread contex")
Cc: stable@kernel.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/ext4/mballoc.c |   12 +++++-------
 1 file changed, 5 insertions(+), 7 deletions(-)

--- a/fs/ext4/mballoc.c
+++ b/fs/ext4/mballoc.c
@@ -3591,13 +3591,11 @@ int ext4_mb_release(struct super_block *
 	struct kmem_cache *cachep = get_groupinfo_cache(sb->s_blocksize_bits);
 	int count;
 
-	if (test_opt(sb, DISCARD)) {
-		/*
-		 * wait the discard work to drain all of ext4_free_data
-		 */
-		flush_work(&sbi->s_discard_work);
-		WARN_ON_ONCE(!list_empty(&sbi->s_discard_list));
-	}
+	/*
+	 * wait the discard work to drain all of ext4_free_data
+	 */
+	flush_work(&sbi->s_discard_work);
+	WARN_ON_ONCE(!list_empty(&sbi->s_discard_list));
 
 	if (sbi->s_group_info) {
 		for (i = 0; i < ngroups; i++) {


