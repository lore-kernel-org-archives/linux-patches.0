Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2DD0E43D504;
	Tue, 16 Jun 2026 15:33:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781624016; cv=none; b=G1CyJx/U/2Rp/xIcmTTUI7ERNO7E7/RH6MFEQH/9vuGOAtPB2gB6rhCMc/dHlxSvPJRiY+jDKOyeU0Cl17/L4WmTBCs+Q7/8kGr90yWd+mLSFg/qdctavJn1VZih+SxcLod86dd/zIC5bNU8yCeHRiMie8eBjWnW98ypYZt2J+4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781624016; c=relaxed/simple;
	bh=TvQ/QicmEAs+L0a+73HIAn5quPm55lXV/VI+KLacyjs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=oYtM9CSGok2+20Rxt+XU30rSu1TXgCdQI3RkpwdMQ4pEnFNFv0xCn8SMa+5mT8UxkGiBcfk/xgw2ZFb6C87y10MTo4AVpNIyVk0JM+TiT/Yf788t1XknxjNCKkexSc6POgEtGPd+T1EKJRUrBH7Gd+KYE1ut7reGZ+VbzHSgU+A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=iBZIHqUQ; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="iBZIHqUQ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3274C1F000E9;
	Tue, 16 Jun 2026 15:33:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1781624015;
	bh=OAD5X9RJ1JUR9alzQhEtZVXc20L3edwaDqIeaewCNec=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=iBZIHqUQkKKvqo5MMXIvB+0ZGMaBSnyz6n5nKEBu9cdhu875botOCEFHZ9lyCjF6R
	 mZzd3kwwEkLoQ7hLDkcnAD+J/FwORLoCvUNQiY/WMVJbSAhhCURj5Adn7+xN1358df
	 rRTSeQ92/8kEtJYAM2JUjg3qH/Yby8wg7F6djL4I=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	syzbot+a16fb0cce329a320661c@syzkaller.appspotmail.com,
	Nirmoy Das <nirmoyd@nvidia.com>,
	Christian Brauner <brauner@kernel.org>
Subject: [PATCH 7.0 256/378] ovl: keep err zero after successful ovl_cache_get()
Date: Tue, 16 Jun 2026 20:28:07 +0530
Message-ID: <20260616145123.606918881@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260616145109.744539446@linuxfoundation.org>
References: <20260616145109.744539446@linuxfoundation.org>
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

7.0-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Nirmoy Das <nirmoyd@nvidia.com>

commit 1711b6ed6953cee5940ca4c3a6e77f1b3798cee2 upstream.

ovl_iterate_merged() stores PTR_ERR(cache) in err before checking
IS_ERR(cache). On success err holds the truncated cache pointer and
can be returned as a bogus non-zero error.

The syzbot reproducer reaches this through overlay-on-overlay readdir:

  getdents64
    iterate_dir(outer overlay file)
      ovl_iterate_merged()
        ovl_cache_get()
          ovl_dir_read_merged()
            ovl_dir_read()
              iterate_dir(inner overlay file)
                ovl_iterate_merged()

Only compute PTR_ERR(cache) on the error path.

Fixes: d25e4b739f83 ("ovl: refactor ovl_iterate() and port to cred guard")
Reported-by: syzbot+a16fb0cce329a320661c@syzkaller.appspotmail.com
Closes: https://syzkaller.appspot.com/bug?extid=a16fb0cce329a320661c
Cc: stable@vger.kernel.org
Signed-off-by: Nirmoy Das <nirmoyd@nvidia.com>
Link: https://patch.msgid.link/20260514144258.3068715-1-nirmoyd@nvidia.com
Signed-off-by: Christian Brauner <brauner@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/overlayfs/readdir.c |    7 +++----
 1 file changed, 3 insertions(+), 4 deletions(-)

--- a/fs/overlayfs/readdir.c
+++ b/fs/overlayfs/readdir.c
@@ -838,15 +838,14 @@ static int ovl_iterate_merged(struct fil
 	struct ovl_dir_file *od = file->private_data;
 	struct dentry *dentry = file->f_path.dentry;
 	struct ovl_cache_entry *p;
-	int err = 0;
+	int err;
 
 	if (!od->cache) {
 		struct ovl_dir_cache *cache;
 
 		cache = ovl_cache_get(dentry);
-		err = PTR_ERR(cache);
 		if (IS_ERR(cache))
-			return err;
+			return PTR_ERR(cache);
 
 		od->cache = cache;
 		ovl_seek_cursor(od, ctx->pos);
@@ -869,7 +868,7 @@ static int ovl_iterate_merged(struct fil
 		od->cursor = p->l_node.next;
 		ctx->pos++;
 	}
-	return err;
+	return 0;
 }
 
 static bool ovl_need_adjust_d_ino(struct file *file)


