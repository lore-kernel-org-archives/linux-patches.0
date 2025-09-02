Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8C51530E83C;
	Tue,  2 Sep 2025 13:34:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756820065; cv=none; b=EeVPJcvvFMswBM/0cBjkabkpEsPQIsSG7FaFDRAnGQCZNzgPwIV9BQaCT5Mh/P32HGqTsXarANYQC//41QohKjvHbVVZdNLQk4yWYbZgL2yf+bvcuD4dHhGMX6m2ctcXUm6MJO3q/Wk4RTn8goRsXrt430f7IQB8VJFfWCOOfxc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756820065; c=relaxed/simple;
	bh=KHZiAg0NR65eXIIwe6nXNe1pMyZwUFLuM9PwUONY5Qw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=X/sxSrI58rrQPx0RFFxNOtppXT/VpjQzSm10j+nD4CQu9zMAsh8cyx11Ubps3Vb+OJTB0L3TamBuPSJ5Zo0eGfZuyWvDbRU/zfhzFlzzYPtFbIMxaa2nPC7Q84hZx6leuMwvzWd8AiAqFOrQAyRI9IQ9GqutziCifPBsVSpPhDc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=I+oW3cqU; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="I+oW3cqU"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A79ABC4CEED;
	Tue,  2 Sep 2025 13:34:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1756820065;
	bh=KHZiAg0NR65eXIIwe6nXNe1pMyZwUFLuM9PwUONY5Qw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=I+oW3cqUdqyQCJW7FaG935LVIfDyFCvVaSP0oeXsnv4o+W5O2iFzg4yK3C8ROw+vO
	 6hyCyP7iUAkw1bMJrwXgt/kwQnD8oIeSZDNrG9fCIaZxcZtiawhPxpkYSrX5xRHA+c
	 AOeIOon0b38ibBW7MuNxK4bAbtC/FL0u2Ivl5T38=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Paulo Alcantara (Red Hat)" <pc@manguebit.org>,
	Steve French <stfrench@microsoft.com>
Subject: [PATCH 6.12 82/95] smb3 client: fix return code mapping of remap_file_range
Date: Tue,  2 Sep 2025 15:20:58 +0200
Message-ID: <20250902131942.752676105@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20250902131939.601201881@linuxfoundation.org>
References: <20250902131939.601201881@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
@@ -1348,6 +1348,20 @@ static loff_t cifs_remap_file_range(stru
 			truncate_setsize(target_inode, new_size);
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
 		if (rc == 0 && new_size > target_cifsi->netfs.zero_point)
 			target_cifsi->netfs.zero_point = new_size;


