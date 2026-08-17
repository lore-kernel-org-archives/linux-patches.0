Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0C0F043B6FE;
	Mon, 17 Aug 2026 14:17:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786976262; cv=none; b=XNxaQ4gDLYl39s9yTPAU8z7QfKBi5cWOk1NIr55gUwHcB7dYF6N1zl4MARJCW4Rawd0+broZihqm4yHL7ifv3hE2u70p41THZCu8g2EYkm7Kn+I+RGg7vktG4WjEojrQgENOx1q5hjK8uV/WJXBC7uHHK7TT2FG9aFUhOCSAi6M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786976262; c=relaxed/simple;
	bh=yTLUPbCswxz6fjvoPAOHGqfqjY8Dp6jMvV+LTor5N+c=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=GF9cIBCXdfjCAxg1YFHfIyTcHeyoLYmKdgEgn4Ep+yMQ9OfAo2NDxwTQ6P2WK6BG82z7+3COea+KUZMzoMhinH/GjszAMXIqUZPmEXGiA8ybiEeLHwy4HekvlQYBv4MtgNYJnZAMbTK9vQqSGvfeObONO7mABGjBHULujXIfoRI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=EvECFoak; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="EvECFoak"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5A6241F00A3A;
	Mon, 17 Aug 2026 14:17:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1786976260;
	bh=RYPlGGxRaJ5HM/GKwvQploB5ZDYKtt6Q9ZvWaN7bxg8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=EvECFoakubdIo7d86ZqwvorX+CaPeedWlxmTqqZZlAcAZv6Dw9PNP2rZn9gR4+8WZ
	 xW2v9EjKlgqlEKIAvJAto6/QCDOgrEoA4fbGjgLWU6WAfV2ebZ7WadZ0hNfiC3f+ia
	 IWMZoKPoI7C6QmPrz5bah0i6DYQvs7XosmZQ5glc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Scott Mayhew <smayhew@redhat.com>,
	Trond Myklebust <trond.myklebust@hammerspace.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 311/389] nfs4: take a reference on the nfs_client when running FREE_STATEID
Date: Mon, 17 Aug 2026 15:32:30 +0200
Message-ID: <20260817132551.133022101@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260817132538.796021292@linuxfoundation.org>
References: <20260817132538.796021292@linuxfoundation.org>
User-Agent: quilt/0.69
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

From: Scott Mayhew <smayhew@redhat.com>

[ Upstream commit 576acc259146af848cec0940f573f7125a116b9f ]

During umount, the session slot tables are freed.  If there are
outstanding FREE_STATEID tasks, a use-after-free and slab corruption can
occur when rpc_exit_task calls rpc_call_done -> nfs41_sequence_done ->
nfs4_sequence_process/nfs41_sequence_free_slot.

Prevent that from happening by taking a reference on the nfs_client in
nfs41_free_stateid and putting it in nfs41_free_stateid_release.

Signed-off-by: Scott Mayhew <smayhew@redhat.com>
Signed-off-by: Trond Myklebust <trond.myklebust@hammerspace.com>
Stable-dep-of: cf616096a0f3 ("NFS: Pin the 'struct nfs_server' during a FREE_STATEID call")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/nfs/nfs4proc.c | 8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/fs/nfs/nfs4proc.c b/fs/nfs/nfs4proc.c
index 170e9eaf536af..bd97e0b61e70d 100644
--- a/fs/nfs/nfs4proc.c
+++ b/fs/nfs/nfs4proc.c
@@ -10135,6 +10135,10 @@ static void nfs41_free_stateid_done(struct rpc_task *task, void *calldata)
 
 static void nfs41_free_stateid_release(void *calldata)
 {
+	struct nfs_free_stateid_data *data = calldata;
+	struct nfs_client *clp = data->server->nfs_client;
+
+	nfs_put_client(clp);
 	kfree(calldata);
 }
 
@@ -10171,6 +10175,10 @@ static int nfs41_free_stateid(struct nfs_server *server,
 	};
 	struct nfs_free_stateid_data *data;
 	struct rpc_task *task;
+	struct nfs_client *clp = server->nfs_client;
+
+	if (!refcount_inc_not_zero(&clp->cl_count))
+		return -EIO;
 
 	nfs4_state_protect(server->nfs_client, NFS_SP4_MACH_CRED_STATEID,
 		&task_setup.rpc_client, &msg);
-- 
2.53.0



