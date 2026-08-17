Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7740A3EC807;
	Mon, 17 Aug 2026 13:38:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786973887; cv=none; b=OKaIYBlGtYk+ZD9n0NZGOKWjs93xAaODvW5vRrY3Ge1q2u+O7VzY8R2n3ijXwafrhcFVyqaIt83yooShrPFjolb0ygMLcOD1ExIX7HWovXzm4pXwUpYn+VL5JpiIj2PRIzYVEtKjV8SBngw0l+VT1KV75lrcekT0iRrLIYvvclU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786973887; c=relaxed/simple;
	bh=kO481/a+QCjcjGtmdV+UYaRuniunwXdMdA/9ywzpbqk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=N4MtkrvosTuKQ5VZgY9+s7JEU9OIPN9vVdOJokafy3jcmSpCmnpL8989lOT5OTis4iYb9Zz2hti3omJa0Od2qbI5/aS7FhWcH/IaRiPXPjuZT6NEAIl3Lh5B6v0w+QPEs2zvytfo6GuNNA8MwibxHBxm/99EbTp4SUB7eNWVSuw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=zwKKysOp; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="zwKKysOp"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AFB241F00A3E;
	Mon, 17 Aug 2026 13:38:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1786973886;
	bh=l7zTgpd2S/UWu69TVsejChr/96O/HyS65g4IoEUfe9g=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=zwKKysOpvbzN9RBfvZfVFFy7hRWP6LgKdz+af0585GBYaSRb/FsMwlp7CNwGahH39
	 xDaU8h20znXvg/Zt/rKWrBmHOQnsWQs2IZQL7sJPl/U8e7csebrN7spJKFrdV6Mzt8
	 Gd6/Tq8AQQusYDldKbPhvip5tKCni/xvkB7zwUKI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dan Aloni <dan.aloni@vastdata.com>,
	Anna Schumaker <anna.schumaker@hammerspace.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.1 016/271] NFS: Pin the struct nfs_server during a FREE_STATEID call
Date: Mon, 17 Aug 2026 15:29:01 +0200
Message-ID: <20260817132537.444806280@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260817132536.752504388@linuxfoundation.org>
References: <20260817132536.752504388@linuxfoundation.org>
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

7.1-stable review patch.  If anyone has any objections, please let me know.

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
index 4db27f4eb01e9..bea00343f09b1 100644
--- a/fs/nfs/nfs4proc.c
+++ b/fs/nfs/nfs4proc.c
@@ -10330,6 +10330,7 @@ static void nfs41_free_stateid_release(void *calldata)
 	struct nfs_free_stateid_data *data = calldata;
 	struct nfs_client *clp = data->server->nfs_client;
 
+	nfs_sb_deactive(data->server->super);
 	nfs_put_client(clp);
 	kfree(calldata);
 }
@@ -10371,6 +10372,10 @@ static int nfs41_free_stateid(struct nfs_server *server,
 
 	if (!refcount_inc_not_zero(&clp->cl_count))
 		return -EIO;
+	if (!nfs_sb_active(server->super)) {
+		nfs_put_client(clp);
+		return -EIO;
+	}
 
 	nfs4_state_protect(clp, NFS_SP4_MACH_CRED_STATEID,
 		&task_setup.rpc_client, &msg);
-- 
2.53.0



