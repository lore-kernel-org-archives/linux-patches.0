Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 155EA4F55A5;
	Wed,  9 Sep 2026 13:47:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788961638; cv=none; b=Y/cEBzJZZAZ1cX6Ngv5N00NCmjiq2v8f83/e5hUP2n3UUAZzA5nWwSQYJIjpgmufkhJA1FTrypMlQovOf4WwjUX92lWZxrNI0cfVQwmMKNKupTJukNgfYyl9rjcL2hSazYVUrrS8UEGbsmsYpJM2mTXHhDvKgcpyvxFaRC2UPKs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788961638; c=relaxed/simple;
	bh=YUW6JHOAqdSyQ5e+cqp0boJOeM1os/MTDLVtPjhBRPs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=QVD1Li4bG2fARC+ig7Rrqko9Kj9gN2WZjbhd8bDNYi8amsVAyJJ8q3JzabEugNcHQCPh+7dquy1Qzw9aImuvzo5dLadscCTcGg+MaqdN7IlJibxyn9ydIWBJrpvXZk5Y6ZAZG5Mwso+RWJK+LqVFnQgE9MoTF8qOvtUapEP/KE4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=wPNdaiIY; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="wPNdaiIY"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CE0E11F00A3A;
	Wed,  9 Sep 2026 13:47:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1788961636;
	bh=PaobECYBkxn5Tttyc1mI0v1TzXnkFEhc2ePnUkjzclY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=wPNdaiIYI6DhNc4TR2Eo9znJPj9yNz47sMBghZ//LYBcWjCxDdelqgeOqRfohqVn4
	 h2RK24U13/0a4C4x4BD6TIPbQxpHBziRfk/7jVniEiq30PD9R8wGzTRvrx71FMfDzU
	 d5L8vbf+91eGfID3wdK2y4md+qwyif4TIfjkKPJo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jeff Layton <jlayton@kernel.org>,
	Chuck Lever <cel@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.2 018/556] NFSD: Annotate caller preconditions for the state-table walkers
Date: Wed,  9 Sep 2026 15:34:58 +0200
Message-ID: <20260909134231.133024979@linuxfoundation.org>
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

[ Upstream commit 5f367f05481d56be90f8c13eee4cb421cd7af2d8 ]

The state-table walkers now assert nfsd_mutex with
lockdep_assert_held() and document the nfsd_mutex / nn->nfsd_serv
precondition in a Context: kdoc section, so the next caller added to
this path cannot silently reintroduce the same use-after-free.

Reviewed-by: Jeff Layton <jlayton@kernel.org>
Link: https://patch.msgid.link/20260613-unlock-filesystem-uaf-v1-3-462b9bec8c84@kernel.org
Signed-off-by: Chuck Lever <cel@kernel.org>
Stable-dep-of: 2f3e6638aebc ("NFSD: Guard admin state-revocation walks with NFSD_NET_UP")
Signed-off-by: Sasha Levin <sashal@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/nfsd/nfs4proc.c  |    6 ++++++
 fs/nfsd/nfs4state.c |   16 +++++++++++++++-
 2 files changed, 21 insertions(+), 1 deletion(-)

--- a/fs/nfsd/nfs4proc.c
+++ b/fs/nfsd/nfs4proc.c
@@ -1597,6 +1597,11 @@ static bool nfsd4_copy_on_sb(const struc
  * nfsd4_cancel_copy_by_sb - cancel async copy operations on @sb
  * @net: net namespace containing the copy operations
  * @sb: targeted superblock
+ *
+ * Context: Caller must hold nfsd_mutex with nn->nfsd_serv confirmed
+ *          non-NULL.  nfs4_state_destroy_net() frees conf_id_hashtbl
+ *          at server shutdown without clearing the pointer, so a
+ *          walk without these guarantees iterates freed slab memory.
  */
 void nfsd4_cancel_copy_by_sb(struct net *net, struct super_block *sb)
 {
@@ -1606,6 +1611,7 @@ void nfsd4_cancel_copy_by_sb(struct net
 	unsigned int idhashval;
 	LIST_HEAD(to_cancel);
 
+	lockdep_assert_held(&nfsd_mutex);
 	spin_lock(&nn->client_lock);
 	for (idhashval = 0; idhashval < CLIENT_HASH_SIZE; idhashval++) {
 		struct list_head *head = &nn->conf_id_hashtbl[idhashval];
--- a/fs/nfsd/nfs4state.c
+++ b/fs/nfsd/nfs4state.c
@@ -1944,14 +1944,21 @@ static void revoke_one_stid(struct nfsd_
  * being released.  Thus nfsd will no longer prevent the filesystem from being
  * unmounted.
  *
- * The clients which own the states will subsequently being notified that the
+ * The clients which own the states will subsequently be notified that the
  * states have been "admin-revoked".
+ *
+ * Context: Caller must hold nfsd_mutex with nn->nfsd_serv confirmed
+ *          non-NULL.  nfs4_state_destroy_net() frees conf_id_hashtbl
+ *          at server shutdown without clearing the pointer, so a
+ *          walk without these guarantees iterates freed slab memory.
  */
 void nfsd4_revoke_states(struct nfsd_net *nn, struct super_block *sb)
 {
 	unsigned int idhashval;
 	unsigned int sc_types;
 
+	lockdep_assert_held(&nfsd_mutex);
+
 	sc_types = SC_TYPE_OPEN | SC_TYPE_LOCK | SC_TYPE_DELEG | SC_TYPE_LAYOUT;
 
 	spin_lock(&nn->client_lock);
@@ -2030,12 +2037,19 @@ static struct nfs4_stid *find_one_export
  *
  * Userspace (exportfs -u) sends this after removing the last client
  * for a path, enabling the underlying filesystem to be unmounted.
+ *
+ * Context: Caller must hold nfsd_mutex with nn->nfsd_serv confirmed
+ *          non-NULL.  nfs4_state_destroy_net() frees conf_id_hashtbl
+ *          at server shutdown without clearing the pointer, so a
+ *          walk without these guarantees iterates freed slab memory.
  */
 void nfsd4_revoke_export_states(struct nfsd_net *nn, const struct path *path)
 {
 	unsigned int idhashval;
 	unsigned int sc_types;
 
+	lockdep_assert_held(&nfsd_mutex);
+
 	sc_types = SC_TYPE_OPEN | SC_TYPE_LOCK | SC_TYPE_DELEG | SC_TYPE_LAYOUT;
 
 	spin_lock(&nn->client_lock);


