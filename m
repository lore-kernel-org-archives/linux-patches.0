Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 70C506FA1
	for <patches@lists.linux.dev>; Mon,  3 Apr 2023 14:48:43 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E8724C433A0;
	Mon,  3 Apr 2023 14:48:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1680533323;
	bh=DwY+yCmnnTVF6ZEf7AKk5MMt3RiJokAbP5E81GglWF0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=M0kIC4Nk/axiVw/sHRmCdcaqNyzKqxPkHs/1cSPemT/aU9ICnzHdM8lLu2h2g8mMo
	 M1KyBYFRmvmAEU9lAWCnrUt+mXHz/bAzQpV880VgQjvVVntyox+PVmLDug+qXf2paE
	 MsURT+ZebEsdFoLOqmRSDiprBa06J9hv+yIusoVM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Christoph Hellwig <hch@infradead.org>,
	Damien Le Moal <damien.lemoal@opensource.wdc.com>,
	Christoph Hellwig <hch@lst.de>,
	Johannes Thumshirn <johannes.thumshirn@wdc.com>,
	Hans Holmberg <hans.holmberg@wdc.com>
Subject: [PATCH 6.2 139/187] zonefs: Do not propagate iomap_dio_rw() ENOTBLK error to user space
Date: Mon,  3 Apr 2023 16:09:44 +0200
Message-Id: <20230403140420.579704128@linuxfoundation.org>
X-Mailer: git-send-email 2.40.0
In-Reply-To: <20230403140416.015323160@linuxfoundation.org>
References: <20230403140416.015323160@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Damien Le Moal <damien.lemoal@opensource.wdc.com>

commit 77af13ba3c7f91d91c377c7e2d122849bbc17128 upstream.

The call to invalidate_inode_pages2_range() in __iomap_dio_rw() may
fail, in which case -ENOTBLK is returned and this error code is
propagated back to user space trhough iomap_dio_rw() ->
zonefs_file_dio_write() return chain. This error code is fairly obscure
and may confuse the user. Avoid this and be consistent with the behavior
of zonefs_file_dio_append() for similar invalidate_inode_pages2_range()
errors by returning -EBUSY to user space when iomap_dio_rw() returns
-ENOTBLK.

Suggested-by: Christoph Hellwig <hch@infradead.org>
Fixes: 8dcc1a9d90c1 ("fs: New zonefs file system")
Cc: stable@vger.kernel.org
Signed-off-by: Damien Le Moal <damien.lemoal@opensource.wdc.com>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Johannes Thumshirn <johannes.thumshirn@wdc.com>
Tested-by: Hans Holmberg <hans.holmberg@wdc.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/zonefs/file.c |   14 ++++++++++++--
 1 file changed, 12 insertions(+), 2 deletions(-)

--- a/fs/zonefs/file.c
+++ b/fs/zonefs/file.c
@@ -567,11 +567,21 @@ static ssize_t zonefs_file_dio_write(str
 		append = sync;
 	}
 
-	if (append)
+	if (append) {
 		ret = zonefs_file_dio_append(iocb, from);
-	else
+	} else {
+		/*
+		 * iomap_dio_rw() may return ENOTBLK if there was an issue with
+		 * page invalidation. Overwrite that error code with EBUSY to
+		 * be consistent with zonefs_file_dio_append() return value for
+		 * similar issues.
+		 */
 		ret = iomap_dio_rw(iocb, from, &zonefs_write_iomap_ops,
 				   &zonefs_write_dio_ops, 0, NULL, 0);
+		if (ret == -ENOTBLK)
+			ret = -EBUSY;
+	}
+
 	if (zonefs_zone_is_seq(z) &&
 	    (ret > 0 || ret == -EIOCBQUEUED)) {
 		if (ret > 0)


