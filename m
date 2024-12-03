Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F11B41F6674;
	Tue,  3 Dec 2024 14:40:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733236846; cv=none; b=pLBQO6fVFEwmnidDMtC1+bmuPwupxttRp8IAp6eqd7heYfLn6xhOlLiEubT+QzSPj74YFOLtypaSMjUmQsZ4Dn/4FfpSQqBpcMoUkcC/nhCfw7nMTdSQeeBb88oPmYeCwnPZk/rdzcc2vVSfetZefPBpeiv50wujs3LiN/Kj/0o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733236846; c=relaxed/simple;
	bh=W8WHrJE3DOOCB6OUuF2y2ge+1Hg/vZH+8fQMVaMK6sE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=M0q4zb70Zagva36m8kxXLyqMHu+L2ZUok9RIFHpx/GKGILnd75HrrXxnhbmL58s6enEL6uzksVnkOIwI2XwviFkXBX6p6PeMa6tOyogbZJ6pQ4Wafq1sEG7Aw7BIfkix3aphOMN3pMzpDfZIHT5jUnO3GLumkEt6Vxh06lXouo0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=n1+8Z1wQ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="n1+8Z1wQ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5C0AAC4CECF;
	Tue,  3 Dec 2024 14:40:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1733236845;
	bh=W8WHrJE3DOOCB6OUuF2y2ge+1Hg/vZH+8fQMVaMK6sE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=n1+8Z1wQpG358KOGfZdccOrMx2qvuaDL0BSTnl+TB+o7KD8AOPfUKUaVDA0qfEgU5
	 PDql0MIi1nBHD/eztBEkc+Y7TcBatDyaO4jybuUlujoivooBTE58KAJ1tSvWJgiDnq
	 GucDj63qKWjFpfVdGoM/N4QO9LsU8zVMqrH/qMqA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Artem Sadovnikov <ancowi69@gmail.com>,
	Dave Kleikamp <dave.kleikamp@oracle.com>
Subject: [PATCH 4.19 102/138] jfs: xattr: check invalid xattr size more strictly
Date: Tue,  3 Dec 2024 15:32:11 +0100
Message-ID: <20241203141927.467401351@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241203141923.524658091@linuxfoundation.org>
References: <20241203141923.524658091@linuxfoundation.org>
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

4.19-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Artem Sadovnikov <ancowi69@gmail.com>

commit d9f9d96136cba8fedd647d2c024342ce090133c2 upstream.

Commit 7c55b78818cf ("jfs: xattr: fix buffer overflow for invalid xattr")
also addresses this issue but it only fixes it for positive values, while
ea_size is an integer type and can take negative values, e.g. in case of
a corrupted filesystem. This still breaks validation and would overflow
because of implicit conversion from int to size_t in print_hex_dump().

Fix this issue by clamping the ea_size value instead.

Found by Linux Verification Center (linuxtesting.org) with Syzkaller.

Cc: stable@vger.kernel.org
Signed-off-by: Artem Sadovnikov <ancowi69@gmail.com>
Signed-off-by: Dave Kleikamp <dave.kleikamp@oracle.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/jfs/xattr.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/fs/jfs/xattr.c
+++ b/fs/jfs/xattr.c
@@ -572,7 +572,7 @@ static int ea_get(struct inode *inode, s
 
       size_check:
 	if (EALIST_SIZE(ea_buf->xattr) != ea_size) {
-		int size = min_t(int, EALIST_SIZE(ea_buf->xattr), ea_size);
+		int size = clamp_t(int, ea_size, 0, EALIST_SIZE(ea_buf->xattr));
 
 		printk(KERN_ERR "ea_get: invalid extended attribute\n");
 		print_hex_dump(KERN_ERR, "", DUMP_PREFIX_ADDRESS, 16, 1,


