Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795705261;
	b=OQyDSNXOA+ZNRUVoHsKBg+hQUtKKjHPha2jc64Slym+Wi3eijhrjiHjR7CJbPUDZAnT4
	 M+saWNqJ3Mi1IUQDX/VpisLzQnC/eZOWeiPslBKUOjnIyHTbuM1jd12fS4S+Uc8wVmQBV
	 AhMDySKe45qWkSozZzCCaQX1IXr0W3PpnqjDCotWWfoGHD56/0/uzXMUtVIMOnrLznfQI
	 hslE9dQE3xdJDp3hhJTYPDz2VIbAxlQAdC5+bIPyRpqUnFcP5PCPBBVLzKpCpSCRHa232
	 Ij5EsEIig+8d7VeGgu/EcdhETtUcfgyr+y0ZJ/MBggY/jQyFmMAgluBI+ffub8LqLxA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795705261;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=kyvNZAaFcqtFNCizcRHhiESSmM9vsKfkHlMrWgAncAY=;
	b=PV5sBeTLlS6yLeLwXhD/RgpE/Bfiy6VtR77Uqk9+uIZqW+zXfDevLWnqccQ6jIY8dPMF
	 tT+mGtRVg4NQ3zGsyXrvn1OLRygZtIV69HHUsSgPS2p1YM5nr3uKrI7nyyMjCKc4C0cwk
	 YMY67MLOxkXXpWJADdTdoQo93DiNntckeipQRAxLVE/g66uQQrCgnzRF/27Knw3HDv1N1
	 Bwcy/6Yd6Z29MZGeKl27nTZ/3ZSQI5LIhpqhqaFrtNYf56BZ/3DRanzOkMoJ2AVM8rhHX
	 vt4pztOQ2m6SqHsODAKDKEcEXafVTSxU5q1vpOi7TeRjzUS8rC/uAS1BhcaQQI0YlWg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=0w7GWHli;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BFD51606A321;
	Thu, 26 Nov 2026 15:01:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=0w7GWHli
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E17061F000EB;
	Thu, 26 Nov 2026 15:01:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795705261;
	bh=kyvNZAaFcqtFNCizcRHhiESSmM9vsKfkHlMrWgAncAY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=0w7GWHliLcynZ83XFOc44AdVzTGm8n9C+uDvAr8Uiu+c4kn/plkGxeaX7ASnQUNru
	 pZ8BGuLN9NTvuAe3F9E4aofCXKREwK8wMEayxlsUlvrUn2aLXhF1ZKf5nHilEZhGXP
	 6z6bfTgAPcJNJNuSm/9A0FaQ6Ta8s4/cfm2AXR9g=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Avi Weiss <thnkslprpt@gmail.com>,
	Anna Schumaker <anna.schumaker@hammerspace.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 140/319] SUNRPC: Balance queue accounting when relocating a task
Date: Thu, 26 Nov 2026 15:38:28 +0100
Message-ID: <20261126144009.907559286@linuxfoundation.org>
X-Mailer: git-send-email 2.56.1
In-Reply-To: <20261126144006.732901931@linuxfoundation.org>
References: <20261126144006.732901931@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Avi Weiss <thnkslprpt@gmail.com>

[ Upstream commit f14b157168ac106cfac6d577e08726488b1b886c ]

When rpc_task_set_transport() relocates a movable task from an
offline transport, it releases the request and drops the
transport reference without decrementing the old transport's
queuelen or the switch's xps_queuelen. Releasing the task
later only accounts for the replacement transport.

The stale counts affect transport selection and can prevent
xprt_delete_locked() from removing an otherwise idle transport.

Use rpc_task_release_xprt() to balance the previous assignment
before selecting a replacement. Pass clnt explicitly because
rpc_task_set_client() can assign a transport before tk_client
is initialized.

Fixes: 82ee41b85cef ("SUNRPC don't resend a task on an offlined transport")
Signed-off-by: Avi Weiss <thnkslprpt@gmail.com>
Signed-off-by: Anna Schumaker <anna.schumaker@hammerspace.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/sunrpc/clnt.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/sunrpc/clnt.c b/net/sunrpc/clnt.c
index 7d7950068b030..799b61a1be010 100644
--- a/net/sunrpc/clnt.c
+++ b/net/sunrpc/clnt.c
@@ -1084,7 +1084,7 @@ void rpc_task_set_transport(struct rpc_task *task, struct rpc_clnt *clnt)
 		      (task->tk_flags & RPC_TASK_MOVEABLE)))
 			return;
 		xprt_release(task);
-		xprt_put(task->tk_xprt);
+		rpc_task_release_xprt(clnt, task->tk_xprt);
 	}
 	if (task->tk_flags & RPC_TASK_NO_ROUND_ROBIN)
 		task->tk_xprt = rpc_task_get_first_xprt(clnt);
-- 
2.53.0



