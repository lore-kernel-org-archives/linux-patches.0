Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 72E0245FFB6;
	Thu, 30 Jul 2026 16:04:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785427446; cv=none; b=oyFDLiz5l6LRSKckMkfQ9bPMfKiZ0Uijl3DdYA5huv3biO7F3Kg4JMqiL0lUPL6q6wNV4fZiBpfBZxyvY0Skv0qpBg7fxbHYJ7LmemcaVtqlNgB28Yj+gGImo4js5brAVsN6hxDcpvCh5uHEQmLWhGwwhBoZsuTwcRCzIrgQkkQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785427446; c=relaxed/simple;
	bh=fwSmDoGgW1QCBuEcO0nv2Tk37LpgMiGBrVWWA3xp31M=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=fFi3fZHNzHv9sFtaO4nso7DjACvgvJ36wY2VSbbYzG1OL4CO9v95vPYRtahsxLc2wqfOiJGA+84GDJHXzPk2K1QMOada9v9M3DkNnbkSm3BpkVKRVLkEbAsXPP+Th09tyn72m2UPtrPF4lMVAfCtZk5g30Mj0HW0PFNSqrN96I8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=LPrP1JBZ; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="LPrP1JBZ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BCD251F00A3A;
	Thu, 30 Jul 2026 16:04:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1785427445;
	bh=gQQi/YfeFU9AlS3WRO1pKb9nDM/rmcGcOJ7e5cjWW+g=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=LPrP1JBZFrlVNEs5lJ+kULjhZaFUFtiXdzmJ2ZtyHAw1RRLFvyKarQO39n2+ld9pQ
	 BEOm2AnPbgcR7glV0+ie/eppFuvpuybBbG7OJpHeg+tzVFURFhz/7SrS5dRc7whteN
	 fN5aELJc9wnoV+2RZVdJlIIVnL51X1gr6VxYCoIk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	AutonomousCodeSecurity@microsoft.com,
	"Xiang Mei (Microsoft)" <xmei5@asu.edu>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 171/484] gtp: check skb_pull_data() return in gtp1u_send_echo_resp()
Date: Thu, 30 Jul 2026 16:11:08 +0200
Message-ID: <20260730141427.183487506@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260730141423.392222816@linuxfoundation.org>
References: <20260730141423.392222816@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Xiang Mei (Microsoft) <xmei5@asu.edu>

[ Upstream commit cd170f051dba9ac146fabcd1b91726487c0cb9fa ]

gtp1u_send_echo_resp() ignores skb_pull_data()'s return value. Its
caller gtp1u_udp_encap_recv() only guarantees 16 bytes (udphdr +
gtp1_header), but the pull requests 20 (gtp1_header_long + udphdr). For
a 16-19 byte echo request the pull fails and returns NULL without
advancing skb->data; execution continues, and the following skb_push()
plus the IP header pushed by iptunnel_xmit() move skb->data below
skb->head, tripping skb_under_panic().

Fix it by dropping the packet when skb_pull_data() fails.

  skbuff: skb_under_panic: ...
  kernel BUG at net/core/skbuff.c:214!
  Call Trace:
   skb_push (net/core/skbuff.c:2648)
   iptunnel_xmit (net/ipv4/ip_tunnel_core.c:82)
   gtp_encap_recv (drivers/net/gtp.c:701 drivers/net/gtp.c:808 drivers/net/gtp.c:920)
   udp_queue_rcv_one_skb (net/ipv4/udp.c:2388)
   ...
  Kernel panic - not syncing: Fatal exception in interrupt

Fixes: 9af41cc33471 ("gtp: Implement GTP echo response")
Reported-by: AutonomousCodeSecurity@microsoft.com
Signed-off-by: Xiang Mei (Microsoft) <xmei5@asu.edu>
Link: https://patch.msgid.link/20260710230724.942574-1-xmei5@asu.edu
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/gtp.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/drivers/net/gtp.c b/drivers/net/gtp.c
index 55160a5fc90fc6..7bb3da8f253635 100644
--- a/drivers/net/gtp.c
+++ b/drivers/net/gtp.c
@@ -490,8 +490,9 @@ static int gtp1u_send_echo_resp(struct gtp_dev *gtp, struct sk_buff *skb)
 		return -1;
 
 	/* pull GTP and UDP headers */
-	skb_pull_data(skb,
-		      sizeof(struct gtp1_header_long) + sizeof(struct udphdr));
+	if (!skb_pull_data(skb, sizeof(struct gtp1_header_long) +
+				sizeof(struct udphdr)))
+		return -1;
 
 	gtp_pkt = skb_push(skb, sizeof(struct gtp1u_packet));
 	memset(gtp_pkt, 0, sizeof(struct gtp1u_packet));
-- 
2.53.0



