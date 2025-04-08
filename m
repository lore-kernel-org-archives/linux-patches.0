Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A0D20268C5D;
	Tue,  8 Apr 2025 11:29:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744111772; cv=none; b=bbS6XdnwHD/TG7ojCf2esdxVuBG3zCmUaVujXhSW0FnSbTVKpx+//bQG15+HKrJJUVW+rS9nrc61YOYXSciLWuXvEglq8kmtt0CYgjEVeVQX8wiF10m6ftDroXTNJ97lgQ8R/KBilRPDdKsDE2XbBINO1RoQAT0clpUPSsO0ook=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744111772; c=relaxed/simple;
	bh=m86NnHeyUYP0lQLbNx2aC4p+WhURhEGQvsAPhX0s/uQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=UNBnR8cE6fjO/M05KxjvNYtsz2GqMeLOQsrHbzBUMjNtwtYIzvMwxSyAFKE90dNmtbuQQEuQib/t/Hb73O5eP9QuPrKgHGDw7pYFWjaIeZ492dXPudmmAZSBin5GRrWcfRXI8s4NwBpfCijJg3mzLkm+WWYEd3YmKHzt73e/IJM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=FI1nJ/9D; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="FI1nJ/9D"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2FA74C4CEE5;
	Tue,  8 Apr 2025 11:29:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1744111772;
	bh=m86NnHeyUYP0lQLbNx2aC4p+WhURhEGQvsAPhX0s/uQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=FI1nJ/9DNRtZL2QVPDKdhAskQXPxv3y6eUswfcxrAano717DRbKf7or/cl6pwNk3+
	 7Rb5uWe/mWvPVLdjYEib2JoAvNS1IAGb9HTzNPNmyRqcHrGvpGFIlpYzqC+NK3ZQ+K
	 6hOkHrbSeqwSq7tfouPedG5ttyYefENPrOAs/bx8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Trond Myklebust <trond.myklebust@hammerspace.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.14 515/731] NFSv4: Dont trigger uneccessary scans for return-on-close delegations
Date: Tue,  8 Apr 2025 12:46:52 +0200
Message-ID: <20250408104926.253382482@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250408104914.247897328@linuxfoundation.org>
References: <20250408104914.247897328@linuxfoundation.org>
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

6.14-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Trond Myklebust <trond.myklebust@hammerspace.com>

[ Upstream commit 47acca884f714f41d95dc654f802845544554784 ]

The amount of looping through the list of delegations is occasionally
leading to soft lockups. Avoid at least some loops by not requiring the
NFSv4 state manager to scan for delegations that are marked for
return-on-close. Instead, either mark them for immediate return (if
possible) or else leave it up to nfs4_inode_return_delegation_on_close()
to return them once the file is closed by the application.

Fixes: b757144fd77c ("NFSv4: Be less aggressive about returning delegations for open files")
Signed-off-by: Trond Myklebust <trond.myklebust@hammerspace.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/nfs/delegation.c | 33 ++++++++++++++++++---------------
 1 file changed, 18 insertions(+), 15 deletions(-)

diff --git a/fs/nfs/delegation.c b/fs/nfs/delegation.c
index 4db912f562305..df77d68d9ff99 100644
--- a/fs/nfs/delegation.c
+++ b/fs/nfs/delegation.c
@@ -590,17 +590,6 @@ static bool nfs_delegation_need_return(struct nfs_delegation *delegation)
 
 	if (test_and_clear_bit(NFS_DELEGATION_RETURN, &delegation->flags))
 		ret = true;
-	else if (test_bit(NFS_DELEGATION_RETURN_IF_CLOSED, &delegation->flags)) {
-		struct inode *inode;
-
-		spin_lock(&delegation->lock);
-		inode = delegation->inode;
-		if (inode && list_empty(&NFS_I(inode)->open_files))
-			ret = true;
-		spin_unlock(&delegation->lock);
-	}
-	if (ret)
-		clear_bit(NFS_DELEGATION_RETURN_IF_CLOSED, &delegation->flags);
 	if (test_bit(NFS_DELEGATION_RETURNING, &delegation->flags) ||
 	    test_bit(NFS_DELEGATION_RETURN_DELAYED, &delegation->flags) ||
 	    test_bit(NFS_DELEGATION_REVOKED, &delegation->flags))
@@ -878,11 +867,25 @@ int nfs4_inode_make_writeable(struct inode *inode)
 	return nfs4_inode_return_delegation(inode);
 }
 
-static void nfs_mark_return_if_closed_delegation(struct nfs_server *server,
-		struct nfs_delegation *delegation)
+static void
+nfs_mark_return_if_closed_delegation(struct nfs_server *server,
+				     struct nfs_delegation *delegation)
 {
-	set_bit(NFS_DELEGATION_RETURN_IF_CLOSED, &delegation->flags);
-	set_bit(NFS4CLNT_DELEGRETURN, &server->nfs_client->cl_state);
+	struct inode *inode;
+
+	if (test_bit(NFS_DELEGATION_RETURN, &delegation->flags) ||
+	    test_bit(NFS_DELEGATION_RETURN_IF_CLOSED, &delegation->flags))
+		return;
+	spin_lock(&delegation->lock);
+	inode = delegation->inode;
+	if (!inode)
+		goto out;
+	if (list_empty(&NFS_I(inode)->open_files))
+		nfs_mark_return_delegation(server, delegation);
+	else
+		set_bit(NFS_DELEGATION_RETURN_IF_CLOSED, &delegation->flags);
+out:
+	spin_unlock(&delegation->lock);
 }
 
 static bool nfs_server_mark_return_all_delegations(struct nfs_server *server)
-- 
2.39.5



