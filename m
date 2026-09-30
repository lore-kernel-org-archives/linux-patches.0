Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A7206514770;
	Wed, 30 Sep 2026 16:20:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790785215; cv=none; b=JPwnFPxrGEdGtPnuYRlxfor475wWzrPMMnp770VWPqYjHl5aVeOPuQbxMqh80XCXvTVVFJLA2QeSwNzGvET/ZMlDaQSlb8jiQAEH4OVODNUTC/v00SHLBfzd2HX6ld7tJy9ZJfYK6f30+YmZ9xh1Ftd27LdCZhvu0ijZLiilIdw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790785215; c=relaxed/simple;
	bh=urn2PJFjIZUK8Ne+R0LGIFWbEKlD2Anb6xj1NyOTtB4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=f8j9oh2wvwCU9tKUjhQZI+W3DspNceY7KT5Y+ZoGpUi93EG/l/HOSubJA2nlC5v3JSIs0JsFyahKrcvDLAd74ysjxGEFjjNQhY/c2pZVNnXa2VzsSCqzTpilia2CWC5yleMaaSktE/5MRAQVpYN5IDlXj3b8IaWov6Ei2esyfR0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=hMoqwAnc; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="hMoqwAnc"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 998361F00893;
	Wed, 30 Sep 2026 16:20:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790785209;
	bh=WZJEhpZTtXarqxB4F3CT5oZOvnqwUbkAK2s3fVybF1Q=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=hMoqwAncCDCUg/8GH+I5+gtt0q4jovi+MOoGvZCBziGVrxWO+QItemdksdQEoVntH
	 2Svgkz1XRuBuGXWT31Gtma4Cei6NarX8Av/Ok/OgwXgDHFYo/BdkFYuPCTsJZoeMOT
	 GH9lv7ONedkiezkNijkKTYzOROlYxbSVizW8En8k=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Vega <vega@nebusec.ai>,
	=?UTF-8?q?Toke=20H=C3=B8iland-J=C3=B8rgensen?= <toke@redhat.com>,
	Victor Nogueira <victor@mojatatu.com>,
	Jamal Hadi Salim <jhs@mojatatu.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 427/982] net/sched: pie: clamp psched_mtu in pie_drop_early
Date: Wed, 30 Sep 2026 17:19:23 +0200
Message-ID: <20260930152425.972081386@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260930152416.775402466@linuxfoundation.org>
References: <20260930152416.775402466@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jamal Hadi Salim <jhs@mojatatu.com>

[ Upstream commit 54370e44c002770ae61fc889f28f699e91616ffc ]

pie_drop_early() calls psched_mtu() with no clamp. With mtu=0x80000000
the bytemode divide silently zeroes the drop probability, disabling AQM.
Clamp to [1, 1<<20].

Conditions to recreate the bug:
  CONFIG_NET_SCH_PIE=y. Requires CAP_NET_ADMIN (namespace-local via
  unshare -Urn suffices).

  tc qdisc add dev dummy0 root pie
  tc qdisc change dev dummy0 root pie stab data 32768 size_log 15 cell_log 0

Fixes: d4b36210c2e6 ("net: pkt_sched: PIE AQM scheme")
Reported-by: Vega <vega@nebusec.ai>
Reviewed-by: Toke Høiland-Jørgensen <toke@redhat.com>
Tested-by: Victor Nogueira <victor@mojatatu.com>
Signed-off-by: Jamal Hadi Salim <jhs@mojatatu.com>
Link: https://patch.msgid.link/QDISC-0CFC.v3.20260901204856@mojatatu.com.7
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/sched/sch_pie.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/sched/sch_pie.c b/net/sched/sch_pie.c
index 4ab296678b0b1..1ed6f43c93c4d 100644
--- a/net/sched/sch_pie.c
+++ b/net/sched/sch_pie.c
@@ -35,7 +35,7 @@ bool pie_drop_early(struct Qdisc *sch, struct pie_params *params,
 {
 	u64 rnd;
 	u64 local_prob = vars->prob;
-	u32 mtu = psched_mtu(qdisc_dev(sch));
+	u32 mtu = clamp_t(u32, psched_mtu(qdisc_dev(sch)), 1, 1 << 20);
 
 	/* If there is still burst allowance left skip random early drop */
 	if (vars->burst_time > 0)
-- 
2.53.0



