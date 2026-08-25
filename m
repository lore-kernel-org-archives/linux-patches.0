Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4AE94409265;
	Tue, 25 Aug 2026 13:53:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787665989; cv=none; b=NI0Y+V+kBKpsfMMNvE4ZH62FN/tX3AXT5jNuMa+rS0IENcERRyMuBcUqizjv7NMdqrkFcMmTN7UQ4nxvhso0AftPohyxTK8/IjLA3zNPNC0T3SzwfWH87y0DIQbMb2BEEulohw7q9O2/AQUO0pB5hH6fgj1fAFvIDRSxIy3WuHA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787665989; c=relaxed/simple;
	bh=mh+epklK7P/f+m1YmpKrJBIeLiuQ/2NPtY5xQbVS8kE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=JGIRzuuidUFSyCZdna2rl7mCM1c2MNchSO7xp7Pk4JUZk6GHobzhwQzySOT+UV4nzX5IiavCcCOMzX4DTI/koPtppNYMxA/mhGcBuAKluOTL6s52Ef9Dub06pXzopLdxV7x2Dj1hvhlhzZJjgKt2GZC/EQIblvIge0LsjRHXgbY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=kyvYHFvO; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="kyvYHFvO"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9AB1B1F000E9;
	Tue, 25 Aug 2026 13:53:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1787665988;
	bh=qsQBpOR4ktXr1kQcDiHKBgUhGbmrJsc/tEXppnczYKs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=kyvYHFvOU0jdR2cIoTlxJbZVGQBVK8PImSyzX/nIDiXaBmdFeXLtg689+4lqeFUxi
	 d2md9RgLRrgqzB+g+81PI4E8DGZtoI6xBAoQ1IoPMQW+LQ2q8DR4Sis0IsBs/EZOMu
	 u4iN11Qo8K+tnrW4o1ZQ8pFhG9sMDMmFT0X2SEI8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Pengpeng Hou <pengpeng@iscas.ac.cn>,
	David Heidelberg <david@ixit.cz>
Subject: [PATCH 6.1 44/79] nfc: microread: validate target discovery payload lengths
Date: Tue, 25 Aug 2026 15:26:24 +0200
Message-ID: <20260825132543.431718409@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260825132541.677185791@linuxfoundation.org>
References: <20260825132541.677185791@linuxfoundation.org>
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

From: Pengpeng Hou <pengpeng@iscas.ac.cn>

commit 25519469972ef57c3edb1805dabd6c5612b90211 upstream.

microread_target_discovered() parses target discovery payloads from
skb->data according to the HCI gate. The fixed field offsets and UID
copies were checked only against the destination nfc_target buffers, not
against the actual skb length.

Validate that each gate-specific payload contains the fixed fields and
UID bytes before reading or copying them.

Fixes: cfad1ba87150 ("NFC: Initial support for Inside Secure microread")
Cc: stable@vger.kernel.org
Signed-off-by: Pengpeng Hou <pengpeng@iscas.ac.cn>
Link: https://patch.msgid.link/20260723103508.1-microread-v2-pengpeng@iscas.ac.cn
Signed-off-by: David Heidelberg <david@ixit.cz>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/nfc/microread/microread.c |   31 +++++++++++++++++++++++++++++--
 1 file changed, 29 insertions(+), 2 deletions(-)

--- a/drivers/nfc/microread/microread.c
+++ b/drivers/nfc/microread/microread.c
@@ -483,13 +483,19 @@ static void microread_target_discovered(
 
 	switch (gate) {
 	case MICROREAD_GATE_ID_MREAD_ISO_A:
+		if (skb->len <= MICROREAD_EMCF_A_LEN) {
+			r = -EINVAL;
+			goto exit_free;
+		}
+
 		targets->supported_protocols =
 		      nfc_hci_sak_to_protocol(skb->data[MICROREAD_EMCF_A_SAK]);
 		targets->sens_res =
 			 be16_to_cpu(*(u16 *)&skb->data[MICROREAD_EMCF_A_ATQA]);
 		targets->sel_res = skb->data[MICROREAD_EMCF_A_SAK];
 		targets->nfcid1_len = skb->data[MICROREAD_EMCF_A_LEN];
-		if (targets->nfcid1_len > sizeof(targets->nfcid1)) {
+		if (targets->nfcid1_len > sizeof(targets->nfcid1) ||
+		    targets->nfcid1_len > skb->len - MICROREAD_EMCF_A_UID) {
 			r = -EINVAL;
 			goto exit_free;
 		}
@@ -497,13 +503,19 @@ static void microread_target_discovered(
 		       targets->nfcid1_len);
 		break;
 	case MICROREAD_GATE_ID_MREAD_ISO_A_3:
+		if (skb->len <= MICROREAD_EMCF_A3_LEN) {
+			r = -EINVAL;
+			goto exit_free;
+		}
+
 		targets->supported_protocols =
 		      nfc_hci_sak_to_protocol(skb->data[MICROREAD_EMCF_A3_SAK]);
 		targets->sens_res =
 			 be16_to_cpu(*(u16 *)&skb->data[MICROREAD_EMCF_A3_ATQA]);
 		targets->sel_res = skb->data[MICROREAD_EMCF_A3_SAK];
 		targets->nfcid1_len = skb->data[MICROREAD_EMCF_A3_LEN];
-		if (targets->nfcid1_len > sizeof(targets->nfcid1)) {
+		if (targets->nfcid1_len > sizeof(targets->nfcid1) ||
+		    targets->nfcid1_len > skb->len - MICROREAD_EMCF_A3_UID) {
 			r = -EINVAL;
 			goto exit_free;
 		}
@@ -511,11 +523,21 @@ static void microread_target_discovered(
 		       targets->nfcid1_len);
 		break;
 	case MICROREAD_GATE_ID_MREAD_ISO_B:
+		if (skb->len < MICROREAD_EMCF_B_UID + 4) {
+			r = -EINVAL;
+			goto exit_free;
+		}
+
 		targets->supported_protocols = NFC_PROTO_ISO14443_B_MASK;
 		memcpy(targets->nfcid1, &skb->data[MICROREAD_EMCF_B_UID], 4);
 		targets->nfcid1_len = 4;
 		break;
 	case MICROREAD_GATE_ID_MREAD_NFC_T1:
+		if (skb->len < MICROREAD_EMCF_T1_UID + 4) {
+			r = -EINVAL;
+			goto exit_free;
+		}
+
 		targets->supported_protocols = NFC_PROTO_JEWEL_MASK;
 		targets->sens_res =
 			le16_to_cpu(*(u16 *)&skb->data[MICROREAD_EMCF_T1_ATQA]);
@@ -523,6 +545,11 @@ static void microread_target_discovered(
 		targets->nfcid1_len = 4;
 		break;
 	case MICROREAD_GATE_ID_MREAD_NFC_T3:
+		if (skb->len < MICROREAD_EMCF_T3_UID + 8) {
+			r = -EINVAL;
+			goto exit_free;
+		}
+
 		targets->supported_protocols = NFC_PROTO_FELICA_MASK;
 		memcpy(targets->nfcid1, &skb->data[MICROREAD_EMCF_T3_UID], 8);
 		targets->nfcid1_len = 8;


