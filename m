Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 611645158BA;
	Wed, 30 Sep 2026 18:06:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790791597; cv=none; b=gxMOhowZwJ/Azqg7LpQlXsuk8Z0U2qyneP29KmUZZBT8p1Mq30QV6KB8PSu1v8y1/z3ksNtpMhTNYZ9DL/yfrvillTDpbMVpPH9RJk65kGwC7o/EPcg4C95DjC+IWtRXpXDfeq4hNQstPyUpNYPp9dCdGLznSKCJwTCFGN39soo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790791597; c=relaxed/simple;
	bh=h6Qc+J4AxIpSwvdQ95k3rZsrSFE4sQc0YdkrpHhqPM8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=r0oDzcsB4wwoMLO6by8YYm05MFonsTkKATElf6c2RLlcvkX+f3eaCZJFMMMp5HiasqgyJ2lFacnnkLmLZF+5I/6vUV6IHP0y9Hmv+DYlxYzKrVNuecXUZ5Zw6sl16gRl3y9Gh0+kv5qOJcX0lgczSdiZ/5luFTn1bfEcjZyDQFE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=JlqXJ4eP; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="JlqXJ4eP"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C0BCD1F000FF;
	Wed, 30 Sep 2026 18:06:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790791596;
	bh=UoJ8zYCQMfPO5yuh+Cb3BBk6X+2L0pwvZ5CzenQNfSc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=JlqXJ4ePUXdStCws/b0mBx41ulsdGAT6Hkewbct+VIM7Giype96vnwQU2F6SWKmNw
	 xPzU4i/nIOKiExKrAVvrRQrXSi/B7lJQTMw7K6AeVrE1NQtMJjoNhhST6781OOPFYU
	 ZAP4YTuizVC3SwvzlOSMlvpSsWbm1cjEpMZf6SJg=
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
Subject: [PATCH 5.15 321/752] net/sched: ets: clamp quantum in parse and fallback paths
Date: Wed, 30 Sep 2026 17:23:11 +0200
Message-ID: <20260930152405.241347197@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260930152358.131179731@linuxfoundation.org>
References: <20260930152358.131179731@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jamal Hadi Salim <jhs@mojatatu.com>

[ Upstream commit 1c38487f46b243bfeefec0c0c86023a3904f2214 ]

ets_qdisc_change() falls back to psched_mtu() with no floor for bands
without an explicit quantum. With a crafted size table qdisc_pkt_len
reaches ~2 GiB, so a zero psched_mtu on a headerless device makes the
deficit-refill loop spin under the qdisc lock.

Move the floor into ets_quantum_parse() so explicitly configured quanta
are also clamped to [256, 1<<20], not just the fallback path.

Conditions to recreate the bug:
  CONFIG_NET_SCH_ETS=y. Requires CAP_NET_ADMIN (namespace-local via
  unshare -Urn suffices).

  tc qdisc add dev dummy0 root ets bands 3 strict 2 quanta 1 1

Fixes: dcc68b4d8084 ("net: sch_ets: Add a new Qdisc")
Reported-by: Vega <vega@nebusec.ai>
Reviewed-by: Toke Høiland-Jørgensen <toke@redhat.com>
Tested-by: Victor Nogueira <victor@mojatatu.com>
Signed-off-by: Jamal Hadi Salim <jhs@mojatatu.com>
Link: https://patch.msgid.link/QDISC-0CFC.v3.20260901204856@mojatatu.com.9
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/sched/sch_ets.c | 12 +++++-------
 1 file changed, 5 insertions(+), 7 deletions(-)

diff --git a/net/sched/sch_ets.c b/net/sched/sch_ets.c
index 7691eb0e0ea4b..78e2dc9ca4f11 100644
--- a/net/sched/sch_ets.c
+++ b/net/sched/sch_ets.c
@@ -83,11 +83,7 @@ static int ets_quantum_parse(struct Qdisc *sch, const struct nlattr *attr,
 			     unsigned int *quantum,
 			     struct netlink_ext_ack *extack)
 {
-	*quantum = nla_get_u32(attr);
-	if (!*quantum) {
-		NL_SET_ERR_MSG(extack, "ETS quantum cannot be zero");
-		return -EINVAL;
-	}
+	*quantum = clamp_t(u32, nla_get_u32(attr), 256, 1 << 20);
 	return 0;
 }
 
@@ -647,11 +643,13 @@ static int ets_qdisc_change(struct Qdisc *sch, struct nlattr *opt,
 			return err;
 	}
 	/* If there are more bands than strict + quanta provided, the remaining
-	 * ones are ETS with quantum of MTU. Initialize the missing values here.
+	 * ones are ETS with quantum of max(MTU, 256). Initialize the missing
+	 * values here.
 	 */
 	for (i = nstrict; i < nbands; i++) {
 		if (!quanta[i])
-			quanta[i] = psched_mtu(qdisc_dev(sch));
+			quanta[i] = clamp_t(u32, (u32)psched_mtu(qdisc_dev(sch)),
+					    256, 1 << 20);
 	}
 
 	/* Before commit, make sure we can allocate all new qdiscs */
-- 
2.53.0



