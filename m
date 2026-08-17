Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D68A72E738B;
	Mon, 17 Aug 2026 14:45:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786977917; cv=none; b=dp1w8qZ5ZvPw1Fhqc6z9bFqbth6olxz76NhTdMUtTgXRBtrHjUTIwplyoIgIuvN3dpP41/CLh48NIM5J/ekvMmVgfMGSn21a62Lig2drqHOHYZJMh39fJHt+SmA8dqcSxRotMYmeZjkrJPd9bw8sb/3WtHBw7l623Ny9BkDdq5M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786977917; c=relaxed/simple;
	bh=/yEH6z0e4933v1qitbeMxPLZeQy8wkDn6fWPZjmuhcQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=lkcJbdsjSZHdI6PWn799nA6jcgxl3+BUQzkW/Zh0xcxtsd/U3kbUOEVq0Zil/7G2lTIl3Nzl/OPsCfxmu+RhNQRrJYQM3tnDxCD3F9zxuv+yWzlm2Qh/EVuh5G7gvftu6TJUXVWru7DujIKohZwvwFYIBHpUc4FPalIP9NH4frk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=P8HkySMf; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="P8HkySMf"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3E99F1F000E9;
	Mon, 17 Aug 2026 14:45:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1786977916;
	bh=T6SV9HdmuoS6aIkEngV9j+EE5GOGyNX3OaYD/edlB5w=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=P8HkySMffUfGNvqTZww3bR0UI6nEj3RLHp4CQC7GYoXtITX84xsnHQOHNoitPkhd/
	 M3+35aepBmF9+PVXPEmQXsyp0RXM55e9C0J37SG4cGA4tekR20wdHn4KGnPjP0oGXQ
	 u3MGVv4fkSw49A7mTToNeIPe6bCzNgjUlTp9n3H4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dan Aloni <dan.aloni@vastdata.com>,
	Anna Schumaker <anna.schumaker@hammerspace.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 006/181] NFS: Pin the struct nfs_server during a FREE_STATEID call
Date: Mon, 17 Aug 2026 15:31:40 +0200
Message-ID: <20260817132535.648623594@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260817132535.394764707@linuxfoundation.org>
References: <20260817132535.394764707@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Anna Schumaker <anna.schumaker@hammerspace.com>

[ Upstream commit cf616096a0f3a2b60f7d68b6b39674a6867ded9c ]

Dan Aloni reports that he was able to hit a use-after-free bug if a
FREE_STATEID operation gets delayed for whatever reason. Fix this by
bumping the refcount of the 'struct nfs_server' object for the duration
of the FREE_STATEID so it doesn't get cleaned up from underneath us
while operations are still in flight.

Reported-by: Dan Aloni <dan.aloni@vastdata.com>
Fixes: 7c1d5fae4a87 ("NFSv4: Convert nfs41_free_stateid to use an asynchronous RPC call")
Tested-by: Dan Aloni <dan.aloni@vastdata.com>
Signed-off-by: Anna Schumaker <anna.schumaker@hammerspace.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/nfs/nfs4proc.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/fs/nfs/nfs4proc.c b/fs/nfs/nfs4proc.c
index 840789e182ef3..facd4e28770be 100644
--- a/fs/nfs/nfs4proc.c
+++ b/fs/nfs/nfs4proc.c
@@ -10585,6 +10585,7 @@ static void nfs41_free_stateid_release(void *calldata)
 	struct nfs_free_stateid_data *data = calldata;
 	struct nfs_client *clp = data->server->nfs_client;
 
+	nfs_sb_deactive(data->server->super);
 	nfs_put_client(clp);
 	kfree(calldata);
 }
@@ -10626,6 +10627,10 @@ static int nfs41_free_stateid(struct nfs_server *server,
 
 	if (!refcount_inc_not_zero(&clp->cl_count))
 		return -EIO;
+	if (!nfs_sb_active(server->super)) {
+		nfs_put_client(clp);
+		return -EIO;
+	}
 
 	nfs4_state_protect(server->nfs_client, NFS_SP4_MACH_CRED_STATEID,
 		&task_setup.rpc_client, &msg);
-- 
2.53.0



