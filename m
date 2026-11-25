Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795624758;
	b=SNuCUdORi0XzDAtrI8jE19VCaloG1HbwyYCcCVe8Y/bvbSEca3hN5mK+P+ZAxFQT+wYZ
	 dkUeiKZMZVMRMCFxwKngxMsQkQQx4DntRQwOtH+0360stABM/aS38M3dDi6VLN7o3dNO1
	 QecWTdEjKQkAaTS5Qyj1ziZNrFtP3HzuKjESa0G1r9BPN/oc0ZkGp+PIPgYX5jjgi0KlO
	 LKRCHRqQJ+AfzIbDw/77JXoS8hs3yygGvcVHKHnWKylLFGvyiFZXcprAv0leRXxfWIrV+
	 RSRpJ3IVemLBRWuz0YC/uAsP9uFMqqJKBG5l04ZYvOK40fMQUvC7MPNDW2x6ecMIfEg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795624758;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=MW+FzLbd8ecVLNM7F4bYKrgaf9uUAoUajIiF9O0HtO0=;
	b=rN/aoJWDrd1Hr5LxGm54NZmT4kVQcfC9cMkGVr4o3hJex/JG1rGF6caoHZ/uh3KdRypr
	 g1RpLFXmLhR/q0TAXhyhE4C5D4FrX2iUPfSjb5JVLqFmaH2TAhjFH5xccKdeTzLf12Tha
	 X6vpfqN/NxAjjdeV4vopZDjLvIUADF5++UxR75Aj46jVmm1dzJZ0ALf5AmGRIFRLaxnJR
	 Llm8sDEuXE5Q8FooqqTnlc/jCUySN+IwNsXCR4nTyd3H+iahx4JA6D4JLzn0BpGnHEYOu
	 ytkL/+Pe+2RZXSYScIOZEFGIAXymINQUxhH/N7Fe0w1Eo85CJ6xGOPx2W2rDHqCMwyw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=dWNG8Doi;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7F519606A336;
	Wed, 25 Nov 2026 16:39:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=dWNG8Doi
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 788571F000CF;
	Wed, 25 Nov 2026 16:39:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795624758;
	bh=MW+FzLbd8ecVLNM7F4bYKrgaf9uUAoUajIiF9O0HtO0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=dWNG8Doi4zdO8nWJbkRHaC5Sd7IfJA9wiFeVZuUDAaZqwzAMMlOtuYnRaJt68d/ZR
	 DabkoIJoRCbK6tZIvapFfIVGAHivQdY7QK61nzVFttgBvY21XFvIHZTvOSXq8S/5b5
	 J7Louk4QTj2hufQdv0gv9X+qYdHnvHRapBn4Sy1c=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Avi Weiss <thnkslprpt@gmail.com>,
	Anna Schumaker <anna.schumaker@hammerspace.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 298/816] NFS: Fix inverted cross-directory rename check
Date: Wed, 25 Nov 2026 15:30:46 +0100
Message-ID: <20261125143856.104121953@linuxfoundation.org>
X-Mailer: git-send-email 2.56.1
In-Reply-To: <20261125143849.205329330@linuxfoundation.org>
References: <20261125143849.205329330@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
index 3b07cda9a8f43..1824cc9040d02 100644
--- a/fs/nfs/dir.c
+++ b/fs/nfs/dir.c
@@ -2701,7 +2701,7 @@ static bool nfs_rename_is_unsafe_cross_dir(struct dentry *old_dentry,
 {
 	struct nfs_server *server = NFS_SB(old_dentry->d_sb);
 
-	if (old_dentry->d_parent != new_dentry->d_parent)
+	if (old_dentry->d_parent == new_dentry->d_parent)
 		return false;
 	if (server->fh_expire_type & NFS_FH_RENAME_UNSAFE)
 		return !(server->fh_expire_type & NFS_FH_NOEXPIRE_WITH_OPEN);
-- 
2.53.0



