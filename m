Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BE6F08828
	for <patches@lists.linux.dev>; Mon, 12 Jun 2023 10:36:47 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4865CC433EF;
	Mon, 12 Jun 2023 10:36:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1686566207;
	bh=b4Kkr79qtovZowNg95+q2loHAogIExXUx/n98AHNaXI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=P2Lqia9N9sDeREe0TdwPkuqvMDvOF4MRBgEg7nDVtSd6m5anrdVSIIRI6MCTmpy1J
	 2NskRryOpWEAzcHCYb/j7/KbZ3HRi5uuJb7K++ioKwpEYBHh25K4iw+LbcyS1DvD9o
	 nvbKiBhpkrEaeL/29jE0kWj88miQGk8JkHY68G+k=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Eric Dumazet <edumazet@google.com>,
	Simon Horman <simon.horman@corigine.com>,
	Kuniyuki Iwashima <kuniyu@amazon.com>,
	"David S. Miller" <davem@davemloft.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 35/91] rfs: annotate lockless accesses to RFS sock flow table
Date: Mon, 12 Jun 2023 12:26:24 +0200
Message-ID: <20230612101703.555440080@linuxfoundation.org>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20230612101702.085813286@linuxfoundation.org>
References: <20230612101702.085813286@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Eric Dumazet <edumazet@google.com>

[ Upstream commit 5c3b74a92aa285a3df722bf6329ba7ccf70346d6 ]

Add READ_ONCE()/WRITE_ONCE() on accesses to the sock flow table.

This also prevents a (smart ?) compiler to remove the condition in:

if (table->ents[index] != newval)
        table->ents[index] = newval;

We need the condition to avoid dirtying a shared cache line.

Fixes: fec5e652e58f ("rfs: Receive Flow Steering")
Signed-off-by: Eric Dumazet <edumazet@google.com>
Reviewed-by: Simon Horman <simon.horman@corigine.com>
Reviewed-by: Kuniyuki Iwashima <kuniyu@amazon.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/linux/netdevice.h | 7 +++++--
 net/core/dev.c            | 6 ++++--
 2 files changed, 9 insertions(+), 4 deletions(-)

diff --git a/include/linux/netdevice.h b/include/linux/netdevice.h
index 5b6c38f748076..823f5ed4ec0cc 100644
--- a/include/linux/netdevice.h
+++ b/include/linux/netdevice.h
@@ -737,8 +737,11 @@ static inline void rps_record_sock_flow(struct rps_sock_flow_table *table,
 		/* We only give a hint, preemption can change CPU under us */
 		val |= raw_smp_processor_id();
 
-		if (table->ents[index] != val)
-			table->ents[index] = val;
+		/* The following WRITE_ONCE() is paired with the READ_ONCE()
+		 * here, and another one in get_rps_cpu().
+		 */
+		if (READ_ONCE(table->ents[index]) != val)
+			WRITE_ONCE(table->ents[index], val);
 	}
 }
 
diff --git a/net/core/dev.c b/net/core/dev.c
index 56a3bff7249d4..24d711fe376a3 100644
--- a/net/core/dev.c
+++ b/net/core/dev.c
@@ -4458,8 +4458,10 @@ static int get_rps_cpu(struct net_device *dev, struct sk_buff *skb,
 		u32 next_cpu;
 		u32 ident;
 
-		/* First check into global flow table if there is a match */
-		ident = sock_flow_table->ents[hash & sock_flow_table->mask];
+		/* First check into global flow table if there is a match.
+		 * This READ_ONCE() pairs with WRITE_ONCE() from rps_record_sock_flow().
+		 */
+		ident = READ_ONCE(sock_flow_table->ents[hash & sock_flow_table->mask]);
 		if ((ident ^ hash) & ~rps_cpu_mask)
 			goto try_rps;
 
-- 
2.39.2



