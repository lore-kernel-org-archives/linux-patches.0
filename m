Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BDCD41494DB;
	Thu,  5 Sep 2024 10:05:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725530705; cv=none; b=L1oRQeEdt+sL67aHu8wNIzRfCtYN3uUVAcLKEecl80IJPNbpfnKwzTXuMivRoVt4/pLpn62cyxPKIn+IahI0ffQvQUO7B1dyrZg4KZiM/mZCWPGqQSpZuO4CqGVVEz4Z3QscFRx9/3Vs2WmplkCk1s7AXk2O4bk3dyoDzE6kqSk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725530705; c=relaxed/simple;
	bh=0tngQQ9fEGOijR5QjHzAh8KoJZg77ELvuu4TZxQugg8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=jcdHAomuo+aIEsNY7MMjDRSLkBt37MOtKvGtXH7F2p4iv+Hnsmvk/qocEERFAERJga9jGUwxAz5vel9d6FHrm2uVSL7UOTyRtUvzVcUsLv2moGX/yy/gKdFICoEFoVpdMez+lz5w99Lh69on/nM8QELEN0eblDKNLEvExZ9h4mk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=RpWgI9HZ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="RpWgI9HZ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2C04EC4CEC3;
	Thu,  5 Sep 2024 10:05:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1725530705;
	bh=0tngQQ9fEGOijR5QjHzAh8KoJZg77ELvuu4TZxQugg8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=RpWgI9HZg2eIl7IN8g7sIT+rBH+jdj+HaYbP1/t37Kj8scjXZOHRT/D5/tEVt+lv9
	 eLeCeRUENtvVNBxqThkzdgiq/hOChk9/bwNndHxHGMVoUkGqiNpAVEKkVZdEbGizpQ
	 uTzmhMBrrlJ+4glybQB9tHDngGQZ+5ihNUsTsAyI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jan Kara <jack@suse.cz>
Subject: [PATCH 6.1 098/101] udf: Limit file size to 4TB
Date: Thu,  5 Sep 2024 11:42:10 +0200
Message-ID: <20240905093719.955093093@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240905093716.075835938@linuxfoundation.org>
References: <20240905093716.075835938@linuxfoundation.org>
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

From: Jan Kara <jack@suse.cz>

commit c2efd13a2ed4f29bf9ef14ac2fbb7474084655f8 upstream.

UDF disk format supports in principle file sizes up to 1<<64-1. However
the file space (including holes) is described by a linked list of
extents, each of which can have at most 1GB. Thus the creation and
handling of extents gets unusably slow beyond certain point. Limit the
file size to 4TB to avoid locking up the kernel too easily.

Signed-off-by: Jan Kara <jack@suse.cz>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/udf/super.c |    9 ++++++++-
 1 file changed, 8 insertions(+), 1 deletion(-)

--- a/fs/udf/super.c
+++ b/fs/udf/super.c
@@ -86,6 +86,13 @@ enum {
 #define UDF_MAX_LVID_NESTING 1000
 
 enum { UDF_MAX_LINKS = 0xffff };
+/*
+ * We limit filesize to 4TB. This is arbitrary as the on-disk format supports
+ * more but because the file space is described by a linked list of extents,
+ * each of which can have at most 1GB, the creation and handling of extents
+ * gets unusably slow beyond certain point...
+ */
+#define UDF_MAX_FILESIZE (1ULL << 42)
 
 /* These are the "meat" - everything else is stuffing */
 static int udf_fill_super(struct super_block *, void *, int);
@@ -2299,7 +2306,7 @@ static int udf_fill_super(struct super_b
 		ret = -ENOMEM;
 		goto error_out;
 	}
-	sb->s_maxbytes = MAX_LFS_FILESIZE;
+	sb->s_maxbytes = UDF_MAX_FILESIZE;
 	sb->s_max_links = UDF_MAX_LINKS;
 	return 0;
 


