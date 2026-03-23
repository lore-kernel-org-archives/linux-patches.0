Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0AE3F3AA4FD;
	Mon, 23 Mar 2026 14:11:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774275068; cv=none; b=UViGK4tl+xFxdhw2624i+Ck9Gzg8cXupQSIYd6/JbiRRtEnH1SXJ5SovFdvNeGaT5uvlez3Na3UQSp123jHZnftcl+y2bQHaHCUC6MsKi3QjBmPSL79GLxEonA3Y+jOXTyntA4uO7Vp02XC8Wd3g+rjH5btbPmFrwcbpDtF9fok=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774275068; c=relaxed/simple;
	bh=+FWItamq3sh6sPF5VR5ecF9cySshWJ+EwSUQcRfMilM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=fGRo/ni/digI+oJOeQBnATNB6cud0+vI6Xover2a6l5Oa7HffSmmoNu88Bp0+XsRFrnJrPrmoz/ocLWqhh78XbKlMOp5uc52m9s2yVgrDKyCzZU93lBK6Cze6gnVi9xgPcburlIVOF+H2QNnQkwIOEqqgMk/UgSGzhJiIZJPEHs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=t0kVBdmR; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="t0kVBdmR"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3FE60C4CEF7;
	Mon, 23 Mar 2026 14:11:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1774275067;
	bh=+FWItamq3sh6sPF5VR5ecF9cySshWJ+EwSUQcRfMilM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=t0kVBdmR+SV+AItyK+kD2FgO9t4jkE1e4RcdFAuW8EXJg3arpdl7JmZJ9bvLe72iO
	 iFIPhh06E7ukhIPRLAHJ5vBJBXObX2v2KKm5NWsaxaS4Y8XEdAxW1KM0sFKMAbZXBI
	 d23q0Emx1aV3EvrmfbPaVZKYcPA+seS9U8PZ5RMc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Xiang Mei <xmei5@asu.edu>,
	Weiming Shi <bestswngs@gmail.com>,
	Florian Westphal <fw@strlen.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 173/212] nfnetlink_osf: validate individual option lengths in fingerprints
Date: Mon, 23 Mar 2026 14:46:34 +0100
Message-ID: <20260323134509.235868984@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260323134503.770111826@linuxfoundation.org>
References: <20260323134503.770111826@linuxfoundation.org>
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

From: Weiming Shi <bestswngs@gmail.com>

[ Upstream commit dbdfaae9609629a9569362e3b8f33d0a20fd783c ]

nfnl_osf_add_callback() validates opt_num bounds and string
NUL-termination but does not check individual option length fields.
A zero-length option causes nf_osf_match_one() to enter the option
matching loop even when foptsize sums to zero, which matches packets
with no TCP options where ctx->optp is NULL:

 Oops: general protection fault
 KASAN: null-ptr-deref in range [0x0000000000000000-0x0000000000000007]
 RIP: 0010:nf_osf_match_one (net/netfilter/nfnetlink_osf.c:98)
 Call Trace:
  nf_osf_match (net/netfilter/nfnetlink_osf.c:227)
  xt_osf_match_packet (net/netfilter/xt_osf.c:32)
  ipt_do_table (net/ipv4/netfilter/ip_tables.c:293)
  nf_hook_slow (net/netfilter/core.c:623)
  ip_local_deliver (net/ipv4/ip_input.c:262)
  ip_rcv (net/ipv4/ip_input.c:573)

Additionally, an MSS option (kind=2) with length < 4 causes
out-of-bounds reads when nf_osf_match_one() unconditionally accesses
optp[2] and optp[3] for MSS value extraction.  While RFC 9293
section 3.2 specifies that the MSS option is always exactly 4
bytes (Kind=2, Length=4), the check uses "< 4" rather than
"!= 4" because lengths greater than 4 do not cause memory
safety issues -- the buffer is guaranteed to be at least
foptsize bytes by the ctx->optsize == foptsize check.

Reject fingerprints where any option has zero length, or where an MSS
option has length less than 4, at add time rather than trusting these
values in the packet matching hot path.

Fixes: 11eeef41d5f6 ("netfilter: passive OS fingerprint xtables match")
Reported-by: Xiang Mei <xmei5@asu.edu>
Signed-off-by: Weiming Shi <bestswngs@gmail.com>
Signed-off-by: Florian Westphal <fw@strlen.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/netfilter/nfnetlink_osf.c | 13 +++++++++++++
 1 file changed, 13 insertions(+)

diff --git a/net/netfilter/nfnetlink_osf.c b/net/netfilter/nfnetlink_osf.c
index c0fc431991e88..9fc9544d4bc53 100644
--- a/net/netfilter/nfnetlink_osf.c
+++ b/net/netfilter/nfnetlink_osf.c
@@ -302,7 +302,9 @@ static int nfnl_osf_add_callback(struct sk_buff *skb,
 {
 	struct nf_osf_user_finger *f;
 	struct nf_osf_finger *kf = NULL, *sf;
+	unsigned int tot_opt_len = 0;
 	int err = 0;
+	int i;
 
 	if (!capable(CAP_NET_ADMIN))
 		return -EPERM;
@@ -318,6 +320,17 @@ static int nfnl_osf_add_callback(struct sk_buff *skb,
 	if (f->opt_num > ARRAY_SIZE(f->opt))
 		return -EINVAL;
 
+	for (i = 0; i < f->opt_num; i++) {
+		if (!f->opt[i].length || f->opt[i].length > MAX_IPOPTLEN)
+			return -EINVAL;
+		if (f->opt[i].kind == OSFOPT_MSS && f->opt[i].length < 4)
+			return -EINVAL;
+
+		tot_opt_len += f->opt[i].length;
+		if (tot_opt_len > MAX_IPOPTLEN)
+			return -EINVAL;
+	}
+
 	if (!memchr(f->genre, 0, MAXGENRELEN) ||
 	    !memchr(f->subtype, 0, MAXGENRELEN) ||
 	    !memchr(f->version, 0, MAXGENRELEN))
-- 
2.51.0



