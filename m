Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795058920;
	b=RJfpVt8ns5/1PGq/ZfbC7e78Ys27IJmJ6+3amZkfcMczDC9uAGyyxNfTtgktWnYp7imt
	 hfOPxNcFU1turensGk7Nl78qhN944iNgvkgl/1DuV9ra8n6VbzIR8exvO6flefOvdu+oW
	 ALCfZmtxi0/PIAxLiVrE+tmJweNryUHomnhX59vGWHBPqt8UcGltDl7aWPPoo0dYL8syC
	 MRLzAnKRK7EftrhrE399PbwwJZeTnLva9VgclPlv3UcIbZ6teEVyBqutq5X94ewfs0TY1
	 zDbl5u/geJbgnZJFK0AaJTV490U/hYRuOmyp7FPF8P1M749G33MwNEHF+6LSz+ciSRg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795058920;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=/02S7qt8gzwgYfxzT+PeccMcpfePVbojiPXuah63K9M=;
	b=VmGR90VlwOSl82oU/ynC8YtdmX/ujIIo7YHJFFcqMgg9VegN/w8DhCklMFJm9iA3Si1n
	 clr4RFwxSyaqjpjao6p9Y7XugDwQTP/sPvF5XsX7ZSVJzb4gdQcVuznwsUSRdAZ2OX/35
	 9pZu9VyUsFyL3OR8b20nQYq5omYb1F6m+O1rctobAhXfEVjeVugAWz3m9SoeX7kgpusTk
	 LLT108AGrwvlPids05Cb8aPC3mzW0cellEQUE8L8auz1CV1hgShiceONZH1E6joGgaWTc
	 fppZyF4UTNWZCAg7BHS3VDQ4V8Q1YOJMhtVE11WsOcMvqwkMG+PlzJi//0iPtyMXk8g==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=FDVV40ST;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B2206606A326;
	Thu, 19 Nov 2026 03:28:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=FDVV40ST
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BFC1E1F000C4;
	Thu, 19 Nov 2026 03:28:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795058920;
	bh=/02S7qt8gzwgYfxzT+PeccMcpfePVbojiPXuah63K9M=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=FDVV40SThzWhNm/RDNI/kxdiZ3idIh6SHI1RR9jEFo4ukNk1gsUsK4JCzZ4e3pCmx
	 n8yxkALZQ6ZIzJqqLiVBUz9ynBXiBGOSCFj2NTZMtO9GALoPNlAR2dr+MvlOBm2VIC
	 MvEYJwP7KIfdVQj6DU5KOKRU3YmR0+0r1KUikIrM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Chris Mason <mason@kernel.org>,
	Josef Bacik <josef@toxicpanda.com>,
	Amir Goldstein <amir73il@gmail.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 0621/1848] ovl: check that the parents of volatile/dirty are dirs
Date: Wed, 18 Nov 2026 15:44:19 +0100
Message-ID: <20261118145941.375298822@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118145911.150052362@linuxfoundation.org>
References: <20261118145911.150052362@linuxfoundation.org>
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

From: Chris Mason <mason@kernel.org>

[ Upstream commit e34d2ef818e4c7676d8d8e1bf43e6a1ed39efb2a ]

An unprivileged user crashes the kernel by mounting overlayfs with the
volatile option.

A dentry that serves as the parent of a lookup must be a directory.
ovl_create_volatile_dirty() walks work/incompat/volatile/dirty by name,
and ovl_lookup_or_create() returns an existing entry whatever its type.
A file or a symlink that another task creates during the mount becomes
the parent of the next lookup, which calls a NULL ->lookup.

An unprivileged user mounted overlayfs with "volatile" in a user
namespace while a second process created a symlink named work/incompat,
and the mount task oopsed on a NULL ->lookup call.

Fix this by returning -ENOTDIR from ovl_lookup_or_create() when the
caller asked for a directory and the existing entry is a non-dir.

Fixes: c86243b090bc ("ovl: provide a mount option "volatile"")
Cc: stable@vger.kernel.org
Signed-off-by: Chris Mason <mason@kernel.org>
Signed-off-by: Josef Bacik <josef@toxicpanda.com>
Signed-off-by: Amir Goldstein <amir73il@gmail.com>
[ sashal: replaced end_creating(child) with dput(child) while retaining the existing explicit parent unlock ]
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/overlayfs/super.c | 17 ++++++++++++-----
 1 file changed, 12 insertions(+), 5 deletions(-)

diff --git a/fs/overlayfs/super.c b/fs/overlayfs/super.c
index 5d7df839902df..5b50a3c2289aa 100644
--- a/fs/overlayfs/super.c
+++ b/fs/overlayfs/super.c
@@ -1242,16 +1242,23 @@ static int ovl_check_rename_whiteout(struct dentry *workdir)
 }
 
 static struct dentry *ovl_lookup_or_create(struct dentry *parent,
-					   const char *name, umode_t mode)
+					   const char *name, bool is_dir)
 {
 	size_t len = strlen(name);
 	struct dentry *child;
 
 	inode_lock_nested(parent->d_inode, I_MUTEX_PARENT);
 	child = lookup_one_len(name, parent, len);
-	if (!IS_ERR(child) && !child->d_inode)
-		child = ovl_create_real(parent->d_inode, child,
-					OVL_CATTR(mode));
+	if (!IS_ERR(child)) {
+		if (!child->d_inode) {
+			child = ovl_create_real(parent->d_inode, child,
+						OVL_CATTR(is_dir ? S_IFDIR :
+								   S_IFREG));
+		} else if (is_dir && !d_can_lookup(child)) {
+			dput(child);
+			child = ERR_PTR(-ENOTDIR);
+		}
+	}
 	inode_unlock(parent->d_inode);
 	dput(parent);
 
@@ -1272,7 +1279,7 @@ static int ovl_create_volatile_dirty(struct ovl_fs *ofs)
 	const char *const *name = volatile_path;
 
 	for (ctr = ARRAY_SIZE(volatile_path); ctr; ctr--, name++) {
-		d = ovl_lookup_or_create(d, *name, ctr > 1 ? S_IFDIR : S_IFREG);
+		d = ovl_lookup_or_create(d, *name, ctr > 1);
 		if (IS_ERR(d))
 			return PTR_ERR(d);
 	}
-- 
2.53.0



