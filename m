Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D40EE21B191;
	Sat, 30 May 2026 18:44:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780166658; cv=none; b=R90loHLk6jZjbARNELAxeR/tmv8PyFjSqATAq8jTYJDfPC5RHHcEzlfP00piH2ZT6EKscGYhSzmeLeL38irhdruOQOwYz2fDtMRBmOQUVRPXTOXWn0kDc3irQtTu+nFIrdazogiBTj4kw4V09o2J7SPCy/4nytC8TrAFU2JVjMI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780166658; c=relaxed/simple;
	bh=/IifuXT7PkGLH0l3TKelaEuHUjO38ayCjyUSOyXbK1c=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=uRmu60QrrAOu0UInOt7aYpaWDKC0CA1psuME1pGmCkIcQhSnm9w3gJm75Dm/k50Sxbnki7stLJuyJxlR+xgDT3JAPSj7LX9a4cQ5/XQiKjbKQrm+REqf8Yx52BilAUxHuYcyDipdTpSpqJFS/7ZhfrIdspiWEdoK3oMd6fuqBoM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=wEGSJRfN; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="wEGSJRfN"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E48DE1F00893;
	Sat, 30 May 2026 18:44:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1780166657;
	bh=51ExX0907vHrzHiz6BVSIMRlYRY7cQEevQZcDI/ucAM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=wEGSJRfNXfTyvemH9WB8eQHini6u9m4/04CyGlDjjYT22DKSDorI992Uf1wrzMHRB
	 UUdZThUtNeGMDC7a/tXymJAlH5MMtCeOzU9quMoKsETzunTuM1CbzI5AWSUsMhimuw
	 qTs/O+kjNydgbkljWtEwuYPgS2OKjLJ8oM1FPG3Q=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Wojciech Drewek <wojciech.drewek@intel.com>,
	Guillaume Nault <gnault@redhat.com>,
	Tony Nguyen <anthony.l.nguyen@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 430/589] flow_dissector: Add PPPoE dissectors
Date: Sat, 30 May 2026 18:05:11 +0200
Message-ID: <20260530160236.022190710@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260530160224.570625122@linuxfoundation.org>
References: <20260530160224.570625122@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Wojciech Drewek <wojciech.drewek@intel.com>

[ Upstream commit 46126db9c86110e5fc1e369b9bb89735ddefdae4 ]

Allow to dissect PPPoE specific fields which are:
- session ID (16 bits)
- ppp protocol (16 bits)
- type (16 bits) - this is PPPoE ethertype, for now only
  ETH_P_PPP_SES is supported, possible ETH_P_PPP_DISC
  in the future

The goal is to make the following TC command possible:

  # tc filter add dev ens6f0 ingress prio 1 protocol ppp_ses \
      flower \
        pppoe_sid 12 \
        ppp_proto ip \
      action drop

Note that only PPPoE Session is supported.

Signed-off-by: Wojciech Drewek <wojciech.drewek@intel.com>
Acked-by: Guillaume Nault <gnault@redhat.com>
Signed-off-by: Tony Nguyen <anthony.l.nguyen@intel.com>
Stable-dep-of: cc1ff87bce1c ("pppoe: drop PFC frames")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/linux/ppp_defs.h     | 14 ++++++++++
 include/net/flow_dissector.h | 13 +++++++++
 net/core/flow_dissector.c    | 53 +++++++++++++++++++++++++++++++-----
 3 files changed, 73 insertions(+), 7 deletions(-)

diff --git a/include/linux/ppp_defs.h b/include/linux/ppp_defs.h
index 9d2b388fae1a4..b7e57fdbd4139 100644
--- a/include/linux/ppp_defs.h
+++ b/include/linux/ppp_defs.h
@@ -11,4 +11,18 @@
 #include <uapi/linux/ppp_defs.h>
 
 #define PPP_FCS(fcs, c) crc_ccitt_byte(fcs, c)
+
+/**
+ * ppp_proto_is_valid - checks if PPP protocol is valid
+ * @proto: PPP protocol
+ *
+ * Assumes proto is not compressed.
+ * Protocol is valid if the value is odd and the least significant bit of the
+ * most significant octet is 0 (see RFC 1661, section 2).
+ */
+static inline bool ppp_proto_is_valid(u16 proto)
+{
+	return !!((proto & 0x0101) == 0x0001);
+}
+
 #endif /* _PPP_DEFS_H_ */
diff --git a/include/net/flow_dissector.h b/include/net/flow_dissector.h
index 6826309631cb3..af0918a676211 100644
--- a/include/net/flow_dissector.h
+++ b/include/net/flow_dissector.h
@@ -277,6 +277,18 @@ struct flow_dissector_key_num_of_vlans {
 	u8 num_of_vlans;
 };
 
+/**
+ * struct flow_dissector_key_pppoe:
+ * @session_id: pppoe session id
+ * @ppp_proto: ppp protocol
+ * @type: pppoe eth type
+ */
+struct flow_dissector_key_pppoe {
+	__be16 session_id;
+	__be16 ppp_proto;
+	__be16 type;
+};
+
 enum flow_dissector_key_id {
 	FLOW_DISSECTOR_KEY_CONTROL, /* struct flow_dissector_key_control */
 	FLOW_DISSECTOR_KEY_BASIC, /* struct flow_dissector_key_basic */
@@ -307,6 +319,7 @@ enum flow_dissector_key_id {
 	FLOW_DISSECTOR_KEY_CT, /* struct flow_dissector_key_ct */
 	FLOW_DISSECTOR_KEY_HASH, /* struct flow_dissector_key_hash */
 	FLOW_DISSECTOR_KEY_NUM_OF_VLANS, /* struct flow_dissector_key_num_of_vlans */
+	FLOW_DISSECTOR_KEY_PPPOE, /* struct flow_dissector_key_pppoe */
 
 	FLOW_DISSECTOR_KEY_MAX,
 };
diff --git a/net/core/flow_dissector.c b/net/core/flow_dissector.c
index 146f24c53c660..c3d64e2d59295 100644
--- a/net/core/flow_dissector.c
+++ b/net/core/flow_dissector.c
@@ -891,6 +891,11 @@ bool bpf_flow_dissect(struct bpf_prog *prog, struct bpf_flow_dissector *ctx,
 	return result == BPF_OK;
 }
 
+static bool is_pppoe_ses_hdr_valid(struct pppoe_hdr hdr)
+{
+	return hdr.ver == 1 && hdr.type == 1 && hdr.code == 0;
+}
+
 /**
  * __skb_flow_dissect - extract the flow_keys struct and return it
  * @net: associated network namespace, derived from @skb if NULL
@@ -1211,26 +1216,60 @@ bool __skb_flow_dissect(const struct net *net,
 			struct pppoe_hdr hdr;
 			__be16 proto;
 		} *hdr, _hdr;
+		u16 ppp_proto;
+
 		hdr = __skb_header_pointer(skb, nhoff, sizeof(_hdr), data, hlen, &_hdr);
 		if (!hdr) {
 			fdret = FLOW_DISSECT_RET_OUT_BAD;
 			break;
 		}
 
-		nhoff += PPPOE_SES_HLEN;
-		switch (hdr->proto) {
-		case htons(PPP_IP):
+		if (!is_pppoe_ses_hdr_valid(hdr->hdr)) {
+			fdret = FLOW_DISSECT_RET_OUT_BAD;
+			break;
+		}
+
+		/* least significant bit of the most significant octet
+		 * indicates if protocol field was compressed
+		 */
+		ppp_proto = ntohs(hdr->proto);
+		if (ppp_proto & 0x0100) {
+			ppp_proto = ppp_proto >> 8;
+			nhoff += PPPOE_SES_HLEN - 1;
+		} else {
+			nhoff += PPPOE_SES_HLEN;
+		}
+
+		if (ppp_proto == PPP_IP) {
 			proto = htons(ETH_P_IP);
 			fdret = FLOW_DISSECT_RET_PROTO_AGAIN;
-			break;
-		case htons(PPP_IPV6):
+		} else if (ppp_proto == PPP_IPV6) {
 			proto = htons(ETH_P_IPV6);
 			fdret = FLOW_DISSECT_RET_PROTO_AGAIN;
-			break;
-		default:
+		} else if (ppp_proto == PPP_MPLS_UC) {
+			proto = htons(ETH_P_MPLS_UC);
+			fdret = FLOW_DISSECT_RET_PROTO_AGAIN;
+		} else if (ppp_proto == PPP_MPLS_MC) {
+			proto = htons(ETH_P_MPLS_MC);
+			fdret = FLOW_DISSECT_RET_PROTO_AGAIN;
+		} else if (ppp_proto_is_valid(ppp_proto)) {
+			fdret = FLOW_DISSECT_RET_OUT_GOOD;
+		} else {
 			fdret = FLOW_DISSECT_RET_OUT_BAD;
 			break;
 		}
+
+		if (dissector_uses_key(flow_dissector,
+				       FLOW_DISSECTOR_KEY_PPPOE)) {
+			struct flow_dissector_key_pppoe *key_pppoe;
+
+			key_pppoe = skb_flow_dissector_target(flow_dissector,
+							      FLOW_DISSECTOR_KEY_PPPOE,
+							      target_container);
+			key_pppoe->session_id = hdr->hdr.sid;
+			key_pppoe->ppp_proto = htons(ppp_proto);
+			key_pppoe->type = htons(ETH_P_PPP_SES);
+		}
 		break;
 	}
 	case htons(ETH_P_TIPC): {
-- 
2.53.0



