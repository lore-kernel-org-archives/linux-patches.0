Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6C35F46AA91;
	Tue, 21 Jul 2026 15:59:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784649552; cv=none; b=rv5BGEzh5OgXwzQyDlwb+Rzphzl1vAMC72PNnPRCX5gTU7YKTVjS+9mWhVxyfriU6yXnmGJNuC1NqIOLoyNYetiKo/gU2Ie6WnLQ7e2WM5VnBNzizHTEKYNuIQMdUz9BSN6SKaiyhN2hfKzyGxXtDNF9cEE1wtIiSqPEQg56I5Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784649552; c=relaxed/simple;
	bh=ZX7R0bs0vdD5/NJEpX5drmerZqNi2FUvLnxsRENxrEw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Y5pYY/yTx0zCzsC88dYOmiGlbtTZ7Op7GIQJL0uUlRRK0+rQqjHLHRc6A17huYzYo1sYBDZh9557lmDqnPzPvZ7TnYVqsexJiMOdS7omP16qvJEvKrnxxaUfWFH9UenZXX2ihor9WCh7xJD2uKIhJIr3o+f45HbITpOjkLB8dVY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=CjwGbvo4; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="CjwGbvo4"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CD2AD1F000E9;
	Tue, 21 Jul 2026 15:59:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784649551;
	bh=7LOVn3SudGSAM8pbGg9tcFsh5LEK9wWj5dI7RrOmGq0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=CjwGbvo4JXSqb2JWU7kfWNX80hnpk/w2J63wxBmn7M0HwIGZpfvK24MvMGqHA5wVm
	 L4PlkGocjiSoT7y7JtZsGEwSGtatOzRsDmYFQabvASy2WGqSYQ5oGtgg1fKnO0F/KB
	 cJiAhKRJglZeSoM4sP+rc/0eI6s5GplSR1RmjvTg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jeff Layton <jlayton@kernel.org>,
	Chuck Lever <chuck.lever@oracle.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.1 0621/2077] lockd: Translate nlm__int__deadlock in __nlm4svc_proc_lock_msg()
Date: Tue, 21 Jul 2026 17:04:54 +0200
Message-ID: <20260721152607.450705106@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152552.646164743@linuxfoundation.org>
References: <20260721152552.646164743@linuxfoundation.org>
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

From: Chuck Lever <chuck.lever@oracle.com>

[ Upstream commit 2175ca75882e346c9d8741a2196693d70f635340 ]

When nlmsvc_lock() detects a deadlock it returns the internal
sentinel nlm__int__deadlock (30001), which version-specific
handlers must translate to a wire-valid status before the reply
is encoded.  The xdrgen LOCK_MSG handler stores the sentinel
unmodified in resp->status; the LOCK_RES callback then places
30001 on the v4 wire, where the client rejects the reply.

Commit 9e0d0c619407 ("lockd: Introduce nlm__int__deadlock")
established the translation boundary and updated the synchronous
v4 path nlm4svc_do_lock(), but the xdrgen LOCK_MSG handler added
later in commit b2be4e28c23a ("lockd: Use xdrgen XDR functions
for the NLMv4 LOCK_MSG procedure") missed the corresponding
remap.  Apply the same translation in __nlm4svc_proc_lock_msg()
so deadlock results are reported as nlm4_deadlock on LOCK_RES.

Fixes: b2be4e28c23a ("lockd: Use xdrgen XDR functions for the NLMv4 LOCK_MSG procedure")
Reviewed-by: Jeff Layton <jlayton@kernel.org>
Signed-off-by: Chuck Lever <chuck.lever@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/lockd/svc4proc.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/fs/lockd/svc4proc.c b/fs/lockd/svc4proc.c
index 41cab858de5782..74070e33cb3e2d 100644
--- a/fs/lockd/svc4proc.c
+++ b/fs/lockd/svc4proc.c
@@ -669,6 +669,8 @@ __nlm4svc_proc_lock_msg(struct svc_rqst *rqstp, struct nlm_res *resp)
 	resp->status = nlmsvc_lock(rqstp, file, host, &argp->lock,
 				   argp->xdrgen.block, &resp->cookie,
 				   argp->xdrgen.reclaim);
+	if (resp->status == nlm__int__deadlock)
+		resp->status = nlm4_deadlock;
 	nlmsvc_release_lockowner(&argp->lock);
 
 out:
-- 
2.53.0



