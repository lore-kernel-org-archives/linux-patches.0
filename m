Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 918C33ACEFE;
	Mon, 20 Apr 2026 13:32:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776691978; cv=none; b=ezyUh7LPXrx80tpZ4x4+qVjCxMSKDbBWJTCXFDTDgn0oho/i1axdJykbKnLrKLoN2QUnQgcdA9PwOOzQjXp6w9n7KHMjME7v62ugqr9LCcpGBCMMRt2tiKSvZAfH/BzqHG312kQijsZpmlcfTKjI7vcx0uiQzwlPB/ztHe/q6BE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776691978; c=relaxed/simple;
	bh=ttQ8PnNXHOtrHcw+2MBiuWE0BJAaVmcJQ5d7CZvwKJY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=t4vI29FQ6+nKle2pSt3NZUwyLQ2gg9wtaRKQo8uHmu/KwtCcFtjJLBns+LuM/S3qQTtyl8a9QGkLagKIfS+ELDGu935ZjWRnfPU8D0zDbdcw5nuQK0UGWloXGDouY0YBAY5mqH0aPIPQ5PSk3tkAMSUG3uh/CZFcOzo5XOWcUN8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=otaEeozZ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="otaEeozZ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 21CB4C19425;
	Mon, 20 Apr 2026 13:32:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1776691978;
	bh=ttQ8PnNXHOtrHcw+2MBiuWE0BJAaVmcJQ5d7CZvwKJY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=otaEeozZ7lD3Vvuscru43KchNQR0JYEHw0UICQpcbb85qtL0jh6w5MoBSFhuSn4ZC
	 7ksaxKYORptncDKTOFZB7NN1z7ItKpmbFNuRJ+qhrVg6fc36wQqPeoz4sFuOoEm3wP
	 6vCcj9vbs2g772TUvUH+PgKe2TMQiooku7C6zPg9j6Y8LXKPg8IVjJdS6x0kXG53ii
	 z0qcR7Nm+Ui+SXgm76ECwQPuXJR6F49tdzuFSUnsSyWHsEKXDB3/FsO7y5HyTLstRj
	 gi9Ys3nMqJfmdxUOFSnTighwsrB2gmWfbafXJSHhDcJSRjI3X7tkOg/JNbKDibbXoJ
	 Ob+Eaifa+KHLw==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Yiqi Sun <sunyiqixm@gmail.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>,
	davem@davemloft.net,
	dsahern@kernel.org,
	edumazet@google.com,
	pabeni@redhat.com,
	andreas.a.roeseler@gmail.com,
	netdev@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH AUTOSEL 6.18] ipv4: icmp: fix null-ptr-deref in icmp_build_probe()
Date: Mon, 20 Apr 2026 09:21:36 -0400
Message-ID: <20260420132314.1023554-302-sashal@kernel.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260420132314.1023554-1-sashal@kernel.org>
References: <20260420132314.1023554-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
X-stable-base: Linux 6.18.23
Content-Transfer-Encoding: 8bit

From: Yiqi Sun <sunyiqixm@gmail.com>

[ Upstream commit fde29fd9349327acc50d19a0b5f3d5a6c964dfd8 ]

ipv6_stub->ipv6_dev_find() may return ERR_PTR(-EAFNOSUPPORT) when the
IPv6 stack is not active (CONFIG_IPV6=m and not loaded), and passing
this error pointer to dev_hold() will cause a kernel crash with
null-ptr-deref.

Instead, silently discard the request. RFC 8335 does not appear to
define a specific response for the case where an IPv6 interface
identifier is syntactically valid but the implementation cannot perform
the lookup at runtime, and silently dropping the request may safer than
misreporting "No Such Interface".

Fixes: d329ea5bd884 ("icmp: add response to RFC 8335 PROBE messages")
Signed-off-by: Yiqi Sun <sunyiqixm@gmail.com>
Link: https://patch.msgid.link/20260402070419.2291578-1-sunyiqixm@gmail.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---

LLM Generated explanations, may be completely bogus:

Error: Failed to generate final synthesis

 net/ipv4/icmp.c | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/net/ipv4/icmp.c b/net/ipv4/icmp.c
index b39176b620785..980aa17f3534d 100644
--- a/net/ipv4/icmp.c
+++ b/net/ipv4/icmp.c
@@ -1145,6 +1145,13 @@ bool icmp_build_probe(struct sk_buff *skb, struct icmphdr *icmphdr)
 			if (iio->ident.addr.ctype3_hdr.addrlen != sizeof(struct in6_addr))
 				goto send_mal_query;
 			dev = ipv6_stub->ipv6_dev_find(net, &iio->ident.addr.ip_addr.ipv6_addr, dev);
+			/*
+			 * If IPv6 identifier lookup is unavailable, silently
+			 * discard the request instead of misreporting NO_IF.
+			 */
+			if (IS_ERR(dev))
+				return false;
+
 			dev_hold(dev);
 			break;
 #endif
-- 
2.53.0

