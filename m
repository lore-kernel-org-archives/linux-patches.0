Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4B25834EEF1;
	Tue, 16 Dec 2025 11:46:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765885616; cv=none; b=oILNp9gKjpmIZZmx2oRUBvwhN55keHNmifnS+zgiwIqYsuH7irvvRfNqPiwwg2NtK6aO9YTvtct/4DMEaLuTfOHmkJqv0lio+B8wQ4kOQn6lK6YWabVD94C+IZVBs13NUIl/El4U+5QgGUtuqpBLUeg7bjD5vcch/68ypCHEoBw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765885616; c=relaxed/simple;
	bh=JlhFRIPA1BiOhAsDEjGSpu8pgBpCz7S2/gz3ciVeEsc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=RvHUmpxTZSEG296QuXqF/7GdZCLSirHk8xCWPla4BusSXMf17X/RCJn3lKlpRHvtDRqGiCxGbNDnn1UABgyiJO8Br56XFRVbF7RqFLojXoFQAE2UPr3mtl2qsWQnldemxnQZnVYFJMEz4x0lJNQzFdhRG+HO7Ri0WadY+qsg1b0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=g3alAx0U; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="g3alAx0U"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A7DEDC4CEF1;
	Tue, 16 Dec 2025 11:46:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1765885616;
	bh=JlhFRIPA1BiOhAsDEjGSpu8pgBpCz7S2/gz3ciVeEsc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=g3alAx0UVkJAx/i/7SDgKO1TLBWuygHcbYXlyvr5Bun3LF47iI8kENpBHocomWpM6
	 AVuIQVQMpUJxoYkbXQ1fzusukPhDozPUOBQLgqwI/rYYxL4T/BENGFxmGV4Aarv2VI
	 kdhyQ2FGDjAycfadsE9ULoZzlPRsfTJPeptvMP1o=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Xiao Ni <xni@redhat.com>,
	Yu Kuai <yukuai@fnnas.com>,
	Li Nan <linan122@huawei.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.17 192/507] md: avoid repeated calls to del_gendisk
Date: Tue, 16 Dec 2025 12:10:33 +0100
Message-ID: <20251216111352.467532936@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251216111345.522190956@linuxfoundation.org>
References: <20251216111345.522190956@linuxfoundation.org>
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

6.17-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Xiao Ni <xni@redhat.com>

[ Upstream commit 90e3bb44c0a86e245d8e5c6520206fa113acb1ee ]

There is a uaf problem which is found by case 23rdev-lifetime:

Oops: general protection fault, probably for non-canonical address 0xdead000000000122
RIP: 0010:bdi_unregister+0x4b/0x170
Call Trace:
 <TASK>
 __del_gendisk+0x356/0x3e0
 mddev_unlock+0x351/0x360
 rdev_attr_store+0x217/0x280
 kernfs_fop_write_iter+0x14a/0x210
 vfs_write+0x29e/0x550
 ksys_write+0x74/0xf0
 do_syscall_64+0xbb/0x380
 entry_SYSCALL_64_after_hwframe+0x77/0x7f
RIP: 0033:0x7ff5250a177e

The sequence is:
1. rdev remove path gets reconfig_mutex
2. rdev remove path release reconfig_mutex in mddev_unlock
3. md stop calls do_md_stop and sets MD_DELETED
4. rdev remove path calls del_gendisk because MD_DELETED is set
5. md stop path release reconfig_mutex and calls del_gendisk again

So there is a race condition we should resolve. This patch adds a
flag MD_DO_DELETE to avoid the race condition.

Link: https://lore.kernel.org/linux-raid/20251029063419.21700-1-xni@redhat.com
Fixes: 9e59d609763f ("md: call del_gendisk in control path")
Signed-off-by: Xiao Ni <xni@redhat.com>
Suggested-by: Yu Kuai <yukuai@fnnas.com>
Reviewed-by: Li Nan <linan122@huawei.com>
Signed-off-by: Yu Kuai <yukuai@fnnas.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/md/md.c | 3 ++-
 drivers/md/md.h | 1 +
 2 files changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/md/md.c b/drivers/md/md.c
index 436aab6c5d3de..209ca3eade260 100644
--- a/drivers/md/md.c
+++ b/drivers/md/md.c
@@ -887,7 +887,8 @@ void mddev_unlock(struct mddev *mddev)
 		 * do_md_stop. dm raid only uses md_stop to stop. So dm raid
 		 * doesn't need to check MD_DELETED when getting reconfig lock
 		 */
-		if (test_bit(MD_DELETED, &mddev->flags)) {
+		if (test_bit(MD_DELETED, &mddev->flags) &&
+		    !test_and_set_bit(MD_DO_DELETE, &mddev->flags)) {
 			kobject_del(&mddev->kobj);
 			del_gendisk(mddev->gendisk);
 		}
diff --git a/drivers/md/md.h b/drivers/md/md.h
index c989cc9f6216b..0a1a227f106b0 100644
--- a/drivers/md/md.h
+++ b/drivers/md/md.h
@@ -353,6 +353,7 @@ enum mddev_flags {
 	MD_HAS_MULTIPLE_PPLS,
 	MD_NOT_READY,
 	MD_BROKEN,
+	MD_DO_DELETE,
 	MD_DELETED,
 };
 
-- 
2.51.0



