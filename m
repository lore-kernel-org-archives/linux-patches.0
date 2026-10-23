Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792774617;
	b=amRp4i5tiftM94WQnscu1BPTVgqMcJfNU1ZE4oIe88mTdc2b2yGUb5sYfggsmWvVroK4
	 WPaOUMQWp+1axl1fRfObvixGsGAiziqrK7PS+YEbmqHadYcCtAKR1WdRMAv6iIJlqn28r
	 mf09WzA/XtlCfc9hokCe8o72zeSzz4RHZKiBsqUNYV4Lo9RboxmaYaJDFuj6R5pfDGfiv
	 RP9tIo8nRSqkV9dbB01nNUYwy9gkquwZrUNJ6fY3pLiM93qVcWpAHHq1+460RX7tcybPi
	 0y9PrqBOLwiOh8x6NpwNGrqItNB2w3h7RZ4P/BHDeNOch7MZ3m/uBahYmlDWzk/4wvQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792774617;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=F6QMhs87baOIkDECRu59eAgPiWgkG6YtzyhVpDxjVKc=;
	b=SLse++8RFjXl54iEbxuEwTJMLyK7Rioe3lZyEPPI3TMDZg7W6FbTzGMP6Mumgm554ywM
	 wWW273CZjWvYWj223jZ/Oud2GJF3aEAifYaxgDAO5ieOScsbbiVuSbeUfafWyws1RD6C2
	 kuf4gh4VqMDcql5HcYycJxQXrmbjJEpix86z3ureUm8/H/6qzq+T0brMnD7qYH3H2Xn24
	 fI9VyG4w7ajs9ZeztC7+umpnCDA0CFBm7HW+HoSwSwAEF72PbNFNOmb+/NkNDY77iJIjK
	 PXapFdwZ7+XiNNAW/1faNKAaYaUQTHny+R8YNvuJFZvYdneyBSpZxdBtKVlcJLuNTRQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=dBji04Hv;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9ACAD606A31D;
	Fri, 23 Oct 2026 16:56:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=dBji04Hv
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DB4C01F01825;
	Fri, 23 Oct 2026 16:56:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1792774617;
	bh=F6QMhs87baOIkDECRu59eAgPiWgkG6YtzyhVpDxjVKc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=dBji04HvWK/FM72xJlq0Tyr/KIKgx8QO16rDxqCUmQblzjEj7Gpw7bl35VifhN2XL
	 ora76zkNAehWFRRbDkXwzizFFCzTvtXKWXh7dp+ElPFj+D/ZAo1raDcUwq8IptdwQP
	 dm+lz86B7Y3yZxc9MwF7y8rbIQ/aWEYrB23xJUq8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Christian Brauner (Amutable)" <brauner@kernel.org>
Subject: [PATCH 7.2 102/242] afs: free the super info after a grace period
Date: Fri, 23 Oct 2026 18:39:04 +0200
Message-ID: <20261023163716.193817373@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261023163713.816071858@linuxfoundation.org>
References: <20261023163713.816071858@linuxfoundation.org>
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

7.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Christian Brauner <brauner@kernel.org>

commit 59e483739f2fd14327ece3f60c4995d060ca46b7 upstream.

afs_atcell_get_link() resolves the @cell and .@cell symlinks of a
dynamic root in rcu pathwalk mode. Before it looks at the dentry it gets
the afs_net through afs_i2net(), which reads ->net_ns from the
afs_super_info in sb->s_fs_info. The @cell dentries are kept around when
unused and the dynamic root has no ->d_revalidate(), so a lookup that
finds @cell in the dcache gets to ->get_link() in rcu mode.

afs_kill_super() frees the afs_super_info with a plain kfree() in
afs_destroy_sbi(). Right now a pathwalk can't still be in
afs_atcell_get_link() at that point, but only by accident. umount(2)
waits for a grace period in namespace_unlock() before it drops the
mount. And a mount whose last reference goes away elsewhere, like the
chdir out of a lazily unmounted directory, still gets a grace period
from bdi_unregister(). afs_fill_super() sets up a private bdi, so
generic_shutdown_super() unregisters it from kill_anon_super() and
bdi_remove_from_list() waits in synchronize_rcu_expedited() before
afs_destroy_sbi() runs. That grace period protects the rcu readers of
bdi_list in the writeback code. It has nothing to do with pathwalk.

Don't rely on it and free the afs_super_info after a grace period.

Fixes: 30bca65bbbae ("afs: Make /afs/@cell and /afs/.@cell symlinks")
Cc: stable@vger.kernel.org
Link: https://patch.msgid.link/20261009-work-fixes-rcu-v1-2-7446d2d335e6@kernel.org
Signed-off-by: Christian Brauner (Amutable) <brauner@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/afs/internal.h |    2 ++
 fs/afs/super.c    |    2 +-
 2 files changed, 3 insertions(+), 1 deletion(-)

--- a/fs/afs/internal.h
+++ b/fs/afs/internal.h
@@ -251,6 +251,8 @@ struct afs_super_info {
 	struct afs_volume	*volume;	/* volume record */
 	enum afs_flock_mode	flock_mode:8;	/* File locking emulation mode */
 	bool			dyn_root;	/* True if dynamic root */
+	/* afs_atcell_get_link() reads ->net_ns in rcu pathwalk */
+	struct rcu_head		rcu;
 };
 
 static inline struct afs_super_info *AFS_FS_S(struct super_block *sb)
--- a/fs/afs/super.c
+++ b/fs/afs/super.c
@@ -523,7 +523,7 @@ static void afs_destroy_sbi(struct afs_s
 		afs_put_volume(as->volume, afs_volume_trace_put_destroy_sbi);
 		afs_unuse_cell(as->cell, afs_cell_trace_unuse_sbi);
 		put_net(as->net_ns);
-		kfree(as);
+		kfree_rcu(as, rcu);
 	}
 }
 


