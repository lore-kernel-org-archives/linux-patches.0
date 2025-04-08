Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 678E72673B7;
	Tue,  8 Apr 2025 12:20:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744114821; cv=none; b=fFAR05xe+k8h2/xt3iOcs4CZjSDvGe4S7VzvbtJm8CxliTV1qCqTxzU60ZHyz56dvhLm/NXZDijUvbmS9+ZjSKl7W4VFOMLEK4D393KlSzCIYs0vm+I30g5SRmDNDPaRZBhADbj/1RgV8psi/Jhqp+fD1fWWmGtFGmXs1YDXPL8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744114821; c=relaxed/simple;
	bh=oBqLLNzmKETf4l85E9sAtnxrOODF8Pn0v4vU/XQQPZw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=WwRXPJ3RSzsX2/+Iz3kRozq0eSo4rdHa6pe2xZ7zZDiGWDsxF843QmtnCAO8VUQQ5Wm2lXsWamJkaDU3vpyThU+iwBbNG0y3PX5u8jPlWQooDZquMrluBhqCxvgrx7PAVZyiH8HlfFxw6C6aOpH7iPertQeaxL47fFQMSeMi6IY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=diecdTqc; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="diecdTqc"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EE579C4CEE5;
	Tue,  8 Apr 2025 12:20:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1744114821;
	bh=oBqLLNzmKETf4l85E9sAtnxrOODF8Pn0v4vU/XQQPZw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=diecdTqcxBIxK9QUadm5OnzyXoUFf0MaVwSqgVSA2Qd57FbJVGm4L9z4kKRQW2n5d
	 N//SimvvV6CZLXWTudsJao/nhRhBHHWd8SyDziMsMYaGwPtz2kUxNcld7bsXLAYVA5
	 fJosarfNf6TspH5klY6fDM7n1OuuN6AmMF0eWBGE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Trond Myklebust <trond.myklebust@hammerspace.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.13 246/499] NFSv4: Avoid unnecessary scans of filesystems for returning delegations
Date: Tue,  8 Apr 2025 12:47:38 +0200
Message-ID: <20250408104857.349753965@linuxfoundation.org>
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

[ Upstream commit 35a566a24e58f1b5f89737edf60b77de58719ed0 ]

The amount of looping through the list of delegations is occasionally
leading to soft lockups. If the state manager was asked to return
delegations asynchronously, it should only scan those filesystems that
hold delegations that need to be returned.

Fixes: af3b61bf6131 ("NFSv4: Clean up nfs_client_return_marked_delegations()")
Signed-off-by: Trond Myklebust <trond.myklebust@hammerspace.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/nfs/delegation.c       | 5 +++++
 include/linux/nfs_fs_sb.h | 2 ++
 2 files changed, 7 insertions(+)

diff --git a/fs/nfs/delegation.c b/fs/nfs/delegation.c
index df77d68d9ff99..d1f5e497729c3 100644
--- a/fs/nfs/delegation.c
+++ b/fs/nfs/delegation.c
@@ -79,6 +79,7 @@ static void nfs_mark_return_delegation(struct nfs_server *server,
 				       struct nfs_delegation *delegation)
 {
 	set_bit(NFS_DELEGATION_RETURN, &delegation->flags);
+	set_bit(NFS4SERV_DELEGRETURN, &server->delegation_flags);
 	set_bit(NFS4CLNT_DELEGRETURN, &server->nfs_client->cl_state);
 }
 
@@ -608,6 +609,9 @@ static int nfs_server_return_marked_delegations(struct nfs_server *server,
 	struct nfs_delegation *place_holder_deleg = NULL;
 	int err = 0;
 
+	if (!test_and_clear_bit(NFS4SERV_DELEGRETURN,
+				&server->delegation_flags))
+		return 0;
 restart:
 	/*
 	 * To avoid quadratic looping we hold a reference
@@ -659,6 +663,7 @@ static int nfs_server_return_marked_delegations(struct nfs_server *server,
 		cond_resched();
 		if (!err)
 			goto restart;
+		set_bit(NFS4SERV_DELEGRETURN, &server->delegation_flags);
 		set_bit(NFS4CLNT_DELEGRETURN, &server->nfs_client->cl_state);
 		goto out;
 	}
diff --git a/include/linux/nfs_fs_sb.h b/include/linux/nfs_fs_sb.h
index b804346a97419..98fc10ee0b869 100644
--- a/include/linux/nfs_fs_sb.h
+++ b/include/linux/nfs_fs_sb.h
@@ -251,6 +251,8 @@ struct nfs_server {
 	struct list_head	ss_copies;
 	struct list_head	ss_src_copies;
 
+	unsigned long		delegation_flags;
+#define NFS4SERV_DELEGRETURN		(1)
 	unsigned long		delegation_gen;
 	unsigned long		mig_gen;
 	unsigned long		mig_status;
-- 
2.39.5



