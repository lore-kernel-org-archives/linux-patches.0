Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795705166;
	b=qcMEIk5XjcQRc/cATr2YhJhw+j+/nckYavFXFCjZctScPRUGDOM6OsIWFjfOfjo/pA7/
	 61BZc74lRuAYgK7DRi6FKv8bUt4OP1JUY0a6Uk2yDlIgbqE/DXA9TFi28dsNd5klbU79X
	 867NAX8AFpl1ePcpWsVos+Rs5vACbMfcbEMlJqEJBGvjPBTgqRAqiS+cVLcKj/2IiL7oy
	 6xQZF3geEaoNYLVALRsng66T5sgsnzqugQy+N/y7HA8Ty0Oa/0eqM0NyQDiK3E24VESM+
	 2ab97ApiMGbGtfyes1XHFWRUWSBFTo8+mQX8Hoh31CIPSYd/tD6USK4RsEE/mAY6jSQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795705166;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=vbL3L6FN0ZsZpMZd0Gcy7jgzosa9gpVPD3VOvY9alak=;
	b=kaI9We7AcprM6TKG7AVs1HYymznpCTXiMRXz/uivccd4N8tpVdf14HhP+MOH7pANzV2T
	 S6U0OgLwa6UR2YHEiuX9C8ZY5edgIafPWSILfKRKINLgCVdYHyfg1KHY+4hmWbORjkgiu
	 bIUaDcAqfKamWQhMAoDTcbmjx9kqg8naKvASunhE1ZHAowWlDjphxV5dvuAhogHVFFSRM
	 nZfeybhj8faCJ7LxX7X0hSqUVKwfLApC9gjhekzjPl2b0wUGuIGj3HbGbJvZwLb8VMRk6
	 0bMhDjEE66TA+xaqAdxjdTskxBYdsl5e4DSWCcxDJgCJAQW3MUbuk+0a8oqq9COdSTQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=fle9Fwz0;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9A0EB606A31E;
	Thu, 26 Nov 2026 14:59:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=fle9Fwz0
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C05551F000C4;
	Thu, 26 Nov 2026 14:59:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795705166;
	bh=vbL3L6FN0ZsZpMZd0Gcy7jgzosa9gpVPD3VOvY9alak=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=fle9Fwz0ctDAbf+CpeJlK3WIY2sRs3lUS7Gq6gWqMVvcAKg6hCIwzxJZ6nblxTT9Q
	 xLiR2NZ19wT5gApinYxz9H1SeYa5PcB6rL/lFklcu+3lpaQM1aw7qhBhQGaGfQO0DP
	 saLJnzxBNsfkoHhCWnRlNXF4i6WFPvOMANkR9uCo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Joas Antonio dos Santos <joasantonio108@gmail.com>,
	Fernando Fernandez Mancera <fmancera@suse.de>,
	Pablo Neira Ayuso <pablo@netfilter.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 105/319] netfilter: nf_conntrack_sip: fix OOB read in ct_sip_parse_transport()
Date: Thu, 26 Nov 2026 15:37:53 +0100
Message-ID: <20261126144009.113943773@linuxfoundation.org>
X-Mailer: git-send-email 2.56.1
In-Reply-To: <20261126144006.732901931@linuxfoundation.org>
References: <20261126144006.732901931@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Joas Antonio dos Santos <joasantonio108@gmail.com>

[ Upstream commit 7af52bda65c0bbbf40894aa3df36ac1bb5697984 ]

ct_sip_parse_transport() compares the value of the "transport=" header
parameter against "TCP"/"UDP" with strncasecmp(..., 3), but it never
checks that the parsed value is at least 3 bytes long.

ct_sip_parse_param() returns matchlen = end - start, where end is the
next ';' or, when there is no ';', the end of the payload buffer
(limit = dptr + datalen).  If the "transport=" value is only 1 or 2
bytes long and runs exactly to the end of the payload (e.g. a REGISTER
request whose Contact header ends in ";transport=T" with no trailing
CRLF), matchlen is less than 3 while strncasecmp() still reads up to 3
bytes, reading 1-2 bytes past the end of the linearized skb data.

Add a matchlen check before the comparison, mirroring the
sdp_media_type() pattern a few lines below, so short values cannot reach
strncasecmp().

The bug was found by LLM-assisted manual review of the SIP helper's
parsers and confirmed with a userspace ASan harness built from the
verbatim parser functions, which reports a heap-buffer-overflow read of
size 2 in strncasecmp() called from ct_sip_parse_transport().

Fixes: ea45f12a2766d ("[NETFILTER]: nf_conntrack_sip: parse SIP headers properly")
Link: https://patch.msgid.link/20260815133104.50369-1-joasantonio108@gmail.com/
Signed-off-by: Joas Antonio dos Santos <joasantonio108@gmail.com>
Assisted-by: Claude:claude-opus-5-5
Reviewed-by: Fernando Fernandez Mancera <fmancera@suse.de>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/netfilter/nf_conntrack_sip.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/net/netfilter/nf_conntrack_sip.c b/net/netfilter/nf_conntrack_sip.c
index 44b21e1802412..2ba47c1a60181 100644
--- a/net/netfilter/nf_conntrack_sip.c
+++ b/net/netfilter/nf_conntrack_sip.c
@@ -707,9 +707,9 @@ static int ct_sip_parse_transport(struct nf_conn *ct, const char *dptr,
 
 	if (ct_sip_parse_param(ct, dptr, dataoff, datalen, "transport=",
 			       &matchoff, &matchlen)) {
-		if (!strncasecmp(dptr + matchoff, "TCP", strlen("TCP")))
+		if (matchlen >= 3 && !strncasecmp(dptr + matchoff, "TCP", 3))
 			*proto = IPPROTO_TCP;
-		else if (!strncasecmp(dptr + matchoff, "UDP", strlen("UDP")))
+		else if (matchlen >= 3 && !strncasecmp(dptr + matchoff, "UDP", 3))
 			*proto = IPPROTO_UDP;
 		else
 			return 0;
-- 
2.53.0



