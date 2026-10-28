Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793211462;
	b=Lm63KPQdUP82+zC276TMJNBqXWKW01wjKXwOn4kFeEL1EA9JO6FWAo3GstIq+M1cKnIK
	 xrhWrk5EgW/yYqBP/7UQGvUI3g+SJ3uSBockIrGRFYrUMIGkO5/f5N5+X89V2LVKDX7pl
	 HEA9mPQhvHmSoiKT8x2mnUlu2QSBwjgjkMyDHEIEJxfFcOXyGpFDBWRjrZGRmcFAHN2Oy
	 z2/I4v3BT6sltwXsRul02SqSpH1xL1PdRLigac7+8H//l+uiaJ7Imc42qyzmHWSek63y2
	 Vj0WZxrZjPuoWsA/3NS7wbAXm/o7pf8chnFxOuIyJFeQBEcAq2JCQ190UPZ9lzW5F5g==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793211462;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=R8BLFDUsCXhZOZJhba/Iz/wx5262X1EJPNrSCcvoUho=;
	b=t3S6oKMS11KArpIZED3GIdIQeBGzP1GbYE5j/lcyAmEe5MUJdkkFcZYOJ21PgrHmCjhX
	 nkBnuEGHlpttafSkkf7TQ02ARsmNvaZ/13pZrODjpj3M+FBJn+napuKiYwbq2yymXuCi1
	 RtQ+DhGOeGsFlO4jAD64mjlXRohK/btcGnjl1mS2fIV6SvMdxTKkZ+Lcg95JYLmvpSQ/Q
	 n85UzYO7uCIOiE0tQV0/960fz2Ls0KCJlL/6JWjs9MBpm7yqFqcbj/2alMvck3WFBpzS5
	 d/CFDQrWtiM4kk6+VeWhyJEtBQL7jGnTzx2WfGoE1wySbQbKzXh93EoeytbYVzZIxWg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=pUObmz8G;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CFA89606A31F;
	Wed, 28 Oct 2026 18:17:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=pUObmz8G
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2AC161F01825;
	Wed, 28 Oct 2026 18:17:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793211461;
	bh=R8BLFDUsCXhZOZJhba/Iz/wx5262X1EJPNrSCcvoUho=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=pUObmz8GPMzuM+yZng7dVnGlh0cd5rdpP7s5rmYLREm76WA3PbY8Bmj79+7k12Xc2
	 KF5JD/dTgAzlcyUusT4YmAXLNC2MV2Yj6T85+LTrQiXRe0HgGRrwHzLNI57Pw+WoMv
	 i0v4atUrLvkFMQQv/F+7bJ8r0hKfXHBslvVvH0qg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Christian Brauner (Amutable)" <brauner@kernel.org>
Subject: [PATCH 5.15 386/571] fs: refuse fspick() on internal superblocks
Date: Wed, 28 Oct 2026 17:58:53 +0100
Message-ID: <20261028170017.173782431@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261028170008.009143722@linuxfoundation.org>
References: <20261028170008.009143722@linuxfoundation.org>
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

From: Christian Brauner <brauner@kernel.org>

commit 02587a4af82adccaef8e3b3624b4e7f1c401632d upstream.

There's a few instances where a internal superblock is reachable by
fspick(). Block that. graft_tree() and fsmount() already refuse them.
fanotify refuses mount and superblock marks on them for the same reason.

Fixes: cf3cba4a429b ("vfs: syscall: Add fspick() to select a superblock for reconfiguration")
Cc: stable@vger.kernel.org # v5.2+
Link: https://patch.msgid.link/20260926-work-mount-fixes-2-v1-6-f357abf3d17b@kernel.org
Signed-off-by: Christian Brauner (Amutable) <brauner@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/fsopen.c |    3 +++
 1 file changed, 3 insertions(+)

--- a/fs/fsopen.c
+++ b/fs/fsopen.c
@@ -191,6 +191,9 @@ SYSCALL_DEFINE3(fspick, int, dfd, const
 	ret = -EINVAL;
 	if (target.mnt->mnt_root != target.dentry)
 		goto err_path;
+	/* kernel-internal superblocks are nobody's to reconfigure */
+	if (target.dentry->d_sb->s_flags & SB_NOUSER)
+		goto err_path;
 
 	fc = fs_context_for_reconfigure(target.dentry, 0, 0);
 	if (IS_ERR(fc)) {


