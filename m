Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793207568;
	b=R6AKD+hJIMTJSzGNoPHTJjD8M4IFBP6z6omX0whLTFI2URGx/WhiQx7Rqj+Ogp1TARqW
	 /kTuDs/SR39M9UhQiKptshq5q3NDhdsMtYUvAlmMIFS0jfa7pitoVhlSEA4WGl+9QSlty
	 09235tE3QyO1Ti9HsmdcSEYdDvAJ/ek0Pc1/h+xh+t5+OLHYRMABBd2dj6Nz8a2fNqEH2
	 yNm3SJsd00Qtpo0infVQDm+oCndjDvX0EfYxVY1OcRJCDdJjkZg5UYE/71R/e3YoMMSs9
	 ElJa8Ve1nUX3MAY3uZgyCVyQJAbQPelBIlpwjxvrz4OojT+5cXr2HIj+xawKIW8uPQQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793207568;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=g0XvElElb1lL0G2EYbUOM1dNlay28tnwVpHcuuC6Z40=;
	b=pw0HO9VDiIrpMWv53LItG/kl379F/ZnGsnuaVqQSBMyuPDHzBQJOLXCGSSgZAZsnXl+y
	 Z3om2L/txuoKIFJp5vlfwUwdDvl8m+M2PbZ4Q5kLbeI9eviS7jy4nXf90BZF9ITIA0Snv
	 P6vViBE3JMqRi0mYR+UrPgbn4h6OyzZ1ortfFyGLvzC3fgbjQS2XC3e0QLNw1MFNxJj3G
	 sEMe7zcK3sMf5/ON/LrMboQjN6UizrMnpJVWKjF3FItCKFQOFwxxGmtvTyjBNrzcNoHeE
	 2XZdkjnP975SvJsEusjyGDHg5SIjpXLRXmotKumUaQyhR7971075k1GkYzKjGyD3qDA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=P4dtSC33;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5C784606A31E;
	Wed, 28 Oct 2026 17:12:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=P4dtSC33
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6ED7E1F01825;
	Wed, 28 Oct 2026 17:12:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793207568;
	bh=g0XvElElb1lL0G2EYbUOM1dNlay28tnwVpHcuuC6Z40=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=P4dtSC33kVz4OhJ+w8b+q2V+FXzFosbDQn8VDU1joxiGeMl3GiBUFEB8yryWWrgO3
	 o5uFD+EoSbWKuqW50rdImn76rXlsA0W61JG0GP4t4mDy/rSt9G2udDvBtZuaJu5UvF
	 s4ChuZCONnohd85ahAEKUCiVnplCtRKEWUBDx2Ao=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Christian Brauner (Amutable)" <brauner@kernel.org>
Subject: [PATCH 6.12 062/247] afs: free the super info after a grace period
Date: Wed, 28 Oct 2026 17:57:45 +0100
Message-ID: <20261028165948.849527874@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261028165947.349197979@linuxfoundation.org>
References: <20261028165947.349197979@linuxfoundation.org>
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
@@ -264,6 +264,8 @@ struct afs_super_info {
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
 


