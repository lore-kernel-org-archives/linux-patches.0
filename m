Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795621950;
	b=Es8SdZ2c66/XF/exDDVVW+BBDm32h7/zD9K2pWEguWdxdumAeDM63EzCipqkaJh2Daiq
	 yJPBJR27rRmfNaRI3sWDsN5Bm8X0mjRsViB3ICrn2EdyCbjGW4oFcg7PBFMZ/yfGKZcLh
	 jVBMgm9NhUE4mry73MsKWVaqn/EvETnGpdIiTWFprx2LNtDLNUhdI/aSs20uo2JM8q+l8
	 noKo7AziFy885f8Yu7jOK3tVQhLKwUf8TDntJ3K3EHExLZfsFdVW4acbPGbVGjyHC56Po
	 F7L2x8nvTTW7vY57akJecrBLgdQMnS+uNg6huo7YzHmPhLeTf6KLcV3b61zuum+fmyA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795621950;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=sFN5q7A8LJbxlFbYlSSB6PpMHs7OicbRjb4xyRCUwI8=;
	b=jH/oTQcaJKRTU3w/WYfnRT22ZcAf/V+MZIlZgH8GuYm0HnLriv+zEd3dlfJmfK8difXA
	 Coe9DSiQijEwL/Aa8SM3eR+puM59ZUCpd1qA619G2zP0UJG53xuKXucQ/hGYyDAWeXxsr
	 2NyzuOj1RjF5cktIMw4722y/kRTld93wdDnTrdhjMHjzijooSl/I+WxyT0Ihf/SK9FCIa
	 OaICePWhf7+WFENcFxoEqxXlfVv8r3DXWtyGnw7DdrrNsza3qVcPqVeSZzr89HDzwDjgd
	 /CZRl3P4QUAgrLzCBNAmBMd3VhsIwtVir7k/LqAKenF3/O6NbgVpCteeBhzr6CmWX6Q==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=1eK1DqsH;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 45173606A327;
	Wed, 25 Nov 2026 15:52:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=1eK1DqsH
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 75E1A1F000D4;
	Wed, 25 Nov 2026 15:52:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795621950;
	bh=sFN5q7A8LJbxlFbYlSSB6PpMHs7OicbRjb4xyRCUwI8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=1eK1DqsHTG4HwIpBhm2iAO0tg5M8D2dYS8eyvr8mUta1CLWH1o/x5CXlRBCGcV+na
	 uaaJN02Q0/J9r5hy04t+1S8xWtjIHf9cUKAYoyZDdfLpsrPFe0gxAG/LnIde0DxPbF
	 VwCdZmfy9KkzAdvJtp/zFjrVoc9KH0XbARjuyShU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Avi Weiss <thnkslprpt@gmail.com>,
	Anna Schumaker <anna.schumaker@hammerspace.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 382/990] NFS: Fix inverted cross-directory rename check
Date: Wed, 25 Nov 2026 15:29:09 +0100
Message-ID: <20261125143831.041606089@linuxfoundation.org>
X-Mailer: git-send-email 2.56.1
In-Reply-To: <20261125143822.072087159@linuxfoundation.org>
References: <20261125143822.072087159@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Avi Weiss <thnkslprpt@gmail.com>

[ Upstream commit b9d518902ff1969f93d2b4787951d98e50ab0181 ]

nfs_rename_is_unsafe_cross_dir() returns false for cross-directory
renames, causing nfs_rename() to skip nfs_sync_inode() even when
filehandles may expire on rename. Same-directory renames may instead
trigger unnecessary synchronization.

Current condition directly contradicts the function name/comments.

Return false for same-directory renames so cross-directory renames
reach the existing filehandle-volatility check. Keep the conservative
fallback unchanged..

Fixes: dcd21b609d4ab ("NFS: Avoid flushing data while holding directory locks in nfs_rename()")
Signed-off-by: Avi Weiss <thnkslprpt@gmail.com>
Signed-off-by: Anna Schumaker <anna.schumaker@hammerspace.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/nfs/dir.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/nfs/dir.c b/fs/nfs/dir.c
index 4dc91428c79cc..ca91e48dc7973 100644
--- a/fs/nfs/dir.c
+++ b/fs/nfs/dir.c
@@ -2687,7 +2687,7 @@ static bool nfs_rename_is_unsafe_cross_dir(struct dentry *old_dentry,
 {
 	struct nfs_server *server = NFS_SB(old_dentry->d_sb);
 
-	if (old_dentry->d_parent != new_dentry->d_parent)
+	if (old_dentry->d_parent == new_dentry->d_parent)
 		return false;
 	if (server->fh_expire_type & NFS_FH_RENAME_UNSAFE)
 		return !(server->fh_expire_type & NFS_FH_NOEXPIRE_WITH_OPEN);
-- 
2.53.0



