Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 20B371F4709;
	Tue,  3 Dec 2024 15:25:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733239516; cv=none; b=SOlghXWoiheuRNmO0Kt6ECfYK64Ld5wFNlddgBJ6H+gOTHTKor5iRarFCNhwBp4dyHdRX0IgHvHapG51VXPpq3EXNOENd1JYfS4ISp2/NKKNBapIQ48Vd5w8uk0x2+TqYMRhkRjjnHFeQMU2s5k8JrM7r2sm3Ykit5QbKqfS6NM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733239516; c=relaxed/simple;
	bh=RJpQa0NLxdVS9ri6025jGH6Z6QkCvJaGv+TqFLmi9FY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ZJ87WG5wpUbFPxU0WSDB2BS7mgsmaXbH9MULh+ILO1+pduLVhf9fUBExRqY8BOVT1Afwk0xlk9BnVFE4QfaE6yAHfgM9DAW+RXAz0weiExnn+R0fGDHD6IY7SXDdYl68lh+YQS1odLb+1fP17NEge97kxvaSgmZf4SCSe8aWAY0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=TW0VLMuQ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="TW0VLMuQ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9EF93C4CECF;
	Tue,  3 Dec 2024 15:25:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1733239516;
	bh=RJpQa0NLxdVS9ri6025jGH6Z6QkCvJaGv+TqFLmi9FY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=TW0VLMuQug+VHcp3O1iTBtUNASbPUbSuwRWMqrf/IVKtSqssPT9nO26eQBLHVAqe/
	 A2OitGDu4B6VqMzXYTUIkxzgu9yDpp+gxZYUIja2Qa/mGGx3xbdIsvIDTD+OioZP21
	 AuiSpDDhvXsDc9WEdMT7lxdRWav6aGpW0OUxNIKo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Artem Sadovnikov <ancowi69@gmail.com>,
	Dave Kleikamp <dave.kleikamp@oracle.com>
Subject: [PATCH 6.11 639/817] jfs: xattr: check invalid xattr size more strictly
Date: Tue,  3 Dec 2024 15:43:31 +0100
Message-ID: <20241203144020.892188548@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241203143955.605130076@linuxfoundation.org>
References: <20241203143955.605130076@linuxfoundation.org>
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

6.11-stable review patch.  If anyone has any objections, please let me know.

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
@@ -559,7 +559,7 @@ static int ea_get(struct inode *inode, s
 
       size_check:
 	if (EALIST_SIZE(ea_buf->xattr) != ea_size) {
-		int size = min_t(int, EALIST_SIZE(ea_buf->xattr), ea_size);
+		int size = clamp_t(int, ea_size, 0, EALIST_SIZE(ea_buf->xattr));
 
 		printk(KERN_ERR "ea_get: invalid extended attribute\n");
 		print_hex_dump(KERN_ERR, "", DUMP_PREFIX_ADDRESS, 16, 1,


