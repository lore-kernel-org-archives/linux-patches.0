Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795054007;
	b=yjVWE1kPeQ4cVGy3p5ZlpSIcZt8N2ZsgHfOG2Clj1EW0Uwus2bRBi8uza3QfguU/Ichf
	 jPLzUI219yGB8zJwA6cCCUV+BNdpaTTfv9Xaw+G8nniP7PINj5ttZwnml24WwVlmiEilQ
	 1BK5cJXe7sc+w0sVmtoHIQqPNtGkQLSX3M0phrSn6glE78rJMv0FQHNKKxNeUuLoL2XQW
	 5KDDuq1f8XBiuGzSS0q7GSYxpZd74ROJp6Ecb+RgfbDfA3+d0Q5fT+MabVFu415o7kUsK
	 z0ZAlSspN0GHJTbJPr3wwGDYIL/JBVax/BOGUu3137U8af8pTYjNKYNZHx5MeiNiF+Q==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795054007;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=m7sxTZs4AEcHUC5KjvIkxDqXRtDnU/AI7AIZmP8j5Sg=;
	b=bv9W54Uvr+E608kGkPI/Ax8Bh43a4oWkUk1b0s+VX5XPMoDDNq358mplOhbixGuuoF2r
	 5LcoXRiVvjea/HAw8iDkroe7Rs90KxgasbPpH1nwvYMBx4AX1/05qvhSjxo0VS70k9+Vu
	 +Ydnrj6YJiZKsFgve2fXBbnZKk3WK+2+TczPcVDG8McTJpWWLRqTHHwgrvBGQ2X8RetUt
	 QXxKQ2xc/jq0YsOxRPbX3kf6s62+kE1Oie0FW2boIhfYtPPvBZMGK7sAquzwtbP0bx2Xq
	 nct/X45GYlIAUPw9vW6/dmq2htHf1ymdPadz/G7EuDXdbcDFaPjulXFZALKIBCBp2LA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=sZGT30cg;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 926D3606A325;
	Thu, 19 Nov 2026 02:06:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=sZGT30cg
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E05BB1F000C4;
	Thu, 19 Nov 2026 02:06:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795054007;
	bh=m7sxTZs4AEcHUC5KjvIkxDqXRtDnU/AI7AIZmP8j5Sg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=sZGT30cg4r+9Drgn1b6Sh4i1sSlwkc5jjiZmOmOGRekqionb7ZLwQk17r+1LUtLtK
	 nCydxBW/txfoIcpxm/9sKdcBLTmrP3qRDrJr1o+9x2J98y68N75UPS3qkBpGnVeh7O
	 k6eJDZ9asEBJUB5S9OUJDwoAeTi+tEbhpBEzNTX4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Joanne Koong <joannelkoong@gmail.com>,
	Miklos Szeredi <mszeredi@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 1123/2214] fuse: dont drop destination page cache on a zero byte copy reply
Date: Wed, 18 Nov 2026 15:46:39 +0100
Message-ID: <20261118150057.011700791@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150009.797899913@linuxfoundation.org>
References: <20261118150009.797899913@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Joanne Koong <joannelkoong@gmail.com>

[ Upstream commit f7585e1ce3418ec282485854b3d8d31c6a961e37 ]

__fuse_copy_file_range() clears the destination page cache after the
server replies:

	truncate_inode_pages_range(inode_out->i_mapping,
				   ALIGN_DOWN(pos_out, PAGE_SIZE),
				   ALIGN(pos_out + bytes_copied, PAGE_SIZE) - 1);

A server may legitimately reply that it copied nothing, eg if the source
file turns out to be shorter than the size the kernel has cached for it.

If pos_out is 0 as well, the end of the range is ALIGN(0, PAGE_SIZE) - 1,
which is -1. lend is a uoff_t and truncate_inode_pages_range() takes -1
as its end of file sentinel, so rather than clearing nothing it drops
every folio in the destination mapping.

That is not only a cache drop. truncate_cleanup_folio() calls
folio_cancel_dirty(), and fuse_writeback_range() only wrote back
[pos_out, pos_out + len - 1], so dirty data elsewhere in the destination
file is discarded without ever reaching the server.

Skip the call when the server copied nothing, since there is nothing
stale to clear in that case.

Fixes: 9b46418c40fe ("fuse: copy_file_range should truncate cache")
Cc: stable@vger.kernel.org
Signed-off-by: Joanne Koong <joannelkoong@gmail.com>
Signed-off-by: Miklos Szeredi <mszeredi@redhat.com>
[ sashal: used outarg.size instead of bytes_copied ]
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/fuse/file.c | 8 +++++---
 1 file changed, 5 insertions(+), 3 deletions(-)

diff --git a/fs/fuse/file.c b/fs/fuse/file.c
index b777ec4ec8414..0da046c9029e2 100644
--- a/fs/fuse/file.c
+++ b/fs/fuse/file.c
@@ -3157,9 +3157,11 @@ static ssize_t __fuse_copy_file_range(struct file *file_in, loff_t pos_in,
 	if (err)
 		goto out;
 
-	truncate_inode_pages_range(inode_out->i_mapping,
-				   ALIGN_DOWN(pos_out, PAGE_SIZE),
-				   ALIGN(pos_out + outarg.size, PAGE_SIZE) - 1);
+	if (outarg.size)
+		truncate_inode_pages_range(inode_out->i_mapping,
+					   ALIGN_DOWN(pos_out, PAGE_SIZE),
+					   ALIGN(pos_out + outarg.size,
+						 PAGE_SIZE) - 1);
 
 	if (fc->writeback_cache) {
 		fuse_write_update_size(inode_out, pos_out + outarg.size);
-- 
2.53.0



