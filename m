Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794591563;
	b=YjJLNiInQK6iN0uH99KbqoQtROXBAfuarKp1fYq8K/npetwxocOmSxiJy1w/Ur1wS1CG
	 EOvx3igCbgIalGDGLNaKovTwmXpIpzZsHTzp5jQuSX9eyLjuIJZY3mhnQqNT5qIpcf80m
	 qL9u8o6381LplkP5Lt5FDIbEobmGwv6OfRjePcZdcNFBqPEjXYQXXCy6BjD50jkYOPOsm
	 gplG3TqvoGiMCxUYHWXugHlXRB5Bj94bYVLDDh8P6YUwWOw+MzN1hOXR2ZAg/WV08JcA6
	 cOHNpJUNaE3IdRpuwbgaquU+0A/yjiscGQgfZBq2C7zlDsaGvH2F48NgTeNBZvy6qNA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794591563;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=v8TH7hslTJVtv+xMrlX5UK1jXygVk4SBPCvul0AuKWA=;
	b=MdJC+megmrKQsZ85d5MlBKw+TkB8xC08X+1et4rbDPWaqxbZYQ9Ut6FfWwk2fh/28Uqx
	 d/FZI4o1t24dEPdwpMsV3sIfqHb6ItSDn19tB927XwJCMJMLwO7nkw8r1hu//9n+Gu+4U
	 KIVDEbIAwDLOKxE9QhDyekVQhVCb6Nvt0tExrSLa4f9Dr5f8D+6LwV+LDdgadfoWYWRkt
	 8JWKrOqT83eqAPdNiJSGDWbotkLS/nQUYQFEjJ/iDYGI2pNNO/Hp9JBts3U8LaX/g4UYj
	 CiLULUu3GDf3vu6jH6HEJ3JsGod5KHJHfjn0P2Cj92QOdS/e2W2w4mkn+keawLR9+HQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=hv7IgAGP;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0D2C8606D4AE;
	Fri, 13 Nov 2026 17:39:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=hv7IgAGP
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 821141F000C4;
	Fri, 13 Nov 2026 17:39:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794591562;
	bh=v8TH7hslTJVtv+xMrlX5UK1jXygVk4SBPCvul0AuKWA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=hv7IgAGPPWPfDfC4EfsvHXSkOwx2EI3LsSIjmWpqeOCD9zbNre8HxvQ1i50oE73LH
	 o1ZH+CErTL/Y+MrNvebFe8Se5QKbJT7IF3Ipfr/FpDYZ182L3b49fcJTUdfwKGc0yE
	 6jksXUv+B4cBTRqSqSxQAkmlXPGsHmXIzHcOB6H0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Joanne Koong <joannelkoong@gmail.com>,
	Miklos Szeredi <mszeredi@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 606/670] fuse: dont drop destination page cache on a zero byte copy reply
Date: Fri, 13 Nov 2026 10:52:50 -0500
Message-ID: <20261113153832.361995934@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261113153811.177190860@linuxfoundation.org>
References: <20261113153811.177190860@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
[ sashal: Replaced bytes_copied with outarg.size to match the existing copy reply format. ]
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/fuse/file.c | 8 +++++---
 1 file changed, 5 insertions(+), 3 deletions(-)

diff --git a/fs/fuse/file.c b/fs/fuse/file.c
index 97fcc5c136fcc..cada359fd03a2 100644
--- a/fs/fuse/file.c
+++ b/fs/fuse/file.c
@@ -3348,9 +3348,11 @@ static ssize_t __fuse_copy_file_range(struct file *file_in, loff_t pos_in,
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



