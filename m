Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CE2BC14A0A4;
	Tue, 25 Jun 2024 10:00:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719309612; cv=none; b=LeiX03YD+FRttoHH1RDxkFU8srb0SKrhOJhPK2icaDt8Y9tKgewc5RvLu/tPfu/ncSL+FvrKNAveLkFz0Nw1SZDryW7BEquC+kYe8nL7s71CY0d6xiAGTb+SHlfxN46zgYOuCnTAwfA+r85jrAbIZq+z1eBd7fnqj2YzXV41yg0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719309612; c=relaxed/simple;
	bh=LWC9vrH6EmAUGvjPRHM/RVgVdOl5hUiEk2/WOqJsa5M=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=juTXDeESsQ0Vrhqyi+GAPKa6Wzyti1GwwyMi6l+7pQvIqHS4zz4ZtLtyzeYagTfRW5XEjVH+GvX+3Bfie5EiTkfshbM6f4uScilhBREkt6e895KrwfP2KE+1HrDRiTCkT/J+pqjB8sSgTBikqb7aTmcwdnO9cqQa4QfrL6p6R1M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=fbTHE2nM; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="fbTHE2nM"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C254BC32789;
	Tue, 25 Jun 2024 10:00:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1719309612;
	bh=LWC9vrH6EmAUGvjPRHM/RVgVdOl5hUiEk2/WOqJsa5M=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=fbTHE2nMKWbpulxum6n0HBnVpvH3hHpoeMsjwBlo8EKQBXSQOh2PzhJUz0nTYnZZz
	 HfkcWyAeBAiSnWsCQaDuEmjLF2O+r7EAjL5mSZQA7lvUXuDCJdJU0ndHeFiZaC3sMu
	 IgUpgviOmanbraWXun8T3oE/WChVFSrG/drVBrg0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Shuang Li <shuali@redhat.com>,
	Xin Long <lucien.xin@gmail.com>,
	Paolo Abeni <pabeni@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 067/131] tipc: force a dst refcount before doing decryption
Date: Tue, 25 Jun 2024 11:33:42 +0200
Message-ID: <20240625085528.491372374@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240625085525.931079317@linuxfoundation.org>
References: <20240625085525.931079317@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Xin Long <lucien.xin@gmail.com>

[ Upstream commit 2ebe8f840c7450ecbfca9d18ac92e9ce9155e269 ]

As it says in commit 3bc07321ccc2 ("xfrm: Force a dst refcount before
entering the xfrm type handlers"):

"Crypto requests might return asynchronous. In this case we leave the
 rcu protected region, so force a refcount on the skb's destination
 entry before we enter the xfrm type input/output handlers."

On TIPC decryption path it has the same problem, and skb_dst_force()
should be called before doing decryption to avoid a possible crash.

Shuang reported this issue when this warning is triggered:

  [] WARNING: include/net/dst.h:337 tipc_sk_rcv+0x1055/0x1ea0 [tipc]
  [] Kdump: loaded Tainted: G W --------- - - 4.18.0-496.el8.x86_64+debug
  [] Workqueue: crypto cryptd_queue_worker
  [] RIP: 0010:tipc_sk_rcv+0x1055/0x1ea0 [tipc]
  [] Call Trace:
  [] tipc_sk_mcast_rcv+0x548/0xea0 [tipc]
  [] tipc_rcv+0xcf5/0x1060 [tipc]
  [] tipc_aead_decrypt_done+0x215/0x2e0 [tipc]
  [] cryptd_aead_crypt+0xdb/0x190
  [] cryptd_queue_worker+0xed/0x190
  [] process_one_work+0x93d/0x17e0

Fixes: fc1b6d6de220 ("tipc: introduce TIPC encryption & authentication")
Reported-by: Shuang Li <shuali@redhat.com>
Signed-off-by: Xin Long <lucien.xin@gmail.com>
Link: https://lore.kernel.org/r/fbe3195fad6997a4eec62d9bf076b2ad03ac336b.1718476040.git.lucien.xin@gmail.com
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/tipc/node.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/net/tipc/node.c b/net/tipc/node.c
index a9c5b6594889b..cf9d9f9b97844 100644
--- a/net/tipc/node.c
+++ b/net/tipc/node.c
@@ -2107,6 +2107,7 @@ void tipc_rcv(struct net *net, struct sk_buff *skb, struct tipc_bearer *b)
 	} else {
 		n = tipc_node_find_by_id(net, ehdr->id);
 	}
+	skb_dst_force(skb);
 	tipc_crypto_rcv(net, (n) ? n->crypto_rx : NULL, &skb, b);
 	if (!skb)
 		return;
-- 
2.43.0



