Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 924C5195FD1;
	Tue, 10 Sep 2024 10:18:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725963523; cv=none; b=dxOj3GKQh3oa2EEM6ezlZfcWBXAfZLLnZ24xfxcqCoBR6wqa2PeXzbTowIxWcgPh5L55XkcYvkMXbT9aLsqsMnLyqHrSWSPa3NR1pc9Ek5iiFOGVHcoLUSUVtsXb7jfn3iNWeOE9hxZwgIActLCJKdGD9PBUhI8dKB9a3yoeyxo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725963523; c=relaxed/simple;
	bh=NVZlz9Kh5NkBrzGoIFH4N6bdFa5m5640RLflj1O1l5A=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=BxZ4zq4FgiudB6x5tl9qzSPbpH/ZcAMZXtZQjTGbhBP+1GrdV0+H1HODVm84FB47yxRFo3hFzQXWU0sZ70nta/4hZHfipt0hLnbc2lHQyBDTmwFtx90kmOLRYF+6cY/M1o+c2oD9dVQr5Bg9AuJNB1cScJVd45kk77nMshNT/0U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Lex87/4W; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Lex87/4W"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 19773C4CEC3;
	Tue, 10 Sep 2024 10:18:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1725963523;
	bh=NVZlz9Kh5NkBrzGoIFH4N6bdFa5m5640RLflj1O1l5A=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Lex87/4W1FuODCjDkW6+26OjTbpzeclFIWLeM9UWjFwv+DWzhDkWkFZbLXyJ7lUY4
	 n8cAEztvCsg6O5xY0OpDUX7t0DH8DjONpC9B8+PoTFj+nK3BgOami0Ps+llP0kCLJP
	 K1WvVs5rWx0LvB9AaWmYhM9BT+NkHzrnLcSFN3yI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jan Kara <jack@suse.cz>
Subject: [PATCH 5.15 059/214] udf: Limit file size to 4TB
Date: Tue, 10 Sep 2024 11:31:21 +0200
Message-ID: <20240910092601.183874021@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240910092558.714365667@linuxfoundation.org>
References: <20240910092558.714365667@linuxfoundation.org>
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
@@ -2302,7 +2309,7 @@ static int udf_fill_super(struct super_b
 		ret = -ENOMEM;
 		goto error_out;
 	}
-	sb->s_maxbytes = MAX_LFS_FILESIZE;
+	sb->s_maxbytes = UDF_MAX_FILESIZE;
 	sb->s_max_links = UDF_MAX_LINKS;
 	return 0;
 


