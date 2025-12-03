Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E69F43148D4;
	Wed,  3 Dec 2025 16:07:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764778071; cv=none; b=pMtbfqc/q+1JgC+McE3WnySZ7O5A+96ZYOEt9V23fDtlQAGHxDCq2JLxTzj+iH+U0uUDEVXItA7TcvNkBliffTcYX2SoHkPIlvSyQXMpdIxrWCkOJSPOeTbvCGQFaPCV8Jdp1JG0OxdUlneFLR//G2LTBgDUGU2c3icAlHaI0U0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764778071; c=relaxed/simple;
	bh=2g0IJmgk7j/sWPxZjKEbv9OXTTC2rj4pDeKs3DE6S9c=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=fkoHWCVsOuR+W1s7b2P9LyIkNBb9lOqZOJeLBgNQPlx8lo9pYRKFXE25Dve05JnRqs3QFqVhmTci+IqSmpJEgWhh5M6GmK2+VOyPO6pIhtrSk46sQ7+ABigX8aTLJUQzDt9tELfEXo+CdU6tY4man2jiNiznb7Hypx7kPiHuxro=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Lhc9h9Dr; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Lhc9h9Dr"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 326C3C4CEF5;
	Wed,  3 Dec 2025 16:07:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1764778070;
	bh=2g0IJmgk7j/sWPxZjKEbv9OXTTC2rj4pDeKs3DE6S9c=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Lhc9h9DrhOspifwh2heM/6QmSZ0c/ZYa4ZhLaIzXpspQdHur2MR+gubEx+lmucBwl
	 fY6COqKl04Bnh/OO7q6Argn+Ka+gOTcw9lex+NDPKISNjahrekEygPYmMlQChK0vpU
	 +SsoSp2MjtdHeim+Y7EGQRanuy4CKzShV/x2ayaE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Joshua Watt <jpewhacker@gmail.com>,
	Anna Schumaker <anna.schumaker@oracle.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 233/392] NFS4: Fix state renewals missing after boot
Date: Wed,  3 Dec 2025 16:26:23 +0100
Message-ID: <20251203152422.754802996@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251203152414.082328008@linuxfoundation.org>
References: <20251203152414.082328008@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Joshua Watt <jpewhacker@gmail.com>

[ Upstream commit 9bb3baa9d1604cd20f49ae7dac9306b4037a0e7a ]

Since the last renewal time was initialized to 0 and jiffies start
counting at -5 minutes, any clients connected in the first 5 minutes
after a reboot would have their renewal timer set to a very long
interval. If the connection was idle, this would result in the client
state timing out on the server and the next call to the server would
return NFS4ERR_BADSESSION.

Fix this by initializing the last renewal time to the current jiffies
instead of 0.

Signed-off-by: Joshua Watt <jpewhacker@gmail.com>
Signed-off-by: Anna Schumaker <anna.schumaker@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/nfs/nfs4client.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/fs/nfs/nfs4client.c b/fs/nfs/nfs4client.c
index 7e4b126e3061e..02082580d34eb 100644
--- a/fs/nfs/nfs4client.c
+++ b/fs/nfs/nfs4client.c
@@ -221,6 +221,7 @@ struct nfs_client *nfs4_alloc_client(const struct nfs_client_initdata *cl_init)
 	clp->cl_state = 1 << NFS4CLNT_LEASE_EXPIRED;
 	clp->cl_mvops = nfs_v4_minor_ops[cl_init->minorversion];
 	clp->cl_mig_gen = 1;
+	clp->cl_last_renewal = jiffies;
 #if IS_ENABLED(CONFIG_NFS_V4_1)
 	init_waitqueue_head(&clp->cl_lock_waitq);
 #endif
-- 
2.51.0



