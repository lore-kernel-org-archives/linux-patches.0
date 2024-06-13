Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0544381AA7;
	Thu, 13 Jun 2024 12:09:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718280583; cv=none; b=Mb9PXcw45aSxqWNYWV+QOqLCQtLDIApH4lSqX9Qu3qi8l/hcSKWndchj5zIJxJot2thfVBceNRkIBmT5BmIyxt3GMJyWqOXdW70Wvn1FioakMmumWsVAdFUIQiULlcktso1/UCKeoSXP48W2UdEYiEyJ7toguD8qu56Uf8+QGLo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718280583; c=relaxed/simple;
	bh=e8wdoUBZa0/Ufs1Bzyy5ew1ooXt6mIqwPsZQpqPvEL4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=OiyhFMSV8Q+sgY797W4ZuJdXku+M38PaJe5rypIT8vd6egVwyNTRSG2eWY6RWMcyQxyMg0fEJCfrVP+UkJ74bzAYbTeBUwleYop+rdNPEO6qJa4o6XM34gwVIRHCzGsCJ2NOdsNOeZk75bZW0HPdK8gMkxcCdr3z+/UCA1Dsw0g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=2EfXBvfy; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="2EfXBvfy"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2F1AFC2BBFC;
	Thu, 13 Jun 2024 12:09:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1718280582;
	bh=e8wdoUBZa0/Ufs1Bzyy5ew1ooXt6mIqwPsZQpqPvEL4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=2EfXBvfyg9QsWpvY34ESevcr0SV3xkCuAldGcqOAA9fOyQLOSHapBy9XfKmjSb+YG
	 GWpp3V9jghbP3WgXkOuaaEomOhqFcmuwgtP26Kdx1HRfKwCEJYw7GP1wRG22M7wl0y
	 EV4Wy9zqsAy94YK4uE9S1BhO3t5hwztSyhCzOyRg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Darrick J. Wong" <djwong@kernel.org>,
	Xu Yang <xu.yang_2@nxp.com>,
	Christoph Hellwig <hch@lst.de>,
	"Matthew Wilcox (Oracle)" <willy@infradead.org>,
	Christian Brauner <brauner@kernel.org>
Subject: [PATCH 6.6 075/137] iomap: fault in smaller chunks for non-large folio mappings
Date: Thu, 13 Jun 2024 13:34:15 +0200
Message-ID: <20240613113226.205317531@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240613113223.281378087@linuxfoundation.org>
References: <20240613113223.281378087@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Xu Yang <xu.yang_2@nxp.com>

commit 4e527d5841e24623181edc7fd6f6598ffa810e10 upstream.

Since commit (5d8edfb900d5 "iomap: Copy larger chunks from userspace"),
iomap will try to copy in larger chunks than PAGE_SIZE. However, if the
mapping doesn't support large folio, only one page of maximum 4KB will
be created and 4KB data will be writen to pagecache each time. Then,
next 4KB will be handled in next iteration. This will cause potential
write performance problem.

If chunk is 2MB, total 512 pages need to be handled finally. During this
period, fault_in_iov_iter_readable() is called to check iov_iter readable
validity. Since only 4KB will be handled each time, below address space
will be checked over and over again:

start         	end
-
buf,    	buf+2MB
buf+4KB, 	buf+2MB
buf+8KB, 	buf+2MB
...
buf+2044KB 	buf+2MB

Obviously the checking size is wrong since only 4KB will be handled each
time. So this will get a correct chunk to let iomap work well in non-large
folio case.

With this change, the write speed will be stable. Tested on ARM64 device.

Before:

 - dd if=/dev/zero of=/dev/sda bs=400K  count=10485  (334 MB/s)
 - dd if=/dev/zero of=/dev/sda bs=800K  count=5242   (278 MB/s)
 - dd if=/dev/zero of=/dev/sda bs=1600K count=2621   (204 MB/s)
 - dd if=/dev/zero of=/dev/sda bs=2200K count=1906   (170 MB/s)
 - dd if=/dev/zero of=/dev/sda bs=3000K count=1398   (150 MB/s)
 - dd if=/dev/zero of=/dev/sda bs=4500K count=932    (139 MB/s)

After:

 - dd if=/dev/zero of=/dev/sda bs=400K  count=10485  (339 MB/s)
 - dd if=/dev/zero of=/dev/sda bs=800K  count=5242   (330 MB/s)
 - dd if=/dev/zero of=/dev/sda bs=1600K count=2621   (332 MB/s)
 - dd if=/dev/zero of=/dev/sda bs=2200K count=1906   (333 MB/s)
 - dd if=/dev/zero of=/dev/sda bs=3000K count=1398   (333 MB/s)
 - dd if=/dev/zero of=/dev/sda bs=4500K count=932    (333 MB/s)

Fixes: 5d8edfb900d5 ("iomap: Copy larger chunks from userspace")
Cc: stable@vger.kernel.org
Reviewed-by: Darrick J. Wong <djwong@kernel.org>
Signed-off-by: Xu Yang <xu.yang_2@nxp.com>
Link: https://lore.kernel.org/r/20240521114939.2541461-2-xu.yang_2@nxp.com
Reviewed-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Matthew Wilcox (Oracle) <willy@infradead.org>
Signed-off-by: Christian Brauner <brauner@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/iomap/buffered-io.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/fs/iomap/buffered-io.c
+++ b/fs/iomap/buffered-io.c
@@ -868,11 +868,11 @@ static size_t iomap_write_end(struct iom
 static loff_t iomap_write_iter(struct iomap_iter *iter, struct iov_iter *i)
 {
 	loff_t length = iomap_length(iter);
-	size_t chunk = PAGE_SIZE << MAX_PAGECACHE_ORDER;
 	loff_t pos = iter->pos;
 	ssize_t written = 0;
 	long status = 0;
 	struct address_space *mapping = iter->inode->i_mapping;
+	size_t chunk = mapping_max_folio_size(mapping);
 	unsigned int bdp_flags = (iter->flags & IOMAP_NOWAIT) ? BDP_ASYNC : 0;
 
 	do {


