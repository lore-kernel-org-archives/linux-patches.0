Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795047112;
	b=oHMvJilCjk7EVXzGWIP+DAKOXPHgAMCbjO9siWwoOygKt1hVwe+VjxRezyp9mymhpK6G
	 Q9TJRfGBUvL0v4Hj0Tc1VNbOs3l+or+N4TnpYfGyUzZH2qw+VVwEyh7Oxh6grXMqnvCUe
	 tqA10tyuLMettEybOmYB1BS0BJiNdKzDTnwSBcsd3GSuJasihww+Npa145rBcOvXtqbtZ
	 dfQn5oW6fdGEjwNSHQWdQ/kk4M9qxaP3YmQYeO+xLA0v34AcqpYas5aqw/9Pg1oynAjzO
	 gMkevdwHTmFoi1RhDQ4NR8ZC98xwi2PblSNJlFPVdIOJ7D1a1R8ojB1U41yKCdSZcUw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795047112;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=O+mo2j9YS+klyuJ93qHn1ntajEVUGf2jBjuGmORMs+o=;
	b=Oy/EAdKGMGs6/mq1/ta9s8gDnD0kGi2fsLtG95WQ8z5txkD1xwqqWDdMiKhkOOWCZT8U
	 FJSkyzXeY2jGFJKi60Gd34kVeODedndhnulI9TEMUeBCvfed1tDNem0tGPhrtP06oXhmn
	 CN1VBagILCDD+pPUm6qTNm0zAj8HkgFkHgfvRaBDnVBG1bf83gPOY9/aS67HEmpqGXXws
	 +1qeRd8e4OL6Y1bdHe1Egp2vdJHZmaFZdo2jILviC9Jd0xhl3PIr5MRHaOqdNsEeOqSZM
	 ijQXwPJtxkOJcaSFvnBTSrE+SfVKOzqnbKqRcGjK5q2avyw4KrQdSXG8r5/IeTcaluQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=ptQtqujT;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 295D0606A31C;
	Thu, 19 Nov 2026 00:11:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=ptQtqujT
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7C47E1F000C4;
	Thu, 19 Nov 2026 00:11:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795047112;
	bh=O+mo2j9YS+klyuJ93qHn1ntajEVUGf2jBjuGmORMs+o=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ptQtqujTykfMLnkTSuBqB6MUQJPixn4zK+4IT829vnxQhLUPSyHysFxdycFwItXsS
	 e5k9fgUcBKzaOdDx6+zDtDEyhTKa3aOKEKtB5FBbKimIaYNlbu+8RCwMNN9VXodQRg
	 XJ50GNASMyxmjNacvyVakT4iKe7SkdHkrZRKObns=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Joanne Koong <joannelkoong@gmail.com>,
	Miklos Szeredi <mszeredi@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 1523/2857] fuse: dont drop destination page cache on a zero byte copy reply
Date: Wed, 18 Nov 2026 15:42:37 +0100
Message-ID: <20261118150256.160709938@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150201.293410965@linuxfoundation.org>
References: <20261118150201.293410965@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
index b1b82e6a72b1b..8290db2b4f13b 100644
--- a/fs/fuse/file.c
+++ b/fs/fuse/file.c
@@ -3213,9 +3213,11 @@ static ssize_t __fuse_copy_file_range(struct file *file_in, loff_t pos_in,
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
 
 	file_update_time(file_out);
 	fuse_write_update_attr(inode_out, pos_out + outarg.size, outarg.size);
-- 
2.53.0



