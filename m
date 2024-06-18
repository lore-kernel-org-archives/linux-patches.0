Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3142A158D9A;
	Tue, 18 Jun 2024 13:15:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718716508; cv=none; b=WEK3+lDhFZDoT9cV0Uh/ofGcZWsDcRJmOqZR6+RH8OBhn5tqlDW3MmSFSfXQ2/IkwQ1SsDzuzd1expIBjfve3+njv0wIGbE2pNAeTxh/JOYT0r/31No30kERR40nFv3GmiIG63ZDHAQhTBg8GauwONIf0e8/mVVG6fixhiR9JeM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718716508; c=relaxed/simple;
	bh=FzG+OJQ58EgCiWk8+pkolb249Up1iT0iCjLUnXBJRJE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=MxJgDN3yuumYbiD7jEYA1RKFjPVZrNrtQ6hqWK4fV4PXI6PaZ5i0KVKSNQlJb75aTWp3n5MlyohbIEeh5OYW1et879C9GbHKW/MqekXCV2ERVfgbbL/BRqG9fQIhir1dhsQUC/dWPDxl5jBS9FEVXS5QT1oT7hpiuV98NGI7PSk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=dCIdF8MS; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="dCIdF8MS"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id ABA51C3277B;
	Tue, 18 Jun 2024 13:15:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1718716508;
	bh=FzG+OJQ58EgCiWk8+pkolb249Up1iT0iCjLUnXBJRJE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=dCIdF8MSfOXzN6dqV9DwgX6EvQN8lA7KGekz8CyZLQNp4t9i1qt98Gvfo6mP811oT
	 sxeScGKWP+bm9imbhw85zBqvfZnguMSZPbomMWyWufCjfNfj6Asm/X04e4/f71XYun
	 w7pVYG+Ce24cusOk4YlM3KzWvXjAabENblKbmBPQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jeff Layton <jlayton@kernel.org>,
	Chuck Lever <chuck.lever@oracle.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 668/770] nfsd: extra checks when freeing delegation stateids
Date: Tue, 18 Jun 2024 14:38:41 +0200
Message-ID: <20240618123433.068429766@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240618123407.280171066@linuxfoundation.org>
References: <20240618123407.280171066@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jeff Layton <jlayton@kernel.org>

[ Upstream commit 895ddf5ed4c54ea9e3533606d7a8b4e4f27f95ef ]

We've had some reports of problems in the refcounting for delegation
stateids that we've yet to track down. Add some extra checks to ensure
that we've removed the object from various lists before freeing it.

Link: https://bugzilla.redhat.com/show_bug.cgi?id=2127067
Signed-off-by: Jeff Layton <jlayton@kernel.org>
Signed-off-by: Chuck Lever <chuck.lever@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/nfsd/nfs4state.c | 7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

diff --git a/fs/nfsd/nfs4state.c b/fs/nfsd/nfs4state.c
index fc6188d70796d..948ef17178158 100644
--- a/fs/nfsd/nfs4state.c
+++ b/fs/nfsd/nfs4state.c
@@ -1071,7 +1071,12 @@ static struct nfs4_ol_stateid * nfs4_alloc_open_stateid(struct nfs4_client *clp)
 
 static void nfs4_free_deleg(struct nfs4_stid *stid)
 {
-	WARN_ON(!list_empty(&stid->sc_cp_list));
+	struct nfs4_delegation *dp = delegstateid(stid);
+
+	WARN_ON_ONCE(!list_empty(&stid->sc_cp_list));
+	WARN_ON_ONCE(!list_empty(&dp->dl_perfile));
+	WARN_ON_ONCE(!list_empty(&dp->dl_perclnt));
+	WARN_ON_ONCE(!list_empty(&dp->dl_recall_lru));
 	kmem_cache_free(deleg_slab, stid);
 	atomic_long_dec(&num_delegations);
 }
-- 
2.43.0



