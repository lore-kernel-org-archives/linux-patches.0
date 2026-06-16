Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 859F244CF37;
	Tue, 16 Jun 2026 16:16:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781626562; cv=none; b=KPSzeeZfJ43H/8djzr3GMvETLiIBUGs5vLbJVQSlxCOpqL5k/gf9TzzSOt3KIGvqUXWLgmgMKrN6NxQ2jApQgQDjdj+/7kQs1VQmkWVLxGGM3jNFeXlsygH9TZ28wcYjUgIhDH0u//LhUc/2JddwgQIo/PkahzH1wQuj7utFJXE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781626562; c=relaxed/simple;
	bh=Lhx4AzUaZfAqgprRm4S+OHyxvgxJiTUmxpd80fKxXrU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=IMIEhprVDWAIuH2kltMpbPCDwP4FkSu6asSZ5DMJAj3JSScV6Q6fpvW90TyQBFQG+NRKXaloa/jI/7yknrMMInGYyu7drwJ5lyidWKHJ3+T1P2wR1HOWcjRhQyaZCQi4RXuIN1EzPKAgq6UIzswJ7QPehPVbhtMdmebtJXsAq4g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=TMGoVutU; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="TMGoVutU"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CC06A1F000E9;
	Tue, 16 Jun 2026 16:16:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1781626561;
	bh=yJa0XVDNVE706q+4PCx1QlN7JI6QwEOaN73mIvLy7rQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=TMGoVutUMlBJV+jVMFz09jsiC1SGX6QSZwT4RUsw2xPoqFXWWLA4+KZMpmmUNDa7P
	 1mN+NxgPg0WL5Ha3qMD0nyTdrpPmQjpFORUfymu5aNqAh7hia5YypHI2s3LkSYT4k5
	 hcWwWOo/864vdFe0PnZwb/l921XN9AfyxYGNpxN8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Nicol=C3=B2=20Coccia?= <n.coccia96@gmail.com>,
	Dust Li <dust.li@linux.alibaba.com>,
	Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 6.12 011/261] net/smc: fix sleep-inside-lock in __smc_setsockopt() causing local DoS
Date: Tue, 16 Jun 2026 20:27:29 +0530
Message-ID: <20260616145045.543992521@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260616145044.869532709@linuxfoundation.org>
References: <20260616145044.869532709@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
@@ -3060,18 +3060,17 @@ static int __smc_setsockopt(struct socke
 
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


