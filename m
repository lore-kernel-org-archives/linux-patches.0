Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1A4C643CE4B;
	Mon, 17 Aug 2026 13:51:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786974672; cv=none; b=e4/xGia7rjLEHprjwUagfzUcaVjHQOAm4T2kSRxJYM1g9Dzvvcn7yJPZEsUDTXF2uy9x2OpVDHKi3S+jdho7XuEGgNBOJxdBlKcRtwg1aUkh5mZq56WwKV9QrY4pjoGDur8QMOuH0OEbMnfpL5GfB0U89HFQWp6L4RYIwGc6D0w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786974672; c=relaxed/simple;
	bh=RksLVMxKDx/nW7/nzItvy3dLEr1PpdNiQf9M9WmpTAg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=JKA9aB8r9BEm3i+zrsT+5ab/5Sd6Jh+CxL1kPo5y9Qrdsu7CfpSIIPjvUTUp29PbWq2FOGMttjOAHbC4witcSspPOb6n14PnENhM5Vv1cVkeKn6PrSer6YYURN4rUcLGfcjBd93vfs8YXdGFaa/bLauj7Yuh7VqLxdQCWTLze2Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Lg5v/MaZ; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Lg5v/MaZ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 007041F000E9;
	Mon, 17 Aug 2026 13:51:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1786974666;
	bh=+cgSlbE32VK8789HL/yIOYruey0SQVDSUy/2Cq8X6Oc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Lg5v/MaZiETeKXD/KDSmyWOrJLjX2x4sRHwtNe1QdqYmf9JhrsOw2AfXOhHeAL0eJ
	 TVxH2KdoZqE1a3z4WPovn5bZirI5Jzgz2Aeu+DR0l3N77adOH89OuTFSe807A/4Qoe
	 1ak1q9Vw2o2zO2J6V0mVijLg7YQ8UfMtVK7cTYK8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dan Aloni <dan.aloni@vastdata.com>,
	Anna Schumaker <anna.schumaker@hammerspace.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 013/250] NFS: Pin the struct nfs_server during a FREE_STATEID call
Date: Mon, 17 Aug 2026 15:29:34 +0200
Message-ID: <20260817132536.996946851@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260817132536.466235697@linuxfoundation.org>
References: <20260817132536.466235697@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

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
index 403f7f8dfea2b..66b8da741a06f 100644
--- a/fs/nfs/nfs4proc.c
+++ b/fs/nfs/nfs4proc.c
@@ -10634,6 +10634,7 @@ static void nfs41_free_stateid_release(void *calldata)
 	struct nfs_free_stateid_data *data = calldata;
 	struct nfs_client *clp = data->server->nfs_client;
 
+	nfs_sb_deactive(data->server->super);
 	nfs_put_client(clp);
 	kfree(calldata);
 }
@@ -10675,6 +10676,10 @@ static int nfs41_free_stateid(struct nfs_server *server,
 
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



