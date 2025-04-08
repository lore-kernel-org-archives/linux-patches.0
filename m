Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8ED1A270EAC;
	Tue,  8 Apr 2025 12:50:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744116607; cv=none; b=oJLfA8bufACKaCPWic7/hENDaOoTOqRB0PZTWV8e2Rf8gA7aC7EtVzIeNl6WGzMWsBCSpg8i5oFvllsPd8I+yKqo3bGGfj2oyhq6n0L/HAkgAZq79l5xUOZYTN6JQxlTAQlRe5NNicMGw2xYGUdc7yGuzb+IwvB8QKvRv10ZmyE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744116607; c=relaxed/simple;
	bh=obuebCR3VBR/fNd95I777PVRU2nw/yv8ixsVLJ5VYh8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=IsOFPJpmDwCsdcusTI6HrdD9dSuNu88xx4suFkKOX/xMphGoJdVNQrSWotls82Qin7Wekyh/js3fUECyAn5cQj9b2aSc2B1MBuqUdno6EZLzcNTs0NLtdq2pb8WCDy+OyxqRdLLpfMwvaogijp3s2y3zxLdniQyhi1g9Q86AfVQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ffJvrvhO; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ffJvrvhO"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2084AC4CEE5;
	Tue,  8 Apr 2025 12:50:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1744116607;
	bh=obuebCR3VBR/fNd95I777PVRU2nw/yv8ixsVLJ5VYh8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ffJvrvhO1OtTG2oydIb0tx3AIhw96mUy3MX3O9STKQQezBBYbUSl+rebW2a9hy6MF
	 H1IiuOh23o2vgYW1F6S9RKBdIas/cWO/VUVI75pKxWvATNrP1GsCCZUicraHg3rK9b
	 flU2ksQwhPm8Z3rn5buWYe58bzoNGVcOacQt+oO4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Trond Myklebust <trond.myklebust@hammerspace.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 202/423] NFSv4: Avoid unnecessary scans of filesystems for expired delegations
Date: Tue,  8 Apr 2025 12:48:48 +0200
Message-ID: <20250408104850.441625645@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250408104845.675475678@linuxfoundation.org>
References: <20250408104845.675475678@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Trond Myklebust <trond.myklebust@hammerspace.com>

[ Upstream commit f163aa81a799e2d46d7f8f0b42a0e7770eaa0d06 ]

The amount of looping through the list of delegations is occasionally
leading to soft lockups.  If the state manager was asked to reap the
expired delegations, it should scan only those filesystems that hold
delegations that need to be reaped.

Fixes: 7f156ef0bf45 ("NFSv4: Clean up nfs_delegation_reap_expired()")
Signed-off-by: Trond Myklebust <trond.myklebust@hammerspace.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/nfs/delegation.c       | 7 +++++++
 include/linux/nfs_fs_sb.h | 1 +
 2 files changed, 8 insertions(+)

diff --git a/fs/nfs/delegation.c b/fs/nfs/delegation.c
index d1f5e497729c3..abd952cc47e4b 100644
--- a/fs/nfs/delegation.c
+++ b/fs/nfs/delegation.c
@@ -1284,6 +1284,7 @@ static void nfs_mark_test_expired_delegation(struct nfs_server *server,
 		return;
 	clear_bit(NFS_DELEGATION_NEED_RECLAIM, &delegation->flags);
 	set_bit(NFS_DELEGATION_TEST_EXPIRED, &delegation->flags);
+	set_bit(NFS4SERV_DELEGATION_EXPIRED, &server->delegation_flags);
 	set_bit(NFS4CLNT_DELEGATION_EXPIRED, &server->nfs_client->cl_state);
 }
 
@@ -1362,6 +1363,9 @@ static int nfs_server_reap_expired_delegations(struct nfs_server *server,
 	nfs4_stateid stateid;
 	unsigned long gen = ++server->delegation_gen;
 
+	if (!test_and_clear_bit(NFS4SERV_DELEGATION_EXPIRED,
+				&server->delegation_flags))
+		return 0;
 restart:
 	rcu_read_lock();
 	list_for_each_entry_rcu(delegation, &server->delegations, super_list) {
@@ -1391,6 +1395,9 @@ static int nfs_server_reap_expired_delegations(struct nfs_server *server,
 			goto restart;
 		}
 		nfs_inode_mark_test_expired_delegation(server,inode);
+		set_bit(NFS4SERV_DELEGATION_EXPIRED, &server->delegation_flags);
+		set_bit(NFS4CLNT_DELEGATION_EXPIRED,
+			&server->nfs_client->cl_state);
 		iput(inode);
 		return -EAGAIN;
 	}
diff --git a/include/linux/nfs_fs_sb.h b/include/linux/nfs_fs_sb.h
index 98fc10ee0b869..f4cb1f4850a0c 100644
--- a/include/linux/nfs_fs_sb.h
+++ b/include/linux/nfs_fs_sb.h
@@ -253,6 +253,7 @@ struct nfs_server {
 
 	unsigned long		delegation_flags;
 #define NFS4SERV_DELEGRETURN		(1)
+#define NFS4SERV_DELEGATION_EXPIRED	(2)
 	unsigned long		delegation_gen;
 	unsigned long		mig_gen;
 	unsigned long		mig_status;
-- 
2.39.5



