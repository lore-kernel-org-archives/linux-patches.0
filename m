Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 28908345726;
	Tue, 26 Aug 2025 13:48:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756216137; cv=none; b=S/iZOQqYK/A2t68ig5gh7y8Q3xlMNzGdqszXXAMk7mXBnplfnRCF/77pOJ2JGnW7S1Lrg4PAJzkibLsQK7znW8FevDO+ukS1wlDDjNYtiZ4kG8MId58IVOdLjixj422JSndjfT7nUi+AkAZnv4Vz0/sAnSMR5ZLQv1RSLnv2EIc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756216137; c=relaxed/simple;
	bh=xlWqR+dVjXF58S4uo4W1zxBvmoaSAu3Ht/lyGvixgIQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=t0fgTD1/xmVwXasE9uOEs1W8bGlzUEeo4iPbkYLPQm9ltWBAGzFI0omspharmvg2hpx5LFKnBlpc/1HRPciRdbgN+gfzyWHdjiyV9ARWNB6yepYRh8rkYc5aR7T6Kj0Z5wVbMxW/La1lsjgKIAws2V55oa90xnJi1NksgLGicVQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=PKeO6XRD; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="PKeO6XRD"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AE6EDC4CEF1;
	Tue, 26 Aug 2025 13:48:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1756216137;
	bh=xlWqR+dVjXF58S4uo4W1zxBvmoaSAu3Ht/lyGvixgIQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=PKeO6XRDLLMYJg02WGigrwhKgmNLFYWJI11IqQPb0FOBVmzfaXTYc8LZELqvytzGX
	 hUhAP1pN8Mrzz0mSgW6U+87ON71UzX0MTZKU312LwCl9Jz7EwxLOIiI9ddTzT11LzO
	 o2zyZw7J9wZSQyeZLVFa9fQcHePWEy90Cp2Eh8XE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	lei lu <llfamsec@gmail.com>,
	Jeff Layton <jlayton@kernel.org>,
	Chuck Lever <chuck.lever@oracle.com>
Subject: [PATCH 5.15 266/644] nfsd: handle get_client_locked() failure in nfsd4_setclientid_confirm()
Date: Tue, 26 Aug 2025 13:05:57 +0200
Message-ID: <20250826110952.966760008@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250826110946.507083938@linuxfoundation.org>
References: <20250826110946.507083938@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jeff Layton <jlayton@kernel.org>

commit 908e4ead7f757504d8b345452730636e298cbf68 upstream.

Lei Lu recently reported that nfsd4_setclientid_confirm() did not check
the return value from get_client_locked(). a SETCLIENTID_CONFIRM could
race with a confirmed client expiring and fail to get a reference. That
could later lead to a UAF.

Fix this by getting a reference early in the case where there is an
extant confirmed client. If that fails then treat it as if there were no
confirmed client found at all.

In the case where the unconfirmed client is expiring, just fail and
return the result from get_client_locked().

Reported-by: lei lu <llfamsec@gmail.com>
Closes: https://lore.kernel.org/linux-nfs/CAEBF3_b=UvqzNKdnfD_52L05Mqrqui9vZ2eFamgAbV0WG+FNWQ@mail.gmail.com/
Fixes: d20c11d86d8f ("nfsd: Protect session creation and client confirm using client_lock")
Cc: stable@vger.kernel.org
Signed-off-by: Jeff Layton <jlayton@kernel.org>
Signed-off-by: Chuck Lever <chuck.lever@oracle.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/nfsd/nfs4state.c |   20 +++++++++++++++-----
 1 file changed, 15 insertions(+), 5 deletions(-)

--- a/fs/nfsd/nfs4state.c
+++ b/fs/nfsd/nfs4state.c
@@ -4285,10 +4285,16 @@ nfsd4_setclientid_confirm(struct svc_rqs
 	}
 	status = nfs_ok;
 	if (conf) {
-		old = unconf;
-		unhash_client_locked(old);
-		nfsd4_change_callback(conf, &unconf->cl_cb_conn);
-	} else {
+		if (get_client_locked(conf) == nfs_ok) {
+			old = unconf;
+			unhash_client_locked(old);
+			nfsd4_change_callback(conf, &unconf->cl_cb_conn);
+		} else {
+			conf = NULL;
+		}
+	}
+
+	if (!conf) {
 		old = find_confirmed_client_by_name(&unconf->cl_name, nn);
 		if (old) {
 			status = nfserr_clid_inuse;
@@ -4305,10 +4311,14 @@ nfsd4_setclientid_confirm(struct svc_rqs
 			}
 			trace_nfsd_clid_replaced(&old->cl_clientid);
 		}
+		status = get_client_locked(unconf);
+		if (status != nfs_ok) {
+			old = NULL;
+			goto out;
+		}
 		move_to_confirmed(unconf);
 		conf = unconf;
 	}
-	get_client_locked(conf);
 	spin_unlock(&nn->client_lock);
 	if (conf == unconf)
 		fsnotify_dentry(conf->cl_nfsd_info_dentry, FS_MODIFY);


