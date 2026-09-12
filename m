Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 17F2F372EF0;
	Sat, 12 Sep 2026 11:55:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789214160; cv=none; b=F4lXdf3aWDpijfZWEsOHRSXtDcOYw++yIAzuvbGmPViseD93pjhgHlOU4b3rK3ciAxs9o2W7WDT8YuMkRF9PcaEPO5eJHWij+1seCEZbjfQ/PjdNd5ydS21B+z8V9X06MaOhcY4YKSRbErNUVYcfBYsdao+++eyjbxrLxsU/9nQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789214160; c=relaxed/simple;
	bh=xdZzYmzCqTcQFfiwEwM0JyLDf3CN1huLRnzsbdpp9XA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ZrWO5/WolxmZ8TPZFTUwfWHHFNZo1f4LYgMm+hRNM7jHbr/zUcs1Mr9P3UDSOjkvVVYjVx0S0UXKuV970QoFVDMKT5xnMIMLIbOyyYLZB8j0ztaPf+WygY3iHebjwwlrVW6rUCKIp2A5Wmo41zzdND2wmY/SlXDS8dViZnmUkoM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=QKCfdTSi; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="QKCfdTSi"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8DC9B1F000FF;
	Sat, 12 Sep 2026 11:55:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789214158;
	bh=/ahg7QgU3kPjbJTiXs6s8Zz4j5s4L2ijIs5SItRL4RI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=QKCfdTSiOLdFBXKz71JGXRK1CLCJDWogSETRumW6OmmmxhlSIcytnTwR0qeD3N4h0
	 Y1koPUis+xen9qOK2ATFMoEEz3YxPKaWUnR92k8v43+1925SH0Gw0f4yU/aLCJetxg
	 kMINOH0rMiWBQ06kPBxkN2PX8FTJ4+wHc1nXNgRk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	stable@kernel.org,
	Wenjie Qi <qiwenjie@xiaomi.com>,
	Chao Yu <chao@kernel.org>,
	Jaegeuk Kim <jaegeuk@kernel.org>
Subject: [PATCH 6.12 0252/1376] f2fs: avoid NULL checkpoint thread access in sysfs
Date: Sat, 12 Sep 2026 08:44:38 +0200
Message-ID: <20260912065613.157418526@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065607.535295758@linuxfoundation.org>
References: <20260912065607.535295758@linuxfoundation.org>
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

From: Wenjie Qi <qwjhust@gmail.com>

commit 5cb33b00c8fbb6e8f1fa3d281c3036d5f7c7c41f upstream.

checkpoint_merge can be enabled even when no checkpoint merge thread is
running. A read-only mount is one case: f2fs does not start
f2fs_issue_ckpt there, but ckpt_thread_ioprio is still writable through
sysfs.

The ckpt_thread_ioprio store path updates the saved ioprio value and,
when checkpoint_merge is enabled, calls set_task_ioprio() for the
checkpoint thread. If cprc->f2fs_issue_ckpt is NULL, that dereferences a
NULL task pointer.

Protect ckpt_thread_ioprio sysfs writes with s_umount as well, so the
checkpoint thread cannot disappear under the store path while updating
its ioprio.

Fixes: e65920661708 ("f2fs: add ckpt_thread_ioprio sysfs node")
Cc: stable@kernel.org
Signed-off-by: Wenjie Qi <qiwenjie@xiaomi.com>
Reviewed-by: Chao Yu <chao@kernel.org>
Signed-off-by: Jaegeuk Kim <jaegeuk@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/f2fs/sysfs.c |    7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

--- a/fs/f2fs/sysfs.c
+++ b/fs/f2fs/sysfs.c
@@ -528,7 +528,7 @@ out:
 			return -EINVAL;
 
 		cprc->ckpt_thread_ioprio = IOPRIO_PRIO_VALUE(class, level);
-		if (test_opt(sbi, MERGE_CHECKPOINT)) {
+		if (cprc->f2fs_issue_ckpt) {
 			ret = set_task_ioprio(cprc->f2fs_issue_ckpt,
 					cprc->ckpt_thread_ioprio);
 			if (ret)
@@ -924,13 +924,14 @@ static ssize_t f2fs_sbi_store(struct f2f
 	ssize_t ret;
 	bool gc_entry = (!strcmp(a->attr.name, "gc_urgent") ||
 					a->struct_type == GC_THREAD);
+	bool thread_entry = !strcmp(a->attr.name, "ckpt_thread_ioprio");
 
-	if (gc_entry) {
+	if (gc_entry || thread_entry) {
 		if (!down_read_trylock(&sbi->sb->s_umount))
 			return -EAGAIN;
 	}
 	ret = __sbi_store(a, sbi, buf, count);
-	if (gc_entry)
+	if (gc_entry || thread_entry)
 		up_read(&sbi->sb->s_umount);
 
 	return ret;


