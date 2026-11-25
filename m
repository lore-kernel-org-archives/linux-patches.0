Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795621970;
	b=wfhAKb39pM5lmLPMtyFdstrR78Uu9PJWZyvPmXKIMUACQwz4OqvbG4IdzY8J+OOY3J6H
	 CkRye5NCixlbsi6RCZ6nuhVWKAYm5GOn6ieXsb3UL/ZiOu+W1xB51eQIybR2+ud1Jzbgn
	 3sC81qsxshR5zeXeQON4noy97WqAcbFJpWE5E2XfbhI4mDK3CJUopkJrxnXclNkfZcKHN
	 tyjj6Rt46rHcPKa0vt6luJ0di1US0RLC0g0flfcBDSfsProEJDhPh7PChJJJG/Zzzawgs
	 WkTdv9WjZHJSqFIlaUixkTCAkSCdhOu1N5KR/Tecl/RF3HqKJ9I2VfA7JFkKbhu0kFA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795621970;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=8E7YoF6+Y7FJmJGwoOAozFd1pXfDWhVsWv7TnFrG354=;
	b=aJnD4mOz3H6afmaJEhkRSEQ4Y8LwIWpSPYQW/M9Oa2Wb9R3aywWLj00XEJsvDxYbS7rO
	 CQNekiJhUfscrPndlszpcXFDAi3+sr1LCj8cZZHsIqF4y8hAEOUyl5yrr0hD8Ex9Z4dJ5
	 YBPZy4zc0OKin/SunAFbqk4tr9tZgSj+GdGqxtvi6e1oWkByArEPGQUubyrVc3SWUyecv
	 Nn2k376Ys+CDdE3MwP++SsElrBReNQeL9IQKtKxPVhWXC1q6582U+7hgWKx4OthM+wkUQ
	 /wSYed2+WSDsOVPB0M/2DGxPis/d93E4Z0Q074vy6dowVtdoiMOyRDBYiUlmXG1h7rA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=z0RmusvH;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 02FBB606A31E;
	Wed, 25 Nov 2026 15:52:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=z0RmusvH
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 505571F000C4;
	Wed, 25 Nov 2026 15:52:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795621969;
	bh=8E7YoF6+Y7FJmJGwoOAozFd1pXfDWhVsWv7TnFrG354=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=z0RmusvH2jBWCew/qkMK0stgoWcENhMcgE2fAs0v8OXcNpuCz8RbsaUlX6kdgVy2V
	 QMLyC10c1Tjioq7rt+KKZD+jhYz1kn4KULqXdHpDkYNuBA2IywugETOASzwrxqJM1U
	 SR+9iYu8lx/Y5OPAqS19N0SUJGHC7cx5K/recLiI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Avi Weiss <thnkslprpt@gmail.com>,
	Anna Schumaker <anna.schumaker@hammerspace.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 388/990] SUNRPC: Balance switch queue length on transport removal
Date: Wed, 25 Nov 2026 15:29:15 +0100
Message-ID: <20261125143831.184697933@linuxfoundation.org>
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

[ Upstream commit 8acd94f02a960c8936df25a7af9c02c8ea87064d ]

When call_connect_status() moves a task off a transport marked for
removal, it decrements xprt->queuelen but leaves the switch's
xps_queuelen unchanged. The stale count persists after the task
finishes and skews multipath transport selection.

Decrement xps_queuelen alongside xprt->queuelen, matching the normal
transport release path.

Fixes: 6f081693e7b2 ("sunrpc: remove an offlined xprt using sysfs")
Signed-off-by: Avi Weiss <thnkslprpt@gmail.com>
Signed-off-by: Anna Schumaker <anna.schumaker@hammerspace.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/sunrpc/clnt.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/net/sunrpc/clnt.c b/net/sunrpc/clnt.c
index 30c996750bd4b..963e9362bfbfc 100644
--- a/net/sunrpc/clnt.c
+++ b/net/sunrpc/clnt.c
@@ -2262,6 +2262,7 @@ call_connect_status(struct rpc_task *task)
 
 				xprt_release(task);
 				value = atomic_long_dec_return(&xprt->queuelen);
+				atomic_long_dec(&xps->xps_queuelen);
 				if (value == 0)
 					rpc_xprt_switch_remove_xprt(xps, saved,
 								    true);
-- 
2.53.0



