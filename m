Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 938E535AC1E;
	Tue, 16 Jun 2026 16:17:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781626629; cv=none; b=AlMjENo3Van+Vrf6u6V7C2dT5tqFBrzLPSqaMzYlm/Q5OovAWLrvhzpjLQC4qTX69wDlU93ygxfaLyIlWBm5m50174Cj56cICKhRxaov+es6+ULGTLAjpVrc6YKKE3gHt8ibjVFSzxcrAKlDze5ur1MeBLSeacQ3ss1omDCwMBc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781626629; c=relaxed/simple;
	bh=hg5QYhXMAjv8hX/Yd862LH4G/WVX4uvVUUgiIu3kFjw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=gqp1J+kHnZUzoPme3dCUsuZWdPvFTNipCt0Vxk72YQsRkaxS87cE++iFUmD1HDxzmr0w+Btjltz1L72F9VYPk49xJ9Y/PcXVz4Po/0TBGe+gxWbmZ1muux0Uc+RxY4LYlexESHNiUzKI6pqs38IIjDgcD3BHPoqsFMpyMn9SPVA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=AMctfhpD; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="AMctfhpD"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A02FF1F000E9;
	Tue, 16 Jun 2026 16:17:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1781626628;
	bh=lGckGrDSCpDfS6C9dpl9N09aZjGiuIEvk3BbHk0kd/o=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=AMctfhpDghVqfboB1SkZ1iOyXh3wYckBuMJkBfYo9V3Z3QF77nK3H4Km/pqv3wwja
	 RNHUIk58A+NzkAw40ntQX+26+wy5bmV7tHQzYZn6jjHXYhyVupM8r3d528Br73zD1z
	 U2xTrrkUxGT6bLMBpdgaUxsP2HvN+2i8lzyInX7o=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Muhammad Bilal <meatuni001@gmail.com>,
	SeungJu Cheon <suunj1331@gmail.com>,
	Luiz Augusto von Dentz <luiz.von.dentz@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 039/261] Bluetooth: RFCOMM: validate skb length in MCC handlers
Date: Tue, 16 Jun 2026 20:27:57 +0530
Message-ID: <20260616145046.939467435@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260616145044.869532709@linuxfoundation.org>
References: <20260616145044.869532709@linuxfoundation.org>
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

From: SeungJu Cheon <suunj1331@gmail.com>

[ Upstream commit 23882b828c3c8c51d0c946446a396b10abb3b16b ]

The RFCOMM MCC handlers cast skb->data to protocol-specific structs
without validating skb->len first. A malicious remote device can send
truncated MCC frames and trigger out-of-bounds reads in these handlers.

Fix this by using skb_pull_data() to validate and access the required
data before dereferencing it.

rfcomm_recv_rpn() requires special handling since ETSI TS 07.10 allows
1-byte RPN requests. Handle this by validating only the DLCI byte first,
and validating the full struct only when len > 1.

Fixes: 1da177e4c3f4 ("Linux-2.6.12-rc2")
Suggested-by: Muhammad Bilal <meatuni001@gmail.com>
Signed-off-by: SeungJu Cheon <suunj1331@gmail.com>
Signed-off-by: Luiz Augusto von Dentz <luiz.von.dentz@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/bluetooth/rfcomm/core.c | 67 +++++++++++++++++++++++++++----------
 1 file changed, 49 insertions(+), 18 deletions(-)

diff --git a/net/bluetooth/rfcomm/core.c b/net/bluetooth/rfcomm/core.c
index ad5177e3a69b77..293bf67cf10d3e 100644
--- a/net/bluetooth/rfcomm/core.c
+++ b/net/bluetooth/rfcomm/core.c
@@ -1431,10 +1431,15 @@ static int rfcomm_apply_pn(struct rfcomm_dlc *d, int cr, struct rfcomm_pn *pn)
 
 static int rfcomm_recv_pn(struct rfcomm_session *s, int cr, struct sk_buff *skb)
 {
-	struct rfcomm_pn *pn = (void *) skb->data;
+	struct rfcomm_pn *pn;
 	struct rfcomm_dlc *d;
-	u8 dlci = pn->dlci;
+	u8 dlci;
+
+	pn = skb_pull_data(skb, sizeof(*pn));
+	if (!pn)
+		return -EILSEQ;
 
+	dlci = pn->dlci;
 	BT_DBG("session %p state %ld dlci %d", s, s->state, dlci);
 
 	if (!dlci)
@@ -1483,8 +1488,8 @@ static int rfcomm_recv_pn(struct rfcomm_session *s, int cr, struct sk_buff *skb)
 
 static int rfcomm_recv_rpn(struct rfcomm_session *s, int cr, int len, struct sk_buff *skb)
 {
-	struct rfcomm_rpn *rpn = (void *) skb->data;
-	u8 dlci = __get_dlci(rpn->dlci);
+	struct rfcomm_rpn *rpn;
+	u8 dlci;
 
 	u8 bit_rate  = 0;
 	u8 data_bits = 0;
@@ -1495,15 +1500,16 @@ static int rfcomm_recv_rpn(struct rfcomm_session *s, int cr, int len, struct sk_
 	u8 xoff_char = 0;
 	u16 rpn_mask = RFCOMM_RPN_PM_ALL;
 
-	BT_DBG("dlci %d cr %d len 0x%x bitr 0x%x line 0x%x flow 0x%x xonc 0x%x xoffc 0x%x pm 0x%x",
-		dlci, cr, len, rpn->bit_rate, rpn->line_settings, rpn->flow_ctrl,
-		rpn->xon_char, rpn->xoff_char, rpn->param_mask);
+	if (len == 1) {
+		rpn = skb_pull_data(skb, 1);
+		if (!rpn)
+			return -EILSEQ;
 
-	if (!cr)
-		return 0;
+		dlci = __get_dlci(rpn->dlci);
+
+		if (!cr)
+			return 0;
 
-	if (len == 1) {
-		/* This is a request, return default (according to ETSI TS 07.10) settings */
 		bit_rate  = RFCOMM_RPN_BR_9600;
 		data_bits = RFCOMM_RPN_DATA_8;
 		stop_bits = RFCOMM_RPN_STOP_1;
@@ -1514,6 +1520,19 @@ static int rfcomm_recv_rpn(struct rfcomm_session *s, int cr, int len, struct sk_
 		goto rpn_out;
 	}
 
+	rpn = skb_pull_data(skb, sizeof(*rpn));
+	if (!rpn)
+		return -EILSEQ;
+
+	dlci = __get_dlci(rpn->dlci);
+
+	BT_DBG("dlci %d cr %d len 0x%x bitr 0x%x line 0x%x flow 0x%x xonc 0x%x xoffc 0x%x pm 0x%x",
+	       dlci, cr, len, rpn->bit_rate, rpn->line_settings, rpn->flow_ctrl,
+	       rpn->xon_char, rpn->xoff_char, rpn->param_mask);
+
+	if (!cr)
+		return 0;
+
 	/* Check for sane values, ignore/accept bit_rate, 8 bits, 1 stop bit,
 	 * no parity, no flow control lines, normal XON/XOFF chars */
 
@@ -1589,9 +1608,14 @@ static int rfcomm_recv_rpn(struct rfcomm_session *s, int cr, int len, struct sk_
 
 static int rfcomm_recv_rls(struct rfcomm_session *s, int cr, struct sk_buff *skb)
 {
-	struct rfcomm_rls *rls = (void *) skb->data;
-	u8 dlci = __get_dlci(rls->dlci);
+	struct rfcomm_rls *rls;
+	u8 dlci;
 
+	rls = skb_pull_data(skb, sizeof(*rls));
+	if (!rls)
+		return -EILSEQ;
+
+	dlci = __get_dlci(rls->dlci);
 	BT_DBG("dlci %d cr %d status 0x%x", dlci, cr, rls->status);
 
 	if (!cr)
@@ -1608,10 +1632,15 @@ static int rfcomm_recv_rls(struct rfcomm_session *s, int cr, struct sk_buff *skb
 
 static int rfcomm_recv_msc(struct rfcomm_session *s, int cr, struct sk_buff *skb)
 {
-	struct rfcomm_msc *msc = (void *) skb->data;
+	struct rfcomm_msc *msc;
 	struct rfcomm_dlc *d;
-	u8 dlci = __get_dlci(msc->dlci);
+	u8 dlci;
+
+	msc = skb_pull_data(skb, sizeof(*msc));
+	if (!msc)
+		return -EILSEQ;
 
+	dlci = __get_dlci(msc->dlci);
 	BT_DBG("dlci %d cr %d v24 0x%x", dlci, cr, msc->v24_sig);
 
 	d = rfcomm_dlc_get(s, dlci);
@@ -1644,17 +1673,19 @@ static int rfcomm_recv_msc(struct rfcomm_session *s, int cr, struct sk_buff *skb
 
 static int rfcomm_recv_mcc(struct rfcomm_session *s, struct sk_buff *skb)
 {
-	struct rfcomm_mcc *mcc = (void *) skb->data;
+	struct rfcomm_mcc *mcc;
 	u8 type, cr, len;
 
+	mcc = skb_pull_data(skb, sizeof(*mcc));
+	if (!mcc)
+		return -EILSEQ;
+
 	cr   = __test_cr(mcc->type);
 	type = __get_mcc_type(mcc->type);
 	len  = __get_mcc_len(mcc->len);
 
 	BT_DBG("%p type 0x%x cr %d", s, type, cr);
 
-	skb_pull(skb, 2);
-
 	switch (type) {
 	case RFCOMM_PN:
 		rfcomm_recv_pn(s, cr, skb);
-- 
2.53.0



