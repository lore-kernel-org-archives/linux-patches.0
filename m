Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 46441267F5B;
	Tue,  8 Apr 2025 11:04:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744110254; cv=none; b=gP4+VJ+kIYnVKQ0aUFRI/TTbDsuCDZnVALQu9Z1vMM5GOU7Dy4X6q2GYAnmQYWhnPQnSbons+qditULoVd9g6PD4RU1i2UzI42DOOjv/ElyUWNoTmH2I1c/HPQ2VT2bJTnfuAqoG1IEE0BGQ2op2IZpscCTrKzO8e4GAyCjVq7k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744110254; c=relaxed/simple;
	bh=MAS5fLQaK5JfgJh43IkoUQHHeXcV7edAqJN9+EucEtY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=owUuWT8OD2LT+L5MdwPdyDQUU3dcXmbdIT7Ljm3dJkaSDD/rqTiFEoXGJ+uAk5Wf1dZpaTZ1jjGAyHXHATDFuDZ2xSf3PS/Mw1E8KN8v49p9cFaLw4rQ96Vc00aIRp1xDZl1YAqAY6Ga+jg9NQ2Hcmp4K06JfXQJF8ovC+eS+xA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=q6BAowD0; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="q6BAowD0"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CA464C4CEEB;
	Tue,  8 Apr 2025 11:04:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1744110254;
	bh=MAS5fLQaK5JfgJh43IkoUQHHeXcV7edAqJN9+EucEtY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=q6BAowD0mQARMu8aC7sfkfto+NZ2noKCvvoyKBbu31zKDuAADDY0bX20dcNd3mgM0
	 c6ecpODP0h1sdQm7IaqTbUjE0eKgqlQFxlgkIZkjL3Yi6hUJ1rThlQBBEzK2js7vC0
	 oZAslH8cHt61VtcpHvcOV1BIXy8ciF/0A4bT5Yps=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jeff Layton <jlayton@kernel.org>,
	Chuck Lever <chuck.lever@oracle.com>
Subject: [PATCH 5.10 225/227] NFSD: Skip sending CB_RECALL_ANY when the backchannel isnt up
Date: Tue,  8 Apr 2025 12:50:03 +0200
Message-ID: <20250408104827.031960532@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250408104820.353768086@linuxfoundation.org>
References: <20250408104820.353768086@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Chuck Lever <chuck.lever@oracle.com>

commit 8a388c1fabeb6606e16467b23242416c0dbeffad upstream.

NFSD sends CB_RECALL_ANY to clients when the server is low on
memory or that client has a large number of delegations outstanding.

We've seen cases where NFSD attempts to send CB_RECALL_ANY requests
to disconnected clients, and gets confused. These calls never go
anywhere if a backchannel transport to the target client isn't
available. Before the server can send any backchannel operation, the
client has to connect first and then do a BIND_CONN_TO_SESSION.

This patch doesn't address the root cause of the confusion, but
there's no need to queue up these optional operations if they can't
go anywhere.

Fixes: 44df6f439a17 ("NFSD: add delegation reaper to react to low memory condition")
Reviewed-by: Jeff Layton <jlayton@kernel.org>
Cc: stable@vger.kernel.org
Signed-off-by: Chuck Lever <chuck.lever@oracle.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/nfsd/nfs4state.c |   19 ++++++++++++-------
 1 file changed, 12 insertions(+), 7 deletions(-)

--- a/fs/nfsd/nfs4state.c
+++ b/fs/nfsd/nfs4state.c
@@ -6246,14 +6246,19 @@ deleg_reaper(struct nfsd_net *nn)
 	spin_lock(&nn->client_lock);
 	list_for_each_safe(pos, next, &nn->client_lru) {
 		clp = list_entry(pos, struct nfs4_client, cl_lru);
-		if (clp->cl_state != NFSD4_ACTIVE ||
-			list_empty(&clp->cl_delegations) ||
-			atomic_read(&clp->cl_delegs_in_recall) ||
-			test_bit(NFSD4_CLIENT_CB_RECALL_ANY, &clp->cl_flags) ||
-			(ktime_get_boottime_seconds() -
-				clp->cl_ra_time < 5)) {
+
+		if (clp->cl_state != NFSD4_ACTIVE)
+			continue;
+		if (list_empty(&clp->cl_delegations))
+			continue;
+		if (atomic_read(&clp->cl_delegs_in_recall))
+			continue;
+		if (test_bit(NFSD4_CLIENT_CB_RECALL_ANY, &clp->cl_flags))
+			continue;
+		if (ktime_get_boottime_seconds() - clp->cl_ra_time < 5)
+			continue;
+		if (clp->cl_cb_state != NFSD4_CB_UP)
 			continue;
-		}
 		list_add(&clp->cl_ra_cblist, &cblist);
 
 		/* release in nfsd4_cb_recall_any_release */


