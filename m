Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8F5F113B2B4;
	Tue, 27 Feb 2024 14:10:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709043008; cv=none; b=Nu6tn8UTWW2oOk2Ndi6Jro+671klRaCpoZnYrsvFlRo9sadpieUiMcssHsx48TsA8t2QzDODDPAJObtiFDNOFnrOW+ya2lvD5uasdq6Hvrqs1FP5NfE/ojau+nnxi7Z1lwFYhqxhCGX5CCkNufntBnlA3DlKzCIZZGT/uJbAJ6A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709043008; c=relaxed/simple;
	bh=JOmvtWeFtiob4IvJtJmGGA3DvCLF4cgQdLEd+4Yy8Zw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=T/ttAvxMiOIRhdaFhi9cvJ0n2w2ON+Nz+2mViQCA7xsn0y+BP6TcIOw5GYGJh8dkDC2FvhYQnLLRWqXEthkYnSW1e0IJEFMubTsreEQog8pmgwGz7dqvZYSAKmF0oxYRuyDsVMaiGoV3lzS0uVfxPWgZ2ktwAd6c9xkarG+yXTA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=TdbURsSO; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="TdbURsSO"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 14AC8C433F1;
	Tue, 27 Feb 2024 14:10:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1709043008;
	bh=JOmvtWeFtiob4IvJtJmGGA3DvCLF4cgQdLEd+4Yy8Zw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=TdbURsSOvjRlZYcRRKP3jehuJBcM05THECX9mjowtEbwGsVvMtmxcv0RrBfkMc4D0
	 wgKuPtaFFFcFlOoZOx+fYZ6ufsl0YxlciznZliialfTWty/axiwZ/W5Oaa/iUmVYGK
	 m4HgWl5hbMcmjSgH1GHq1ZomU6vyXEPYCVh8Iip0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yuezhang Mo <Yuezhang.Mo@sony.com>,
	Andy Wu <Andy.Wu@sony.com>,
	Aoyama Wataru <wataru.aoyama@sony.com>,
	Sungjong Seo <sj1557.seo@samsung.com>,
	Namjae Jeon <linkinjeon@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 183/245] exfat: support dynamic allocate bh for exfat_entry_set_cache
Date: Tue, 27 Feb 2024 14:26:11 +0100
Message-ID: <20240227131621.154581307@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240227131615.098467438@linuxfoundation.org>
References: <20240227131615.098467438@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Yuezhang Mo <Yuezhang.Mo@sony.com>

[ Upstream commit a3ff29a95fde16906304455aa8c0bd84eb770258 ]

In special cases, a file or a directory may occupied more than 19
directory entries, pre-allocating 3 bh is not enough. Such as
  - Support vendor secondary directory entry in the future.
  - Since file directory entry is damaged, the SecondaryCount
    field is bigger than 18.

So this commit supports dynamic allocation of bh.

Signed-off-by: Yuezhang Mo <Yuezhang.Mo@sony.com>
Reviewed-by: Andy Wu <Andy.Wu@sony.com>
Reviewed-by: Aoyama Wataru <wataru.aoyama@sony.com>
Reviewed-by: Sungjong Seo <sj1557.seo@samsung.com>
Signed-off-by: Namjae Jeon <linkinjeon@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/exfat/dir.c      | 15 +++++++++++++++
 fs/exfat/exfat_fs.h |  5 ++++-
 2 files changed, 19 insertions(+), 1 deletion(-)

diff --git a/fs/exfat/dir.c b/fs/exfat/dir.c
index f6dd4fc8eaf45..be7570d01ae1a 100644
--- a/fs/exfat/dir.c
+++ b/fs/exfat/dir.c
@@ -618,6 +618,10 @@ int exfat_free_dentry_set(struct exfat_entry_set_cache *es, int sync)
 			bforget(es->bh[i]);
 		else
 			brelse(es->bh[i]);
+
+	if (IS_DYNAMIC_ES(es))
+		kfree(es->bh);
+
 	kfree(es);
 	return err;
 }
@@ -853,6 +857,7 @@ struct exfat_entry_set_cache *exfat_get_dentry_set(struct super_block *sb,
 	/* byte offset in sector */
 	off = EXFAT_BLK_OFFSET(byte_offset, sb);
 	es->start_off = off;
+	es->bh = es->__bh;
 
 	/* sector offset in cluster */
 	sec = EXFAT_B_TO_BLK(byte_offset, sb);
@@ -872,6 +877,16 @@ struct exfat_entry_set_cache *exfat_get_dentry_set(struct super_block *sb,
 	es->num_entries = num_entries;
 
 	num_bh = EXFAT_B_TO_BLK_ROUND_UP(off + num_entries * DENTRY_SIZE, sb);
+	if (num_bh > ARRAY_SIZE(es->__bh)) {
+		es->bh = kmalloc_array(num_bh, sizeof(*es->bh), GFP_KERNEL);
+		if (!es->bh) {
+			brelse(bh);
+			kfree(es);
+			return NULL;
+		}
+		es->bh[0] = bh;
+	}
+
 	for (i = 1; i < num_bh; i++) {
 		/* get the next sector */
 		if (exfat_is_last_sector_in_cluster(sbi, sec)) {
diff --git a/fs/exfat/exfat_fs.h b/fs/exfat/exfat_fs.h
index db538709dafa0..58816ee3162c4 100644
--- a/fs/exfat/exfat_fs.h
+++ b/fs/exfat/exfat_fs.h
@@ -170,10 +170,13 @@ struct exfat_entry_set_cache {
 	bool modified;
 	unsigned int start_off;
 	int num_bh;
-	struct buffer_head *bh[DIR_CACHE_SIZE];
+	struct buffer_head *__bh[DIR_CACHE_SIZE];
+	struct buffer_head **bh;
 	unsigned int num_entries;
 };
 
+#define IS_DYNAMIC_ES(es)	((es)->__bh != (es)->bh)
+
 struct exfat_dir_entry {
 	struct exfat_chain dir;
 	int entry;
-- 
2.43.0



