Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1942630F958;
	Tue, 31 Mar 2026 17:09:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774976955; cv=none; b=tF6c1+us/BjSdBuuETam+bvIz9pb4QYGj87cia9m82p/OOh51qBgDDDaLqrWQitGDRaWKUlR7hFnhuTuVoGBfahbFfHr3WWXPAR0396rfNMhcDf0SW6gannrpB+6g2rn2VOqIEGgz7rg1IsotizwXUcsMx0EPtn2fi18KXsUdhM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774976955; c=relaxed/simple;
	bh=ptJlhiLK6MMPlIdijsYeTe6ICg9RPFq9FqWfg1hSMAU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=TYMhm3BhkKgFghxmNGZbATd78MQ+TLyfF0zvWXiU3XCMMSSGoW2Mtg1aV7I9jCuFqLsgBDvehs9RUV8U6crYhICG1tHkv/qpmFkTKoepmLPp9ApnC7hOWPKo0r6bcg9ICQPISK3O/4cEjThL7dqet4L3DmDSlpizaDES5YfCq6A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=SAQDJlOX; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="SAQDJlOX"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A4798C19423;
	Tue, 31 Mar 2026 17:09:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1774976955;
	bh=ptJlhiLK6MMPlIdijsYeTe6ICg9RPFq9FqWfg1hSMAU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=SAQDJlOXnNjYpRe8jpZjN0GVSB4//rtowhgQn7cMo0mNcdiQUMpd9qjCRokaBJPky
	 MUkTiP9TelXmgAVbyUqDOqe0pHSN4rEj4jFIEAVQ/RUEdwWujtybCew7H6bam7tRIK
	 LJA9nZkXqdzacVIUA/n4sooItRPcX0djUGvwC5ug=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	syzbot+9c058f0d63475adc97fd@syzkaller.appspotmail.com,
	Deepanshu Kartikey <Kartikey406@gmail.com>,
	Christian Brauner <brauner@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 292/309] netfs: Fix kernel BUG in netfs_limit_iter() for ITER_KVEC iterators
Date: Tue, 31 Mar 2026 18:23:15 +0200
Message-ID: <20260331161804.314663221@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260331161753.468533260@linuxfoundation.org>
References: <20260331161753.468533260@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Deepanshu Kartikey <kartikey406@gmail.com>

[ Upstream commit 67e467a11f62ff64ad219dc6aa5459e132c79d14 ]

When a process crashes and the kernel writes a core dump to a 9P
filesystem, __kernel_write() creates an ITER_KVEC iterator. This
iterator reaches netfs_limit_iter() via netfs_unbuffered_write(), which
only handles ITER_FOLIOQ, ITER_BVEC and ITER_XARRAY iterator types,
hitting the BUG() for any other type.

Fix this by adding netfs_limit_kvec() following the same pattern as
netfs_limit_bvec(), since both kvec and bvec are simple segment arrays
with pointer and length fields. Dispatch it from netfs_limit_iter() when
the iterator type is ITER_KVEC.

Fixes: cae932d3aee5 ("netfs: Add func to calculate pagecount/size-limited span of an iterator")
Reported-by: syzbot+9c058f0d63475adc97fd@syzkaller.appspotmail.com
Closes: https://syzkaller.appspot.com/bug?extid=9c058f0d63475adc97fd
Tested-by: syzbot+9c058f0d63475adc97fd@syzkaller.appspotmail.com
Signed-off-by: Deepanshu Kartikey <Kartikey406@gmail.com>
Link: https://patch.msgid.link/20260307090041.359870-1-kartikey406@gmail.com
Signed-off-by: Christian Brauner <brauner@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/netfs/iterator.c | 43 +++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 43 insertions(+)

diff --git a/fs/netfs/iterator.c b/fs/netfs/iterator.c
index 72a435e5fc6da..154a14bb2d7f7 100644
--- a/fs/netfs/iterator.c
+++ b/fs/netfs/iterator.c
@@ -142,6 +142,47 @@ static size_t netfs_limit_bvec(const struct iov_iter *iter, size_t start_offset,
 	return min(span, max_size);
 }
 
+/*
+ * Select the span of a kvec iterator we're going to use.  Limit it by both
+ * maximum size and maximum number of segments.  Returns the size of the span
+ * in bytes.
+ */
+static size_t netfs_limit_kvec(const struct iov_iter *iter, size_t start_offset,
+			       size_t max_size, size_t max_segs)
+{
+	const struct kvec *kvecs = iter->kvec;
+	unsigned int nkv = iter->nr_segs, ix = 0, nsegs = 0;
+	size_t len, span = 0, n = iter->count;
+	size_t skip = iter->iov_offset + start_offset;
+
+	if (WARN_ON(!iov_iter_is_kvec(iter)) ||
+	    WARN_ON(start_offset > n) ||
+	    n == 0)
+		return 0;
+
+	while (n && ix < nkv && skip) {
+		len = kvecs[ix].iov_len;
+		if (skip < len)
+			break;
+		skip -= len;
+		n -= len;
+		ix++;
+	}
+
+	while (n && ix < nkv) {
+		len = min3(n, kvecs[ix].iov_len - skip, max_size);
+		span += len;
+		nsegs++;
+		ix++;
+		if (span >= max_size || nsegs >= max_segs)
+			break;
+		skip = 0;
+		n -= len;
+	}
+
+	return min(span, max_size);
+}
+
 /*
  * Select the span of an xarray iterator we're going to use.  Limit it by both
  * maximum size and maximum number of segments.  It is assumed that segments
@@ -245,6 +286,8 @@ size_t netfs_limit_iter(const struct iov_iter *iter, size_t start_offset,
 		return netfs_limit_bvec(iter, start_offset, max_size, max_segs);
 	if (iov_iter_is_xarray(iter))
 		return netfs_limit_xarray(iter, start_offset, max_size, max_segs);
+	if (iov_iter_is_kvec(iter))
+		return netfs_limit_kvec(iter, start_offset, max_size, max_segs);
 	BUG();
 }
 EXPORT_SYMBOL(netfs_limit_iter);
-- 
2.53.0



