Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795054286;
	b=p01PjFZ7VIKoNBa5j568LHw+zdgqJJwkk1iyolU9OxlywppjlP1VqciKTiSZAyt0zZ8b
	 vvVyp7KMPeAfRRPNj+VHTIGZvWnXcI9VPIKPH5Ct20E2FO+AijyfERF+XrHkDA861opdn
	 If6Nm/C+4Pb18FvuRR3VudE6HllvzJzDzflSdgNbVV7Tt5dsuOXrjfSeTG1qIiy4n3taC
	 gnR2kn5b0VZUIcmRTht5b9J3UQ8cAY0ckrA19mJ7Fxw51IhS/x3H62QcvqX9QIsnJdLwn
	 fLp+tkyvKQkY6z2z56ZMb1aI8oqKKWPSqE5QHP86GapYll7TogvPeUQ0GBi4ZYTD6ng==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795054286;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=4hzmH4OTmjGQSj9ws4Mxfsil43o6xDul9DcqEzUjFAg=;
	b=VVhU5rikKS1pTG51bg2r6S+8sDHCEO8NZg7UGlbqsaeSVPEpFoDyUsipD6mcQ+jF53Hx
	 MukgkVyYpkVjw7FPbGUS8u0XS5txlROyUQzEY7uSTBNLze1Pt/6UXsBUv9SvERCuo3KW+
	 A/19vBVLQaWe0W1z+bAFMGMCNRNZTwNFUIIk0fxQdx1YLh50BlPErZ3qToDv8duFZyNFX
	 GgBm0gKbJpugN9Mll3NLnxA6WgKeLmY7vqKLMaxAEYGnPTjVxBjRsrQ+6L4JTIS99de4w
	 q+qbt53lhMojnEu7ZRezAZPEpAN4l7WH8p7WpbgdD0VUhWHkUc3TXBIsBt7iC74g08g==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=t5AKQ2mh;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8C908606A32A;
	Thu, 19 Nov 2026 02:11:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=t5AKQ2mh
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D9D871F000C5;
	Thu, 19 Nov 2026 02:11:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795054286;
	bh=4hzmH4OTmjGQSj9ws4Mxfsil43o6xDul9DcqEzUjFAg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=t5AKQ2mhYT9Uq4mAAX0PWATwZ7xRERxqqX8Fz5ZIbRw9SXz7v3dv1TiuxcnT9xTDS
	 goATRyF3OKV2BdMZhQAoLUSOkLdUbnKub3sVYGt0YwzRk68+2exLb11Nc+b2wibUyi
	 yjl6pS4iVlzaVtFwJTc54Mpa6vIfDhQQH3ynQ38g=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Al Viro <viro@zeniv.linux.org.uk>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 1221/2214] /proc/sys: use d_splice_alias() calling conventions to simplify failure exits
Date: Wed, 18 Nov 2026 15:48:17 +0100
Message-ID: <20261118150100.621299142@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150009.797899913@linuxfoundation.org>
References: <20261118150009.797899913@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Al Viro <viro@zeniv.linux.org.uk>

[ Upstream commit 1eae9a47835ed4703055afbb3c52fef6d07a8a4c ]

Signed-off-by: Al Viro <viro@zeniv.linux.org.uk>
Stable-dep-of: eeecea75ece2 ("proc: don't let an entry below /proc/<pid>/net be a mountpoint")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/proc/proc_sysctl.c | 14 ++------------
 1 file changed, 2 insertions(+), 12 deletions(-)

diff --git a/fs/proc/proc_sysctl.c b/fs/proc/proc_sysctl.c
index 1a22aa43e740d..7f7ffbc9276c5 100644
--- a/fs/proc/proc_sysctl.c
+++ b/fs/proc/proc_sysctl.c
@@ -522,13 +522,8 @@ static struct dentry *proc_sys_lookup(struct inode *dir, struct dentry *dentry,
 			goto out;
 	}
 
-	inode = proc_sys_make_inode(dir->i_sb, h ? h : head, p);
-	if (IS_ERR(inode)) {
-		err = ERR_CAST(inode);
-		goto out;
-	}
-
 	d_set_d_op(dentry, &proc_sys_dentry_operations);
+	inode = proc_sys_make_inode(dir->i_sb, h ? h : head, p);
 	err = d_splice_alias(inode, dentry);
 
 out:
@@ -686,13 +681,8 @@ static bool proc_sys_fill_cache(struct file *file,
 			return false;
 		if (d_in_lookup(child)) {
 			struct dentry *res;
-			inode = proc_sys_make_inode(dir->d_sb, head, table);
-			if (IS_ERR(inode)) {
-				d_lookup_done(child);
-				dput(child);
-				return false;
-			}
 			d_set_d_op(child, &proc_sys_dentry_operations);
+			inode = proc_sys_make_inode(dir->d_sb, head, table);
 			res = d_splice_alias(inode, child);
 			d_lookup_done(child);
 			if (unlikely(res)) {
-- 
2.53.0



