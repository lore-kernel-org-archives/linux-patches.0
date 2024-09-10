Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3D27518595E;
	Tue, 10 Sep 2024 09:58:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725962281; cv=none; b=K2V98IFfqP1kfsIzhZ1m1nIC0VZCzr8EvV0RUaWnek0xrOItt68eRXBqAjv/ZrjPAAaa9gKCsWHqxuzn7gMkp5yGC8laB2Etzbd14/h0+fkeeLSedeLWlOo+cC7ppD79NuubiWtlK5Cl6vxcpC8LlxM1Vzjv/4BdL88LQJKcses=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725962281; c=relaxed/simple;
	bh=Y9WJmnZLARiinuvVgkXSCpYr9Y0b1tN/lS5Tcddmts8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=qpArL+pEiz2eoIp2tNdHexBxM5M718HSLFn/ztow1Qe3ycrJfwTQfYZlCceCeWoU6T5IF7/gva9UhFIiRymzz2WxenIH6/66CngS3oQ0KWocN1mmBkogju35z70NKvYXFC2PyVVRc7PPqcIbH4cZUBvpoE6HwjKL5JRRWrAasa0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=B63UdKub; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="B63UdKub"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B9402C4CEC3;
	Tue, 10 Sep 2024 09:58:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1725962281;
	bh=Y9WJmnZLARiinuvVgkXSCpYr9Y0b1tN/lS5Tcddmts8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=B63UdKubkd0aZZeSMqh0coqfMi/xnVehJxn55WXfkoStaiWcrBXjANRqlWvnNa0JZ
	 IKHK/kH4kEhIBo47a5oYjc8/VAdJrqrU/2yzKLiyAGOUw6C+1shWwfp3lYU3vKBK3Q
	 vXeESQLpE7hIEQUZqkCL87Y3wqvIZWtUGkl+4kJE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Paulo Alcantara (Red Hat)" <pc@manguebit.com>,
	David Howells <dhowells@redhat.com>,
	Steve French <stfrench@microsoft.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.10 357/375] smb: client: fix double put of @cfile in smb2_rename_path()
Date: Tue, 10 Sep 2024 11:32:34 +0200
Message-ID: <20240910092634.589961294@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240910092622.245959861@linuxfoundation.org>
References: <20240910092622.245959861@linuxfoundation.org>
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

6.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Paulo Alcantara <pc@manguebit.com>

[ Upstream commit 3523a3df03c6f04f7ea9c2e7050102657e331a4f ]

If smb2_set_path_attr() is called with a valid @cfile and returned
-EINVAL, we need to call cifs_get_writable_path() again as the
reference of @cfile was already dropped by previous smb2_compound_op()
call.

Fixes: 71f15c90e785 ("smb: client: retry compound request without reusing lease")
Signed-off-by: Paulo Alcantara (Red Hat) <pc@manguebit.com>
Cc: David Howells <dhowells@redhat.com>
Signed-off-by: Steve French <stfrench@microsoft.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/smb/client/smb2inode.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/fs/smb/client/smb2inode.c b/fs/smb/client/smb2inode.c
index 2a2847601f26..11a1c53c64e0 100644
--- a/fs/smb/client/smb2inode.c
+++ b/fs/smb/client/smb2inode.c
@@ -1106,6 +1106,8 @@ int smb2_rename_path(const unsigned int xid,
 				  co, DELETE, SMB2_OP_RENAME, cfile, source_dentry);
 	if (rc == -EINVAL) {
 		cifs_dbg(FYI, "invalid lease key, resending request without lease");
+		cifs_get_writable_path(tcon, from_name,
+				       FIND_WR_WITH_DELETE, &cfile);
 		rc = smb2_set_path_attr(xid, tcon, from_name, to_name, cifs_sb,
 				  co, DELETE, SMB2_OP_RENAME, cfile, NULL);
 	}
-- 
2.43.0



