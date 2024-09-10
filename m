Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7187E181B8D;
	Tue, 10 Sep 2024 10:00:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725962410; cv=none; b=QvAur4Ttlfn82e01jIe/mXCA70IqqdC18uft0EzMzTIda5k7WNwHMftBf3pxSmyFu83Hf7AyqVZww2/mDa9PExwjDMHsAL31dF39AZZmOvz+DaqT+CSH+EQHxp5DP/wszcyU1ilVzaPCHn376JUAxV7o8U1H5XVL8X/S2krle3Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725962410; c=relaxed/simple;
	bh=66U8mezrOnbG37ykK7lU7KG1h4AN0CT5tAjqqqauA4k=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=a540/3WoiaRL+UFgR+ewNyj5d2+AtOCEPqzKznQYKerhlYCvQjg9CCzc6u1rZgJxmxNZouB0hx/o6UsQJySdwV1/GrJarso2GhR0YMevmzkbrCecmyy+/oj49BT1o9XDguff4mBbjgop6eV/bP62rV1GyQzvZnXUtT/VghspZlc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=O2U9sCdo; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="O2U9sCdo"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E3EBBC4CEC3;
	Tue, 10 Sep 2024 10:00:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1725962410;
	bh=66U8mezrOnbG37ykK7lU7KG1h4AN0CT5tAjqqqauA4k=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=O2U9sCdok3h1Vssxy2m+wiNRfEX0YB0farkNUXXij215WT8ASqIJmlcYNxPBSB8mD
	 FBBrm9b+n3gPpAxOwqdrmjVNNAuCkpWa/RySMz9LBzPGngcGIC4TpG11nrfCtGgsG+
	 UoUF9Y+ghugjUhBKQN0pbMltKqWY+pwm31FJcZ30=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jan Kara <jack@suse.cz>
Subject: [PATCH 5.4 024/121] udf: Limit file size to 4TB
Date: Tue, 10 Sep 2024 11:31:39 +0200
Message-ID: <20240910092546.858911920@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240910092545.737864202@linuxfoundation.org>
References: <20240910092545.737864202@linuxfoundation.org>
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

5.4-stable review patch.  If anyone has any objections, please let me know.

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
@@ -2308,7 +2315,7 @@ static int udf_fill_super(struct super_b
 		ret = -ENOMEM;
 		goto error_out;
 	}
-	sb->s_maxbytes = MAX_LFS_FILESIZE;
+	sb->s_maxbytes = UDF_MAX_FILESIZE;
 	sb->s_max_links = UDF_MAX_LINKS;
 	return 0;
 


