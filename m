Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3E87B4F68C4;
	Tue, 13 Oct 2026 12:55:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791896103; cv=none; b=DqYZiBmUMbZt0I7kZ6pnixFFB00FNfkVZu3zUdKQvOwsaBADjMAnFbxDkiprE43rfB/6h1YquJBVh7JhHc/LuoKsmcaVzrf/EJhfX6+mpHj33lInXyA84P+bLfYrnkz8TzjK7r59cx2waZIcY9MB+kIAkGZilX97GH3t4fjANtw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791896103; c=relaxed/simple;
	bh=XiD3uizjQyjJa9JWbZP7HRdT6QyXSTgA3iTnD55Y5us=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=DUcgQxdVNQBqpjl2x9r5JsDT2RMOaF4NcP04ez6xP8Z594EHJSJYdS2vxcCMHEozF9jfYzJk7r0uFnI/6Q/q8uxYSxJww9AshlKh0tNsXcB8nkuzlpLDcb53VsyZi6Fq7pOv0xTC6eONhXWv2MPV6hUcCuLib4XOizUY0JDh0Sw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=HYWspvB2; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="HYWspvB2"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 56B831F00893;
	Tue, 13 Oct 2026 12:55:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1791896101;
	bh=SGLX6CBGZnHg81YMaymG0AsC7qB1pcaQOfhk7yoL5ME=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=HYWspvB2KFyhvMUT7xPOKiZfolwF6yUVnEbfxGC6YxjugDs3+xqFXjs191c0GKTrd
	 HYQVyS8rLA33Amsxa/lPS0Gpj26YFXAlb0B3J/FcfKtzPznTeMj7Xe8OYWzePzMqFe
	 YqNl6dEc8KRScoq+xwGzXPDk0swdawHCJ3v2wna0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Florian Westphal <fw@strlen.de>,
	Adrian Bente <adibente@gmail.com>,
	Pablo Neira Ayuso <pablo@netfilter.org>
Subject: [PATCH 6.12 497/497] netfilter: flowtable: fix offloaded ct timeout never being extended
Date: Tue, 13 Oct 2026 13:41:04 +0200
Message-ID: <20261013112919.671224232@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261013112907.864180619@linuxfoundation.org>
References: <20261013112907.864180619@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Adrian Bente <adibente@gmail.com>

commit 53b3e60edb674b442b2b3bbdba484667b0f47a5d upstream.

OpenWrt has recently migrated many platforms to kernel 6.18. On the
MediaTek platform, which supports hardware network offloading, WiFi
connections accelerated via the WED path were observed to drop after
roughly 300 seconds.

After several debugging sessions, assisted by the Claude LLM, the
problem was narrowed down as follows:

nf_flow_table_extend_ct_timeout() extends ct->timeout for offloaded
flows using:

	cmpxchg(&ct->timeout, expires, new_timeout);

'expires' comes from nf_ct_expires(ct) and is a relative value, while
ct->timeout holds an absolute timestamp. The two are never equal, so
the cmpxchg always fails and the timeout is never extended.

This goes unnoticed for most flows, but a long-lived hardware (WED)
offloaded flow on MediaTek MT7986 eventually has ct->timeout decay to
zero, the conntrack entry is reaped and the connection breaks.

Open-code the relative value from a single READ_ONCE(ct->timeout)
snapshot and compare against that same absolute snapshot in the
cmpxchg, so the timeout extension actually takes effect while the
datapath remains authoritative if it updates ct->timeout concurrently.

Fixes: 03428ca5cee9 ("netfilter: conntrack: rework offload nf_conn timeout extension logic")
Cc: stable@vger.kernel.org
Suggested-by: Florian Westphal <fw@strlen.de>
Signed-off-by: Adrian Bente <adibente@gmail.com>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/netfilter/nf_flow_table_core.c |   13 +++++++++----
 1 file changed, 9 insertions(+), 4 deletions(-)

--- a/net/netfilter/nf_flow_table_core.c
+++ b/net/netfilter/nf_flow_table_core.c
@@ -468,8 +468,13 @@ static u32 nf_flow_table_tcp_timeout(con
  */
 static void nf_flow_table_extend_ct_timeout(struct nf_conn *ct)
 {
-	static const u32 min_timeout = 5 * 60 * HZ;
-	u32 expires = nf_ct_expires(ct);
+	static const s32 min_timeout = 5 * 60 * HZ;
+	u32 ct_timeout = READ_ONCE(ct->timeout);
+	s32 expires;
+
+	expires = ct_timeout - nfct_time_stamp;
+	if (expires <= 0) /* already expired */
+		return;
 
 	/* normal case: large enough timeout, nothing to do. */
 	if (likely(expires >= min_timeout))
@@ -487,7 +492,7 @@ static void nf_flow_table_extend_ct_time
 	if (nf_ct_is_confirmed(ct) &&
 	    test_bit(IPS_OFFLOAD_BIT, &ct->status)) {
 		u8 l4proto = nf_ct_protonum(ct);
-		u32 new_timeout = true;
+		u32 new_timeout = 1;
 
 		switch (l4proto) {
 		case IPPROTO_UDP:
@@ -512,7 +517,7 @@ static void nf_flow_table_extend_ct_time
 		 */
 		if (new_timeout) {
 			new_timeout += nfct_time_stamp;
-			cmpxchg(&ct->timeout, expires, new_timeout);
+			cmpxchg(&ct->timeout, ct_timeout, new_timeout);
 		}
 	}
 


