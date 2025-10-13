Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 50A7030CD87;
	Mon, 13 Oct 2025 15:38:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760369916; cv=none; b=CBPr3hI33D9sR/2PP4tDsaI9JWBS9SAvrbpk6dU4+6aMF2dEBBMPlkph067rxs8HYmkuowDJZlo9haW10jIwU6nYKbJtI1cE45BEtGxid/HLm+UyCAcOBfVTarKsJEx1Z9Z/cUFApFnlL7LGoJ4s9sfMSNvc8q5+Djhxn4Bi/+M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760369916; c=relaxed/simple;
	bh=fq8pLD8sdByCRDAmQVntXN3xxSFeBv102CBzqfqTiaM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=sQg0GJZ9WfnyRAVPZwv9nD/p5S5+KXJ935mDjeLiRvO8JNCrGVYKayH4wpGe/zmiP9EYyhhEYJXNkLixnaJuKXaZgF9EOnSc2cZTlhwcHKynA4TCqmJHKoBYOauUdy5Rv5kRvnzRy9IKz8Q5izFp0ExEn8mX/EsI5oul8SPpzyE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=JNHMOybd; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="JNHMOybd"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CA4FFC4CEE7;
	Mon, 13 Oct 2025 15:38:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1760369916;
	bh=fq8pLD8sdByCRDAmQVntXN3xxSFeBv102CBzqfqTiaM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=JNHMOybdrYGJ5Xm+jwlQDLjcHLY6mwhiA7sVAIfc1aBrbhXKTAyUMM4PSRRMFAx7P
	 P/ZGpeJWknMriFNioZ2aZDDfoxxrtSlUeZ2gvhWE8CvxFPvgxf19epH1lcnQF4JftY
	 O9M/ZWqzKTLeaJtLDpdZWnAFzgTy6eQZPT2VLnes=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Kuniyuki Iwashima <kuniyu@google.com>,
	Eric Dumazet <edumazet@google.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.17 380/563] smc: Use __sk_dst_get() and dst_dev_rcu() in smc_clc_prfx_match().
Date: Mon, 13 Oct 2025 16:44:01 +0200
Message-ID: <20251013144425.039968882@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20251013144411.274874080@linuxfoundation.org>
References: <20251013144411.274874080@linuxfoundation.org>
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

6.17-stable review patch.  If anyone has any objections, please let me know.

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
index 976b2102bdfcd..09745baa10170 100644
--- a/net/smc/smc_clc.c
+++ b/net/smc/smc_clc.c
@@ -657,26 +657,26 @@ static int smc_clc_prfx_match6_rcu(struct net_device *dev,
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
2.51.0



