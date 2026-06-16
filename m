Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CA5283A9D94;
	Tue, 16 Jun 2026 15:07:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781622456; cv=none; b=aP7+Yh2uqJ5LZjnwUl0n7jTFtOES1a7RBu4VlsfV6CbDFJ6gQdlWmkydbsHJZHiCSxVwvW8qo0ES06/b8IrnYEGyT0uUr6NEENNgI1pKO484HY80WsHsfKvdbv6lggFub9bgOgPWpOPpYsPeQnE08BMPCgz7SdR1XlFhNq2lIO8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781622456; c=relaxed/simple;
	bh=FIPzQkczePF0mCNdbc1it+lrz49Lhzx7SjQ3sfcU3No=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=c5Y2VZJ8gj/GBva4bKg4KrFHFf9fnrBs28qo0/mG6i1ZZKCZakRQAc/ljqNEAwrVdWhoSnmOdNVZWkhuHHmKrA2qu+wN7x7Eh3JQIjFdBrCBA27nQ2YFg2kHZ2cMuC3jfgRFXuVMXmnXlU3xYDbEg+kFha93BMS4CIz9S+kK8lg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=V6Semp2X; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="V6Semp2X"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CEC3F1F000E9;
	Tue, 16 Jun 2026 15:07:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1781622455;
	bh=v9dBJXqMICvV3NRKcGABMU/qbUEUU7wWT8E1Pb8owvM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=V6Semp2XlzC254tYD07nkppeA6yLyxOOZFDDWZsYsD+D4Oat/nWzEsd7gnusA+ZvC
	 4HK/er+eUb/1SqMco7e5Wjh/4MCJvUpKTIsNCnoL2p/C/P7d88UqT8zUR8DaHfDty6
	 HeIhA/B8UFF1BpbpUXNejgoHJWvrNQIqGn0OKyn0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Nicol=C3=B2=20Coccia?= <n.coccia96@gmail.com>,
	Dust Li <dust.li@linux.alibaba.com>,
	Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 7.0 006/378] net/smc: fix sleep-inside-lock in __smc_setsockopt() causing local DoS
Date: Tue, 16 Jun 2026 20:23:57 +0530
Message-ID: <20260616145110.102965656@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260616145109.744539446@linuxfoundation.org>
References: <20260616145109.744539446@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

7.0-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Nicolò Coccia <n.coccia96@gmail.com>

commit a3fdd924d88c30b9f488636ce0e4696012cf5511 upstream.

A logic flaw in __smc_setsockopt() allows a local unprivileged user to
cause a Denial of Service (DoS) by holding the socket lock indefinitely.

The function __smc_setsockopt() calls copy_from_sockptr() while holding
lock_sock(sk). By passing a userfaultfd-monitored memory page (or
FUSE-backed memory on systems where unprivileged userfaultfd is disabled)
as the optval, an attacker can halt execution during the copy operation,
keeping the lock held.

Combined with asynchronous tear-down operations like shutdown(), this
exhausts the kernel wq (kworkers) and triggers the hung task watchdog.

[  240.123456] INFO: task kworker/u8:2 blocked for more than 120 seconds.
[  240.123489] Call Trace:
[  240.123501]  smc_shutdown+...
[  240.123512]  lock_sock_nested+...

This patch moves the user-space copy outside the lock_sock() critical
section to prevent the issue.

Fixes: a6a6fe27bab4 ("net/smc: Dynamic control handshake limitation by socket options")
Signed-off-by: Nicolò Coccia <n.coccia96@gmail.com>
Reviewed-by: Dust Li <dust.li@linux.alibaba.com>
Tested-by: Dust Li <dust.li@linux.alibaba.com>
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/smc/af_smc.c |   17 ++++++++---------
 1 file changed, 8 insertions(+), 9 deletions(-)

--- a/net/smc/af_smc.c
+++ b/net/smc/af_smc.c
@@ -3061,18 +3061,17 @@ static int __smc_setsockopt(struct socke
 
 	smc = smc_sk(sk);
 
+	/* pre-fetch user data outside the lock */
+	if (optname == SMC_LIMIT_HS) {
+		if (optlen < sizeof(int))
+			return -EINVAL;
+		if (copy_from_sockptr(&val, optval, sizeof(int)))
+			return -EFAULT;
+	}
+
 	lock_sock(sk);
 	switch (optname) {
 	case SMC_LIMIT_HS:
-		if (optlen < sizeof(int)) {
-			rc = -EINVAL;
-			break;
-		}
-		if (copy_from_sockptr(&val, optval, sizeof(int))) {
-			rc = -EFAULT;
-			break;
-		}
-
 		smc->limit_smc_hs = !!val;
 		rc = 0;
 		break;


