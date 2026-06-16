Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3469744D6AB;
	Tue, 16 Jun 2026 15:46:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781624774; cv=none; b=tiq/fPJaO+mXg+cWG/m8GEJAj7gjAoiIne4u8WR6ZyKQnOFwWBza5HIIZtrLW4Bxtyr3l4T01l2knlDZX6gdac6iXY9y70DKkUaoudREqHKDf1RyIOkn3P82+/QqaTwDNm6dtQo6RZzM5A624VI5yPWptdozdC39rW8mIIDeW+U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781624774; c=relaxed/simple;
	bh=2WAtC2wJoKO+JpVe4Kh2plAV6R6qxEnYECO4MsBxekU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=U3AiZRa0UrnYyW2cXVruPQOxz0PaBLJPLzC5OMbqv1oPPLlbBSlF6LRp5Q+vvLvN0Ywyri8iN+TejL6tfpSfZmffpey2VpTa5mkVriistUMUF90S4v5iMsctLxaB984ySjDR7aYTu9I+EbGQ3pzrsgTv1sbUdUpvPT+LHxSUEtk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=vrZ98Awk; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="vrZ98Awk"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 03DC71F000E9;
	Tue, 16 Jun 2026 15:46:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1781624771;
	bh=/PeP/gI/FZs4ADIw++d0ndwRxmNmtA1EIjSMo39eBMg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=vrZ98Awk6BleVaORdrRex5xN3LtXvp6QCvo6PTl5X4DuFxabszryrYSqD9jvrpBnJ
	 L4kcS6IYLJq56IVvzKe6OwvDCPFOUJqHa1qRRdPFoeqe5nN79Y9OrQ3SIQCKhTke/6
	 VSvXhQzhlosR9JL/1kzf6Aw+R55VES6hrTuG87X8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Nicol=C3=B2=20Coccia?= <n.coccia96@gmail.com>,
	Dust Li <dust.li@linux.alibaba.com>,
	Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 6.18 009/325] net/smc: fix sleep-inside-lock in __smc_setsockopt() causing local DoS
Date: Tue, 16 Jun 2026 20:26:45 +0530
Message-ID: <20260616145058.287064614@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260616145057.827196531@linuxfoundation.org>
References: <20260616145057.827196531@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

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


