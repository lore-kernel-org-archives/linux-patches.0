Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 86A08385D97;
	Wed, 30 Sep 2026 15:45:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790783150; cv=none; b=SfPctVbcsfeSRZnUhD8x8jtFv0EkU22IxSyNtzG5iBQdOizwYNADaRKhjxzG3aYkls+jPmlRcW4HIEy8HiujXaiIVj+/V7HynSAg4TQOyUkYTgl1pB10e0HGmLoxB3+E+mHQIVATyxAtdso3L7cMaEdNEvd3jqyPmgpzsJGSU90=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790783150; c=relaxed/simple;
	bh=NgJrgScMf6JGBV3j/0HnKsuOy4oWswdp2hHKf/kIeJ4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=hDk+Jn7eQv/k+BKn3G9N3ZPUeRTuz5zY8NIJiJ4S6ZKYxYd1+nTodD3lYXaQ9k9QTRitxJo9+bN6zm5D2kYR4U3pMQqnUrJ7pSJYX1P6YuMnKGjYbq/o0+4sFomO0/J7dVpop6LWmYKwv3XOyXxB5XlZ1s0k3t3IruVoGrn1z5w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ZqJHUc4k; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ZqJHUc4k"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 600681F00899;
	Wed, 30 Sep 2026 15:45:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790783145;
	bh=Vo1GNVA91fH9nroQYCepwCUMzM0WiV2Jyxhzs379H9A=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ZqJHUc4kmCCvRPzraVVyt3Xgmxm6de0qH2B/cKG/BcIby1+lV2PleBa5wvjjk7yTA
	 mUT6lZJ/zpjefZHcH9mVkLX/JIjwpi+DN16sMFvd63fNc6xE1sbbEc7F+L5x+/VYh3
	 +SIUwIKSTLN2Q0tBcs0eAcnWce1LRmYwNBjS/Wec=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Eulgyu Kim <eulgyukim@snu.ac.kr>,
	Jaeyoung Chung <jjy600901@snu.ac.kr>,
	Florian Westphal <fw@strlen.de>,
	Pablo Neira Ayuso <pablo@netfilter.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 259/595] netfilter: nfnetlink_log: cope with concurrent instance destruction
Date: Wed, 30 Sep 2026 17:22:32 +0200
Message-ID: <20260930152353.278672596@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260930152347.700140858@linuxfoundation.org>
References: <20260930152347.700140858@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Florian Westphal <fw@strlen.de>

[ Upstream commit 387d744fa7e499d2c3748a4e60e02ebb24e7fb16 ]

Instances are refcounted. However, only memory release happens on the
1 -> 0 transition; the unlink from hashes can occur with any refcount.

Uncooperative userspace can force a situation where a queue is pending
for destruction from netlink event while a different socket with same
portid processes an UNBIND request.

With right timing, this will unhash the instance again:

Oops: general protection fault, [..]
Call Trace:
 <TASK>
 nfulnl_recv_config+0x31a/0xd50
 nfnetlink_rcv_msg+0x7c2/0xeb0

Fixes: 0597f2680d66 ("[NETFILTER]: Add new "nfnetlink_log" userspace packet logging facility")
Reported-by: Eulgyu Kim <eulgyukim@snu.ac.kr>
Reported-by: Jaeyoung Chung <jjy600901@snu.ac.kr>
Signed-off-by: Florian Westphal <fw@strlen.de>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/netfilter/nfnetlink_log.c | 13 +++++++++----
 1 file changed, 9 insertions(+), 4 deletions(-)

diff --git a/net/netfilter/nfnetlink_log.c b/net/netfilter/nfnetlink_log.c
index 8c967bd772ec3..042d417eb5ec0 100644
--- a/net/netfilter/nfnetlink_log.c
+++ b/net/netfilter/nfnetlink_log.c
@@ -213,13 +213,18 @@ static void __nfulnl_flush(struct nfulnl_instance *inst);
 static void
 __instance_destroy(struct nfulnl_instance *inst)
 {
+	spin_lock(&inst->lock);
+	if (inst->copy_mode == NFULNL_COPY_DISABLED) {
+		/* attempt to UNBIND a queue already pending
+		 * destruction via netlink close event. Ignore.
+		 */
+		spin_unlock(&inst->lock);
+		return;
+	}
+
 	/* first pull it out of the global list */
 	hlist_del_rcu(&inst->hlist);
 
-	/* then flush all pending packets from skb */
-
-	spin_lock(&inst->lock);
-
 	/* lockless readers wont be able to use us */
 	inst->copy_mode = NFULNL_COPY_DISABLED;
 
-- 
2.53.0



