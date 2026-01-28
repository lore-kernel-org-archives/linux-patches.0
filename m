Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B4D3527BF79;
	Wed, 28 Jan 2026 15:50:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769615421; cv=none; b=eUKB5ulr5Vy/xOHP4J5VmX/HoPAd7El5SGj1d6r4Jg7bkrJbD0kJaCbuKRBnbfiJ8uGQaRc9AmMvl9iHH9sk1c3lOKdr1hKEgRyMo1NLd9iFW7x0PBa6D3ZihPJBbJw4dPF4ttM+EJ7tvx+EncjtvlBDDsHfV1/iWkOkeGBAz4E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769615421; c=relaxed/simple;
	bh=j6UL9SpPOOFPhW2IRF57UbjZbZ8AuWDqlp63tjh1wgE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=YilgmRVLE+3Ax926nWUGPXx78s2ft1zg7EPoIVIDLpRSnZVwyHrUB19/eVTEU6/tlFNbqHCYdHRPJAhxanq0kC47FkKApJVMMVBXKhKEfaQk0DekYHSICBhgpo+81a5lXGUUlPONXLiJpGkhajhlpXtLpK/ZdURzEwngxtDEM2I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=QvUPAYhh; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="QvUPAYhh"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BBB2EC4CEF1;
	Wed, 28 Jan 2026 15:50:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1769615421;
	bh=j6UL9SpPOOFPhW2IRF57UbjZbZ8AuWDqlp63tjh1wgE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=QvUPAYhh4ERSiQf0huPsZmNR44pDHoM6EtQK8BikKlh+AnHjZpisAwCMc23HWAl3V
	 FYZrov2olJfp76tPYbedTYkqPpfEkrHiBJ4+Iriw5NmwSH4CQG3dzfp1An7QaFY9w3
	 YyGjKplL7duhYQFE8dTGPQK08ZAEicNHrZ3eHmeI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Shuhao Fu <sfual@cse.ust.hk>,
	Yuezhang Mo <Yuezhang.Mo@sony.com>,
	Namjae Jeon <linkinjeon@kernel.org>,
	Li hongliang <1468888505@139.com>
Subject: [PATCH 6.12 156/169] exfat: fix refcount leak in exfat_find
Date: Wed, 28 Jan 2026 16:23:59 +0100
Message-ID: <20260128145339.625928886@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260128145334.006287341@linuxfoundation.org>
References: <20260128145334.006287341@linuxfoundation.org>
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
Signed-off-by: Li hongliang <1468888505@139.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/exfat/namei.c |   20 ++++++++++----------
 1 file changed, 10 insertions(+), 10 deletions(-)

--- a/fs/exfat/namei.c
+++ b/fs/exfat/namei.c
@@ -638,16 +638,6 @@ static int exfat_find(struct inode *dir,
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
@@ -685,6 +675,16 @@ static int exfat_find(struct inode *dir,
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


