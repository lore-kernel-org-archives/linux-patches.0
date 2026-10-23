Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792773956;
	b=uKZjRW+OuK27N8+/+ireRacsolkQaGjf78aYSeOeCQtrpUzOmEVVCfPAHCF8gO1xlHMR
	 z5FmE0l7WsChSHOzK4j8DLVaXxaRYKUDZZPGmRt1iH5Qap6N1wzF4BSDyCG4UkvPyenJ1
	 D3sYAoeys0NzktiORn1DDXK1plaZnQdCi3/XCuLB73YAjDV/mVLyV8YtgegcPbnmee9JS
	 RGTJ4QXwtUi+VJk0w3DbGBVUWWeG3QtpbVhs+6r/bfBvbLJUpJECKBjfue4Sty8Ic7/hI
	 9SqCkQ/vfRSPwazJI1583QOzeG/rPTra0e+VXj+5ADm4E5I++tK9e033nEfor8mpc5A==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792773956;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=oKWz8e+btx/GYJbC/jy77r0N2dDeerfr5pNZjUaPSxQ=;
	b=4LB6WfyhR/4DvVEYtm8WcWhA4AWhYe+n8ngxtGkXdf6sfoJ7ifEoioqjPFjbDDffOezs
	 roo6eYNSJ33vpnMCZwgaBHAMsBx+cfc5ubIlMxG+3YfqzLEB5xGps7bTi9AxRJYRFdIE7
	 HRmzQ+yLy1ci4toVtbOrIWatJdqd8kll9nkrH8g0uzICiqjeUDgmWYqnLSf9H3FnUKF3k
	 YWQob+u5lwY1aBF+u+hkiNH/QwJ60pDsn3XQLCD/u+TQJwKAzqoTfh0Mvv1SUs5Bj6k6q
	 hcbTRULZT4WPIorhHzxYSJceRLfhkK1GCwp9f8Gth+zqcd7RN9sOL81svy2ddJDENdA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b="L/cdAEcT";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 32626606A31B;
	Fri, 23 Oct 2026 16:45:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=L/cdAEcT
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7C49F1F01825;
	Fri, 23 Oct 2026 16:45:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1792773956;
	bh=oKWz8e+btx/GYJbC/jy77r0N2dDeerfr5pNZjUaPSxQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=L/cdAEcT175S6toYVCPmtmqtbrK2sZ3D7Bv8Cqc0eNbmD6rGXNf9s/ck8mhV7te/C
	 +A/lAqHcR97gZVPVKLzsTYJxDCBpczkztmTDqHgBpEUsVRBuq0j2boXTbEenVJRXBC
	 hfymmz/R0Nc3d/J/SR56H8BYg3BzutmRaioqi4Tg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Christian Brauner (Amutable)" <brauner@kernel.org>
Subject: [PATCH 6.18 072/193] afs: free the super info after a grace period
Date: Fri, 23 Oct 2026 18:35:49 +0200
Message-ID: <20261023163715.908596716@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261023163714.201276352@linuxfoundation.org>
References: <20261023163714.201276352@linuxfoundation.org>
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
@@ -252,6 +252,8 @@ struct afs_super_info {
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
 


