Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6990038DC59;
	Sat, 12 Sep 2026 09:15:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789204542; cv=none; b=rKCPvpYIWYmLidN2uV0SEbmNyGvLOaytjykWXWxOZUvJb/iLdmLn0jYBueEk+gLSA7uCorjVweXsFqdZhoaikZIyHTACGsgF0stt5Bgpx0sqKzcN9AtCWMta1DJKyJpKR7p82yZgB0IO92oFyIi2MqU993kjZK7m/HQh0VRhUSE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789204542; c=relaxed/simple;
	bh=4SAuDoyb7sITTjyo92wg2UwE/HRlKVvMoEOzmz5RY8k=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Dkhem1VwDICzx1DDuo4lYQX04zsqpYByQnx0AAoYLrza9dwSfgelUJZDM6Mb6DkGOlp9MmIL6kM9Z+VIy3yurdF8SW8u9xY93oT4pNjXDum6qCU6E3GJmT5rt0FqlqXZd9rqs1kaPTq5DPML28tWVQke2i8eJUd0fMKcyoBWU5Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=wlHV3HYD; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="wlHV3HYD"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 60CAD1F00898;
	Sat, 12 Sep 2026 09:15:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789204540;
	bh=O+M3hht+ta3+MPY+QIL9NJC2ham3gB4DvmZwqmZowMY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=wlHV3HYDthBOcmTVzjMF4LbPQ7tiw770+55ZYmfk86miqpLU0jSou1V28UckpLWfc
	 sQfJvHCahl7ANreBdBp9BfJj8ZCQSyK6SGT9IAzkQElpJcClriIMs7o1GoL+bUU2xS
	 rsC9uzyzz7fclQWKHJEux5A0Mta72V++HKsFc1js=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Frank Sorenson <sorenson@redhat.com>,
	Huiwen He <hehuiwen@kylinos.cn>,
	Namjae Jeon <linkinjeon@kernel.org>,
	Paulo Alcantara <pc@manguebit.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.2 1633/1815] cifs: remove dead size-update blocks in cifs_setattr_unix/nounix
Date: Sat, 12 Sep 2026 08:56:23 +0200
Message-ID: <20260912065727.324979496@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065648.999753832@linuxfoundation.org>
References: <20260912065648.999753832@linuxfoundation.org>
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

7.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Frank Sorenson <sorenson@redhat.com>

[ Upstream commit 60be95527bc8d1b33dca25d2a849268cca11d139 ]

Commit 110fee6b9bb5 ("smb: client: fix missing timestamp updates with
O_TRUNC") introduced cifs_file_set_size(), which calls netfs_resize_file()
and cifs_setsize() on success.  cifs_setsize() calls i_size_write(),
updating i_size to the new value.  The subsequent blocks in both
cifs_setattr_unix() and cifs_setattr_nounix():

    if ((attrs->ia_valid & ATTR_SIZE) &&
        attrs->ia_size != i_size_read(inode)) {
        truncate_setsize(inode, attrs->ia_size);
        netfs_resize_file(&cifsInode->netfs, attrs->ia_size, true);
        fscache_resize_cookie(cifs_inode_cookie(inode), attrs->ia_size);
    }

are therefore unreachable on the success path: attrs->ia_size ==
i_size_read(inode) always holds after cifs_file_set_size() succeeds.
On the failure path, execution jumps to out/cifs_setattr_exit before
reaching these blocks.

truncate_setsize() and netfs_resize_file() are redundant with what
cifs_file_set_size() already did; fscache_resize_cookie() was moved there
by commit fa724e235cfd ("cifs: add fscache_resize_cookie() to
cifs_setsize()").  Remove both dead blocks.

Fixes: 110fee6b9bb5 ("smb: client: fix missing timestamp updates with O_TRUNC")
Signed-off-by: Frank Sorenson <sorenson@redhat.com>
Reviewed-by: Huiwen He <hehuiwen@kylinos.cn>
Signed-off-by: Namjae Jeon <linkinjeon@kernel.org>
Signed-off-by: Paulo Alcantara <pc@manguebit.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/smb/client/inode.c | 14 --------------
 1 file changed, 14 deletions(-)

diff --git a/fs/smb/client/inode.c b/fs/smb/client/inode.c
index aec8ed8881a6c..85ef8fff0e842 100644
--- a/fs/smb/client/inode.c
+++ b/fs/smb/client/inode.c
@@ -3310,13 +3310,6 @@ cifs_setattr_unix(struct dentry *direntry, struct iattr *attrs)
 	if (rc)
 		goto out;
 
-	if ((attrs->ia_valid & ATTR_SIZE) &&
-	    attrs->ia_size != i_size_read(inode)) {
-		truncate_setsize(inode, attrs->ia_size);
-		netfs_resize_file(&cifsInode->netfs, attrs->ia_size, true);
-		fscache_resize_cookie(cifs_inode_cookie(inode), attrs->ia_size);
-	}
-
 	setattr_copy(&nop_mnt_idmap, inode, attrs);
 	mark_inode_dirty(inode);
 
@@ -3537,13 +3530,6 @@ cifs_setattr_nounix(struct dentry *direntry, struct iattr *attrs)
 	if (rc)
 		goto cifs_setattr_exit;
 
-	if ((attrs->ia_valid & ATTR_SIZE) &&
-	    attrs->ia_size != i_size_read(inode)) {
-		truncate_setsize(inode, attrs->ia_size);
-		netfs_resize_file(&cifsInode->netfs, attrs->ia_size, true);
-		fscache_resize_cookie(cifs_inode_cookie(inode), attrs->ia_size);
-	}
-
 	setattr_copy(&nop_mnt_idmap, inode, attrs);
 	mark_inode_dirty(inode);
 
-- 
2.53.0



