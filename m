Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 50846362157;
	Tue, 16 Dec 2025 12:35:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765888549; cv=none; b=R5++lsYTRKQeqaf0QriHsLBKd5VM59b7v9CBKiV4ZEgv6/rOYkcnBlBcmMkSRmI7KE11XfE6di/je0tdPeyKBat3Gdck8aQ4/uzpYJJLru/YZ9Ox6IQ20/fAczed2VBypNyLsyi4HzzNqVKyZp8osrg0Qi8jmKpM7NYHo09PKf8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765888549; c=relaxed/simple;
	bh=WS5Fa3jv2Tn+ZCkdGpfB7ZUTujDsBrylFQojmcJwHW8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=tbFX7DZg03LuguwEHPqD4BK9RGWD6YBZf9ZaKUFRx+JQE/k1D8XAl5u246CHHtswSQ8q+GhyW3m1DFpPqc7Ij2+9GwNxxq9uTrOLcqREsqzaRo8g1FwIhGThRTiSqwrSv24o0Rj6fgWKRhWoldwpLSgw57p/9LGJTIPHd4JAV3g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=G0YiI/Fg; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="G0YiI/Fg"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6EBE1C4CEF1;
	Tue, 16 Dec 2025 12:35:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1765888548;
	bh=WS5Fa3jv2Tn+ZCkdGpfB7ZUTujDsBrylFQojmcJwHW8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=G0YiI/FgIxfNu1P83mzPH+eyp3k/PC6YuaabWuiG/BfSvLY7Pd8ft889Cm6C0rgzI
	 5D9rLRb6Bu5jFq8DwgQh+VzWjxh5+d86Spex+PXyIGe1jGkzN/C2waIdyGO7I/mQ1z
	 rWuIhKPvDbQ2SZnP6Px854nSuhmz3ba9Y/MLzW1E=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Shuhao Fu <sfual@cse.ust.hk>,
	Yuezhang Mo <Yuezhang.Mo@sony.com>,
	Namjae Jeon <linkinjeon@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 524/614] exfat: fix refcount leak in exfat_find
Date: Tue, 16 Dec 2025 12:14:51 +0100
Message-ID: <20251216111420.361657242@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251216111401.280873349@linuxfoundation.org>
References: <20251216111401.280873349@linuxfoundation.org>
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

From: Shuhao Fu <sfual@cse.ust.hk>

[ Upstream commit 9aee8de970f18c2aaaa348e3de86c38e2d956c1d ]

Fix refcount leaks in `exfat_find` related to `exfat_get_dentry_set`.

Function `exfat_get_dentry_set` would increase the reference counter of
`es->bh` on success. Therefore, `exfat_put_dentry_set` must be called
after `exfat_get_dentry_set` to ensure refcount consistency. This patch
relocate two checks to avoid possible leaks.

Fixes: 82ebecdc74ff ("exfat: fix improper check of dentry.stream.valid_size")
Fixes: 13940cef9549 ("exfat: add a check for invalid data size")
Signed-off-by: Shuhao Fu <sfual@cse.ust.hk>
Reviewed-by: Yuezhang Mo <Yuezhang.Mo@sony.com>
Signed-off-by: Namjae Jeon <linkinjeon@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/exfat/namei.c | 20 ++++++++++----------
 1 file changed, 10 insertions(+), 10 deletions(-)

diff --git a/fs/exfat/namei.c b/fs/exfat/namei.c
index 745dce29ddb53..dfe957493d49e 100644
--- a/fs/exfat/namei.c
+++ b/fs/exfat/namei.c
@@ -645,16 +645,6 @@ static int exfat_find(struct inode *dir, const struct qstr *qname,
 	info->valid_size = le64_to_cpu(ep2->dentry.stream.valid_size);
 	info->size = le64_to_cpu(ep2->dentry.stream.size);
 
-	if (info->valid_size < 0) {
-		exfat_fs_error(sb, "data valid size is invalid(%lld)", info->valid_size);
-		return -EIO;
-	}
-
-	if (unlikely(EXFAT_B_TO_CLU_ROUND_UP(info->size, sbi) > sbi->used_clusters)) {
-		exfat_fs_error(sb, "data size is invalid(%lld)", info->size);
-		return -EIO;
-	}
-
 	info->start_clu = le32_to_cpu(ep2->dentry.stream.start_clu);
 	if (!is_valid_cluster(sbi, info->start_clu) && info->size) {
 		exfat_warn(sb, "start_clu is invalid cluster(0x%x)",
@@ -692,6 +682,16 @@ static int exfat_find(struct inode *dir, const struct qstr *qname,
 			     0);
 	exfat_put_dentry_set(&es, false);
 
+	if (info->valid_size < 0) {
+		exfat_fs_error(sb, "data valid size is invalid(%lld)", info->valid_size);
+		return -EIO;
+	}
+
+	if (unlikely(EXFAT_B_TO_CLU_ROUND_UP(info->size, sbi) > sbi->used_clusters)) {
+		exfat_fs_error(sb, "data size is invalid(%lld)", info->size);
+		return -EIO;
+	}
+
 	if (ei->start_clu == EXFAT_FREE_CLUSTER) {
 		exfat_fs_error(sb,
 			       "non-zero size file starts with zero cluster (size : %llu, p_dir : %u, entry : 0x%08x)",
-- 
2.51.0



