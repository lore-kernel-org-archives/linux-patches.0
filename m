Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F1350221F26;
	Sat, 12 Sep 2026 11:02:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789210957; cv=none; b=FVfaaAiaT+akclduaWj8v5XeKMdU0SzG9eAvklD6dEpbZvAI4SVXIdhzoJI9U50R0QxS8wH25VC1DcQisE2/8VXXPW3WhsQmgp6mD8uv43CgYGkgES4pffjBY4uX7Gga9CgHVmNSxEJ/rmWVenK9m8eOLl8DoVGmWYuIibQD/H0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789210957; c=relaxed/simple;
	bh=wEDSTzBCl5U4BCq9vUAP+3ZWfGQ8HUUH8x7H8Dq+w0g=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=eFX3tBwPRa0wVBJoQ3eht5Q2Rfi1d4M1n7lnp7hZsDi+SHmplPkbj0/T3r8Vua/S74KHZT/7b9L6VlRYvUgM40BYltuk2O4+S+6MBOC7xNXbe8yO8Mgq0vOR1PRzoFyoWuryC2rj0WXdsdsXE9vPvTVXOowR6Z+WvyTrAFNjw0Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=asf3DfVn; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="asf3DfVn"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A9C221F000FF;
	Sat, 12 Sep 2026 11:02:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789210955;
	bh=4fmgIN1oum+e1NMXa8USO+toMyIKVIGcjQWhUdbET0k=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=asf3DfVn2GzT4veS/RiMgq3LVdm+strwpHuhZJRgiuSsykbCFB1ykC0BdDD5gnTMc
	 +UNZbYA5MXveNd1H1Mnj0VJwfhJLWwa2AxCQzgHHHadjzeX9xXdn7sgjiVly2p0Ebx
	 KbsWxevIaWqxaLr6A0sSXmg1BvN0UQ11dgkUlOf4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	syzbot+46ca2592193f2fb3debc@syzkaller.appspotmail.com,
	Yun Zhou <yun.zhou@windriver.com>,
	David Heidelberg <david@ixit.cz>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 1131/1518] nfc: nci: fix use of uninitialized memory in CORE_INIT_RSP parsing
Date: Sat, 12 Sep 2026 08:55:00 +0200
Message-ID: <20260912065649.040577760@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065623.398859879@linuxfoundation.org>
References: <20260912065623.398859879@linuxfoundation.org>
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

From: Yun Zhou <yun.zhou@windriver.com>

[ Upstream commit d56575a2595ee1f597f39e8a1cfb67ed3501678d ]

nci_core_init_rsp_packet_v1() and nci_core_init_rsp_packet_v2() parse
the CORE_INIT_RSP packet without validating that the skb contains
enough data. A malformed response (e.g. injected via virtual_ncidev)
can declare a large num_supported_rf_interfaces while providing
insufficient data, causing reads of uninitialized slab memory. This
is later used in nci_init_complete_req(), triggering a KMSAN
uninit-value warning.

Add skb length checks before accessing packet fields:
- Validate the skb has at least 1 byte for the status field.
- Validate the skb can hold the fixed-size header before parsing.
- In v2, bounds-check each variable-length rf_interface entry and its
  extension parameters within the parsing loop.
- In v1, verify the skb is large enough for both the variable-length
  rf_interfaces array and the trailing rsp_2 structure.

Reported-by: syzbot+46ca2592193f2fb3debc@syzkaller.appspotmail.com
Closes: https://syzkaller.appspot.com/bug?extid=46ca2592193f2fb3debc
Fixes: bcd684aace34 ("net/nfc/nci: Support NCI 2.x initial sequence")
Signed-off-by: Yun Zhou <yun.zhou@windriver.com>
Link: https://patch.msgid.link/20260527052625.3309581-1-yun.zhou@windriver.com
Signed-off-by: David Heidelberg <david@ixit.cz>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/nfc/nci/rsp.c | 41 ++++++++++++++++++++++++++++++++++++++---
 1 file changed, 38 insertions(+), 3 deletions(-)

diff --git a/net/nfc/nci/rsp.c b/net/nfc/nci/rsp.c
index 165aa4115166a..b0ab4f5acbce8 100644
--- a/net/nfc/nci/rsp.c
+++ b/net/nfc/nci/rsp.c
@@ -50,11 +50,27 @@ static u8 nci_core_init_rsp_packet_v1(struct nci_dev *ndev,
 	const struct nci_core_init_rsp_1 *rsp_1 = (void *)skb->data;
 	const struct nci_core_init_rsp_2 *rsp_2;
 
+	/* Ensure that the status field can be accessed. */
+	if (skb_headlen(skb) < 1)
+		return NCI_STATUS_SYNTAX_ERROR;
+
 	pr_debug("status 0x%x\n", rsp_1->status);
 
 	if (rsp_1->status != NCI_STATUS_OK)
 		return rsp_1->status;
 
+	/* Success response must contain the full fixed-size header */
+	if (skb_headlen(skb) < sizeof(*rsp_1))
+		return NCI_STATUS_SYNTAX_ERROR;
+
+	/* Ensure the variable-length rf_interfaces array and trailing
+	 * rsp_2 structure are fully contained within the skb.
+	 */
+	if (skb_headlen(skb) < sizeof(*rsp_1) +
+			       rsp_1->num_supported_rf_interfaces +
+			       sizeof(*rsp_2))
+		return NCI_STATUS_SYNTAX_ERROR;
+
 	ndev->nfcc_features = __le32_to_cpu(rsp_1->nfcc_features);
 	ndev->num_supported_rf_interfaces = rsp_1->num_supported_rf_interfaces;
 
@@ -87,15 +103,25 @@ static u8 nci_core_init_rsp_packet_v2(struct nci_dev *ndev,
 				      const struct sk_buff *skb)
 {
 	const struct nci_core_init_rsp_nci_ver2 *rsp = (void *)skb->data;
-	const u8 *supported_rf_interface = rsp->supported_rf_interfaces;
+	const u8 *supported_rf_interface;
 	u8 rf_interface_idx = 0;
 	u8 rf_extension_cnt = 0;
 
+	/* Ensure that the status field can be accessed. */
+	if (skb_headlen(skb) < 1)
+		return NCI_STATUS_SYNTAX_ERROR;
+
 	pr_debug("status %x\n", rsp->status);
 
 	if (rsp->status != NCI_STATUS_OK)
 		return rsp->status;
 
+	/* Success response must contain the full fixed-size header */
+	if (skb_headlen(skb) < sizeof(*rsp))
+		return NCI_STATUS_SYNTAX_ERROR;
+
+	supported_rf_interface = rsp->supported_rf_interfaces;
+
 	ndev->nfcc_features = __le32_to_cpu(rsp->nfcc_features);
 	ndev->num_supported_rf_interfaces = rsp->num_supported_rf_interfaces;
 
@@ -104,13 +130,22 @@ static u8 nci_core_init_rsp_packet_v2(struct nci_dev *ndev,
 		    NCI_MAX_SUPPORTED_RF_INTERFACES);
 
 	while (rf_interface_idx < ndev->num_supported_rf_interfaces) {
-		ndev->supported_rf_interfaces[rf_interface_idx++] = *supported_rf_interface++;
+		/* Each entry: [rf_interface_type (1B)] [ext_count (1B)] [ext...] */
+		if (supported_rf_interface + 2 > skb_tail_pointer(skb))
+			break;
+		ndev->supported_rf_interfaces[rf_interface_idx] = *supported_rf_interface++;
 
-		/* skip rf extension parameters */
 		rf_extension_cnt = *supported_rf_interface++;
+		if (supported_rf_interface + rf_extension_cnt > skb_tail_pointer(skb))
+			break;
+
+		/* Only count the entry after full validation */
+		rf_interface_idx++;
 		supported_rf_interface += rf_extension_cnt;
 	}
 
+	ndev->num_supported_rf_interfaces = rf_interface_idx;
+
 	ndev->max_logical_connections = rsp->max_logical_connections;
 	ndev->max_routing_table_size =
 			__le16_to_cpu(rsp->max_routing_table_size);
-- 
2.53.0



