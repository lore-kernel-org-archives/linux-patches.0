Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1B0DC4FC35A;
	Thu, 17 Sep 2026 17:24:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789665879; cv=none; b=d+KEURNVTcYpNPJnktdyXYIuL7rCglO6R5fL7JCQUUU1aJubuvbQus2QLiCZZ0U9CZc0d/s5d/LQHMlJazdEDqcO4P2pJpxTSjPUCyp1q3x84CjSMOmaUHRw6QNY/GDHTx8oqsdyCUnNtL8ybLo3ycZW7BbcoVKEHk0oaG16Ipo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789665879; c=relaxed/simple;
	bh=lYX3ppBaIb9YZ06XtwWvP1rQTlfEfMdHSpbcxHs2Ry4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Er8u0IIwJ5jLhTmD35QoUtj5XPzRLLq9U1SoPeRXF/zrEU0Z9WxiW9/pc7rxT+rAma7kdSM02t1Zjl4cpGj0CltEMVYKp0ZVmlTOX6UPYIDYlzOzyovZv74IzlPCPhOoEUyhhF6w8T4c9TVrAT5oBDNoWyUJ+kLr14XGcV4GO7g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=qn6EoX8z; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="qn6EoX8z"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 72EAF1F000FF;
	Thu, 17 Sep 2026 17:24:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789665878;
	bh=E7AWviYvZVfRiTRiAa5qNLo5cpcBKpo+lKNlJBfMcjY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=qn6EoX8zmXMlx6SzRIYbQRzbBOMYuFOM5UCjUJJBmlzaLhr9XW/u3NfaZGKeR7cTu
	 BgLlrAIispmdb2/nTdVdE8P5gL2D19lHQ5BQeYf1aMY1jhNT/3L4Crk7d7oXdjT3O1
	 E3egaArArGJYJbxE4/yosmzw1ahF8h/3y2UUy+c0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Zhiling Zou <zhilinz@nebusec.ai>,
	Florian Westphal <fw@strlen.de>,
	Pablo Neira Ayuso <pablo@netfilter.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0849/1250] netfilter: ip6_tables: set F_PROTO when proto value is nonzero
Date: Thu, 17 Sep 2026 16:10:44 +0100
Message-ID: <20260917151614.973593661@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260917151551.901433442@linuxfoundation.org>
References: <20260917151551.901433442@linuxfoundation.org>
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

From: Florian Westphal <fw@strlen.de>

[ Upstream commit da4afc5a956d407443988e97a4d4ca14c2e999c7 ]

The ip6tables traverser doesn't search the extension header chain unless
userspace did set the IP6T_F_PROTO flag.

This also means that userspace that sets the e->ipv6.proto flag can bypass
the protocol check for the rule by not setting this flag.

That in turn means that all ip6_tables modules and targets that want to
reject rules without '-p' flag MUST also check for that flag.

Not all do, likely because they got copied from iptables which lacks
this flag (no extension headers).

Instead of fixing up all the relevant targets, emulate ip6tables behaviour
in the kernel (like nft_compat.c) and set the flag if the protocol is set.

Reported-by: Zhiling Zou <zhilinz@nebusec.ai>
Fixes: 1da177e4c3f4 ("Linux-2.6.12-rc2")
Signed-off-by: Florian Westphal <fw@strlen.de>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/ipv6/netfilter/ip6_tables.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/net/ipv6/netfilter/ip6_tables.c b/net/ipv6/netfilter/ip6_tables.c
index 3586e636c66bd..7efc2a19662f9 100644
--- a/net/ipv6/netfilter/ip6_tables.c
+++ b/net/ipv6/netfilter/ip6_tables.c
@@ -647,6 +647,11 @@ check_entry_size_and_hooks(struct ip6t_entry *e,
 	/* Clear counters and comefrom */
 	e->counters = ((struct xt_counters) { 0, 0 });
 	e->comefrom = 0;
+
+	/* set F_PROTO, else ip6_packet_match won't do the right thing. */
+	if (e->ipv6.proto)
+		e->ipv6.flags |= IP6T_F_PROTO;
+
 	return 0;
 }
 
-- 
2.53.0



