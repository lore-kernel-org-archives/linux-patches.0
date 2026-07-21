Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DE1F63EEAC7;
	Tue, 21 Jul 2026 19:11:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784661094; cv=none; b=t4CjVf/UJLB+5kksRgd/JnE1CRAqNKmz0/jDUTXv2Iq8kRE9DcE48tfNJO4LAO+ReAPwaGgDjlv7L+q5NqNiFnXuqQJiXAxET6xuXe5Tk12tcMSmemG8lGPicV39LOxc22N1M+92KSk8N7nXv5NCNovliJzUgCWc3r4VJkUQEh4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784661094; c=relaxed/simple;
	bh=WBngp3IzXUPMU6D5BphFu6bSsUw7DehMYl3ZHojIBWE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=QH7d4ljTEBFt7tHb5hr6VlzY3fbp9ggtbEDIyMbZCb5/Vl6D51FNFif0/joYWY1XJsSGwy2QBCukOMCJpaEK0he0CbjtOapQA0gC/9ZOfiqN1xBmg92Fv2D9DJU5YcrrwVM4421w9m9aKwamtrVN0jewFuB+WhGv2mGo6KVmPT8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=XD4Hn9P1; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="XD4Hn9P1"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4F1391F000E9;
	Tue, 21 Jul 2026 19:11:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784661092;
	bh=5c1zZEFQ8vNW+JzBW3KFBvsri7vclDuzTq5TQ+zeEfw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=XD4Hn9P12MtDAHN29GfhjEra8avn965UcUWKnQ0vK8NtGzblb5GRbeyjrzjE5d7FY
	 MeH6s7v24x3w5dqC72bpCC6mQ3D3uJOtZZrFYDlDk/PAijfIFKNGO9b7kY82Inok5/
	 A0e9MYyAaZe2XllynJCx2DcvDomOIJJT+hEwEzPI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Alejandro Olivan Alvarez <alejandro.olivan.alvarez@gmail.com>,
	Fernando Fernandez Mancera <fmancera@suse.de>,
	Pablo Neira Ayuso <pablo@netfilter.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.1 1227/2077] netfilter: nf_conncount: prevent connlimit drops for early confirmed ct
Date: Tue, 21 Jul 2026 17:15:00 +0200
Message-ID: <20260721152621.752793473@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152552.646164743@linuxfoundation.org>
References: <20260721152552.646164743@linuxfoundation.org>
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

7.1-stable review patch.  If anyone has any objections, please let me know.

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
index dac29e933553d3..c6d3f1c06b3300 100644
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



