Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0727A34D3B1;
	Tue,  6 Jan 2026 17:20:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767720044; cv=none; b=kgzPOvgoDgxoIjZzBF5TXJhMSslM1MfPKDrqGqOm34+KS8b1A4U4hxZ5lpUx0TF7IyVMYasfFy6LD/i1Fckm22j7OJRJCe6qfuL4d6eriyEKrAtYSX0DGOwgoOZvWmtT2vLTlNcjQ9FsvDwdcOm4W2/yyjgaXi/chc6MWswozEc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767720044; c=relaxed/simple;
	bh=qans7hAB2rWX44ZzffgppZbRAXmg+/5XLGsTX1NhCwg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=c55Z7ZPVoY0BYcNHRTacrJ2cY0g1pxmPztKS53BdCIfTIqpPfyrZ+1ttkJMJbC1EImxeuMgJ/XRM+yA8eCf8NyzKPK+RJ1N4Uwx63m8C8R5uGHYREWJkgaj4n5uR3QbGarE7SehvUQWtK42/hwguwdBIa+jdPUOUHG5KzNPtjX0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=xbC+v7Kr; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="xbC+v7Kr"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5E7C6C116C6;
	Tue,  6 Jan 2026 17:20:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1767720043;
	bh=qans7hAB2rWX44ZzffgppZbRAXmg+/5XLGsTX1NhCwg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=xbC+v7Kre8NWMgKjdrgXQ2yDfl5n+taTNSKe91eHbmQqJ1BIAh31btN00jeDPeMeK
	 dwvzV3an45UmGPP6pLt2xadAf0HLY9xWWe5qQ3F9SZOw8BU7qqoGc8teao4rfKb136
	 aeBhdmUenomUsGj3gFb7UOdMtcCmtgPhS+hOGK2g=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	syzbot+099461f8558eb0a1f4f3@syzkaller.appspotmail.com,
	Shardul Bankar <shardul.b@mpiricsoftware.com>,
	Jeff Layton <jlayton@kernel.org>,
	Chuck Lever <chuck.lever@oracle.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 118/567] nfsd: fix memory leak in nfsd_create_serv error paths
Date: Tue,  6 Jan 2026 17:58:20 +0100
Message-ID: <20260106170455.694088661@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260106170451.332875001@linuxfoundation.org>
References: <20260106170451.332875001@linuxfoundation.org>
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

From: Shardul Bankar <shardul.b@mpiricsoftware.com>

[ Upstream commit df8d829bba3adcf3cc744c01d933b6fd7cf06e91 ]

When nfsd_create_serv() calls percpu_ref_init() to initialize
nn->nfsd_net_ref, it allocates both a percpu reference counter
and a percpu_ref_data structure (64 bytes). However, if the
function fails later due to svc_create_pooled() returning NULL
or svc_bind() returning an error, these allocations are not
cleaned up, resulting in a memory leak.

The leak manifests as:
- Unreferenced percpu allocation (8 bytes per CPU)
- Unreferenced percpu_ref_data structure (64 bytes)

Fix this by adding percpu_ref_exit() calls in both error paths
to properly clean up the percpu_ref_init() allocations.

This patch fixes the percpu_ref leak in nfsd_create_serv() seen
as an auxiliary leak in syzbot report 099461f8558eb0a1f4f3; the
prepare_creds() and vsock-related leaks in the same report
remain to be addressed separately.

Reported-by: syzbot+099461f8558eb0a1f4f3@syzkaller.appspotmail.com
Link: https://syzkaller.appspot.com/bug?extid=099461f8558eb0a1f4f3
Fixes: 47e988147f40 ("nfsd: add nfsd_serv_try_get and nfsd_serv_put")
Signed-off-by: Shardul Bankar <shardul.b@mpiricsoftware.com>
Reviewed-by: Jeff Layton <jlayton@kernel.org>
Signed-off-by: Chuck Lever <chuck.lever@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/nfsd/nfssvc.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/fs/nfsd/nfssvc.c b/fs/nfsd/nfssvc.c
index 571a6ae90833..cc185c00e309 100644
--- a/fs/nfsd/nfssvc.c
+++ b/fs/nfsd/nfssvc.c
@@ -667,13 +667,16 @@ int nfsd_create_serv(struct net *net)
 	serv = svc_create_pooled(nfsd_programs, ARRAY_SIZE(nfsd_programs),
 				 &nn->nfsd_svcstats,
 				 nfsd_max_blksize, nfsd);
-	if (serv == NULL)
+	if (serv == NULL) {
+		percpu_ref_exit(&nn->nfsd_net_ref);
 		return -ENOMEM;
+	}
 
 	serv->sv_maxconn = nn->max_connections;
 	error = svc_bind(serv, net);
 	if (error < 0) {
 		svc_destroy(&serv);
+		percpu_ref_exit(&nn->nfsd_net_ref);
 		return error;
 	}
 	spin_lock(&nfsd_notifier_lock);
-- 
2.51.0



