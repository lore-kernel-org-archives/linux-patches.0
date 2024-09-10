Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CB00118C32E;
	Tue, 10 Sep 2024 10:40:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725964844; cv=none; b=M9OClW+G8PaSSq8XhGzrltj4QsU1TqndBJC9DcttB5Z38vlgh/nU5o6G8YSs5bwWk8Vm6WM8xw99isCR6u1G5x8cGr2cqL8KlwNmKi8r2AKNqDIxhjr+FXtKGVqYbUw0rfrW4lDSeU+1ZRg9RtLKiFzFoKddo7WFrW91InwRk7E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725964844; c=relaxed/simple;
	bh=fxqB62WNp3Ar+uJz1tgp/6oQxPyGYN9bMsGEj1c75CY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=L2SmH6gc+RHTolcIaT9OMDeKyEcclEgGRrNcIfZpAcZ208UylYG+uwn1qzJMSkvzDBixiXjGKX4j0xKynH03f4nthfaqTZ9Cr0zjvATTU0Eo6S32+1dgYfJg5lzV9JZfkKZC9stsN/JB7PvfmoeT9w8kKUewosoALtER4r82ku8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=1X9tF+Xl; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="1X9tF+Xl"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 46C4DC4CEC3;
	Tue, 10 Sep 2024 10:40:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1725964844;
	bh=fxqB62WNp3Ar+uJz1tgp/6oQxPyGYN9bMsGEj1c75CY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=1X9tF+XlTzmcjaeIAhDKYqwUEDwEHSNXp+ttSyLunrrCcjdaipzolwR+2QXZRdZCg
	 kYWToWadetukEhsubUHN3unFOHodAfVf4pYbr+iyoUcd90JgcJg6RsEeTzkCHIiljI
	 ueAk8ir0PMr+cNExrxlqGquqSV7C6c94WjkUXtMg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jan Kara <jack@suse.cz>
Subject: [PATCH 5.10 050/186] udf: Limit file size to 4TB
Date: Tue, 10 Sep 2024 11:32:25 +0200
Message-ID: <20240910092556.564519987@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240910092554.645718780@linuxfoundation.org>
References: <20240910092554.645718780@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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
@@ -2301,7 +2308,7 @@ static int udf_fill_super(struct super_b
 		ret = -ENOMEM;
 		goto error_out;
 	}
-	sb->s_maxbytes = MAX_LFS_FILESIZE;
+	sb->s_maxbytes = UDF_MAX_FILESIZE;
 	sb->s_max_links = UDF_MAX_LINKS;
 	return 0;
 


