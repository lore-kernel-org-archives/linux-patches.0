Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BB2A13A4F4B;
	Tue, 21 Jul 2026 19:46:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784663203; cv=none; b=ArJdQTEETOqfTz42vogy/tJ3Slp65OjfpbQj2A5eaoOYadr97mTHCprmDUikOG12VVsedALc+CbQP3CU9b0dr8IkC2q6i8MR69MGfgZA8BtmxArtuIv/LljGpQKSHAnbpdX51LdD9x+xJm3OOiS2Cse8WaOZc09yM8czQKuRVF4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784663203; c=relaxed/simple;
	bh=8eLUUId3e/58NBLBRRRiaNLNevEsjRMlm8qTPgCQEBw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=bjyOBWUQZrz9JgzHB4zWE7yVLekz8ullGlVed7yvDGKH5Kdn0aABJKR61T6oPHTNDB0KHGwLXGiy2K/aOMwinv3rPkeywKOJdYvfhGcgoDJ/5WUS96+561CeW7ZJcy7STrxusC9YU4CBpHOK9gt8iDRNcsUlSapiqBu4QkkZr24=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=LTWRz1x4; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="LTWRz1x4"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 24C841F000E9;
	Tue, 21 Jul 2026 19:46:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784663202;
	bh=sP37TBnG1dX6zhG8shMWNrXG2WaqKU12ym1dr/Kmq4c=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=LTWRz1x4cnZa2Yep2eGukLnmFtEtg/QHXOZGT7S7mqSzcbNQ87POKd7mVJYhYpyIW
	 AoT30Jm1Nk1uFM/KzbwekMnapjEoGwodk/Eyimi0dx/pyIdyWCgmeE+V47BOO8zzWV
	 kS/CjyGZXORO84UrtazG9Otxk/14drZLKYkb5JhA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	David Howells <dhowells@redhat.com>,
	Marc Dionne <marc.dionne@auristor.com>,
	linux-afs@lists.infradead.org,
	Christian Brauner <brauner@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 0732/1276] afs: Add rootcell checks
Date: Tue, 21 Jul 2026 17:19:35 +0200
Message-ID: <20260721152502.464845715@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152446.065700225@linuxfoundation.org>
References: <20260721152446.065700225@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: David Howells <dhowells@redhat.com>

[ Upstream commit 3e914febd79a8d1a78ee6e67ff3fa4214d6d1d57 ]

Add some checks for the validity of the cell name.  It's may get put into a
symlink, so preclude it containing any slashes or "..".  Also disallow
starting/ending with a dot.  This makes /afs/@cell/ as a symlink less of a
security risk.

Also disallow multiple setting of /proc/net/afs/rootcell for any given
network namespace.  Once set, the value may not be changed.  This makes it
easier to only create /afs/@cell and /afs/.@cell if there's a rootcell.

Signed-off-by: David Howells <dhowells@redhat.com>
Link: https://lore.kernel.org/r/20250107183454.608451-3-dhowells@redhat.com
cc: Marc Dionne <marc.dionne@auristor.com>
cc: linux-afs@lists.infradead.org
Signed-off-by: Christian Brauner <brauner@kernel.org>
Stable-dep-of: c9c3b615a462 ("afs: Fix misplaced inc of net->cells_outstanding")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/afs/cell.c | 8 ++++++++
 fs/afs/proc.c | 8 +++++++-
 2 files changed, 15 insertions(+), 1 deletion(-)

diff --git a/fs/afs/cell.c b/fs/afs/cell.c
index 1aba6d4d03a9b0..cee42646736c86 100644
--- a/fs/afs/cell.c
+++ b/fs/afs/cell.c
@@ -367,6 +367,14 @@ int afs_cell_init(struct afs_net *net, const char *rootcell)
 		len = cp - rootcell;
 	}
 
+	if (len == 0 || !rootcell[0] || rootcell[0] == '.' || rootcell[len - 1] == '.')
+		return -EINVAL;
+	if (memchr(rootcell, '/', len))
+		return -EINVAL;
+	cp = strstr(rootcell, "..");
+	if (cp && cp < rootcell + len)
+		return -EINVAL;
+
 	/* allocate a cell record for the root cell */
 	new_root = afs_lookup_cell(net, rootcell, len, vllist, false);
 	if (IS_ERR(new_root)) {
diff --git a/fs/afs/proc.c b/fs/afs/proc.c
index 15eab053af6dc0..e7614f4f30c21e 100644
--- a/fs/afs/proc.c
+++ b/fs/afs/proc.c
@@ -240,7 +240,13 @@ static int afs_proc_rootcell_write(struct file *file, char *buf, size_t size)
 	/* determine command to perform */
 	_debug("rootcell=%s", buf);
 
-	ret = afs_cell_init(net, buf);
+	ret = -EEXIST;
+	inode_lock(file_inode(file));
+	if (!net->ws_cell)
+		ret = afs_cell_init(net, buf);
+	else
+		printk("busy\n");
+	inode_unlock(file_inode(file));
 
 out:
 	_leave(" = %d", ret);
-- 
2.53.0



