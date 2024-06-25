Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A50B324B34;
	Tue, 25 Jun 2024 09:52:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719309171; cv=none; b=ORTbbmq66gNHIQ9OTU0UBd91AeIZWK+HhPWPw5l2R5KmeT/vxW6BYx3211BLI3iVZXvidLM9yHg4LqbAqiIh2AUIADmO7DJMBqKruXtOwWetsW2v4LDKMBgVot9xjaKPp8RCeHrz2+Mzf82TAoeayg3dXkR1shg69e5EN4xJRcI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719309171; c=relaxed/simple;
	bh=On9+3wCT3cr1Q3iv3WxJlPQBJTSRP/HJB6yHAejqO7Y=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=q4/DsHl5vFWbG6Ho5Zg1Sxo+fGh0u4MX7HNsJyrVUNZWvyzw6w9/MwQ20YteaybfmfmN4dj3jfMFWvycscSCHufWKHMM+LiGn0/8ggdqOkKzi11KsW0/zlJ5OyOvjk8kKyeLrfVKLPithUk7l6udQtKCPA3/pT0z+Tp6rQrBAYM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=kfv7U2gZ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="kfv7U2gZ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2CD53C32781;
	Tue, 25 Jun 2024 09:52:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1719309171;
	bh=On9+3wCT3cr1Q3iv3WxJlPQBJTSRP/HJB6yHAejqO7Y=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=kfv7U2gZ0/u6u7+lcdAgj6KxA4FCd0lF6yOG5m+dtpFDjJ3HuURl/3fyyyuITDcno
	 n+zN7cORLkzU8gNQ3Ca0ib9+SciGfRso9/WOZqm0tR/FOCoM3Fq/p5eSE0Pyqj4gBq
	 blKoVspQR8Arc0Fn+EpHTydEWekuhxGn0xdCKq/0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Shuang Li <shuali@redhat.com>,
	Xin Long <lucien.xin@gmail.com>,
	Paolo Abeni <pabeni@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 089/192] tipc: force a dst refcount before doing decryption
Date: Tue, 25 Jun 2024 11:32:41 +0200
Message-ID: <20240625085540.591981090@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240625085537.150087723@linuxfoundation.org>
References: <20240625085537.150087723@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
index 3105abe97bb9c..69053c0398252 100644
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



