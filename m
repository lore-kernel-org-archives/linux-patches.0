Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AD5F9396B7D;
	Thu, 15 Jan 2026 16:53:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768495980; cv=none; b=TQL1aJPP1Pq5fW+AMmU1X1/ZO6gsRhnbmvqUTa5iwrVDqXAmonqC/VYpFDPYHiJsT4k+gzAQFE4o5tXQFFR4vaZfXp4a6c6r+VwyiPYekVdD0JpbNRqL9HGQM3M2z217pMXGwKoD3x2V/LmNSBpLN7wIXnYM3fZmHlah4G+ac3o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768495980; c=relaxed/simple;
	bh=aNqBlNyLkH6UK7Dfhac4v6ZgJ10c+hm4N01qrfXabZ8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=P853Y0BZmtJPtbqdW9GU70cRfjQeYRMVSCcjsg2BiuR/S39Xc+RZ2o1na2WAFr0zzov532mrD6jUO6VLCSKKNcAucKjbNAvYpTalMuVh3gYlT/0GK2s5GyMffltksYVwDwo/zQ6IObD+N8QHoqKgYpESmBf4SmMAlFeF7u9mmn0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=U3FBetpb; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="U3FBetpb"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 38378C19421;
	Thu, 15 Jan 2026 16:53:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1768495980;
	bh=aNqBlNyLkH6UK7Dfhac4v6ZgJ10c+hm4N01qrfXabZ8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=U3FBetpb3AC6HbtKO7l7qcCPqx/fYp2ni5Sd+kBFUmTcPkDkhn6vnEiIx/m8Bt9u3
	 Et+hTwU2T8S9hW2/gjQfNx3nl6tdF1pokEfSSvJk4xBF6tac3fFiwppq9W17HZ856T
	 nXyofPnnHKXtACuhdNsb29D1E7t9+KhKedCAQAys=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	NeilBrown <neil@brown.name>,
	Jeff Layton <jlayton@kernel.org>,
	Olga Kornievskaia <okorniev@redhat.com>,
	Chuck Lever <chuck.lever@oracle.com>
Subject: [PATCH 6.18 004/181] nfsd: check that server is running in unlock_filesystem
Date: Thu, 15 Jan 2026 17:45:41 +0100
Message-ID: <20260115164202.473129426@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260115164202.305475649@linuxfoundation.org>
References: <20260115164202.305475649@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

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
@@ -1759,7 +1759,7 @@ static struct nfs4_stid *find_one_sb_sti
 
 /**
  * nfsd4_revoke_states - revoke all nfsv4 states associated with given filesystem
- * @net:  used to identify instance of nfsd (there is one per net namespace)
+ * @nn:   used to identify instance of nfsd (there is one per net namespace)
  * @sb:   super_block used to identify target filesystem
  *
  * All nfs4 states (open, lock, delegation, layout) held by the server instance
@@ -1771,9 +1771,8 @@ static struct nfs4_stid *find_one_sb_sti
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
@@ -259,6 +259,7 @@ static ssize_t write_unlock_fs(struct fi
 	struct path path;
 	char *fo_path;
 	int error;
+	struct nfsd_net *nn;
 
 	/* sanity check */
 	if (size == 0)
@@ -285,7 +286,13 @@ static ssize_t write_unlock_fs(struct fi
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
@@ -841,9 +841,9 @@ static inline void get_nfs4_file(struct
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


