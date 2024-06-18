Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E71361A00E0;
	Tue, 18 Jun 2024 13:08:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718716124; cv=none; b=Bwma3XKXBWV1siVfWkNBlQX9MWZIQyM8vQBCwL/c4fg9SgmUYjQnMavGQdR/EBkKJswg0UZKYWEihkNWeOMXr5wTxNkqpsNUEKxAQQkG+hkPVzhqEhEfv20XcE3/EcGafSkVTTyjagG4XP0i2E3mucCmFqm70E5Y4NOVv27UNmw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718716124; c=relaxed/simple;
	bh=0cWuDeVRf7YufkctSMJ9+DwT/0pDKzUuMgACWYt5BlY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=mJ9h+Jl13tf6OWfTxFBKJbqVdSzNxT/FIq54yvLqNJZ6GZPxFg+a6gbPdI+UHROnUOC0UMlBqsEiueWxDMpdbtU3NdlFnM/q3gOBym5sRRmDpQyfSv5vfdRh4Sp2kcJFvrzfG8sSgA7Mids2Ktafvq+jIo/f1DxMA7vS908sNsU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=DFAXKSlo; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="DFAXKSlo"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6A1A9C3277B;
	Tue, 18 Jun 2024 13:08:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1718716123;
	bh=0cWuDeVRf7YufkctSMJ9+DwT/0pDKzUuMgACWYt5BlY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=DFAXKSloQ92WjG8jUbJT/GZGCoe+d7f8H1M0NvW3Kft+lE+H6dZTOY5PYYFgHEqaH
	 EP9XieiuIX53trfP7ve7TG5DirD9pRLZDL4CBTGfjmROfMwBJlwe2rPP1tmWoZKbEA
	 YkMY7yP2w5riwjBqeda+O3R7J45/XhD1KAcI4YFc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	NeilBrown <neilb@suse.de>,
	Anna Schumaker <Anna.Schumaker@Netapp.com>,
	Chuck Lever <chuck.lever@oracle.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 540/770] NFS: restore module put when manager exits.
Date: Tue, 18 Jun 2024 14:36:33 +0200
Message-ID: <20240618123428.154251084@linuxfoundation.org>
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
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/nfs/nfs4state.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/fs/nfs/nfs4state.c b/fs/nfs/nfs4state.c
index ae2da65ffbafb..d8fc5d72a161c 100644
--- a/fs/nfs/nfs4state.c
+++ b/fs/nfs/nfs4state.c
@@ -2757,6 +2757,7 @@ static int nfs4_run_state_manager(void *ptr)
 		goto again;
 
 	nfs_put_client(clp);
+	module_put_and_kthread_exit(0);
 	return 0;
 }
 
-- 
2.43.0



