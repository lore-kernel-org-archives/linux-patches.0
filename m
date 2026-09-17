Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3F87A4FC35A;
	Thu, 17 Sep 2026 17:24:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789665876; cv=none; b=N99BQ9+nHtnenQM4ETqsKJ5X430CQnNKS12I+xpsDLKjZwsPHpkm+ttpWGp5VNviHjIHxs+2ZEaBx8l4VbZnuCiSWydCsUUV98hWUKV7vqBu+gJgVGC1RbBmw1Sa8of3JzXNgdRraOk+rYn05e5H8vORmNTb5wBj/aBHY5jNK/I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789665876; c=relaxed/simple;
	bh=Zei/fNISqfXX4xGv8F6xM86f7qZ7xEVOCjpl3pZVVGI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Ds41H4oIyHrWTQZ31si7TU1a6jiw5/cnTZMkDQtiEbToIuonbdVmZaeGVcVg9rmtuH2CJjtqvPip+E4iJlYWpdAoICKjk2r36syYR9AHYuX9X7gV+R+OgGkyPMvy2UAvTwj6fvLeuTpO0eY2pt7dh8ykKNWYhpXr0zN0R4Q/QUc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=OR5GOHS1; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="OR5GOHS1"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 790191F000FF;
	Thu, 17 Sep 2026 17:24:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789665875;
	bh=e8iPbe511LwfO5m6Ef+twLaFMBeH+FcBfV0hGs41zLM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=OR5GOHS1XgmrNqh88p2JBoqSswsNJjVzD9Lg4YjsOphcI/mhKxLHx36z4HWOIfIBM
	 QDxIRcz5DeshngSm3fn8amghQH7aaDCXMmIVcU27cVAc4MT0EEcmpTl7b6Pq+GtB2L
	 EDsUusAP/w2psmFSI1m8DcmMxb2J7MoDc33jfblQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Eulgyu Kim <eulgyukim@snu.ac.kr>,
	Jaeyoung Chung <jjy600901@snu.ac.kr>,
	Florian Westphal <fw@strlen.de>,
	Pablo Neira Ayuso <pablo@netfilter.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0848/1250] netfilter: nfnetlink_log: cope with concurrent instance destruction
Date: Thu, 17 Sep 2026 16:10:43 +0100
Message-ID: <20260917151614.944670987@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260917151551.901433442@linuxfoundation.org>
References: <20260917151551.901433442@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

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
index 68e5429338330..66ab77684c8fd 100644
--- a/net/netfilter/nfnetlink_log.c
+++ b/net/netfilter/nfnetlink_log.c
@@ -228,13 +228,18 @@ static void __nfulnl_flush(struct nfulnl_instance *inst);
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



