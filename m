Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 22A4A11C83
	for <patches@lists.linux.dev>; Mon, 28 Aug 2023 10:21:28 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9BBA9C433C7;
	Mon, 28 Aug 2023 10:21:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1693218088;
	bh=gsPb8MZmR6kG16j5tSbTsuMYEdqdtn5h4bwm5wL+GJI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=hMMwK8GZdl46HvSi9526DD+J106L/40OCZE36LDpFA+ESSt+TFhye99hpcFY5Q4p9
	 3XdSNIpLr4yRIJ8VvY8vnEAa51DqhhPXSMZKRA882PjdKXuM+sKb2Ao4lsT/OyMBnP
	 AM5T1BtZzAuv8efrYYtxabksO924dYrDUZlZRO9w=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Benjamin Coddington <bcodding@redhat.com>,
	Jeff Layton <jlayton@kernel.org>,
	Chuck Lever <chuck.lever@oracle.com>
Subject: [PATCH 6.4 090/129] nfsd: Fix race to FREE_STATEID and cl_revoked
Date: Mon, 28 Aug 2023 12:12:49 +0200
Message-ID: <20230828101200.343003820@linuxfoundation.org>
X-Mailer: git-send-email 2.42.0
In-Reply-To: <20230828101157.383363777@linuxfoundation.org>
References: <20230828101157.383363777@linuxfoundation.org>
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

6.4-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Benjamin Coddington <bcodding@redhat.com>

commit 3b816601e279756e781e6c4d9b3f3bd21a72ac67 upstream.

We have some reports of linux NFS clients that cannot satisfy a linux knfsd
server that always sets SEQ4_STATUS_RECALLABLE_STATE_REVOKED even though
those clients repeatedly walk all their known state using TEST_STATEID and
receive NFS4_OK for all.

Its possible for revoke_delegation() to set NFS4_REVOKED_DELEG_STID, then
nfsd4_free_stateid() finds the delegation and returns NFS4_OK to
FREE_STATEID.  Afterward, revoke_delegation() moves the same delegation to
cl_revoked.  This would produce the observed client/server effect.

Fix this by ensuring that the setting of sc_type to NFS4_REVOKED_DELEG_STID
and move to cl_revoked happens within the same cl_lock.  This will allow
nfsd4_free_stateid() to properly remove the delegation from cl_revoked.

Link: https://bugzilla.redhat.com/show_bug.cgi?id=2217103
Link: https://bugzilla.redhat.com/show_bug.cgi?id=2176575
Signed-off-by: Benjamin Coddington <bcodding@redhat.com>
Cc: stable@vger.kernel.org # v4.17+
Reviewed-by: Jeff Layton <jlayton@kernel.org>
Signed-off-by: Chuck Lever <chuck.lever@oracle.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/nfsd/nfs4state.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/fs/nfsd/nfs4state.c
+++ b/fs/nfsd/nfs4state.c
@@ -1354,9 +1354,9 @@ static void revoke_delegation(struct nfs
 	trace_nfsd_stid_revoke(&dp->dl_stid);
 
 	if (clp->cl_minorversion) {
+		spin_lock(&clp->cl_lock);
 		dp->dl_stid.sc_type = NFS4_REVOKED_DELEG_STID;
 		refcount_inc(&dp->dl_stid.sc_count);
-		spin_lock(&clp->cl_lock);
 		list_add(&dp->dl_recall_lru, &clp->cl_revoked);
 		spin_unlock(&clp->cl_lock);
 	}


