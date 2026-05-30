Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6CC72219303;
	Sat, 30 May 2026 18:24:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780165470; cv=none; b=Ke8/55gdRq/wx9/HsGr6y2t9J/ass8GgfDPXE3HfLi4q0IQssfFjwYGrlsrNnpNgGp5Upd07QKuV0SibamWtwzn33GLHEO/91l45VEB01m8PU3lSMnUCCdAyso5ItHe56rRfMiouY7Ghd0KxIQFXKLwp8o7eA0TzWWiDUzrdQfY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780165470; c=relaxed/simple;
	bh=9i397wQPDcq6v3Mh4D90KyoWhqAsAvRaU7rRToxDseA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=tKYUMGlLS9Hh3yb73HaNVyjZ1rjmmcEf7SfqLhatHjUbPL953+8zSoGKYluXU0JaBpqWkotk5gH0LJ4go3MSGLkjoMZHHMYCkrt/bFZJZZKgAmZoZ/pdgMEFIKejAEw++fy0wJmos+gRGEtFG5aj34Lt13pN41CWqqnMGWPi5X8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=uC8Rm7YZ; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="uC8Rm7YZ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AC59E1F00893;
	Sat, 30 May 2026 18:24:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1780165469;
	bh=F8TcH6DzrfjhwYvvXgUl4KheEoNYXbW2elaUM1WdNqs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=uC8Rm7YZjOYi7RuUxhFWmiXsAPZyKHx8lmnWVLp06ELRWVMgyyBZqHUOQ+OVuCsTW
	 vC+hszzL/klBIlXFDV5nrHJSz5ERyeEVzuS2JChQoRfuOBe4VfBTFSlpPYx9JmjU77
	 rGuUBPN90zrdouPtEO/2IwgwyArZQA557PBFlSxk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Florian Westphal <fw@strlen.de>,
	Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>,
	"David S. Miller" <davem@davemloft.net>,
	Vasiliy Kovalev <kovalev@altlinux.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 087/589] net/sched: act_ct: fix ref leak when switching zones
Date: Sat, 30 May 2026 17:59:28 +0200
Message-ID: <20260530160226.957792863@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260530160224.570625122@linuxfoundation.org>
References: <20260530160224.570625122@linuxfoundation.org>
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

From: Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>

commit bcb74e132a76ce0502bb33d5b65533a4ed72d159 upstream.

When switching zones or network namespaces without doing a ct clear in
between, it is now leaking a reference to the old ct entry. That's
because tcf_ct_skb_nfct_cached() returns false and
tcf_ct_flow_table_lookup() may simply overwrite it.

The fix is to, as the ct entry is not reusable, free it already at
tcf_ct_skb_nfct_cached().

Reported-by: Florian Westphal <fw@strlen.de>
Fixes: 2f131de361f6 ("net/sched: act_ct: Fix flow table lookup after ct clear or switching zones")
Signed-off-by: Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
[ kovalev: bp to fix CVE-2022-49183; used nf_conntrack_put(&ct->ct_general)
  instead of nf_ct_put(ct) due to the older kernel not yet having the
  conversion from the indirect call (see upstream commit 408bdcfce8df) ]
Signed-off-by: Vasiliy Kovalev <kovalev@altlinux.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/sched/act_ct.c | 15 +++++++++------
 1 file changed, 9 insertions(+), 6 deletions(-)

diff --git a/net/sched/act_ct.c b/net/sched/act_ct.c
index d9748c917a503..d75f4b2b97daa 100644
--- a/net/sched/act_ct.c
+++ b/net/sched/act_ct.c
@@ -589,22 +589,25 @@ static bool tcf_ct_skb_nfct_cached(struct net *net, struct sk_buff *skb,
 	if (!ct)
 		return false;
 	if (!net_eq(net, read_pnet(&ct->ct_net)))
-		return false;
+		goto drop_ct;
 	if (nf_ct_zone(ct)->id != zone_id)
-		return false;
+		goto drop_ct;
 
 	/* Force conntrack entry direction. */
 	if (force && CTINFO2DIR(ctinfo) != IP_CT_DIR_ORIGINAL) {
 		if (nf_ct_is_confirmed(ct))
 			nf_ct_kill(ct);
 
-		nf_conntrack_put(&ct->ct_general);
-		nf_ct_set(skb, NULL, IP_CT_UNTRACKED);
-
-		return false;
+		goto drop_ct;
 	}
 
 	return true;
+
+drop_ct:
+	nf_conntrack_put(&ct->ct_general);
+	nf_ct_set(skb, NULL, IP_CT_UNTRACKED);
+
+	return false;
 }
 
 /* Trim the skb to the length specified by the IP/IPv6 header,
-- 
2.53.0



