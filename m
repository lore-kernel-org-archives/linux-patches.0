Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D0FCE3B9D9F;
	Sat, 17 Oct 2026 17:57:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792259853; cv=none; b=ZPWkDv+NX6Ks7KMbzfv9CU1NOfGY9LCCm+bY+K2/DM0FFK8EnYudV+INUVq4klsum/yZdjG42FDf80qwF8t1gCwITWfRJKuUZ3463b9juT761W05vNZPSZBjd78aqlQTJHKt23PSHFtRMzFQ3amDSzM/JGh72vHWRVFe9AEQ3BE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792259853; c=relaxed/simple;
	bh=9F7KG0qUcDaSbZ+2p9LVoqqaAJLZOVI11G+uXUBIZOU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=C4EVhO5tnX1Umh/4L8EMfUv4ZTyAPEGijVHaM3qnoNAVJn52+G08ZhTaw6udXaiDTIpooJcje1lOXeOyBETkmV4W2sssQoSSZRfaG8aZDmqMm9yNykibQEg94CeVu3mqdTFYjQ5MzXLYaGVcJXzcmO7EJ2kRlNixWLv3OUuLmFQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=k7fr9dd4; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="k7fr9dd4"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2F6161F000C4;
	Sat, 17 Oct 2026 17:57:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1792259852;
	bh=aW/FmOJEav7w/GNTJjayubFdN1KCEQLgA7uxgZL+RYk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=k7fr9dd4ncEB+YZWAkBExG66rD8IjbClRqWrlCAt97MXYoSHcUde7LOtf0/pgorY9
	 oA7+i88rsdOwJDpWKn3WjlQnxJHfagTjr28usUvZk98zosxSoYfiD6Qu1v5sk67oeF
	 /DvFHrBX5WFKk1XAzTFBFLQYE0sBvIcq5l48qXPk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	stable@kernel.org,
	Wenjie Qi <qiwenjie@xiaomi.com>,
	Chao Yu <chao@kernel.org>,
	Jaegeuk Kim <jaegeuk@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 1351/1674] f2fs: avoid NULL checkpoint thread access in sysfs
Date: Sat, 17 Oct 2026 18:00:23 +0200
Message-ID: <20261017160505.839987284@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261017160431.119607952@linuxfoundation.org>
References: <20261017160431.119607952@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Wenjie Qi <qwjhust@gmail.com>

[ Upstream commit 5cb33b00c8fbb6e8f1fa3d281c3036d5f7c7c41f ]

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
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/f2fs/sysfs.c | 7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

diff --git a/fs/f2fs/sysfs.c b/fs/f2fs/sysfs.c
index f47b745d3c390..694bca245a52f 100644
--- a/fs/f2fs/sysfs.c
+++ b/fs/f2fs/sysfs.c
@@ -488,7 +488,7 @@ static ssize_t __sbi_store(struct f2fs_attr *a,
 			return -EINVAL;
 
 		cprc->ckpt_thread_ioprio = IOPRIO_PRIO_VALUE(class, level);
-		if (test_opt(sbi, MERGE_CHECKPOINT)) {
+		if (cprc->f2fs_issue_ckpt) {
 			ret = set_task_ioprio(cprc->f2fs_issue_ckpt,
 					cprc->ckpt_thread_ioprio);
 			if (ret)
@@ -799,13 +799,14 @@ static ssize_t f2fs_sbi_store(struct f2fs_attr *a,
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
-- 
2.53.0



