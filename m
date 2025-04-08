Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E2BF2280CC4;
	Tue,  8 Apr 2025 12:50:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744116605; cv=none; b=M7wA5iSFq/xcyOEwBC3VKsI/2Aaxnv5YJQXr/4kb78b6mICeJyXiCavv3jWfBP37SR/P82CrAK+mMMp+O3MutnUFKmZjkTlZO41OHH2E98MuT6TRuj+RGJRRJ4kpFnnFvqD2t80SuAtaDZaInWpTH1C0ssScrHETHzzrUkL7URs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744116605; c=relaxed/simple;
	bh=nfy2iCMUyOwwST0g0ExnHTWxftPuK3AgoOl9fkNfY7A=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=e4WZliVBLQ4zm1Hc4r7OAyEIAWdSXQFsWPl+v82F3UvEm0lsytSmpyAYizBbuVtAgdiruXZKo+07wpLX4cOo/j5HX0htgz5UcrnDD4JhArfk8/SjFrovNuuL5VAHb6CSN3dKudwa948dqiRUQX1YOZtavCgkq4fMuusyfA63yuI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=T+kaBpv6; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="T+kaBpv6"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 726A4C4CEE5;
	Tue,  8 Apr 2025 12:50:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1744116604;
	bh=nfy2iCMUyOwwST0g0ExnHTWxftPuK3AgoOl9fkNfY7A=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=T+kaBpv6U8YXlq4YgEDal4l3mQjVi0lRxgv5WhARnJxfIpPkS3/re9+bPhU6zMDpP
	 7blJu6+3Wr9ILntUKO/lGswSIQZ9jOP5p5cEDfULn8x0LX8juI+PG5hAXPVq6Y7gD5
	 IohRlTlQxJZ+rbfWCD7YlKrwmHAm/jTeUaxEWk1U=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Trond Myklebust <trond.myklebust@hammerspace.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 201/423] NFSv4: Avoid unnecessary scans of filesystems for returning delegations
Date: Tue,  8 Apr 2025 12:48:47 +0200
Message-ID: <20250408104850.417534116@linuxfoundation.org>
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



