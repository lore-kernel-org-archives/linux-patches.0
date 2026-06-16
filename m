Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8764E47884C;
	Tue, 16 Jun 2026 16:57:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781629060; cv=none; b=GdcZDnMSHccsrUBn5z55L+1V01U5IMYVEkYDeCOmqgt787VAH2arOvPmpVdwyGdU8H0BGCZSEF41TIu8KuU+2ucNWCs7WLLTreWwbYLOe6mb5ddv75j7+Re/SCRJ0ofz0DT868FE5cnYnnKhZ8nB8QFcRV3qqPdoS9LFUjnvO7s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781629060; c=relaxed/simple;
	bh=WcLyp31VBuy6k77ub3m6NzHTN5jBUQC6cqM4t7kT/4o=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=CGpQeUGDm82IZOG6dmxnlKqoggRHp0bgWWR4ztr03E2IGEKZUL37A4dwAlKmxpCyrQ2sjJr88BzoA8Y3HyEriHflla93Ij+LMj2WUtPsSWqBdHGRO+IyRvRpZ6FlrtIQ7pipgabG/4GrRyA1lsmqQYNs9UCBWxbIBD4Z681q3nQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=iNcXykLu; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="iNcXykLu"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8F80A1F000E9;
	Tue, 16 Jun 2026 16:57:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1781629058;
	bh=6RclnDSf596z6JPKyMh6iDO23O2gejo4Es3LO5Cd6+I=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=iNcXykLuTxqLyo7IVzPynJIN439eXCsRd68wpZAmB02nTIKL4kqqiMBCVRVrS0aQo
	 dl0yJh3vNznYjiy7VeRXa0it8FIv9XL/ioP0JFM8MoX2wjVzoy/aUkZXfS7ikVXmaE
	 msagPH0SM8zSK2f+X5nbf2XGc2mcfDyZu/2JdwSI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Nicol=C3=B2=20Coccia?= <n.coccia96@gmail.com>,
	Dust Li <dust.li@linux.alibaba.com>,
	Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 6.6 212/452] net/smc: fix sleep-inside-lock in __smc_setsockopt() causing local DoS
Date: Tue, 16 Jun 2026 20:27:19 +0530
Message-ID: <20260616145128.938061595@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260616145117.796205997@linuxfoundation.org>
References: <20260616145117.796205997@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
@@ -3048,18 +3048,17 @@ static int __smc_setsockopt(struct socke
 
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


