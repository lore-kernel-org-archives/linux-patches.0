Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 21B4B1EB5A;
	Mon,  4 Mar 2024 21:49:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709588981; cv=none; b=Trp6kpLJ8hK9NdgCzPwP2Heu8OSQYQciR2w8N/LNr3y8rqtox70Pyu8W7st9xEPMFwb/hjTQVMzzM2x9hNifTpM/uUSyytL/h4QtdwFgXXhWCU8r1Kq0q9zurJrZwtEU8DZ3j/3SqlTkMKwTJSRfflYwRt/J7YNq/NmgrDLird8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709588981; c=relaxed/simple;
	bh=/PVlykqlVZg4H4VF5GDUWtbTiq9tKZPDD4JVi90h0jM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=dI2Z2cOS3/ABP7FZjFt9s63l1CvEwKopPEB/BlPYYEulioTnDX4aEzChD2gnJpr3VfN5goTVR8qrAhOC/PYdl0oBuWF+LiSw+UFvLhLUqlT0+3rsTsvkuIV3QunkL0zLI2yRLP6JSRty/scm0GzwXd85WEEgOVs+5RUzHbTA5Gw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=u5mVjEK2; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="u5mVjEK2"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A6400C433C7;
	Mon,  4 Mar 2024 21:49:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1709588981;
	bh=/PVlykqlVZg4H4VF5GDUWtbTiq9tKZPDD4JVi90h0jM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=u5mVjEK2vIb+7Umb+UeMmfTonhIZIEUBYrqIo6lteo9BNzoNfsXlA6mmBFQsT8pVh
	 q6G09MsHK/rk95JDgRiyjfRm9PA9vV49Vv7OwI21NuFrxeSkbpBrvOr4Jq1gJX99At
	 eT8tmze3qhtskMxcSudQ47XI7ZLB1ezSie4AEcME=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Chuck Lever <chuck.lever@oracle.com>,
	NeilBrown <neilb@suse.de>,
	Jeff Layton <jlayton@kernel.org>
Subject: [PATCH 6.1 156/215] NFSD: Add a nfsd4_file_hash_remove() helper
Date: Mon,  4 Mar 2024 21:23:39 +0000
Message-ID: <20240304211601.957144377@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240304211556.993132804@linuxfoundation.org>
References: <20240304211556.993132804@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Chuck Lever <chuck.lever@oracle.com>

[ Upstream commit 3341678f2fd6106055cead09e513fad6950a0d19 ]

Refactor to relocate hash deletion operation to a helper function
that is close to most other nfs4_file data structure operations.

The "noinline" annotation will become useful in a moment when the
hlist_del_rcu() is replaced with a more complex rhash remove
operation. It also guarantees that hash remove operations can be
traced with "-p function -l remove_nfs4_file_locked".

This also simplifies the organization of forward declarations: the
to-be-added rhashtable and its param structure will be defined
/after/ put_nfs4_file().

Signed-off-by: Chuck Lever <chuck.lever@oracle.com>
Reviewed-by: NeilBrown <neilb@suse.de>
Reviewed-by: Jeff Layton <jlayton@kernel.org>
Signed-off-by: Chuck Lever <chuck.lever@oracle.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/nfsd/nfs4state.c |    8 +++++++-
 1 file changed, 7 insertions(+), 1 deletion(-)

--- a/fs/nfsd/nfs4state.c
+++ b/fs/nfsd/nfs4state.c
@@ -84,6 +84,7 @@ static bool check_for_locks(struct nfs4_
 static void nfs4_free_ol_stateid(struct nfs4_stid *stid);
 void nfsd4_end_grace(struct nfsd_net *nn);
 static void _free_cpntf_state_locked(struct nfsd_net *nn, struct nfs4_cpntf_state *cps);
+static void nfsd4_file_hash_remove(struct nfs4_file *fi);
 
 /* Locking: */
 
@@ -591,7 +592,7 @@ put_nfs4_file(struct nfs4_file *fi)
 	might_lock(&state_lock);
 
 	if (refcount_dec_and_lock(&fi->fi_ref, &state_lock)) {
-		hlist_del_rcu(&fi->fi_hash);
+		nfsd4_file_hash_remove(fi);
 		spin_unlock(&state_lock);
 		WARN_ON_ONCE(!list_empty(&fi->fi_clnt_odstate));
 		WARN_ON_ONCE(!list_empty(&fi->fi_delegations));
@@ -4750,6 +4751,11 @@ find_or_add_file(struct nfs4_file *new,
 	return insert_file(new, fh, hashval);
 }
 
+static noinline_for_stack void nfsd4_file_hash_remove(struct nfs4_file *fi)
+{
+	hlist_del_rcu(&fi->fi_hash);
+}
+
 /*
  * Called to check deny when READ with all zero stateid or
  * WRITE with all zero or all one stateid


