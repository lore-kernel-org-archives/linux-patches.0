Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C5A581F8910;
	Tue, 17 Dec 2024 17:16:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734455763; cv=none; b=NwLtPjZwRvCCuc3q6Goh/GJKfP+TRFbIsO6nJOPuOpAKTjoTojkU/CSzXTxqH651oOEhwYUeahIo49RF1UizowQMhrInkraSHOpTjpDh6f3ch0GLIA/Or2vcc4adGkQ/JQGTYJ0giR/ZPfO9zKEOL0IoRrKBnT1h8mWso8ADPJo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734455763; c=relaxed/simple;
	bh=dFwKb1vGBgaE1gLoI1mSMojUnB64viBLEFEy1IKtHOA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=l069LwWVtplvEHSEvv75AgjW3CJ7RMT3iGQis+zTrq3Yp5jNjsWHC3jpHg2zw4g3C2uSas5jFNj7B8fcDj2ZhDee7N22zW5RTNMx+FJVjlW9Y1Jxd75zL6jDeufnexJOwu/U7Bish9UmiIfMcYTiR8Cg/Vbf0HrHgv6AhC4IDfc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=nZKbE8ep; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="nZKbE8ep"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4B9CBC4CED3;
	Tue, 17 Dec 2024 17:16:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1734455763;
	bh=dFwKb1vGBgaE1gLoI1mSMojUnB64viBLEFEy1IKtHOA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=nZKbE8ep5JWjNI+Bdgl+PehWH7wkWR3EA4pTKrzNwfIgURopEfRaqu2FnETrteZrV
	 ShqLn0f6WEUytbmjxNkFMfIGsmzDOj729mVv10Bo+QWJDHXCZS/vG4WSUl6vPqi2R1
	 aPhKAghx/5ywxuC3efzj7av6tfnav01VTunwPF4A=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yuezhang Mo <Yuezhang.Mo@sony.com>,
	Andy Wu <Andy.Wu@sony.com>,
	Aoyama Wataru <wataru.aoyama@sony.com>,
	Sungjong Seo <sj1557.seo@samsung.com>,
	Namjae Jeon <linkinjeon@kernel.org>,
	Harshit Mogalapalli <harshit.m.mogalapalli@oracle.com>
Subject: [PATCH 6.1 25/76] exfat: support dynamic allocate bh for exfat_entry_set_cache
Date: Tue, 17 Dec 2024 18:07:05 +0100
Message-ID: <20241217170527.306930790@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241217170526.232803729@linuxfoundation.org>
References: <20241217170526.232803729@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Yuezhang Mo <Yuezhang.Mo@sony.com>

commit a3ff29a95fde16906304455aa8c0bd84eb770258 upstream.

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
Signed-off-by: Harshit Mogalapalli <harshit.m.mogalapalli@oracle.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/exfat/dir.c      |   15 +++++++++++++++
 fs/exfat/exfat_fs.h |    5 ++++-
 2 files changed, 19 insertions(+), 1 deletion(-)

--- a/fs/exfat/dir.c
+++ b/fs/exfat/dir.c
@@ -613,6 +613,10 @@ int exfat_free_dentry_set(struct exfat_e
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
@@ -845,6 +849,7 @@ struct exfat_entry_set_cache *exfat_get_
 	/* byte offset in sector */
 	off = EXFAT_BLK_OFFSET(byte_offset, sb);
 	es->start_off = off;
+	es->bh = es->__bh;
 
 	/* sector offset in cluster */
 	sec = EXFAT_B_TO_BLK(byte_offset, sb);
@@ -864,6 +869,16 @@ struct exfat_entry_set_cache *exfat_get_
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
--- a/fs/exfat/exfat_fs.h
+++ b/fs/exfat/exfat_fs.h
@@ -169,10 +169,13 @@ struct exfat_entry_set_cache {
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


