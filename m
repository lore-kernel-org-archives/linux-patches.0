Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1F27E522E
	for <patches@lists.linux.dev>; Sun,  9 Jul 2023 11:36:38 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 91A92C433C7;
	Sun,  9 Jul 2023 11:36:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1688902597;
	bh=3i4V4WRCJQPm669W9zfDKuzLO9ZGqs6pCSrwL2Ljz1A=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=AGnwNig24nDA114XX4kENbjQLGTnY6HHr89KhibDqSHcM4PEmMI7ouaJdq3w68aQr
	 gqScv2fmFM8JKo7nJ/3EVFkS8TTxDFoyulFDTk9xdZCeqP885MHaiskzJFQl3x+rRH
	 hdaY45s+lyUNm4mHoUMgUs2r/gvJnNWqcUycgS4U=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Paulo Alcantara (SUSE)" <pc@manguebit.com>,
	Steve French <stfrench@microsoft.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.3 426/431] smb: client: fix broken file attrs with nodfs mounts
Date: Sun,  9 Jul 2023 13:16:14 +0200
Message-ID: <20230709111501.171287759@linuxfoundation.org>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20230709111451.101012554@linuxfoundation.org>
References: <20230709111451.101012554@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Paulo Alcantara <pc@manguebit.com>

[ Upstream commit d439b29057e26464120fc6c18f97433aa003b5fe ]

*_get_inode_info() functions expect -EREMOTE when query path info
calls find a DFS link, regardless whether !CONFIG_CIFS_DFS_UPCALL or
'nodfs' mount option.  Otherwise, those files will miss the fake DFS
file attributes.

Before patch

  $ mount.cifs //srv/dfs /mnt/1 -o ...,nodfs
  $ ls -l /mnt/1
  ls: cannot access '/mnt/1/link': Operation not supported
  total 0
  -rwxr-xr-x 1 root root 0 Jul 26  2022 dfstest2_file1.txt
  drwxr-xr-x 2 root root 0 Aug  8  2022 dir1
  d????????? ? ?    ?    ?            ? link

After patch

  $ mount.cifs //srv/dfs /mnt/1 -o ...,nodfs
  $ ls -l /mnt/1
  total 0
  -rwxr-xr-x 1 root root 0 Jul 26  2022 dfstest2_file1.txt
  drwxr-xr-x 2 root root 0 Aug  8  2022 dir1
  drwx--x--x 2 root root 0 Jun 26 20:29 link

Fixes: c877ce47e137 ("cifs: reduce roundtrips on create/qinfo requests")
Signed-off-by: Paulo Alcantara (SUSE) <pc@manguebit.com>
Signed-off-by: Steve French <stfrench@microsoft.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/cifs/smb2inode.c | 3 ---
 1 file changed, 3 deletions(-)

diff --git a/fs/cifs/smb2inode.c b/fs/cifs/smb2inode.c
index 7e3ac4cb4efa6..8e696fbd72fa8 100644
--- a/fs/cifs/smb2inode.c
+++ b/fs/cifs/smb2inode.c
@@ -609,9 +609,6 @@ int smb2_query_path_info(const unsigned int xid, struct cifs_tcon *tcon,
 			if (islink)
 				rc = -EREMOTE;
 		}
-		if (rc == -EREMOTE && IS_ENABLED(CONFIG_CIFS_DFS_UPCALL) && cifs_sb &&
-		    (cifs_sb->mnt_cifs_flags & CIFS_MOUNT_NO_DFS))
-			rc = -EOPNOTSUPP;
 	}
 
 out:
-- 
2.39.2



