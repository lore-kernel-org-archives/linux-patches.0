Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 109EA53D0B8;
	Wed,  9 Sep 2026 13:50:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788961849; cv=none; b=rF6/i5T+hzSqlXjlDb1I+kBm7wn5VKVlrJnWrfUbDqtLzPvsEeBPaLv3V9iLRSSVcj1HKoaPZ1raGF6USknMF+UNVhrwzIPlKRx3HZD11wU/pX+I9Bjv6k83oMjF23opEg8MlcMJdyVZCDu80mOY45o2R25Wht+2ErGYAo0o+jo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788961849; c=relaxed/simple;
	bh=RtJnzXluNfjV38lkzDSjv1ZxZFHKIH2I7/8WvVk2KFg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=NqupGWqYwEHnoKgl6aDWsJ/SHauzjAW1x7u0kW6I/jG8swt8t90tHP3PyGS5kqe9+HBV0qVB/9UMIqBZcAwofoMfnlQwDLyo6GyBBVR7SK3RehXeQ+8Xjlg52TTSPVh6H5LmC/7u+MHf6fb7tMXYXa3tQnXC79iqzUdJ/xozKgY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=HMz/OEMr; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="HMz/OEMr"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6BD5B1F00A3A;
	Wed,  9 Sep 2026 13:50:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1788961848;
	bh=arKeYTa987ywvGqcY2S6UfZ0X2PcnZvqA3MB9P9Z+Hc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=HMz/OEMrKzDWU5Gb+382bcbkbzwbG+HBRgn+VL32EEy1bYrzxWqeMyWOBpuVS65hn
	 7oivw/P6yc3uBOjEL5jDvsI3dJ/Y5dUuEddGvXKqPxEdo82E4aR1nfqefhAud+QQp3
	 fFjHM+vFqbJkeZnn72qXiC/8018DQLLjFaYlmVC4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	SJ Park <sj@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH 7.2 088/556] mm/damon/sysfs: kobject_del() region and target (error) dirs
Date: Wed,  9 Sep 2026 15:36:08 +0200
Message-ID: <20260909134233.601201139@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260909134230.441546314@linuxfoundation.org>
References: <20260909134230.441546314@linuxfoundation.org>
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

7.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: SJ Park <sj@kernel.org>

commit 2603ef6f6ec3d3f7de2d6a07e7c9a683cebac419 upstream.

On CONFIG_DEBUG_KOBJECT_RELEASE enabled kernel, lack of kobject_del()
could cause directories creation failures due to the name conflicts.  Fix
those issues for the normal creation path of region directories and the
error path of target directories, by adding kobject_del() calls.

Link: https://lore.kernel.org/20260628220121.97360-3-sj@kernel.org
Fixes: 2031b14ea757 ("mm/damon/sysfs: support the physical address space monitoring")
Signed-off-by: SJ Park <sj@kernel.org>
Cc: <stable@vger.kernel.org> # 5.18.x
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 mm/damon/sysfs.c |    8 ++++++--
 1 file changed, 6 insertions(+), 2 deletions(-)

--- a/mm/damon/sysfs.c
+++ b/mm/damon/sysfs.c
@@ -105,8 +105,10 @@ static void damon_sysfs_regions_rm_dirs(
 	struct damon_sysfs_region **regions_arr = regions->regions_arr;
 	int i;
 
-	for (i = 0; i < regions->nr; i++)
+	for (i = 0; i < regions->nr; i++) {
+		kobject_del(&regions_arr[i]->kobj);
 		kobject_put(&regions_arr[i]->kobj);
+	}
 	regions->nr = 0;
 	kfree(regions_arr);
 	regions->regions_arr = NULL;
@@ -369,13 +371,15 @@ static int damon_sysfs_targets_add_dirs(
 
 		err = damon_sysfs_target_add_dirs(target);
 		if (err)
-			goto out;
+			goto del_out;
 
 		targets_arr[i] = target;
 		targets->nr++;
 	}
 	return 0;
 
+del_out:
+	kobject_del(&target->kobj);
 out:
 	damon_sysfs_targets_rm_dirs(targets);
 	kobject_put(&target->kobj);


