Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B407B1A71F
	for <patches@lists.linux.dev>; Mon,  9 Oct 2023 13:33:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="boOvK0nj"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2EAC7C433C9;
	Mon,  9 Oct 2023 13:33:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1696858410;
	bh=hPDP4fHUh5LyK41cQnoZn9s6RWcDfpx/tDkTwdoIXPI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=boOvK0njhBcf5WwIRBI6LlTzwWgCkiE9bHiUrsQmCLKT4I0kIvqW/9Kcao+rynr28
	 xWYTbSLLV2AejlWDGuQm2i5+rGOgt00pGCmFHFRInSd+uZHR6jgghudePUe90OH7cJ
	 k5M7udHpe/AhFmDIgd9JNmdYAoky1RrxJ/dIBIPU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Xin Long <lucien.xin@gmail.com>,
	Florian Westphal <fw@strlen.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 114/131] netfilter: handle the connecting collision properly in nf_conntrack_proto_sctp
Date: Mon,  9 Oct 2023 15:02:34 +0200
Message-ID: <20231009130119.922993693@linuxfoundation.org>
X-Mailer: git-send-email 2.42.0
In-Reply-To: <20231009130116.329529591@linuxfoundation.org>
References: <20231009130116.329529591@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

5.4-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Xin Long <lucien.xin@gmail.com>

[ Upstream commit 8e56b063c86569e51eed1c5681ce6361fa97fc7a ]

In Scenario A and B below, as the delayed INIT_ACK always changes the peer
vtag, SCTP ct with the incorrect vtag may cause packet loss.

Scenario A: INIT_ACK is delayed until the peer receives its own INIT_ACK

  192.168.1.2 > 192.168.1.1: [INIT] [init tag: 1328086772]
    192.168.1.1 > 192.168.1.2: [INIT] [init tag: 1414468151]
    192.168.1.2 > 192.168.1.1: [INIT ACK] [init tag: 1328086772]
  192.168.1.1 > 192.168.1.2: [INIT ACK] [init tag: 1650211246] *
  192.168.1.2 > 192.168.1.1: [COOKIE ECHO]
    192.168.1.1 > 192.168.1.2: [COOKIE ECHO]
    192.168.1.2 > 192.168.1.1: [COOKIE ACK]

Scenario B: INIT_ACK is delayed until the peer completes its own handshake

  192.168.1.2 > 192.168.1.1: sctp (1) [INIT] [init tag: 3922216408]
    192.168.1.1 > 192.168.1.2: sctp (1) [INIT] [init tag: 144230885]
    192.168.1.2 > 192.168.1.1: sctp (1) [INIT ACK] [init tag: 3922216408]
    192.168.1.1 > 192.168.1.2: sctp (1) [COOKIE ECHO]
    192.168.1.2 > 192.168.1.1: sctp (1) [COOKIE ACK]
  192.168.1.1 > 192.168.1.2: sctp (1) [INIT ACK] [init tag: 3914796021] *

This patch fixes it as below:

In SCTP_CID_INIT processing:
- clear ct->proto.sctp.init[!dir] if ct->proto.sctp.init[dir] &&
  ct->proto.sctp.init[!dir]. (Scenario E)
- set ct->proto.sctp.init[dir].

In SCTP_CID_INIT_ACK processing:
- drop it if !ct->proto.sctp.init[!dir] && ct->proto.sctp.vtag[!dir] &&
  ct->proto.sctp.vtag[!dir] != ih->init_tag. (Scenario B, Scenario C)
- drop it if ct->proto.sctp.init[dir] && ct->proto.sctp.init[!dir] &&
  ct->proto.sctp.vtag[!dir] != ih->init_tag. (Scenario A)

In SCTP_CID_COOKIE_ACK processing:
- clear ct->proto.sctp.init[dir] and ct->proto.sctp.init[!dir].
  (Scenario D)

Also, it's important to allow the ct state to move forward with cookie_echo
and cookie_ack from the opposite dir for the collision scenarios.

There are also other Scenarios where it should allow the packet through,
addressed by the processing above:

Scenario C: new CT is created by INIT_ACK.

Scenario D: start INIT on the existing ESTABLISHED ct.

Scenario E: start INIT after the old collision on the existing ESTABLISHED
ct.

  192.168.1.2 > 192.168.1.1: sctp (1) [INIT] [init tag: 3922216408]
  192.168.1.1 > 192.168.1.2: sctp (1) [INIT] [init tag: 144230885]
  (both side are stopped, then start new connection again in hours)
  192.168.1.2 > 192.168.1.1: sctp (1) [INIT] [init tag: 242308742]

Fixes: 9fb9cbb1082d ("[NETFILTER]: Add nf_conntrack subsystem.")
Signed-off-by: Xin Long <lucien.xin@gmail.com>
Signed-off-by: Florian Westphal <fw@strlen.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/linux/netfilter/nf_conntrack_sctp.h |  1 +
 net/netfilter/nf_conntrack_proto_sctp.c     | 43 ++++++++++++++++-----
 2 files changed, 34 insertions(+), 10 deletions(-)

diff --git a/include/linux/netfilter/nf_conntrack_sctp.h b/include/linux/netfilter/nf_conntrack_sctp.h
index 625f491b95de8..fb31312825ae5 100644
--- a/include/linux/netfilter/nf_conntrack_sctp.h
+++ b/include/linux/netfilter/nf_conntrack_sctp.h
@@ -9,6 +9,7 @@ struct ip_ct_sctp {
 	enum sctp_conntrack state;
 
 	__be32 vtag[IP_CT_DIR_MAX];
+	u8 init[IP_CT_DIR_MAX];
 	u8 last_dir;
 	u8 flags;
 };
diff --git a/net/netfilter/nf_conntrack_proto_sctp.c b/net/netfilter/nf_conntrack_proto_sctp.c
index 21cbaf6dac331..e7545bcca805e 100644
--- a/net/netfilter/nf_conntrack_proto_sctp.c
+++ b/net/netfilter/nf_conntrack_proto_sctp.c
@@ -112,7 +112,7 @@ static const u8 sctp_conntracks[2][11][SCTP_CONNTRACK_MAX] = {
 /* shutdown_ack */ {sSA, sCL, sCW, sCE, sES, sSA, sSA, sSA, sSA},
 /* error        */ {sCL, sCL, sCW, sCE, sES, sSS, sSR, sSA, sCL},/* Can't have Stale cookie*/
 /* cookie_echo  */ {sCL, sCL, sCE, sCE, sES, sSS, sSR, sSA, sCL},/* 5.2.4 - Big TODO */
-/* cookie_ack   */ {sCL, sCL, sCW, sCE, sES, sSS, sSR, sSA, sCL},/* Can't come in orig dir */
+/* cookie_ack   */ {sCL, sCL, sCW, sES, sES, sSS, sSR, sSA, sCL},/* Can't come in orig dir */
 /* shutdown_comp*/ {sCL, sCL, sCW, sCE, sES, sSS, sSR, sCL, sCL},
 /* heartbeat    */ {sHS, sCL, sCW, sCE, sES, sSS, sSR, sSA, sHS},
 /* heartbeat_ack*/ {sCL, sCL, sCW, sCE, sES, sSS, sSR, sSA, sHS},
@@ -126,7 +126,7 @@ static const u8 sctp_conntracks[2][11][SCTP_CONNTRACK_MAX] = {
 /* shutdown     */ {sIV, sCL, sCW, sCE, sSR, sSS, sSR, sSA, sIV},
 /* shutdown_ack */ {sIV, sCL, sCW, sCE, sES, sSA, sSA, sSA, sIV},
 /* error        */ {sIV, sCL, sCW, sCL, sES, sSS, sSR, sSA, sIV},
-/* cookie_echo  */ {sIV, sCL, sCW, sCE, sES, sSS, sSR, sSA, sIV},/* Can't come in reply dir */
+/* cookie_echo  */ {sIV, sCL, sCE, sCE, sES, sSS, sSR, sSA, sIV},/* Can't come in reply dir */
 /* cookie_ack   */ {sIV, sCL, sCW, sES, sES, sSS, sSR, sSA, sIV},
 /* shutdown_comp*/ {sIV, sCL, sCW, sCE, sES, sSS, sSR, sCL, sIV},
 /* heartbeat    */ {sIV, sCL, sCW, sCE, sES, sSS, sSR, sSA, sHS},
@@ -426,6 +426,9 @@ int nf_conntrack_sctp_packet(struct nf_conn *ct,
 			/* (D) vtag must be same as init_vtag as found in INIT_ACK */
 			if (sh->vtag != ct->proto.sctp.vtag[dir])
 				goto out_unlock;
+		} else if (sch->type == SCTP_CID_COOKIE_ACK) {
+			ct->proto.sctp.init[dir] = 0;
+			ct->proto.sctp.init[!dir] = 0;
 		} else if (sch->type == SCTP_CID_HEARTBEAT) {
 			if (ct->proto.sctp.vtag[dir] == 0) {
 				pr_debug("Setting %d vtag %x for dir %d\n", sch->type, sh->vtag, dir);
@@ -474,16 +477,18 @@ int nf_conntrack_sctp_packet(struct nf_conn *ct,
 		}
 
 		/* If it is an INIT or an INIT ACK note down the vtag */
-		if (sch->type == SCTP_CID_INIT ||
-		    sch->type == SCTP_CID_INIT_ACK) {
-			struct sctp_inithdr _inithdr, *ih;
+		if (sch->type == SCTP_CID_INIT) {
+			struct sctp_inithdr _ih, *ih;
 
-			ih = skb_header_pointer(skb, offset + sizeof(_sch),
-						sizeof(_inithdr), &_inithdr);
-			if (ih == NULL)
+			ih = skb_header_pointer(skb, offset + sizeof(_sch), sizeof(*ih), &_ih);
+			if (!ih)
 				goto out_unlock;
-			pr_debug("Setting vtag %x for dir %d\n",
-				 ih->init_tag, !dir);
+
+			if (ct->proto.sctp.init[dir] && ct->proto.sctp.init[!dir])
+				ct->proto.sctp.init[!dir] = 0;
+			ct->proto.sctp.init[dir] = 1;
+
+			pr_debug("Setting vtag %x for dir %d\n", ih->init_tag, !dir);
 			ct->proto.sctp.vtag[!dir] = ih->init_tag;
 
 			/* don't renew timeout on init retransmit so
@@ -494,6 +499,24 @@ int nf_conntrack_sctp_packet(struct nf_conn *ct,
 			    old_state == SCTP_CONNTRACK_CLOSED &&
 			    nf_ct_is_confirmed(ct))
 				ignore = true;
+		} else if (sch->type == SCTP_CID_INIT_ACK) {
+			struct sctp_inithdr _ih, *ih;
+			__be32 vtag;
+
+			ih = skb_header_pointer(skb, offset + sizeof(_sch), sizeof(*ih), &_ih);
+			if (!ih)
+				goto out_unlock;
+
+			vtag = ct->proto.sctp.vtag[!dir];
+			if (!ct->proto.sctp.init[!dir] && vtag && vtag != ih->init_tag)
+				goto out_unlock;
+			/* collision */
+			if (ct->proto.sctp.init[dir] && ct->proto.sctp.init[!dir] &&
+			    vtag != ih->init_tag)
+				goto out_unlock;
+
+			pr_debug("Setting vtag %x for dir %d\n", ih->init_tag, !dir);
+			ct->proto.sctp.vtag[!dir] = ih->init_tag;
 		}
 
 		ct->proto.sctp.state = new_state;
-- 
2.40.1



