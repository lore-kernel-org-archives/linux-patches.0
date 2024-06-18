Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 44015176AB0;
	Tue, 18 Jun 2024 12:57:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718715458; cv=none; b=Dby2rXMONNU2ezmhutZHGaSggVp7EIjjHXUMxetIV1t63oL5fRM2U2A5oRWueLuKo1lra04kyjEIRLPrdt1x3Y6q4ocfu0pTVf/dlub0JhsFNXwLQcuG2VQTuFOWQpYUpFSjrptKGczkZ2xATcMBjW8BBjvQPlnu3kwcJ/YrJB8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718715458; c=relaxed/simple;
	bh=gNcYsq5gDEhIIbCWxgY//g7pC+FKSaZzYAdrk8wj0BE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Kuf8ArzY8CrC1rqPFC1JVmvhhpsXjj/FEahGlRxiZmOPp+1IOtNnlkXsF+/g+ZY559tMR6TZrxLymlPrjT8S7PN70o+a3YAmF5CHR/j1iTpqg7wd2wntisGhQ+H61qP+IqaB62Q6MXP4J4J5HSqzmpiZAM5kEawsFHLg5ez5YDA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=auaiI3sn; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="auaiI3sn"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C0468C3277B;
	Tue, 18 Jun 2024 12:57:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1718715458;
	bh=gNcYsq5gDEhIIbCWxgY//g7pC+FKSaZzYAdrk8wj0BE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=auaiI3snsyUubtQ6qRME5KkyzGU8KOaFuBqMFrn1YTIxdw7bgbpJ0jYItguaPNcTO
	 a21Z7TZt+rTohxt7trg6BrgZ8tOnKjg5GswxasGrhx1MmvLkZhaYbo8vUkEN2KRaeP
	 L5y5v3/yBjmf9zGvW2iV7UTRSbNnvhbby2O6tQoM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Chuck Lever <chuck.lever@oracle.com>,
	"J. Bruce Fields" <bfields@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 274/770] NFSD: Add nfsd_clid_destroyed tracepoint
Date: Tue, 18 Jun 2024 14:32:07 +0200
Message-ID: <20240618123417.845015887@linuxfoundation.org>
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

From: Chuck Lever <chuck.lever@oracle.com>

[ Upstream commit c41a9b7a906fb872f8b2b1a34d2a1d5ef7f94adb ]

Record client-requested termination of client IDs.

Signed-off-by: Chuck Lever <chuck.lever@oracle.com>
Signed-off-by: J. Bruce Fields <bfields@redhat.com>
Signed-off-by: Chuck Lever <chuck.lever@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/nfsd/nfs4state.c | 1 +
 fs/nfsd/trace.h     | 1 +
 2 files changed, 2 insertions(+)

diff --git a/fs/nfsd/nfs4state.c b/fs/nfsd/nfs4state.c
index da5b9b88b0cd4..6f04a84f76c0e 100644
--- a/fs/nfsd/nfs4state.c
+++ b/fs/nfsd/nfs4state.c
@@ -3939,6 +3939,7 @@ nfsd4_destroy_clientid(struct svc_rqst *rqstp,
 		status = nfserr_wrong_cred;
 		goto out;
 	}
+	trace_nfsd_clid_destroyed(&clp->cl_clientid);
 	unhash_client_locked(clp);
 out:
 	spin_unlock(&nn->client_lock);
diff --git a/fs/nfsd/trace.h b/fs/nfsd/trace.h
index 6c787f4ef5633..3aca6dcba90a5 100644
--- a/fs/nfsd/trace.h
+++ b/fs/nfsd/trace.h
@@ -513,6 +513,7 @@ DEFINE_EVENT(nfsd_clientid_class, nfsd_clid_##name, \
 
 DEFINE_CLIENTID_EVENT(reclaim_complete);
 DEFINE_CLIENTID_EVENT(confirmed);
+DEFINE_CLIENTID_EVENT(destroyed);
 DEFINE_CLIENTID_EVENT(expired);
 DEFINE_CLIENTID_EVENT(purged);
 DEFINE_CLIENTID_EVENT(renew);
-- 
2.43.0



