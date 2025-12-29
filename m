Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DB0C79460;
	Mon, 29 Dec 2025 16:22:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767025372; cv=none; b=hGfSh1KRQBI190Hd3Y4hAAdFoYZSLe6sk1PYVLPPnCbqTw80oA360cEmwSRr5ZsOH6MmQ7OxQtzac5f95R9CiT83f3Y0zlpquWckT2caVLihk2iLb2zQSCjGj2rR093J19MTsgmPlR9xH/iBM+rs9C7jQn3DkGgBhDRLqTtopQo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767025372; c=relaxed/simple;
	bh=xV+M1K7pfOC6AjB22gtJUF7yoDgR5IJrV2cU//fOZug=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=o2kqd3M/RvE4j33sOrDykn28f+8IxGdxkO45Un5boyt+S2xSKzdriZJuLYYhRbWz1iWR/KqphOITjBwrB2rOXeVGW1xHrfq86fIwQMJ16q+1FH68D2PxtZdRbn/d2t8LZ+tC+sXgqzu5cYgGuZ7Z8QvzMKfYEkTaER/nVfAF0wY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=IhtizOkq; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="IhtizOkq"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 659A1C4CEF7;
	Mon, 29 Dec 2025 16:22:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1767025372;
	bh=xV+M1K7pfOC6AjB22gtJUF7yoDgR5IJrV2cU//fOZug=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=IhtizOkqY2ky4eHcDrae08Dx06pd71Mbeib6Ze1uLuxia+T7rVHLyMbO80QKRxzu5
	 9f+0iJ2L0wNh3PjRs4AQZY0BVj4K6TYosNcMbT2+r2plprs9757JiyKdSqv1FLEdV8
	 Cjwrbra/v/fiT7e4OWkW4WrgGnDoyuN2eCGQ0r78=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Bernd Schubert <bschubert@ddn.com>,
	Miklos Szeredi <mszeredi@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 190/430] fuse: Invalidate the page cache after FOPEN_DIRECT_IO write
Date: Mon, 29 Dec 2025 17:09:52 +0100
Message-ID: <20251229160731.348767704@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251229160724.139406961@linuxfoundation.org>
References: <20251229160724.139406961@linuxfoundation.org>
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

From: Bernd Schubert <bschubert@ddn.com>

[ Upstream commit b359af8275a982a458e8df6c6beab1415be1f795 ]

generic_file_direct_write() also does this and has a large
comment about.

Reproducer here is xfstest's generic/209, which is exactly to
have competing DIO write and cached IO read.

Signed-off-by: Bernd Schubert <bschubert@ddn.com>
Signed-off-by: Miklos Szeredi <mszeredi@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/fuse/file.c | 9 +++++++++
 1 file changed, 9 insertions(+)

diff --git a/fs/fuse/file.c b/fs/fuse/file.c
index c5c82b380791..bb4ecfd469a5 100644
--- a/fs/fuse/file.c
+++ b/fs/fuse/file.c
@@ -1681,6 +1681,15 @@ ssize_t fuse_direct_io(struct fuse_io_priv *io, struct iov_iter *iter,
 	if (res > 0)
 		*ppos = pos;
 
+	if (res > 0 && write && fopen_direct_io) {
+		/*
+		 * As in generic_file_direct_write(), invalidate after the
+		 * write, to invalidate read-ahead cache that may have competed
+		 * with the write.
+		 */
+		invalidate_inode_pages2_range(mapping, idx_from, idx_to);
+	}
+
 	return res > 0 ? res : err;
 }
 EXPORT_SYMBOL_GPL(fuse_direct_io);
-- 
2.51.0



