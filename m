Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795038677;
	b=GQPfjHwbTRfZF+xdOXKbMJOnWDKSDY4pEj1dKXSNPFFd7vim7UBG82jG8+8Yrx1/vFle
	 Tiy8R43i4WXK7UiL/BoFHN8dP3vwuIWWs0LQk2xFT5DOaC0c4yq4Wmp02Q3GkSx0+GCeI
	 ekov261dIllfcJ/2YxUR3hoqnW7DDIwzy5LpPQmgQe/KPjlzPWoTW8TuTDV76hRSjPCYg
	 Tkm6uhHRhDJTs/e4A5JHIvdgXvA4XACM5Dz4O6kwwt6FziX9TokaIJr8WiJfwqfVHiMq1
	 2w4LvTPy3fB64SOcGB2Dn6QqT4/VPC2QM4clYrsG5I003aergPlj8Kie+RGSiXUiVdA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795038677;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=A0CWt0ZS4MFpjpW3NvUoHWfHM+obp6uDqAgS3I5m76k=;
	b=z9aNKdft3+8VTAsKAhkawTjqoJnxcsHLHqGeVB+4cpGT4SNVVywbFAhS/TRxQYmsGiOo
	 XiSZruL+EKLidBlXQ+Wsq1Z7iYiV5Ej1ww/NC3ocEaFHeFGSsV7UEOvSIKsJpNHLmeHPm
	 lYwdard9a0HRcalzcMX3KzBIr823immgeA0ZWj7gfe4PUtYx1v3sGlbk5dvMtxs8rzuhl
	 rrpFIPSIeK/fd/2v+3jBkbXumE/hlKcinXajtF64foRGriAPhfOK855yyoUMYwPApFa/M
	 dfYCWPmEuNkLzd5oR1LH7nE2NKfe0lR5hbOqun5Zrjxf4HoRQEdHGdDehGzxAD6gZZQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=V3S+Zkb+;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5E2CB606A320;
	Wed, 18 Nov 2026 21:51:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=V3S+Zkb+
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B3F931F000C4;
	Wed, 18 Nov 2026 21:51:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795038677;
	bh=A0CWt0ZS4MFpjpW3NvUoHWfHM+obp6uDqAgS3I5m76k=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=V3S+Zkb+8bEeHzYkT63aENxxBKoEdAHTqKHUWil6zcSMWwtE4gJjGxhVwBxAgAudC
	 xMNo7Gdu9ioUSiqW+naDejFvgVw7vuhi2By/Ls1D89PIUPdzcaq0njeh23kLFC8RIp
	 jm1Fs/NSH8wMZ3SPrWWY9HXpMmffyM78Jcs9QPgs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Joanne Koong <joannelkoong@gmail.com>,
	Miklos Szeredi <mszeredi@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 1786/3318] fuse: dont drop destination page cache on a zero byte copy reply
Date: Wed, 18 Nov 2026 15:40:08 +0100
Message-ID: <20261118150415.439289017@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150313.527275416@linuxfoundation.org>
References: <20261118150313.527275416@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
[ sashal: used outarg.size instead of bytes_copied to match the existing copy-length handling ]
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/fuse/file.c | 8 +++++---
 1 file changed, 5 insertions(+), 3 deletions(-)

diff --git a/fs/fuse/file.c b/fs/fuse/file.c
index 791824a4273a0..50b25b5304f07 100644
--- a/fs/fuse/file.c
+++ b/fs/fuse/file.c
@@ -3263,9 +3263,11 @@ static ssize_t __fuse_copy_file_range(struct file *file_in, loff_t pos_in,
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



