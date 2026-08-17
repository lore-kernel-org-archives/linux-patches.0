Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C038E3F5BEF;
	Mon, 17 Aug 2026 15:06:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786979195; cv=none; b=k0EL3XBNo6m6d6lcFpubyZNlaxWjx0eGSEM9TDEJvJOFxkNUK/pwtTCQcKlYf1V/Xw1jEsLATWxEciB83k7Og6R3JfSbd3jNKZSaKNeEcHnIV/bJYsH75oceN1xKPPy6ohyNcQ2hTg/hnZTDxk6COfgpY7GJsdZTKLPQes7KifA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786979195; c=relaxed/simple;
	bh=AfyeMCytIt/R3//JKxOaMdX1uqFsFgChes/Tx1YVEd0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Xw+ogzsFiNH3TinKTjhqAAmuOgnZB4ID6nptCezcfa/sew/Q/IKWSmoV0/UlH7E1MeAaa6Mu9QT+xI/0TloidACzoxtLQyKDS1AvCoUSiYmoUbdqeRGb6FEbwP0dd0SGPtw/b9qpWuGxxXq9YcdomwgmihmWqoA9+o4+Tw9QljY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=uW9zXaxz; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="uW9zXaxz"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 261F11F000E9;
	Mon, 17 Aug 2026 15:06:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1786979194;
	bh=khLZE041hKON3PVhqPHACMh6WcshBDB61jDzFCwHkLk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=uW9zXaxzYYAhsTtQiILT9C3/x9fFAOh/hTMjMM8FhXEM1kEOHc0ZIK0GSQpO/ZyE+
	 Zrpi9REnqrOvvQK6r9UNYGg11EJu3U9pIuYoRcVhZElXZbh2FcQjyXosG5tpI1iMmD
	 94kpkeGUTS1Q90EY2iIyYt/7hGbygq9zFDnANXbQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	AutonomousCodeSecurity@microsoft.com,
	"Xiang Mei (Microsoft)" <xmei5@asu.edu>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 140/609] gtp: check skb_pull_data() return in gtp1u_send_echo_resp()
Date: Mon, 17 Aug 2026 15:27:16 +0200
Message-ID: <20260817132548.678371378@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260817132543.039278408@linuxfoundation.org>
References: <20260817132543.039278408@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
index 797886f10868af..59c9bd459b2fb5 100644
--- a/drivers/net/gtp.c
+++ b/drivers/net/gtp.c
@@ -489,8 +489,9 @@ static int gtp1u_send_echo_resp(struct gtp_dev *gtp, struct sk_buff *skb)
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



