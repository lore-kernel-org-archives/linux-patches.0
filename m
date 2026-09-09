Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5382D348C7B;
	Wed,  9 Sep 2026 13:47:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788961640; cv=none; b=QrwzsSP+DnXxbeb2ktlLhkp2u9LBYM2OobZYDBxJkdvw6bjWFp4fEnysNojtCHr4nzcHpGzVbh4K75D0A2jqnBjQ1pPOqHidJBBRvRrlUSo7KWBbwaZqkwP47hxI9TTE0wzqCllvBxbn5IOVZqdqY/tyO+hZrAo24MGEaYEiEks=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788961640; c=relaxed/simple;
	bh=BAoTAAshHC4QFTydwXYit+6jOBUS7oa/IxMN5nynaxA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ZS/SvRmML63W+7/RLXujatn1VPLYK2T3GvcZALGcD6dWBADCu23YW2huqE1GOmwIVvcD/Y6xCwf2K2tJ8A/yRhvvhOvik9h7weDSPs5PQVauS2wYaVhJXR1d9/6pX1qrm4WChOoH2zn68T+x3VUKUPVPYLYR+v1Nm1j1dtTjZJk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=18HyRmBq; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="18HyRmBq"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id ADED01F00A3D;
	Wed,  9 Sep 2026 13:47:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1788961639;
	bh=OO6TAKX2gEtVpCPw8m6TbM6YhplbyHptz7dnYJIRBls=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=18HyRmBq23u+BORAFsB+IKkqaOzSJQ4XskvM9MpY0utmDadXKSrXGBmIHPRRSHU/F
	 tObbuKatPP281QgIxVIPDGhClq8vSbRe0qak9QgF0ta4S6F7f5kDJyV7DyB1XkvWE1
	 UnjQMccrn7DTdsojuf18GPw8Ig1XbqgJBX4+eIiE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	XIAO WU <xiaowu.417@qq.com>,
	Jeff Layton <jlayton@kernel.org>,
	Chuck Lever <cel@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.2 019/556] NFSD: Guard admin state-revocation walks with NFSD_NET_UP
Date: Wed,  9 Sep 2026 15:34:59 +0200
Message-ID: <20260909134231.164137036@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260909134230.441546314@linuxfoundation.org>
References: <20260909134230.441546314@linuxfoundation.org>
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

7.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Chuck Lever <cel@kernel.org>

[ Upstream commit 2f3e6638aebc0ab8afb8b4e9816ea9a1cad85378 ]

Writing to /proc/fs/nfsd/unlock_filesystem, or sending the
NFSD_CMD_UNLOCK_FILESYSTEM or NFSD_CMD_UNLOCK_EXPORT netlink command,
walks the NFSv4 client hash tables to revoke open state and cancel
async COPY operations.  All three handlers gate that walk on
nn->nfsd_serv, but a listener added via portlist or netlink
listener_set sets nn->nfsd_serv before any nfsd thread starts.
nfsd_startup_net() has not yet allocated nn->conf_id_hashtbl, so the
walkers dereference a NULL table.  A local administrator with
CAP_SYS_ADMIN can crash the kernel this way without ever starting the
server.

nn->nfsd_serv is set when the service is created, which precedes
table allocation.  NFSD_NET_UP instead brackets the window where the
tables are live: set at the end of nfsd_startup_net() and cleared in
nfsd_shutdown_net() after they are freed, both under nfsd_mutex.
Gating the three unlock paths on NFSD_NET_UP fixes the startup-time
NULL dereference while preserving the earlier post-shutdown
use-after-free fix.

Reported-by: XIAO WU <xiaowu.417@qq.com>
Fixes: 1ac3629bf012 ("nfsd: prepare for supporting admin-revocation of state")
Cc: stable@vger.kernel.org
Reviewed-by: Jeff Layton <jlayton@kernel.org>
Link: https://patch.msgid.link/20260621162551.2469460-1-cel@kernel.org
Signed-off-by: Chuck Lever <cel@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/nfsd/nfs4proc.c  |    7 +++----
 fs/nfsd/nfs4state.c |   14 ++++++--------
 fs/nfsd/nfsctl.c    |    6 +++---
 3 files changed, 12 insertions(+), 15 deletions(-)

--- a/fs/nfsd/nfs4proc.c
+++ b/fs/nfsd/nfs4proc.c
@@ -1598,10 +1598,9 @@ static bool nfsd4_copy_on_sb(const struc
  * @net: net namespace containing the copy operations
  * @sb: targeted superblock
  *
- * Context: Caller must hold nfsd_mutex with nn->nfsd_serv confirmed
- *          non-NULL.  nfs4_state_destroy_net() frees conf_id_hashtbl
- *          at server shutdown without clearing the pointer, so a
- *          walk without these guarantees iterates freed slab memory.
+ * Context: Caller must hold nfsd_mutex with NFSD_NET_UP set.  Outside
+ *          that window nn->conf_id_hashtbl is unallocated or freed,
+ *          so the walk would dereference a NULL or dangling pointer.
  */
 void nfsd4_cancel_copy_by_sb(struct net *net, struct super_block *sb)
 {
--- a/fs/nfsd/nfs4state.c
+++ b/fs/nfsd/nfs4state.c
@@ -1947,10 +1947,9 @@ static void revoke_one_stid(struct nfsd_
  * The clients which own the states will subsequently be notified that the
  * states have been "admin-revoked".
  *
- * Context: Caller must hold nfsd_mutex with nn->nfsd_serv confirmed
- *          non-NULL.  nfs4_state_destroy_net() frees conf_id_hashtbl
- *          at server shutdown without clearing the pointer, so a
- *          walk without these guarantees iterates freed slab memory.
+ * Context: Caller must hold nfsd_mutex with NFSD_NET_UP set.  Outside
+ *          that window nn->conf_id_hashtbl is unallocated or freed,
+ *          so the walk would dereference a NULL or dangling pointer.
  */
 void nfsd4_revoke_states(struct nfsd_net *nn, struct super_block *sb)
 {
@@ -2038,10 +2037,9 @@ static struct nfs4_stid *find_one_export
  * Userspace (exportfs -u) sends this after removing the last client
  * for a path, enabling the underlying filesystem to be unmounted.
  *
- * Context: Caller must hold nfsd_mutex with nn->nfsd_serv confirmed
- *          non-NULL.  nfs4_state_destroy_net() frees conf_id_hashtbl
- *          at server shutdown without clearing the pointer, so a
- *          walk without these guarantees iterates freed slab memory.
+ * Context: Caller must hold nfsd_mutex with NFSD_NET_UP set.  Outside
+ *          that window nn->conf_id_hashtbl is unallocated or freed,
+ *          so the walk would dereference a NULL or dangling pointer.
  */
 void nfsd4_revoke_export_states(struct nfsd_net *nn, const struct path *path)
 {
--- a/fs/nfsd/nfsctl.c
+++ b/fs/nfsd/nfsctl.c
@@ -299,7 +299,7 @@ static ssize_t write_unlock_fs(struct fi
 	error = nlmsvc_unlock_all_by_sb(path.dentry->d_sb);
 	mutex_lock(&nfsd_mutex);
 	nn = net_generic(netns(file), nfsd_net_id);
-	if (nn->nfsd_serv) {
+	if (test_bit(NFSD_NET_UP, &nn->flags)) {
 		nfsd4_cancel_copy_by_sb(netns(file), path.dentry->d_sb);
 		nfsd4_revoke_states(nn, path.dentry->d_sb);
 	} else {
@@ -2424,7 +2424,7 @@ int nfsd_nl_unlock_filesystem_doit(struc
 	error = nlmsvc_unlock_all_by_sb(path.dentry->d_sb);
 
 	mutex_lock(&nfsd_mutex);
-	if (nn->nfsd_serv) {
+	if (test_bit(NFSD_NET_UP, &nn->flags)) {
 		nfsd4_cancel_copy_by_sb(net, path.dentry->d_sb);
 		nfsd4_revoke_states(nn, path.dentry->d_sb);
 	} else {
@@ -2471,7 +2471,7 @@ int nfsd_nl_unlock_export_doit(struct sk
 		return error;
 
 	mutex_lock(&nfsd_mutex);
-	if (nn->nfsd_serv) {
+	if (test_bit(NFSD_NET_UP, &nn->flags)) {
 		nfsd_file_close_export(net, &path);
 		nfsd4_revoke_export_states(nn, &path);
 	} else


