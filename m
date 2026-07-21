Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7EFD137E310;
	Tue, 21 Jul 2026 22:46:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784673973; cv=none; b=r/LLyldeY0WK6SC4z7x7fIhhaJ4RJvUlcHfgbjYrqUgAG6jDkFuy1+BBcvJvVfKmaApG/ni4cX20G7wT8p1PymmLYvuQs3Cdg5/zvxNd3YnaGvQh1qcbkcKUrZR6POKBWdewg8ze0loNPMbovU+BRwzqGHHeRu2JLjWgs+qWyAA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784673973; c=relaxed/simple;
	bh=ZmuWo6faVe/oeZm4Xx0ajVXTJGsAWCRSEwO99TbTPT4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=PK6ry6U66yN0ABsiEHl6mxxa9+vBTSiPcjGkoVhXTtqENdY3fp9aZHiCUhQCXEe1LUupCaReJVuw6LNUdeqT4GOpoOTcvqVlPBEyna3ldLxuNCaD1hoJyE9REiO6PfLHNkuEh8QDJ4hiVRLurYllqVHMVcri9TGL9Pqv168gDhE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=QoV2urhH; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="QoV2urhH"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DAF7E1F000E9;
	Tue, 21 Jul 2026 22:46:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784673972;
	bh=QpTx8lk8ypgv9auJ1LKNX8PiqfARbzWu/snndM8D5yg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=QoV2urhHErquIu7CT6b66dtLdR+0Ow1T93+j8FLyHt02NiqZBuNml2VamDdEYQBvT
	 xHtrzJFS3+yw4Dyj7vt3qcdylz2TNicc38FsqUyheKnkO2896kymZB24wChPtAZqQJ
	 Sb3EPI0vs8yFHrI28UhwQAoyL0wZSh+5vwQDNgpM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Alejandro Olivan Alvarez <alejandro.olivan.alvarez@gmail.com>,
	Fernando Fernandez Mancera <fmancera@suse.de>,
	Pablo Neira Ayuso <pablo@netfilter.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 358/699] netfilter: nf_conncount: prevent connlimit drops for early confirmed ct
Date: Tue, 21 Jul 2026 17:21:57 +0200
Message-ID: <20260721152403.766524241@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152355.667394603@linuxfoundation.org>
References: <20260721152355.667394603@linuxfoundation.org>
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

From: Fernando Fernandez Mancera <fmancera@suse.de>

[ Upstream commit c8b6f36f766991e3ebebec6596daee4b04dcbc49 ]

Commit 69894e5b4c5e ("netfilter: nft_connlimit: update the count if add
was skipped") introduced a regression where packets for valid
connections are dropped when using connlimit for soft-limiting
scenarios.

The issue occurs when a new connection reuses a socket currently in
the TIME_WAIT state. In this scenario, the connection tracking entry
is evaluated as already confirmed. Previously, __nf_conncount_add()
assumed that if a connection was confirmed and did not originate from
the loopback interface, it should skip the addition and return -EEXIST.

Skipping the addition triggers a garbage collection run that cleans up
the TIME_WAIT connection. Consequently, the active connection count
drops to 0, which xt_connlimit mishandles, leading to the false rejection
of the perfectly valid new connection.

Fix this by replacing the interface check with protocol-agnostic state
checks. We now skip the tree insertion and preserve the lockless garbage
collection optimization only if the connection is IPS_ASSURED. This
allows early-confirmed setup packets (such as reused TIME_WAIT sockets
or locally generated SYN-ACKs) to be properly evaluated and counted
without falsely dropping. The goto check_connections path is maintained
to ensure these setup packets are deduplicated correctly.

This has been tested with slowhttptest and HTTP server configured
locally to ensure we are not breaking soft-limiting scenarios for local
or external connections. In addition, it was tested with a OVS zone
limit too.

Fixes: 69894e5b4c5e ("netfilter: nft_connlimit: update the count if add was skipped")
Reported-by: Alejandro Olivan Alvarez <alejandro.olivan.alvarez@gmail.com>
Closes: https://lore.kernel.org/netfilter-devel/177349610461.3071718.4083978280323144323@eldamar.lan/
Signed-off-by: Fernando Fernandez Mancera <fmancera@suse.de>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/netfilter/nf_conncount.c | 11 +++++------
 1 file changed, 5 insertions(+), 6 deletions(-)

diff --git a/net/netfilter/nf_conncount.c b/net/netfilter/nf_conncount.c
index b9265a8cdb2bc4..79b0d9c8de56d9 100644
--- a/net/netfilter/nf_conncount.c
+++ b/net/netfilter/nf_conncount.c
@@ -179,17 +179,16 @@ static int __nf_conncount_add(struct net *net,
 		return -ENOENT;
 
 	if (ct && nf_ct_is_confirmed(ct)) {
-		/* local connections are confirmed in postrouting so confirmation
-		 * might have happened before hitting connlimit
+		/* Connection is confirmed but might still be in the setup phase.
+		 * Only skip the tracking if it is fully assured. This guarantees
+		 * that setup packets or retransmissions are properly counted and
+		 * deduplicated.
 		 */
-		if (skb->skb_iif != LOOPBACK_IFINDEX) {
+		if (test_bit(IPS_ASSURED_BIT, &ct->status)) {
 			err = -EEXIST;
 			goto out_put;
 		}
 
-		/* this is likely a local connection, skip optimization to avoid
-		 * adding duplicates from a 'packet train'
-		 */
 		goto check_connections;
 	}
 
-- 
2.53.0



