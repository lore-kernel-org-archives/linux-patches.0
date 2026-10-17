Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D194D3515CE;
	Sat, 17 Oct 2026 17:24:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792257856; cv=none; b=KxnDHpcJQV9NT9C/Vxx6h9R86FJSVwkbLnOZdsXJQiM2gFpKxzotTR8X8BM3XuPXLADGyQRFa7r3M86w9m4EgoM8E2XPygvkDhJptvrus4a9ZBIYzKOfmNqdEj/g7KooL9pxM717fwDos0EuYdA8fQhAxIyhBm5sQNCgQruQE00=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792257856; c=relaxed/simple;
	bh=Z43Kz+HRZoPUMeRcABbrrmkSo0srpeE35eHWhSovO+k=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=r9Pt0dQ7BQJIBRjt9M8iRQiBTILyjQNo5zzo9pb8K3sUkF0QwhJiiMuC1LUX3hRlgBQLu7TzV7x42GnJrnFYa1Q/EFzTGB+Tnu0FVDZ74FQQ1Nm5pl6fU3eZ0Hf9cLc1uFkvDX0KwKxtDAV3UcuGPX9QT4I2WLC8tdnRyIeyKM4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=d9ZA+z5c; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="d9ZA+z5c"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 29A681F000C4;
	Sat, 17 Oct 2026 17:24:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1792257854;
	bh=Fr5OMKFOglDt6BmbZKjX97x65zTQWesaDwQ3y2k/awk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=d9ZA+z5c+9lNgLf3wC32xugzGhRpwQI2NxbQngEOt9LQIi5E5NdZ+Y9k4YhnIQQP3
	 DGU/mME5h43mnzSwhM0A3Vzu53g7Xag11rEmbjDqjePXod+MEmhRv+hVO6FHhaZke7
	 Cp0hCBJ4zm8Hj0Jb3Qu0I7bZkgXZkHMHoyNVf0Wc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	syzbot+5b667f9a1fee4ba3775a@syzkaller.appspotmail.com,
	Christian Schoenebeck <linux_oss@crudebyte.com>,
	Dominique Martinet <asmadeus@codewreck.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 0691/1674] fs/9p: fix NULL pointer dereference on mkdir
Date: Sat, 17 Oct 2026 17:49:23 +0200
Message-ID: <20261017160448.843871409@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261017160431.119607952@linuxfoundation.org>
References: <20261017160431.119607952@linuxfoundation.org>
User-Agent: quilt/0.69
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

From: Christian Schoenebeck <linux_oss@crudebyte.com>

[ Upstream commit 3f61ac7c65bdb26accb52f9db66313597e759821 ]

When a 9p tree was mounted with option 'posixacl', parent directory had a
default ACL set for its subdirectories, e.g.:

  setfacl -m default:group:simpsons:rwx parentdir

then creating a subdirectory crashed 9p client, as v9fs_fid_add() call in
function v9fs_vfs_mkdir_dotl() sets the passed 'fid' pointer to NULL
(since dafbe689736) even though the subsequent v9fs_set_create_acl() call
expects a valid non-NULL 'fid' pointer:

  [   37.273191] BUG: kernel NULL pointer dereference, address: 0000000000000000
  ...
  [   37.322338] Call Trace:
  [   37.323043]  <TASK>
  [   37.323621] ? __die (arch/x86/kernel/dumpstack.c:421 arch/x86/kernel/dumpstack.c:434)
  [   37.324448] ? page_fault_oops (arch/x86/mm/fault.c:714)
  [   37.325532] ? search_module_extables (kernel/module/main.c:3733)
  [   37.326742] ? p9_client_walk (net/9p/client.c:1165) 9pnet
  [   37.328006] ? search_bpf_extables (kernel/bpf/core.c:804)
  [   37.329142] ? exc_page_fault (./arch/x86/include/asm/paravirt.h:686 arch/x86/mm/fault.c:1488 arch/x86/mm/fault.c:1538)
  [   37.330196] ? asm_exc_page_fault (./arch/x86/include/asm/idtentry.h:574)
  [   37.331330] ? p9_client_walk (net/9p/client.c:1165) 9pnet
  [   37.332562] ? v9fs_fid_xattr_get (fs/9p/xattr.c:30) 9p
  [   37.333824] v9fs_fid_xattr_set (fs/9p/fid.h:23 fs/9p/xattr.c:121) 9p
  [   37.335077] v9fs_set_acl (fs/9p/acl.c:276) 9p
  [   37.336112] v9fs_set_create_acl (fs/9p/acl.c:307) 9p
  [   37.337326] v9fs_vfs_mkdir_dotl (fs/9p/vfs_inode_dotl.c:411) 9p
  [   37.338590] vfs_mkdir (fs/namei.c:4313)
  [   37.339535] do_mkdirat (fs/namei.c:4336)
  [   37.340465] __x64_sys_mkdir (fs/namei.c:4354)
  [   37.341455] do_syscall_64 (arch/x86/entry/common.c:52 arch/x86/entry/common.c:83)
  [   37.342447] entry_SYSCALL_64_after_hwframe (arch/x86/entry/entry_64.S:130)

Fix this by simply swapping the sequence of these two calls in
v9fs_vfs_mkdir_dotl(), i.e. calling v9fs_set_create_acl() before
v9fs_fid_add().

Fixes: dafbe689736f ("9p fid refcount: cleanup p9_fid_put calls")
Reported-by: syzbot+5b667f9a1fee4ba3775a@syzkaller.appspotmail.com
Signed-off-by: Christian Schoenebeck <linux_oss@crudebyte.com>
Message-ID: <E1tsiI6-002iMG-Kh@kylie.crudebyte.com>
Signed-off-by: Dominique Martinet <asmadeus@codewreck.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/9p/vfs_inode_dotl.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/9p/vfs_inode_dotl.c b/fs/9p/vfs_inode_dotl.c
index b870e3bba940b..f309464aee4da 100644
--- a/fs/9p/vfs_inode_dotl.c
+++ b/fs/9p/vfs_inode_dotl.c
@@ -409,8 +409,8 @@ static int v9fs_vfs_mkdir_dotl(struct mnt_idmap *idmap,
 			 err);
 		goto error;
 	}
-	v9fs_fid_add(dentry, &fid);
 	v9fs_set_create_acl(inode, fid, dacl, pacl);
+	v9fs_fid_add(dentry, &fid);
 	d_instantiate(dentry, inode);
 	err = 0;
 	inc_nlink(dir);
-- 
2.53.0



