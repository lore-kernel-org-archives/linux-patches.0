Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EC6B9417D7E;
	Thu, 30 Jul 2026 15:07:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785424040; cv=none; b=uhuUBbkDdaEQP6T7BSjkL/2a0Xey9FGYczaE/6idqFqgedY6a9DhGQDfODbgAxH8e+/bcxtOGkvOEmx5Qgvch68biqsMhsDFUAEXB38DrKgFzsWT0flawVV2C5gMc9zlBJNNoYgJRsYyuAkqWzWjlHidj6wf3l4IuySwrF8FxAY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785424040; c=relaxed/simple;
	bh=/Q3BPBzXk+AalGlMHX/aBCikaOpK2diZp5vRCQWrU4o=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=PB62iRYEFT7o4cTFVNIT0CfL7ojxB+ivXveHKBNuiBWvTx8OUETcCU0vt9aTQYd72ci1QhNearsq9T3B7VzhOHp9uBH+f8LzdFXPfiHuXC+TNy3qWb5cwtlCCHcAGB+gpoFR1t7GfClw96YfrxugwvaSBOgz7/LqnoGV9/yY37I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=mSbwgpH8; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="mSbwgpH8"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4CF241F000E9;
	Thu, 30 Jul 2026 15:07:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1785424038;
	bh=ZeblVi/gg9LIOW222sBsdkeyCT0+D3a+thkMBUELveI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=mSbwgpH8Oe3RDhiGqk6UMS8AgBQMZdeNSSmoPpidn/aBQb9Ok60fgeGFZf8MyWyZm
	 0Y/hB/3QanyY9i1uAmKoX8oDgJGBic1vOO7YhChouz/Fxhm//Usxej6vptTdc+JJ3/
	 Wx6Q3disL+QXQCY3azT/M/cNWRF/N596V+fJoR+I=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	AutonomousCodeSecurity@microsoft.com,
	"Xiang Mei (Microsoft)" <xmei5@asu.edu>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 253/675] gtp: check skb_pull_data() return in gtp1u_send_echo_resp()
Date: Thu, 30 Jul 2026 16:09:43 +0200
Message-ID: <20260730141450.515242854@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260730141445.110192266@linuxfoundation.org>
References: <20260730141445.110192266@linuxfoundation.org>
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
index 937d913ce5c334..98614d0b390b8c 100644
--- a/drivers/net/gtp.c
+++ b/drivers/net/gtp.c
@@ -669,8 +669,9 @@ static int gtp1u_send_echo_resp(struct gtp_dev *gtp, struct sk_buff *skb)
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



