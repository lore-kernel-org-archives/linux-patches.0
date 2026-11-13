Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794585737;
	b=iBXAE702iMGlaUXPxW6T2dmH7uLe6y2e+tuUqMuB4M3/Lkqq0CogKLLY4UjTUgv/XKP9
	 hiPfiLNmGADHN1JRSc+QFgERbMFglQC3JxAYxp3ELlmnH5+j+x51fKsUgyaAovmkaHBk2
	 8G0VJDN2cXoLCcWquhsml/6HR0ZohF3MMHUNYnSQoWsMdY5HAefmcQyLcvm9PgVc0RThd
	 pk5KPy2iF0foGjVu35JL3Kjh4F1F5Scr3lb7nJv5BS3z6wWB2bOKQm8AJzDiIiU2uJAjU
	 z2k+n9EKWSMF+fWSZcEpINws3vtAHBERKbRjsqRjWK7rkunYti/AKGX4L2UwSe+3GXw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794585737;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=kOC6DM3/Dliwa2kDTWzC+ZhwkYAuXL9J+va2O9WL0IE=;
	b=kq0+gcrvsNRnS5v3V3eFYYddWd8Do1fua/L0syoUFeMw26ntWKWshEwe6f5QYqLMqr9P
	 AHLHTt3+CLYmFBInFD1BNslay9fUUoILkymFxC1lOX8vzxdrwSKxgo8dg6aoE0CdwmCn+
	 gHY6DsD+yq9c84sVyGnMG/VZLXhPy66BVvVQ3FoNDA4n/VruWSv+k1eBhQ7wWCxvluzVp
	 C6nKlPVo5pBCqYmzmEUIL3mqDTwg35W61dkB0BXLBd4hAfgXx16NjS7dw8qGguo6+yqDD
	 I0m8fAxZRIjRwZlnx6ZZ4xup+KscPN3Sioa8/jZ/FDXkU1LrtwF1QMySg3KaZfUSStw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Umqyq3it;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AEF1E606EB82;
	Fri, 13 Nov 2026 16:02:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Umqyq3it
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5ACCF1F000C4;
	Fri, 13 Nov 2026 16:02:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794585737;
	bh=kOC6DM3/Dliwa2kDTWzC+ZhwkYAuXL9J+va2O9WL0IE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Umqyq3itPh9AXOVElYw6XxQ8NABQyn50rmh8D1drNmYtRreoezbnmRBMyt+Ya++ur
	 3cLfwCXboJemS9HQY9p6ZlWZQzhjNMZ96j4XnKZdai51gA0f9dOYzerpDEA/88s98Y
	 ZcmHvxzJ63OXHMM/gx/3M7UJKrFr5jdBTuf52/zk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Chris Mason <mason@kernel.org>,
	Hungyu Lin <dennylin0707@gmail.com>,
	Amir Goldstein <amir73il@gmail.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 337/507] ovl: fail the mount if the casefold flag has changed
Date: Fri, 13 Nov 2026 10:50:41 -0500
Message-ID: <20261113153806.833469697@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261113153753.358973689@linuxfoundation.org>
References: <20261113153753.358973689@linuxfoundation.org>
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

7.3-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Chris Mason <mason@kernel.org>

[ Upstream commit c782fc8ada811569811c0fdea5c3412511be95d0 ]

An unprivileged user in a user namespace can repeatedly trigger a kernel
warning with their own overlay mounts. They do so by changing the
casefold flag of the topmost layer's empty root, the top directory of
that layer, after the layers are set and before the mount is created.

The casefold flag of a directory makes name lookups in that directory
case-insensitive. All layers of an overlay must agree on casefolding.

ovl_mount_dir_check() reads the casefold flag of a layer root when
fsconfig() sets that layer, and saves the result in ofs->casefold. The
mount is created later, by another fsconfig() call with
FSCONFIG_CMD_CREATE.

The casefold flag of an empty directory can be changed.

The casefold flag of the overlay root must match ofs->casefold.
ovl_get_root() copies the flag from the topmost layer root, as it is
when the mount is created. On a mismatch, ovl_get_root() only does a
WARN_ON(), and the mount continues. The check is not a WARN_ON_ONCE(),
so each such mount warns again.

An unprivileged user needs CONFIG_UNICODE, and a tmpfs mounted with the
casefold option in their namespace.

Reproduced by changing the casefold flag of the empty upper directory
after the layers were set and before FSCONFIG_CMD_CREATE, with tmpfs and
ext4 layers, and as uid 1000 in a user namespace.

Fix this by replacing the WARN_ON() with a check that fails the mount
with -EINVAL.

Fixes: f9377faaeae0 ("ovl: Add S_CASEFOLD as part of the inode flag to be copied")
Cc: stable@vger.kernel.org
Signed-off-by: Chris Mason <mason@kernel.org>
Tested-by: Hungyu Lin <dennylin0707@gmail.com>
Signed-off-by: Amir Goldstein <amir73il@gmail.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/overlayfs/super.c | 12 +++++++++++-
 1 file changed, 11 insertions(+), 1 deletion(-)

diff --git a/fs/overlayfs/super.c b/fs/overlayfs/super.c
index 861b0775f9ddb..c06bfe9765e25 100644
--- a/fs/overlayfs/super.c
+++ b/fs/overlayfs/super.c
@@ -1366,7 +1366,6 @@ static struct dentry *ovl_get_root(struct super_block *sb,
 	ovl_dentry_set_flag(OVL_E_CONNECTED, root);
 	ovl_set_upperdata(d_inode(root));
 	ovl_inode_init(d_inode(root), &oip, ino, fsid);
-	WARN_ON(!!IS_CASEFOLDED(d_inode(root)) != ofs->casefold);
 	ovl_dentry_init_flags(root, upperdentry, oe, DCACHE_OP_WEAK_REVALIDATE);
 	/* root keeps a reference of upperdentry */
 	dget(upperdentry);
@@ -1550,6 +1549,17 @@ static int ovl_fill_super_creds(struct fs_context *fc, struct super_block *sb)
 	if (!sb->s_root)
 		goto out_free_oe;
 
+	/*
+	 * The casefold flag of an empty layer root may have changed since the
+	 * mount options were parsed.  The root inode owns oe by now.
+	 */
+	if (!!IS_CASEFOLDED(d_inode(sb->s_root)) != ofs->casefold) {
+		pr_err("casefold flag of the root directory has changed\n");
+		dput(sb->s_root);
+		sb->s_root = NULL;
+		return -EINVAL;
+	}
+
 	return 0;
 
 out_free_oe:
-- 
2.53.0



