Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C6554477290;
	Mon, 31 Aug 2026 13:54:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788184480; cv=none; b=HtD7/iHmoN8qo6LyVuruJn0ogE9mN3k4BZfMZna38Wh39cunCB0mhWoMcXoJNrGov0wrzTyaXgatecXtD0K++KumIynaPAx6XT74Vxz8Y/IbvS02RB5vnW2shIo9BWLsRLXkvzqENVAWYcQrjLYpRL1bHZneNsxV6QnKQ1/I47w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788184480; c=relaxed/simple;
	bh=ViYUF+ySi7X2LUNEzGzblLTr+zy+/ryJVfULQ7cXkIU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=pCtdoFdL0hF/WQHH3ReSSG0YJNO9IH7RA5KWSG2AMJTyWbXPWd/oTs7pykTxIcDu1ye61KIcchRzqF0n1hTxbHl2i87KWTTTbYXy1cemvq2I04eG7AewJzU/DkhmO2EWlfImZnfLyKIKhAvY+nhbFqTiUnvSI8e8kU5jbmRWwZY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ljeLLm8D; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ljeLLm8D"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2B8041F000E9;
	Mon, 31 Aug 2026 13:54:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1788184479;
	bh=Ze0Tr5+KEw267azS57JQ2oxr35x1fgLgZmyenmbP0z8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ljeLLm8Ddn+L70MfxVmw512S2rpYbzI0MRyK67sB38VXlZ2UnyZWHfTUTmxLnjAPn
	 g5ZLhgJ/83ltE8a4BUDntfXOMKdhUs9hojFfjMlQKxohPEwFcQtS62eKc++hftuWak
	 5xtof3wnPiYkxGv31ypFovbgnuvwuw8zPXoSK7nM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Kuniyuki Iwashima <kuniyu@google.com>,
	Eric Dumazet <edumazet@google.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 22/91] smc: Use __sk_dst_get() and dst_dev_rcu() in smc_clc_prfx_match().
Date: Mon, 31 Aug 2026 15:34:10 +0200
Message-ID: <20260831133400.785548859@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260831133359.468089036@linuxfoundation.org>
References: <20260831133359.468089036@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Kuniyuki Iwashima <kuniyu@google.com>

[ Upstream commit 235f81045c008169cc4e1955b4a64e118eebe61b ]

smc_clc_prfx_match() is called from smc_listen_work() and
not under RCU nor RTNL.

Using sk_dst_get(sk)->dev could trigger UAF.

Let's use __sk_dst_get() and dst_dev_rcu().

Note that the returned value of smc_clc_prfx_match() is not
used in the caller.

Fixes: a046d57da19f ("smc: CLC handshake (incl. preparation steps)")
Signed-off-by: Kuniyuki Iwashima <kuniyu@google.com>
Reviewed-by: Eric Dumazet <edumazet@google.com>
Link: https://patch.msgid.link/20250916214758.650211-4-kuniyu@google.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/smc/smc_clc.c | 26 +++++++++++++-------------
 1 file changed, 13 insertions(+), 13 deletions(-)

diff --git a/net/smc/smc_clc.c b/net/smc/smc_clc.c
index 1859682dfb1cd..571533c72661f 100644
--- a/net/smc/smc_clc.c
+++ b/net/smc/smc_clc.c
@@ -656,26 +656,26 @@ static int smc_clc_prfx_match6_rcu(struct net_device *dev,
 int smc_clc_prfx_match(struct socket *clcsock,
 		       struct smc_clc_msg_proposal_prefix *prop)
 {
-	struct dst_entry *dst = sk_dst_get(clcsock->sk);
+	struct net_device *dev;
+	struct dst_entry *dst;
 	int rc;
 
-	if (!dst) {
-		rc = -ENOTCONN;
-		goto out;
-	}
-	if (!dst->dev) {
+	rcu_read_lock();
+
+	dst = __sk_dst_get(clcsock->sk);
+	dev = dst ? dst_dev_rcu(dst) : NULL;
+	if (!dev) {
 		rc = -ENODEV;
-		goto out_rel;
+		goto out;
 	}
-	rcu_read_lock();
+
 	if (!prop->ipv6_prefixes_cnt)
-		rc = smc_clc_prfx_match4_rcu(dst->dev, prop);
+		rc = smc_clc_prfx_match4_rcu(dev, prop);
 	else
-		rc = smc_clc_prfx_match6_rcu(dst->dev, prop);
-	rcu_read_unlock();
-out_rel:
-	dst_release(dst);
+		rc = smc_clc_prfx_match6_rcu(dev, prop);
 out:
+	rcu_read_unlock();
+
 	return rc;
 }
 
-- 
2.53.0



