Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E5D7A3AEF3F;
	Mon, 23 Mar 2026 14:11:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774275097; cv=none; b=XHQCxfoun/saB1UMWDn4UGNfqr32wq4swawcyqkUIPJNT7O7QDFU5Ezr7JN3nULWrWwrEWLpnThmDQRMqBGnNeZrcVJE5Y77s8Rl9XWjnxgkgGWhyX75Jbhosqei1+Lhctg2Y9m6qmYMH0P/F3CFde2UfzSpa5Nue0jRQ/Y5dDo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774275097; c=relaxed/simple;
	bh=B03wMRCPlUhGmcXaCtV8TNDZHxpwWXDDhE/zdQGzBMc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=fmW7SKWgmmas+qEwQ42Q9yLeQqlWPamrC17C+EZpHpRIeXwc1jeLLfzC8ajrgVsn6xTxqsahbL/tJFOh8NMWyS75QUaEzMopBQU5+wmAZBOS2dOLq3cGOOA/s5vMXuoULCPSeGfzW9Fgsg8pzBn2vpCgh0SJPXwW5u0ohEcM5e4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=nhW+AlV8; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="nhW+AlV8"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 76802C4CEF7;
	Mon, 23 Mar 2026 14:11:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1774275096;
	bh=B03wMRCPlUhGmcXaCtV8TNDZHxpwWXDDhE/zdQGzBMc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=nhW+AlV8Aw2+3M+CgtR2tdcR/wxdPOAWSQPqzw9tpDwCRxvs8us8khuSzmog+zUB/
	 DLl2fHgZffxG2tbnBNN1+38zU9h4a6CrXXevTjwoZwpmhvQ8mFNtpYjaz+Cep3zVDY
	 i1t1skK00urwsn8eFelB52Fu/+PhzU91pbyYn/3o=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Xiang Mei <xmei5@asu.edu>,
	Weiming Shi <bestswngs@gmail.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 178/212] icmp: fix NULL pointer dereference in icmp_tag_validation()
Date: Mon, 23 Mar 2026 14:46:39 +0100
Message-ID: <20260323134509.384002700@linuxfoundation.org>
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

[ Upstream commit 614aefe56af8e13331e50220c936fc0689cf5675 ]

icmp_tag_validation() unconditionally dereferences the result of
rcu_dereference(inet_protos[proto]) without checking for NULL.
The inet_protos[] array is sparse -- only about 15 of 256 protocol
numbers have registered handlers. When ip_no_pmtu_disc is set to 3
(hardened PMTU mode) and the kernel receives an ICMP Fragmentation
Needed error with a quoted inner IP header containing an unregistered
protocol number, the NULL dereference causes a kernel panic in
softirq context.

 Oops: general protection fault, probably for non-canonical address 0xdffffc0000000002: 0000 [#1] SMP KASAN NOPTI
 KASAN: null-ptr-deref in range [0x0000000000000010-0x0000000000000017]
 RIP: 0010:icmp_unreach (net/ipv4/icmp.c:1085 net/ipv4/icmp.c:1143)
 Call Trace:
  <IRQ>
  icmp_rcv (net/ipv4/icmp.c:1527)
  ip_protocol_deliver_rcu (net/ipv4/ip_input.c:207)
  ip_local_deliver_finish (net/ipv4/ip_input.c:242)
  ip_local_deliver (net/ipv4/ip_input.c:262)
  ip_rcv (net/ipv4/ip_input.c:573)
  __netif_receive_skb_one_core (net/core/dev.c:6164)
  process_backlog (net/core/dev.c:6628)
  handle_softirqs (kernel/softirq.c:561)
  </IRQ>

Add a NULL check before accessing icmp_strict_tag_validation. If the
protocol has no registered handler, return false since it cannot
perform strict tag validation.

Fixes: 8ed1dc44d3e9 ("ipv4: introduce hardened ip_no_pmtu_disc mode")
Reported-by: Xiang Mei <xmei5@asu.edu>
Signed-off-by: Weiming Shi <bestswngs@gmail.com>
Link: https://patch.msgid.link/20260318130558.1050247-4-bestswngs@gmail.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/ipv4/icmp.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/net/ipv4/icmp.c b/net/ipv4/icmp.c
index 3e19a5d465b83..b39176b620785 100644
--- a/net/ipv4/icmp.c
+++ b/net/ipv4/icmp.c
@@ -879,10 +879,12 @@ static void icmp_socket_deliver(struct sk_buff *skb, u32 info)
 
 static bool icmp_tag_validation(int proto)
 {
+	const struct net_protocol *ipprot;
 	bool ok;
 
 	rcu_read_lock();
-	ok = rcu_dereference(inet_protos[proto])->icmp_strict_tag_validation;
+	ipprot = rcu_dereference(inet_protos[proto]);
+	ok = ipprot ? ipprot->icmp_strict_tag_validation : false;
 	rcu_read_unlock();
 	return ok;
 }
-- 
2.51.0



