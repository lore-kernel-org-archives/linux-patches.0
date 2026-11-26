Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795704847;
	b=tC5nvpAhPpJxXfHTwjDyTsERnlY2oOXZRYs3dYu6zx6Uc8yza4sIem0MCoBqKzTiK7PK
	 X9ffWV4+e9aZK4yMVMq/Rixk9bU4cD+hpDPTyqlDRPpSWmgzU7ZBBRiI440bRTgYBsjol
	 ZsYxvNwfEkxgpOwvCOdb4mh1RIPc0DhqN/5CGJPRbji+9vERyu2m8Ts91w5YU/XS8CeLM
	 SJrddypj7qpd91xavbjjeS+DXVRNgwWopnMGvS6gHkPUvCG8l6TM8KmZk5DpQwWJnojjK
	 ssFVk/PQh3w88lslgelRodEEXB3BhoKmXPJ+D/gbI1G3g6JFFrErYzt6PiH73Eo3QoQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795704847;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=kQdYesf+Cd7Zip+CXT+V6QPE/7zXa9vXgSxZivlLYt0=;
	b=1iag3LBpxyL88cC9ueLHTfMEZsRFHZOD9ibv2uT8loSULG9/w8u7OBV9cl9qRL2lAHAW
	 RZtTaqbjJQxFfV6WhhGOHkeeTdelxA0saLiBlGijbKj3LhWNycSmfFh3XF2tSSwAWbcXd
	 5qHr0jnspMO5rd5Thj8kQnLnGsu2mfynZr7vqzHPD+io3XU8nLgqrgALkjSd1NVJa2kn7
	 RK2bpTe5By/HOfy5LsESrI96gfBl3B4Tw3GFTl2AHt4DPipTortFmMKMzxFN7ikrS+gmZ
	 hk5fI7ON+sBDtkw+W8MM0kFSVB7zEhQVi/pnVbyQqVYWcI/PoRr6SXQb/ZolPVQY18g==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=ebrlOuCX;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B9EBB606A327;
	Thu, 26 Nov 2026 14:54:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=ebrlOuCX
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C03F01F000C4;
	Thu, 26 Nov 2026 14:54:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795704847;
	bh=kQdYesf+Cd7Zip+CXT+V6QPE/7zXa9vXgSxZivlLYt0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ebrlOuCXTP922vi4Ta8oCtVpzeQlZWPhmFiDNoKlW21itJ+FjjojWzSSynjHiyeho
	 xi+rSD1+dnZwsPFBKq9Wj3vDDZ9zXTgAmoCI1ToIcgXkSKu6uuBl1cxt8w2oV/xSGl
	 OFHqc9P/BojBKzIjivzOdmmEo7ZDqzZY51PKpt5E=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Su Hui <suhui@nfschina.com>,
	Christian Brauner <brauner@kernel.org>,
	Petr Vaganov <petrvaganoff@gmail.com>
Subject: [PATCH 5.10 262/265] fs/stat.c: avoid harmless garbage value problem in vfs_statx_path()
Date: Thu, 26 Nov 2026 15:39:52 +0100
Message-ID: <20261126143623.547291961@linuxfoundation.org>
X-Mailer: git-send-email 2.56.1
In-Reply-To: <20261126143605.076581697@linuxfoundation.org>
References: <20261126143605.076581697@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Su Hui <suhui@nfschina.com>

commit 0fac3ed473dd2955053be6671cdd747807f5e488 upstream.

Clang static checker(scan-build) warning:
fs/stat.c:287:21: warning: The left expression of the compound assignment is
an uninitialized value. The computed value will also be garbage.
  287 |                 stat->result_mask |= STATX_MNT_ID_UNIQUE;
      |                 ~~~~~~~~~~~~~~~~~ ^
fs/stat.c:290:21: warning: The left expression of the compound assignment is
an uninitialized value. The computed value will also be garbage.
  290 |                 stat->result_mask |= STATX_MNT_ID;

When vfs_getattr() failed because of security_inode_getattr(), 'stat' is
uninitialized. In this case, there is a harmless garbage problem in
vfs_statx_path(). It's better to return error directly when
vfs_getattr() failed, avoiding garbage value and more clearly.

Signed-off-by: Su Hui <suhui@nfschina.com>
Link: https://lore.kernel.org/r/20250119025946.1168957-1-suhui@nfschina.com
Signed-off-by: Christian Brauner <brauner@kernel.org>
[ Petr: There is no vfs_statx_path() in this tree. The fix is applied
  directly in vfs_statx() by jumping to path_put() via a new out_path
  label, preserving the reference drop and the ESTALE retry. ]
Fixes: fa2fcf4f1df1 ("statx: add mount ID")
Signed-off-by: Petr Vaganov <petrvaganoff@gmail.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/stat.c |    3 +++
 1 file changed, 3 insertions(+)

--- a/fs/stat.c
+++ b/fs/stat.c
@@ -195,11 +195,14 @@ retry:
 		goto out;
 
 	error = vfs_getattr(&path, stat, request_mask, flags);
+	if (error)
+		goto out_path;
 	stat->mnt_id = real_mount(path.mnt)->mnt_id;
 	stat->result_mask |= STATX_MNT_ID;
 	if (path.mnt->mnt_root == path.dentry)
 		stat->attributes |= STATX_ATTR_MOUNT_ROOT;
 	stat->attributes_mask |= STATX_ATTR_MOUNT_ROOT;
+out_path:
 	path_put(&path);
 	if (retry_estale(error, lookup_flags)) {
 		lookup_flags |= LOOKUP_REVAL;


