Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0D7F0351C04;
	Fri,  4 Sep 2026 05:27:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788499631; cv=none; b=kd49IRO7sLu0ZAJGj3fIYW5dJ36pEbJl2VjIrsrEqR0gKlqcyFEuQ/cRpC9qZz4VGoJSSqqJleIzf/9fIVl2eAYICXyACSAN7h7PjZ3SihyzTKIAR+pKBz1U7nQdI+Q+8CgrQEJAaenxY/ber8VIatqW12F4logqMcbHGS/7shc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788499631; c=relaxed/simple;
	bh=HXskMTt1yyCZLBL6K8QhbJRuMkYfh/OMi57k0qLVWfU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=qVec/Ob3JHchvpyjiCbw443YqGklDSPRoLjxmkE2C9hsUsUIFZ/G+Ns7tkKzB1QnUy87k6lNW6ugLTlS/P5ISb7qQOWhhZK3syT0QiIHMXSK2icKIsCLthq+ysomSrg3PYZH6w8XWZcBUioCy44wfMm+YplxJFBUNCC0d/xR3sY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=NnPw5VVo; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="NnPw5VVo"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6829A1F00A3D;
	Fri,  4 Sep 2026 05:27:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1788499629;
	bh=9BJhdn0xr/xt1tucyUdA9xEQAUdVocIfiC3h+0+tw2w=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=NnPw5VVo2osNrlpJNlae3jPmFQGB/8kcZJiGMQ1++tGx+5B0r1W5I2F5rjQuiH+jN
	 VCibjvH+N7SImoufmzyDw6e/lOFF88OMS/sDcIBNnyvYHyhHa6LSMVmKVNNO8QxBnJ
	 M5LDcyrYcUrSmJ0JyNU3eJuvd/6S5s8UDgwyrcy8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Olga Kornievskaia <okorniev@redhat.com>,
	NeilBrown <neil@brown.name>,
	Chuck Lever <cel@kernel.org>
Subject: [PATCH 7.2 484/713] lockd: fix NLMv4 GRANTED_MSG handling
Date: Fri,  4 Sep 2026 06:57:32 +0200
Message-ID: <20260904045814.675192728@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260904045803.810145556@linuxfoundation.org>
References: <20260904045803.810145556@linuxfoundation.org>
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

7.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Olga Kornievskaia <okorniev@redhat.com>

commit 88e90d3f7e0251770e52d85c5319f037024b2c59 upstream.

GRANTED_MSG is a server-to-client callback, so it runs on the client,
where nfsd never registers nlmsvc_ops. The nlm4svc_lookup_host()
helper is for the server-side request handlers
(TEST/LOCK/CANCEL/UNLOCK), which reach nlmsvc_ops->fopen and must
reject requests when nfsd isn't running. GRANTED_MSG only calls
nlmclnt_grant(). Instead, of calling nlm4svc_lookup_host(), which
results in a client failing a GRANTED_MSG call, call
nlmsvc_lookup_host().

Fixes: 62721885e861 ("lockd: Use xdrgen XDR functions for the NLMv4 GRANTED_MSG procedure")
Cc: stable@vger.kernel.org
Signed-off-by: Olga Kornievskaia <okorniev@redhat.com>
Reviewed-by: NeilBrown <neil@brown.name>
Link: https://patch.msgid.link/20260625211852.31972-1-okorniev@redhat.com
Signed-off-by: Chuck Lever <cel@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/lockd/svc4proc.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/fs/lockd/svc4proc.c b/fs/lockd/svc4proc.c
index 080dffce9d8e..b73004a7987e 100644
--- a/fs/lockd/svc4proc.c
+++ b/fs/lockd/svc4proc.c
@@ -872,7 +872,8 @@ static __be32 nlm4svc_proc_granted_msg(struct svc_rqst *rqstp)
 	struct nlm4_testargs_wrapper *argp = rqstp->rq_argp;
 	struct nlm_host *host;
 
-	host = nlm4svc_lookup_host(rqstp, argp->xdrgen.alock.caller_name, false);
+	host = nlmsvc_lookup_host(rqstp, argp->xdrgen.alock.caller_name.data,
+				  argp->xdrgen.alock.caller_name.len);
 	if (!host)
 		return rpc_system_err;
 
-- 
2.55.0



