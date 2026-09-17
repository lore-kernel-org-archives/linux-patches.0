Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 17C984D4881;
	Thu, 17 Sep 2026 15:41:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789659683; cv=none; b=jt9nFXaSSJKLXKJ3D2BM3zjqeJCSzsLngDtmBz/ph4IbX3c0qsH3s+NgNRuKFVh8RdYx4NaIngg9zkV1yAPT7HlbjcRBlwhQm1CHDAxhcqDz8B3EodTA/Pzx5DH4TItEwRaAvvJV+uoHjMs+l8jjHNqRDxxKe/avUU4kM7/kQxg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789659683; c=relaxed/simple;
	bh=WZHf9UGBNEbLza0A1zsHcpxHgEBIkEDEz9iKpgCgnm4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=tOZyCtSou7qcZtzsxFCTy4GAus9GXcKKjY3BbiyM4aiGmbKEuicTtECYEqnsYsxumKwdUTMhLkNB/covAXmHzxS1rrp04T0ccpJdupmDw3voEHCGb90P3sT0+fTN4m45O+W/7E8C1S4zvOL9ua3iuSMQ0r8JuSk3uVhPH+iieLc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=prIX4Ujs; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="prIX4Ujs"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 983891F000FF;
	Thu, 17 Sep 2026 15:41:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789659676;
	bh=5pprrffpGCHvQ+oQIVv4rDRTpwuQ4lQ0Q+ZWZJ+dGtg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=prIX4UjsRIV8uxQpWuPxXMbIqIIUOjZINIIW6JTNwVZUkBWFUiVKG6LyelF2qapns
	 cFP+mI/ppnWkndNwklzeewPRDis3bLl8+VBIVrSUwRXYIrZJVPXdJu5N5mRitB/XMU
	 2IfC1eW4CH6hrdHLH5WzelZuImvfQ5SPgXzF/gI4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Zhiling Zou <zhilinz@nebusec.ai>,
	Florian Westphal <fw@strlen.de>,
	Pablo Neira Ayuso <pablo@netfilter.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.2 337/733] netfilter: ip6_tables: set F_PROTO when proto value is nonzero
Date: Thu, 17 Sep 2026 16:10:45 +0100
Message-ID: <20260917151359.934622567@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260917151350.597953846@linuxfoundation.org>
References: <20260917151350.597953846@linuxfoundation.org>
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

7.2-stable review patch.  If anyone has any objections, please let me know.

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
index f42fb96ef64b6..313c4aac377aa 100644
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



