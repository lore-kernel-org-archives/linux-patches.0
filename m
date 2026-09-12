Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D7B4247F2F9;
	Sat, 12 Sep 2026 13:04:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789218292; cv=none; b=tixOHG4SXvmvhxPgoaTuqMMdLQ89WBq5NDJ8LNRTuvv0gBXx8iSepJm9/oG0m1bY/3/NBRbgMqSZHqTGy+cMO5kP6NJM6hEjr+DZZymh6ex5IzTfPxZHGS4hdvkbk01EfwIodN5TXHXtAabETkl49K5Z7WZ0qO5fTzzEppGE1ww=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789218292; c=relaxed/simple;
	bh=6ZzwKcgqFkJbWV0qTAX5m63Mej4/SBJCmlrRw2XQsco=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=WSUR5iLylpGalerAtqexdQqidNF2j0xHPQC0aKfOpZ+pdZYtL8lOa5ze1KwYJUpRW/68aN1t+iYmIY7BLLAcvHaglNLAgq76k/sUIjyjrIBsDPnhwq5s3MCMBPB/Wi2hWPLsll03dUmrPDcMk4I7ZBAb46IW7p8w8dxaxusHAH0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=1q3cyeUA; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="1q3cyeUA"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7FD541F00893;
	Sat, 12 Sep 2026 13:04:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789218289;
	bh=eCPo+s+tYzxNrSXXBMjH10Wm3jTpogEH+azTJTzz8n0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=1q3cyeUAfIx0wAb/6FQUVW8O/rNE0E1+J8uXVpiNjVoPOqJp5kpUspFoVf1EJukt7
	 0XXyxavo833TKA0o+FZN67Gc4JyoiE2ux9c2Br48HrLINMJ0pTFnmy04EVOu6FS1Jc
	 xN9oEZdHLAo9gbII5Zjwyod2ahBFIzGHvxmkWnS8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	syzbot+46ca2592193f2fb3debc@syzkaller.appspotmail.com,
	Yun Zhou <yun.zhou@windriver.com>,
	David Heidelberg <david@ixit.cz>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 1071/1376] nfc: nci: fix use of uninitialized memory in CORE_INIT_RSP parsing
Date: Sat, 12 Sep 2026 08:58:17 +0200
Message-ID: <20260912065631.429795549@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065607.535295758@linuxfoundation.org>
References: <20260912065607.535295758@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
index fccd7ce69bb7b..e5d6ce71ca330 100644
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



