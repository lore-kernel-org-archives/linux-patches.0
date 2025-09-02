Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BB1B931282C;
	Tue,  2 Sep 2025 13:39:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756820371; cv=none; b=fzpIDjdrgp+8SGTOM4fm3kQEcaI+sc6xUjpwyYzAf1ia9wnX0RS8NqJMSnYnxYlsciTu3QL4BttGWEvmsSGH4Mbbrrrvgae8XQBEYj0Ae22JeKPUoDX6qkttB+eB/93JJjD85GA1LD/KTvr5IUhh4N/h3FIHZqLl3oHwuNivFO8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756820371; c=relaxed/simple;
	bh=Nvyhux3PimkNeGWLbTTdrTQe5hfVwVsyZ4cqW1M3zRI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=qN367NO3/QIqqEfJ+BSPjgGPORtNwULNC6RSKlP5wAv+asqlk3cENEFnvGmYmHQRJe/bfCsrSEj76jtJ7Uc4rfnXnZ8SUsR0qFxH50lKv7X4EIaxJc9zXc8RpNJtRmXlBZjYa6ovumIsocED2MlCN+GeNn7Le9wY3uDIwGTIVYI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=po+DZRcB; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="po+DZRcB"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 29FC9C4CEF5;
	Tue,  2 Sep 2025 13:39:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1756820371;
	bh=Nvyhux3PimkNeGWLbTTdrTQe5hfVwVsyZ4cqW1M3zRI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=po+DZRcBqyUtb65B0W9Agdkh2RoljuP2RK5pQBm1pVINR7i3sni1ek58LsdJY+PjQ
	 8BSuUvpezkAsLFzB2OXHyvHTgl6EDEIjQyQ59WfDfIDuok8zm6wBeqhxjm7Etgyhh2
	 psWwuvEajJmT5GGVtXjGKzr/An2aSIMRFZylrEUg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Paulo Alcantara (Red Hat)" <pc@manguebit.org>,
	Steve French <stfrench@microsoft.com>
Subject: [PATCH 6.6 68/75] smb3 client: fix return code mapping of remap_file_range
Date: Tue,  2 Sep 2025 15:21:20 +0200
Message-ID: <20250902131937.781693913@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20250902131935.107897242@linuxfoundation.org>
References: <20250902131935.107897242@linuxfoundation.org>
User-Agent: quilt/0.68
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

From: Steve French <stfrench@microsoft.com>

commit 0e08fa789d39aa01923e3ba144bd808291895c3c upstream.

We were returning -EOPNOTSUPP for various remap_file_range cases
but for some of these the copy_file_range_syscall() requires -EINVAL
to be returned (e.g. where source and target file ranges overlap when
source and target are the same file). This fixes xfstest generic/157
which was expecting EINVAL for that (and also e.g. for when the src
offset is beyond end of file).

Cc: stable@vger.kernel.org
Acked-by: Paulo Alcantara (Red Hat) <pc@manguebit.org>
Signed-off-by: Steve French <stfrench@microsoft.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/smb/client/cifsfs.c |   14 ++++++++++++++
 1 file changed, 14 insertions(+)

--- a/fs/smb/client/cifsfs.c
+++ b/fs/smb/client/cifsfs.c
@@ -1371,6 +1371,20 @@ static loff_t cifs_remap_file_range(stru
 			netfs_resize_file(&target_cifsi->netfs, new_size);
 			fscache_resize_cookie(cifs_inode_cookie(target_inode),
 					      new_size);
+		} else if (rc == -EOPNOTSUPP) {
+			/*
+			 * copy_file_range syscall man page indicates EINVAL
+			 * is returned e.g when "fd_in and fd_out refer to the
+			 * same file and the source and target ranges overlap."
+			 * Test generic/157 was what showed these cases where
+			 * we need to remap EOPNOTSUPP to EINVAL
+			 */
+			if (off >= src_inode->i_size) {
+				rc = -EINVAL;
+			} else if (src_inode == target_inode) {
+				if (off + len > destoff)
+					rc = -EINVAL;
+			}
 		}
 	}
 


