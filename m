Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795621973;
	b=iKHcodj57HkGqcSvyHMYukr1gu5GQJmBlpuvtkE32gzggStZ+v/5wO8vfg6O0UZk4t4R
	 oKcUle1CCn25NpoUjUXaIaexqT++S/VtIsMrwrMBovCCoQS5f6FECaFtCnTgZXQH8v6tS
	 XlBSqwC9SV7b2Cza+b6d6S1ZvJ1kj4crBdrK61cdQ+FHvLdC5WtDfWR5ijluCnCISAU8L
	 xWvO4Y1dzLtW3WFR+d9x+PojmkpdydCM+fNtcX3ySkOlVcUB9hLEc4DjQRRTjAlMZU3ph
	 RTPIjJN5DZVcaEZW8ndoGLGh7JRZk/fj7d6FJajECd1do00ASnn5VrP2DURcO8PaCIA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795621973;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=nJU4nQ6f2SfXovnax84BN6hfdLWNp3sxdapL1l4jD98=;
	b=ekAtQIOybxy3B3TPrRSKL/AzbGrBWesDb03s2a/WfnmF8yWmcQhzKnKfDwqhW5ippwZt
	 WFoM/1LaxcFLbrlKNUa62g7k4jVBbKKrh+FNzuEi3FpO+oBQ7htGACrsamgHVp6E7yM4n
	 KXSlJKKy0AxMC6r1QLwPLrw0xEqqeg13OCj1+e+gSRmcsZuoYzipC9sYw3NjaMDyRn6k5
	 TY5I60CsEq/OQnfKm7E1p1OKe2bQSX7k+tgsFgZjCno9tRFB+dq2DE3G34kL/V+m/VY1y
	 1nDXonMtQn1iLQktEMoksRin6th5K52kLZHaT9r3XQJHL53Xp71y+wSkftr4SwwOl8w==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=T0eJfs18;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 63D7C606A321;
	Wed, 25 Nov 2026 15:52:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=T0eJfs18
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 306191F000CA;
	Wed, 25 Nov 2026 15:52:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795621972;
	bh=nJU4nQ6f2SfXovnax84BN6hfdLWNp3sxdapL1l4jD98=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=T0eJfs18jCl9/v1H3mvrSU1kBoGKh+z1lzmnOG2YepFaV0V3cjpIcrse6/h6gEXO9
	 39QhYRQ5MIKdQHpZa3DDThIFts51hA9GcBIztGTdMGZ2qzoJaljUFOnF92JmNLdkCt
	 46MeWk1yCL9EzFoaJ1aeV3hpkYxayo7TGI7Y9ECM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Avi Weiss <thnkslprpt@gmail.com>,
	Anna Schumaker <anna.schumaker@hammerspace.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 389/990] SUNRPC: Balance queue accounting when relocating a task
Date: Wed, 25 Nov 2026 15:29:16 +0100
Message-ID: <20261125143831.209185764@linuxfoundation.org>
X-Mailer: git-send-email 2.56.1
In-Reply-To: <20261125143822.072087159@linuxfoundation.org>
References: <20261125143822.072087159@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

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
index 963e9362bfbfc..9c6cdc29102a5 100644
--- a/net/sunrpc/clnt.c
+++ b/net/sunrpc/clnt.c
@@ -1197,7 +1197,7 @@ void rpc_task_set_transport(struct rpc_task *task, struct rpc_clnt *clnt)
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



