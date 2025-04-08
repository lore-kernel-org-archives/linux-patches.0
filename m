Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CCEE2268FE4;
	Tue,  8 Apr 2025 12:20:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744114818; cv=none; b=j06vGjztv0eJFhDS0hxu4ii5WzeKd6TV804jkBZezNiweVfEKuVaztJYQWmC+acgfN9aG5vuU+yhjzzo1p9paeh9PIo2EyeHBLUUDhMxYyGl1n4RnyiXUUh2ohUTqUVPx4ezWzM/cHA1dJZMyfxlEgRwXXB+FpEIvj3hhmruU48=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744114818; c=relaxed/simple;
	bh=jjUS84lyDrMx5AQYhBt0Mg6Xs5AR1XlBACJju2ZmdNI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=A+9LLXl9I4jqJUnA+YByCnT7tFV2badnhh91c7vlNLUp6rhYZ4wsQmg9/Smhd0PmY5d/YFuOsuo4MEVDT6vaeoWnuC6mChNO0IZ0inVuovpRw2u+fLKphWGQQSMyNJ9D/08mNnRwJWTAvJ0Ys/LL1Hwi5OnMa2bwugvPh23fuA8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=CsT+exlr; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="CsT+exlr"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 35D34C4CEE5;
	Tue,  8 Apr 2025 12:20:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1744114818;
	bh=jjUS84lyDrMx5AQYhBt0Mg6Xs5AR1XlBACJju2ZmdNI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=CsT+exlrfMOWC+1Z79b1Ptk9E89sBPJm9wH9S4HWFJUkFn/A/GxNc2+yLBpmJINB4
	 voD9NicF0u3IlccY+McyLqU327pw1uRSuzriurkMHPhNeuPRdIqRPwAYIqSgCkki70
	 8ILDWODwgQ24R0rNiyXadOPH/WPS4MGTWYEquvUo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Trond Myklebust <trond.myklebust@hammerspace.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.13 245/499] NFSv4: Dont trigger uneccessary scans for return-on-close delegations
Date: Tue,  8 Apr 2025 12:47:37 +0200
Message-ID: <20250408104857.323597600@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250408104851.256868745@linuxfoundation.org>
References: <20250408104851.256868745@linuxfoundation.org>
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

6.13-stable review patch.  If anyone has any objections, please let me know.

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



