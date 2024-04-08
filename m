Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2233F6FE35;
	Mon,  8 Apr 2024 13:48:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712584095; cv=none; b=bxjLTEQe4UITj+dKqz1tzWg0goiLsnwaUHzTjdyU1ld+am+8ZfB/tx0Vi4p9e+awNaaOIpJ2XNzfFR6coY1IdzNaGxtNrPoSxQuNV3EnQ6zzFVjLUNDJHMkSoHAP0Yr0HaizJdwVAFUxMlNe22SxLRnpiVEQC23K/j6HYFFcbfs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712584095; c=relaxed/simple;
	bh=gE7WlArNqyFRuzuNOr0CJDIS8pOKJkArp1uBEutpVJc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=hKibaJyh1SI4NsKjynX6yVcCuJAqQgxkMWCVlUIOL5fVStgsX40e4/gBxkkWSpX+sbD01qx+CNbRm4MTMR1ZKRLwLEA99npOtXZEPVZLve580SMIL134HtnRNiGVgRf5VbKH65LcBJWwrpCITa5IJmnhIyfwGh51JfSafqC3llU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=R+V72YX2; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="R+V72YX2"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 99214C433C7;
	Mon,  8 Apr 2024 13:48:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1712584095;
	bh=gE7WlArNqyFRuzuNOr0CJDIS8pOKJkArp1uBEutpVJc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=R+V72YX2CHV3TrxlEO8DDpGjFMXyckI22+qgZfE4O2JXyAjU1oLjFBRwYbO9+jMGc
	 xcMLR4nUysS1nbIg+t7jVABslrlJh6MGQ7QUR8l0m8mjYNiKfwZLJnmlc0bD+U/8/K
	 9B2MhWRLxvY51B0uXhTekfOKTV/T+xQyXHBc67zw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	NeilBrown <neilb@suse.de>,
	Anna Schumaker <Anna.Schumaker@Netapp.com>,
	Chuck Lever <chuck.lever@oracle.com>
Subject: [PATCH 5.15 333/690] NFS: restore module put when manager exits.
Date: Mon,  8 Apr 2024 14:53:19 +0200
Message-ID: <20240408125411.664822917@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240408125359.506372836@linuxfoundation.org>
References: <20240408125359.506372836@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: NeilBrown <neilb@suse.de>

[ Upstream commit 080abad71e99d2becf38c978572982130b927a28 ]

Commit f49169c97fce ("NFSD: Remove svc_serv_ops::svo_module") removed
calls to module_put_and_kthread_exit() from threads that acted as SUNRPC
servers and had a related svc_serv_ops structure.  This was correct.

It ALSO removed the module_put_and_kthread_exit() call from
nfs4_run_state_manager() which is NOT a SUNRPC service.

Consequently every time the NFSv4 state manager runs the module count
increments and won't be decremented.  So the nfsv4 module cannot be
unloaded.

So restore the module_put_and_kthread_exit() call.

Fixes: f49169c97fce ("NFSD: Remove svc_serv_ops::svo_module")
Signed-off-by: NeilBrown <neilb@suse.de>
Signed-off-by: Anna Schumaker <Anna.Schumaker@Netapp.com>
Signed-off-by: Chuck Lever <chuck.lever@oracle.com>
---
 fs/nfs/nfs4state.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/fs/nfs/nfs4state.c b/fs/nfs/nfs4state.c
index 61050ffac93ef..d7868cc527805 100644
--- a/fs/nfs/nfs4state.c
+++ b/fs/nfs/nfs4state.c
@@ -2766,5 +2766,6 @@ static int nfs4_run_state_manager(void *ptr)
 		goto again;
 
 	nfs_put_client(clp);
+	module_put_and_kthread_exit(0);
 	return 0;
 }
-- 
2.43.0



