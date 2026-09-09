Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A22A25867E7;
	Wed,  9 Sep 2026 14:32:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788964351; cv=none; b=rMwmzmApbWxrfvyBJbAXCnjUWt+UzOnHF1tLNg+mPsZ56a5wIhJ5enk9XTy90Wvdq+V7Xit12xgvxdUjta4GRDq1c/6/CLUJyaBsKS5dnIbMG5DQzW55CTbJUxEjs6sGyojLsrQ79N8h62DayURkqtrDcpYwhZ4fsDJU7ZhsE1k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788964351; c=relaxed/simple;
	bh=CzhpwP+cPTrUFk+NrSOkjNxLkm0DKiPllA0plcbjnMQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=dKYlR0MjQXvFou7R9vfWXkCWMYZYjYtcBR7zJZMQTwezDiO9FY7VLAYYr4QXvf5izpg1Eh/HTnSFo2Pnqhk5/M9U/M98/unsWzhWL7ELm8Bibt+bzBPUPRemWhgcNrgRj37KNkTfh0rP936xRKwlmaUaAAQEz/JM9hafTzYiqUc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=AnKGiFY0; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="AnKGiFY0"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C80891F00A3A;
	Wed,  9 Sep 2026 14:32:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1788964350;
	bh=9O5Bf3pKpgBvM4oM2eGHOCCYvzRwer42IiJ09V16ZvY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=AnKGiFY0uGUS2i2He02Q6Cw+PZH01CY6gy9Im7wSZvl8gNo4CZHFCJhEGYDmKf8Bq
	 lCG2tw1SSW06zMn302hK8yvhBpo7LOXAvfJLKme339CR7711LHOTh7TukKehcRJ+P8
	 TCAO5qpmc5QemnDVkejMI2FTtKYXnfiufo85xY+g=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	stable@kernel.org,
	Wenjie Qi <qiwenjie@xiaomi.com>,
	Chao Yu <chao@kernel.org>,
	Jaegeuk Kim <jaegeuk@kernel.org>
Subject: [PATCH 6.18 360/583] f2fs: avoid NULL checkpoint thread access in sysfs
Date: Wed,  9 Sep 2026 15:40:45 +0200
Message-ID: <20260909134250.470776540@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260909134237.773280130@linuxfoundation.org>
References: <20260909134237.773280130@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

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
@@ -547,7 +547,7 @@ out:
 			return -EINVAL;
 
 		cprc->ckpt_thread_ioprio = IOPRIO_PRIO_VALUE(class, level);
-		if (test_opt(sbi, MERGE_CHECKPOINT)) {
+		if (cprc->f2fs_issue_ckpt) {
 			ret = set_task_ioprio(cprc->f2fs_issue_ckpt,
 					cprc->ckpt_thread_ioprio);
 			if (ret)
@@ -962,13 +962,14 @@ static ssize_t f2fs_sbi_store(struct f2f
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


