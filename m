Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794585509;
	b=s6RAmuQzn9p8z9vpRPRmRvgQoLux6B+xS2WeA79RkcdDLa9k5jgLGwhBJcmgyGu8e+8X
	 z9yYjrBhB8l+NwXuv285bE/mrXDqxpZU05nPRRrLjWC2XSqMAtMLBc1yUMdj0C8I9VX6P
	 AvQXVWokReHbotr3/vJ+5wCuKvXN0M2zv3GMsOBukgtF2tR8HbWbgD20evXrG0tjkE4Wb
	 mlB3dPjoRIeOtkCRkYTQQ//mYwVqgfbJFq3fb7TBRpNIIm2GCpeQlbMtV177vNPvqk8cM
	 X3SFf1LbtuV4dGXJs6GO9kDETYNI3lAZBqsJRdDWUU3LF0e/22EywzPXLuus+z0MBsg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794585509;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=jYpjBL/K5oKZK5b+pTheSqdscUoeAu5yS7Oalqq/Ke8=;
	b=qlP2ihVQf2fLkmVIZikIZPACqPBng6ZZ94887pZ+eJlfdZBoRwneGWSpMCu75DZN2Dc+
	 MwjLZDgGrmS9IqRGxONSEPOy73d07MUcvwmP0kFrQaWcjhVBNW68zEImBpXQCCdmrNAhj
	 9d5mGY1CrBtyMT1gj0Kfh/8S8sUB9oStNWOXCX4MIo8QUfC1pw53QfwkDC39+AXboh8Bj
	 OEu8WSofgPUOi4wcLAhZbkhJEPMMYGJNgP84Mun5/3eKAJUVMWtfLA4vt1Pdu702HqTiQ
	 ACJUR42sVqTE8E2YLrKs9bLSLoF8f7b8WOxvd0Gg0wQ76ICJKTFdbNnzdwmpBP84Eog==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=jN8l97L+;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BAC79606AE0B;
	Fri, 13 Nov 2026 15:58:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=jN8l97L+
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 672B91F000C5;
	Fri, 13 Nov 2026 15:58:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794585509;
	bh=jYpjBL/K5oKZK5b+pTheSqdscUoeAu5yS7Oalqq/Ke8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=jN8l97L+5GNh82BLoD7kEpyJvlt69E3CHEOUZcisEYsnI43ksJsjvJDuYNJCy9Pn2
	 hFaDbG7Gzq2NaacTI2zMArEBa1nhZHT1wZVdzcyCi1HC95ZKmEW3T3VzVLTLoQwKfy
	 WiNX8cqSm0O/Yje6LH06xsRIMY/+AcqcatEQJ1Ow=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Hungyu Lin <dennylin0707@gmail.com>,
	Jan Kara <jack@suse.cz>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 156/507] ext2: preserve completed DIO bytes when buffered fallback fails
Date: Fri, 13 Nov 2026 10:47:40 -0500
Message-ID: <20261113153759.800746940@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261113153753.358973689@linuxfoundation.org>
References: <20261113153753.358973689@linuxfoundation.org>
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

7.3-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Hungyu Lin <dennylin0707@gmail.com>

[ Upstream commit cbf04dde8b3c5a7e043e91cefad68b8980ea0d18 ]

ext2_dio_write_iter() can complete part of a direct write before
falling back to buffered I/O for a hole inside i_size. If
generic_perform_write() then fails, its error overwrites the completed
direct-I/O byte count.

For example, on a full filesystem, an 8 KiB write to a file with an
allocated 4 KiB prefix and a 4 KiB hole overwrites the prefix but returns
ENOSPC and leaves the file position unchanged. GNU dd with oflag=direct
consequently reports zero bytes written.

Preserve a positive direct-I/O result and return the buffered error
when no bytes were direct-written. This restores the fallback policy of
generic_file_write_iter(), which ext2 used before its iomap conversion.

Fixes: fb5de4358e1a ("ext2: Move direct-io to use iomap")
Cc: stable@vger.kernel.org
Signed-off-by: Hungyu Lin <dennylin0707@gmail.com>
Link: https://patch.msgid.link/20261102061555.55183-1-dennylin0707@gmail.com
Signed-off-by: Jan Kara <jack@suse.cz>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/ext2/file.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/fs/ext2/file.c b/fs/ext2/file.c
index b9020df7d89e0..d4a0a528c3429 100644
--- a/fs/ext2/file.c
+++ b/fs/ext2/file.c
@@ -138,7 +138,8 @@ static ssize_t ext2_dio_write_iter(struct kiocb *iocb, struct iov_iter *from)
 		pos = iocb->ki_pos;
 		status = generic_perform_write(iocb, from);
 		if (unlikely(status < 0)) {
-			ret = status;
+			if (!ret)
+				ret = status;
 			goto out_unlock;
 		}
 
-- 
2.53.0



