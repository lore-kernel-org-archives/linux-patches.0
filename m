Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2D16629C338;
	Thu, 15 Jan 2026 17:01:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768496486; cv=none; b=Q3wDqJ2nOqUUxyME9glrcutCKqu+SFHMxoBhgEoUBr86eZlppBGNAGBviGdU3iyWVFAq0uCD6UJjtD9sj4yC86/VtsHZ2fUA3bA2FPIJ597PRdEtJqySZ4P5wir0mvHcsvHt5Y2tfVKSf7B6VQr1j6EBNEO/DpeDPKDaHiWBfvU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768496486; c=relaxed/simple;
	bh=keSAJ/YqNd85wNust8mK3MLANf6+ETFsNOINzYKFT6M=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=q0crJxU3ty421BnUE6YpcjV9N/hczDYnKULa6vvoFmFbnNVNiu9rqBO2PCAawuWE2AbDZ2vc0AMawxsIBmpiWgsFI8etdUhij+chJAA7H8R+GP25eZNdnstryOR7qeKwbFGDlGEcRuuHwJc664O1Iwzvu0r3Z0qToNsQMvQQgFc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=wKKzRp2t; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="wKKzRp2t"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AC0DFC16AAE;
	Thu, 15 Jan 2026 17:01:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1768496486;
	bh=keSAJ/YqNd85wNust8mK3MLANf6+ETFsNOINzYKFT6M=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=wKKzRp2tTBq1ul/ckhwQA5UPB/WUVe4On1vSqpdbrBp2l1RlYyzS77tdkPt3TvAHh
	 Kh/m7BodMZQAxDzqmEDp8JdZk2sQ5Ne7o+i90nB8Rffk155s0zdKG1rG3mOTNwKMFi
	 u4LtPo0cBzTVwx7dbzO0XObRnbTewj9HgmSUS9lA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	NeilBrown <neil@brown.name>,
	Jeff Layton <jlayton@kernel.org>,
	Olga Kornievskaia <okorniev@redhat.com>,
	Chuck Lever <chuck.lever@oracle.com>
Subject: [PATCH 6.12 004/119] nfsd: check that server is running in unlock_filesystem
Date: Thu, 15 Jan 2026 17:46:59 +0100
Message-ID: <20260115164152.116981402@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260115164151.948839306@linuxfoundation.org>
References: <20260115164151.948839306@linuxfoundation.org>
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

From: Olga Kornievskaia <okorniev@redhat.com>

commit d0424066fcd294977f310964bed6f2a487fa4515 upstream.

If we are trying to unlock the filesystem via an administrative
interface and nfsd isn't running, it crashes the server. This
happens currently because nfsd4_revoke_states() access state
structures (eg., conf_id_hashtbl) that has been freed as a part
of the server shutdown.

[   59.465072] Call trace:
[   59.465308]  nfsd4_revoke_states+0x1b4/0x898 [nfsd] (P)
[   59.465830]  write_unlock_fs+0x258/0x440 [nfsd]
[   59.466278]  nfsctl_transaction_write+0xb0/0x120 [nfsd]
[   59.466780]  vfs_write+0x1f0/0x938
[   59.467088]  ksys_write+0xfc/0x1f8
[   59.467395]  __arm64_sys_write+0x74/0xb8
[   59.467746]  invoke_syscall.constprop.0+0xdc/0x1e8
[   59.468177]  do_el0_svc+0x154/0x1d8
[   59.468489]  el0_svc+0x40/0xe0
[   59.468767]  el0t_64_sync_handler+0xa0/0xe8
[   59.469138]  el0t_64_sync+0x1ac/0x1b0

Ensure this can't happen by taking the nfsd_mutex and checking that
the server is still up, and then holding the mutex across the call to
nfsd4_revoke_states().

Reviewed-by: NeilBrown <neil@brown.name>
Reviewed-by: Jeff Layton <jlayton@kernel.org>
Fixes: 1ac3629bf0125 ("nfsd: prepare for supporting admin-revocation of state")
Cc: stable@vger.kernel.org
Signed-off-by: Olga Kornievskaia <okorniev@redhat.com>
Signed-off-by: Chuck Lever <chuck.lever@oracle.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/nfsd/nfs4state.c |    5 ++---
 fs/nfsd/nfsctl.c    |    9 ++++++++-
 fs/nfsd/state.h     |    4 ++--
 3 files changed, 12 insertions(+), 6 deletions(-)

--- a/fs/nfsd/nfs4state.c
+++ b/fs/nfsd/nfs4state.c
@@ -1743,7 +1743,7 @@ static struct nfs4_stid *find_one_sb_sti
 
 /**
  * nfsd4_revoke_states - revoke all nfsv4 states associated with given filesystem
- * @net:  used to identify instance of nfsd (there is one per net namespace)
+ * @nn:   used to identify instance of nfsd (there is one per net namespace)
  * @sb:   super_block used to identify target filesystem
  *
  * All nfs4 states (open, lock, delegation, layout) held by the server instance
@@ -1755,9 +1755,8 @@ static struct nfs4_stid *find_one_sb_sti
  * The clients which own the states will subsequently being notified that the
  * states have been "admin-revoked".
  */
-void nfsd4_revoke_states(struct net *net, struct super_block *sb)
+void nfsd4_revoke_states(struct nfsd_net *nn, struct super_block *sb)
 {
-	struct nfsd_net *nn = net_generic(net, nfsd_net_id);
 	unsigned int idhashval;
 	unsigned int sc_types;
 
--- a/fs/nfsd/nfsctl.c
+++ b/fs/nfsd/nfsctl.c
@@ -262,6 +262,7 @@ static ssize_t write_unlock_fs(struct fi
 	struct path path;
 	char *fo_path;
 	int error;
+	struct nfsd_net *nn;
 
 	/* sanity check */
 	if (size == 0)
@@ -288,7 +289,13 @@ static ssize_t write_unlock_fs(struct fi
 	 * 3.  Is that directory the root of an exported file system?
 	 */
 	error = nlmsvc_unlock_all_by_sb(path.dentry->d_sb);
-	nfsd4_revoke_states(netns(file), path.dentry->d_sb);
+	mutex_lock(&nfsd_mutex);
+	nn = net_generic(netns(file), nfsd_net_id);
+	if (nn->nfsd_serv)
+		nfsd4_revoke_states(nn, path.dentry->d_sb);
+	else
+		error = -EINVAL;
+	mutex_unlock(&nfsd_mutex);
 
 	path_put(&path);
 	return error;
--- a/fs/nfsd/state.h
+++ b/fs/nfsd/state.h
@@ -759,9 +759,9 @@ static inline void get_nfs4_file(struct
 struct nfsd_file *find_any_file(struct nfs4_file *f);
 
 #ifdef CONFIG_NFSD_V4
-void nfsd4_revoke_states(struct net *net, struct super_block *sb);
+void nfsd4_revoke_states(struct nfsd_net *nn, struct super_block *sb);
 #else
-static inline void nfsd4_revoke_states(struct net *net, struct super_block *sb)
+static inline void nfsd4_revoke_states(struct nfsd_net *nn, struct super_block *sb)
 {
 }
 #endif


