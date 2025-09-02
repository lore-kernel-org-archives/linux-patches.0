Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E26B7322A2A;
	Tue,  2 Sep 2025 13:41:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756820482; cv=none; b=uE6tnVweQlUL2U/59h1X1mg3tz6SdKplSNGKFXYa5n3bgPSrSEwnGzwMWQ6WCfQdWUG9bWjnItZjCpCXSm76L4P55iWDxhWabhPB0/Dle46PiicpvNlefMwONtylqGX0Ju2awHxuHO73NmFzmkgB/F1wVuS9nJDiUpHCn9pV2Bg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756820482; c=relaxed/simple;
	bh=RDmuU69rXIxpbcRaEQuz41zrjX9QCvE5buEvbPCjKmo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=DohZialvFUQLA/KqSiE2KRFjGNkqDP4ntOiFmyFsnrcUPvmDC4wI/s+ravdm5Wdt/QXOWUoBC5+X/JKcOz/vP+OYzF6hFvuog7PdB+eToBAugbCTyY8BlodufqzROnYGR427cP0+AqS9IOARPlXhvZ4BeESdNRzOPrHIPQj3FXw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=C8cTDqDf; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="C8cTDqDf"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 66362C4CEF4;
	Tue,  2 Sep 2025 13:41:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1756820481;
	bh=RDmuU69rXIxpbcRaEQuz41zrjX9QCvE5buEvbPCjKmo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=C8cTDqDfQVDkGk/1A+z4jiO0/Z35ysScM6H38E/t4+T6M3LYg7ivakOzfNWw5EIVx
	 pgVpRwaXQ0tLvccHHGUn+lX3HKWL+fRLyDvd2N6vAI97wIP+YdtEl5Yykbpp92BXqv
	 IZ9K8OUSMuUqUstrI/Hqy9SWCLYyJCKcJKAoBBNU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Paulo Alcantara (Red Hat)" <pc@manguebit.org>,
	Steve French <stfrench@microsoft.com>
Subject: [PATCH 6.1 44/50] smb3 client: fix return code mapping of remap_file_range
Date: Tue,  2 Sep 2025 15:21:35 +0200
Message-ID: <20250902131932.265355235@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20250902131930.509077918@linuxfoundation.org>
References: <20250902131930.509077918@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
@@ -1363,6 +1363,20 @@ static loff_t cifs_remap_file_range(stru
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
 


