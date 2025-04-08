Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2636526A1B1;
	Tue,  8 Apr 2025 12:20:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744114824; cv=none; b=BsMT5htJITl8HP0DQSAfYL9JeWSi83nthRPI1GPQOszgtTa0V6//gWqlFsfprWYgsqhWNCg4BwVWcV6NiI0JOl0wlYDhrQuKJO9r8BtpOXW2fCpXejnQnL4XDePbmFsH+syPaU2Zd99GjZT1rkUzvLPq5C8K1x1OdHpNdZwyjOg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744114824; c=relaxed/simple;
	bh=ymsqHOsvKgFbrMJyXKESy3NfE743dpgRGA1ZkfW0ALI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=gIs1LnyUuEpGRR00HY8T0HxH0X2KfbJTDWWuo6mbCwZmrOhzy6L+NMcdH0gORHGL0dh79TPx211IVDyfYmnkHXNW/WdeXO9U0cFHxqqDXSFY+1VrzNCmAa5CAHi4Vzk2vn1nmPolYFJArxhKSUZ9ue3iWJs66H/N9yO8OuP3C4U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=CNK4qtOj; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="CNK4qtOj"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A8AABC4CEE5;
	Tue,  8 Apr 2025 12:20:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1744114824;
	bh=ymsqHOsvKgFbrMJyXKESy3NfE743dpgRGA1ZkfW0ALI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=CNK4qtOjswOFmOVAWJVGvEKJuEc4ldOfndvDa167vBz3IeP6EEuW7PA41QcWXkfBl
	 bVjrc4ghDrIojtrI/VuYgJdu1kmEoGh2nh9gFlO7BzvY7VRgJoxkVaBSZWa/LO+bEV
	 3n/OF+DmSJnP6CvvDEZFCLZF4I4Y1fIVnws9MpQ4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Trond Myklebust <trond.myklebust@hammerspace.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.13 247/499] NFSv4: Avoid unnecessary scans of filesystems for expired delegations
Date: Tue,  8 Apr 2025 12:47:39 +0200
Message-ID: <20250408104857.372954009@linuxfoundation.org>
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



