Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DC1994457BD;
	Mon, 17 Aug 2026 15:24:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786980301; cv=none; b=YjC2YCwgRqdEb9+JJ6BxHl4VGe6v1NpKJ6Xlaqlj7B7qV1vDB+IZf9PbOPbZbrYHS4Jf2yXULjiWpkJj2J5i17PoQtxYU3r6Gqm4U2iHFNiPMn/vl38e4bQgypiQ5cvVgzNp4+4ErjLE7SqNcc4VCt/gzg+eDOKVQ6Uqsbh5W7c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786980301; c=relaxed/simple;
	bh=rCdgNKLFLE/pE76WG+OUKeYpeWWym+SjzWFvXzZBcFg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=GoCcSKXX65kv+UEjNvOGpHKw2B/7itwyzFva0hpQ/P0VDx4kwoE/+RWwRjMP/S+2d3WoPmTTdxVrLWbSjEsVnJ15D7MDjiPozMRbqF2DEOn912CINKnW7jkHxcIBjCS3A3M7S/5X+33ZjNlI93oq8KSN02r+utSCisdY9g3yQI8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=2KQyGn3Z; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="2KQyGn3Z"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4243A1F000E9;
	Mon, 17 Aug 2026 15:24:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1786980299;
	bh=D9mcrFwHXW4w95G4+iCRfQot7zvZ5QK0Gnq3AjVCEwk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=2KQyGn3ZtIjjOgseVS5xMCX9gn67ts1cRy3BvKohMNbo859e3fORo0NSfrEm/ZoHw
	 Y9jJZNV69sGNFKv5Wy3beZLB9xw1zb0VotcMJp2iiY40lsRnjw9j7aA7DlSKlvYmBY
	 zVYnc/b5PK2TV5KAC8J2NycMiAen1jiDc6p+5Oo0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dan Aloni <dan.aloni@vastdata.com>,
	Anna Schumaker <anna.schumaker@hammerspace.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 488/609] NFS: Pin the struct nfs_server during a FREE_STATEID call
Date: Mon, 17 Aug 2026 15:33:04 +0200
Message-ID: <20260817132600.254646994@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260817132543.039278408@linuxfoundation.org>
References: <20260817132543.039278408@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
index 8258bce82e5bc..9f352f1a6eb1e 100644
--- a/fs/nfs/nfs4proc.c
+++ b/fs/nfs/nfs4proc.c
@@ -10388,6 +10388,7 @@ static void nfs41_free_stateid_release(void *calldata)
 	struct nfs_free_stateid_data *data = calldata;
 	struct nfs_client *clp = data->server->nfs_client;
 
+	nfs_sb_deactive(data->server->super);
 	nfs_put_client(clp);
 	kfree(calldata);
 }
@@ -10429,6 +10430,10 @@ static int nfs41_free_stateid(struct nfs_server *server,
 
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



