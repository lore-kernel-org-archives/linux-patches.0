Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6C3BFDDA9;
	Mon, 27 May 2024 19:00:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1716836429; cv=none; b=heGkHLXMWtsa7vh136w+J4sh4qcig8d9Lv3JxajHRNdtXDrVTI8dT9RxkL2FA3WQ8CNDPNwGnoTSf4yBEjFOlgphd+JLOrU88DkKwOLC3RZoNR8bTdkM0mAgnm7GiuC/NzKmCPXyX6NrJZsXBx80oJtkisH4mvsCPiXTbZ6Y6rE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1716836429; c=relaxed/simple;
	bh=4VLKc3dtQ2S7r9mDTX2J98cPsPzyCf9f77+2Wbbh/II=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=TshIuiUw3NsL61uRRX6Y9FMurFJSZ8MiYfDm2sVF+g9ZTGotit2fkkfpdieNxhn1161pluSiGg2kXlGDg+jg21Z9CTkJhxI6yoe+FLp1XGu6mgKL+YnANJ07Gb/fYpoXr2Ieo2lzEvrO5mCOqPJr1ZQA+KxnE8cFTHfEHN21Buc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=y6ubUjwJ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="y6ubUjwJ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 95F36C2BBFC;
	Mon, 27 May 2024 19:00:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1716836429;
	bh=4VLKc3dtQ2S7r9mDTX2J98cPsPzyCf9f77+2Wbbh/II=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=y6ubUjwJk7YVPG2x84x8lstv0hA90Tx5XPvzaDf3JNwtsBvQFS1YmHGy41MPmpZxF
	 RRtp6Ns+zm7raIqyrxJtR8pI3SEC6cUoBw+nghU23KMLXdqIiT8qOnIr7gTgysjZqr
	 HRNDuRT7Q846oTPMgO9HTYAHkxOyOoJmGYeULiTQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Daniel Starke <daniel.starke@siemens.com>
Subject: [PATCH 6.9 009/427] tty: n_gsm: fix missing receive state reset after mode switch
Date: Mon, 27 May 2024 20:50:56 +0200
Message-ID: <20240527185602.681079876@linuxfoundation.org>
X-Mailer: git-send-email 2.45.1
In-Reply-To: <20240527185601.713589927@linuxfoundation.org>
References: <20240527185601.713589927@linuxfoundation.org>
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

6.9-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Daniel Starke <daniel.starke@siemens.com>

commit 70d7f1427afcf7fa2d21cb5a04c6f3555d5b9357 upstream.

The current implementation uses either gsm0_receive() or gsm1_receive()
depending on whether the user configured the mux in basic or advanced
option mode. Both functions share some state values over the same logical
elements of the frame. However, both frame types differ in their nature.
gsm0_receive() uses non-transparency framing, whereas gsm1_receive() uses
transparency mechanism. Switching between both modes leaves the receive
function in an undefined state when done during frame reception.

Fix this by splitting both states. Add gsm0_receive_state_check_and_fix()
and gsm1_receive_state_check_and_fix() to ensure that gsm->state is reset
after a change of gsm->receive.

Note that gsm->state is only accessed in:
- gsm0_receive()
- gsm1_receive()
- gsm_error()

Fixes: e1eaea46bb40 ("tty: n_gsm line discipline")
Cc: stable@vger.kernel.org
Signed-off-by: Daniel Starke <daniel.starke@siemens.com>
Link: https://lore.kernel.org/r/20240424054842.7741-2-daniel.starke@siemens.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/tty/n_gsm.c |  133 +++++++++++++++++++++++++++++++++++-----------------
 1 file changed, 92 insertions(+), 41 deletions(-)

--- a/drivers/tty/n_gsm.c
+++ b/drivers/tty/n_gsm.c
@@ -245,16 +245,18 @@ enum gsm_encoding {
 
 enum gsm_mux_state {
 	GSM_SEARCH,
-	GSM_START,
-	GSM_ADDRESS,
-	GSM_CONTROL,
-	GSM_LEN,
-	GSM_DATA,
-	GSM_FCS,
-	GSM_OVERRUN,
-	GSM_LEN0,
-	GSM_LEN1,
-	GSM_SSOF,
+	GSM0_ADDRESS,
+	GSM0_CONTROL,
+	GSM0_LEN0,
+	GSM0_LEN1,
+	GSM0_DATA,
+	GSM0_FCS,
+	GSM0_SSOF,
+	GSM1_START,
+	GSM1_ADDRESS,
+	GSM1_CONTROL,
+	GSM1_DATA,
+	GSM1_OVERRUN,
 };
 
 /*
@@ -2847,6 +2849,30 @@ invalid:
 	return;
 }
 
+/**
+ * gsm0_receive_state_check_and_fix	-	check and correct receive state
+ * @gsm: gsm data for this ldisc instance
+ *
+ * Ensures that the current receive state is valid for basic option mode.
+ */
+
+static void gsm0_receive_state_check_and_fix(struct gsm_mux *gsm)
+{
+	switch (gsm->state) {
+	case GSM_SEARCH:
+	case GSM0_ADDRESS:
+	case GSM0_CONTROL:
+	case GSM0_LEN0:
+	case GSM0_LEN1:
+	case GSM0_DATA:
+	case GSM0_FCS:
+	case GSM0_SSOF:
+		break;
+	default:
+		gsm->state = GSM_SEARCH;
+		break;
+	}
+}
 
 /**
  *	gsm0_receive	-	perform processing for non-transparency
@@ -2860,26 +2886,27 @@ static void gsm0_receive(struct gsm_mux
 {
 	unsigned int len;
 
+	gsm0_receive_state_check_and_fix(gsm);
 	switch (gsm->state) {
 	case GSM_SEARCH:	/* SOF marker */
 		if (c == GSM0_SOF) {
-			gsm->state = GSM_ADDRESS;
+			gsm->state = GSM0_ADDRESS;
 			gsm->address = 0;
 			gsm->len = 0;
 			gsm->fcs = INIT_FCS;
 		}
 		break;
-	case GSM_ADDRESS:	/* Address EA */
+	case GSM0_ADDRESS:	/* Address EA */
 		gsm->fcs = gsm_fcs_add(gsm->fcs, c);
 		if (gsm_read_ea(&gsm->address, c))
-			gsm->state = GSM_CONTROL;
+			gsm->state = GSM0_CONTROL;
 		break;
-	case GSM_CONTROL:	/* Control Byte */
+	case GSM0_CONTROL:	/* Control Byte */
 		gsm->fcs = gsm_fcs_add(gsm->fcs, c);
 		gsm->control = c;
-		gsm->state = GSM_LEN0;
+		gsm->state = GSM0_LEN0;
 		break;
-	case GSM_LEN0:		/* Length EA */
+	case GSM0_LEN0:		/* Length EA */
 		gsm->fcs = gsm_fcs_add(gsm->fcs, c);
 		if (gsm_read_ea(&gsm->len, c)) {
 			if (gsm->len > gsm->mru) {
@@ -2889,14 +2916,14 @@ static void gsm0_receive(struct gsm_mux
 			}
 			gsm->count = 0;
 			if (!gsm->len)
-				gsm->state = GSM_FCS;
+				gsm->state = GSM0_FCS;
 			else
-				gsm->state = GSM_DATA;
+				gsm->state = GSM0_DATA;
 			break;
 		}
-		gsm->state = GSM_LEN1;
+		gsm->state = GSM0_LEN1;
 		break;
-	case GSM_LEN1:
+	case GSM0_LEN1:
 		gsm->fcs = gsm_fcs_add(gsm->fcs, c);
 		len = c;
 		gsm->len |= len << 7;
@@ -2907,11 +2934,11 @@ static void gsm0_receive(struct gsm_mux
 		}
 		gsm->count = 0;
 		if (!gsm->len)
-			gsm->state = GSM_FCS;
+			gsm->state = GSM0_FCS;
 		else
-			gsm->state = GSM_DATA;
+			gsm->state = GSM0_DATA;
 		break;
-	case GSM_DATA:		/* Data */
+	case GSM0_DATA:		/* Data */
 		gsm->buf[gsm->count++] = c;
 		if (gsm->count >= MAX_MRU) {
 			gsm->bad_size++;
@@ -2922,14 +2949,14 @@ static void gsm0_receive(struct gsm_mux
 				gsm->fcs = gsm_fcs_add_block(gsm->fcs, gsm->buf,
 							     gsm->count);
 			}
-			gsm->state = GSM_FCS;
+			gsm->state = GSM0_FCS;
 		}
 		break;
-	case GSM_FCS:		/* FCS follows the packet */
+	case GSM0_FCS:		/* FCS follows the packet */
 		gsm->fcs = gsm_fcs_add(gsm->fcs, c);
-		gsm->state = GSM_SSOF;
+		gsm->state = GSM0_SSOF;
 		break;
-	case GSM_SSOF:
+	case GSM0_SSOF:
 		gsm->state = GSM_SEARCH;
 		if (c == GSM0_SOF)
 			gsm_queue(gsm);
@@ -2943,6 +2970,29 @@ static void gsm0_receive(struct gsm_mux
 }
 
 /**
+ * gsm1_receive_state_check_and_fix	-	check and correct receive state
+ * @gsm: gsm data for this ldisc instance
+ *
+ * Ensures that the current receive state is valid for advanced option mode.
+ */
+
+static void gsm1_receive_state_check_and_fix(struct gsm_mux *gsm)
+{
+	switch (gsm->state) {
+	case GSM_SEARCH:
+	case GSM1_START:
+	case GSM1_ADDRESS:
+	case GSM1_CONTROL:
+	case GSM1_DATA:
+	case GSM1_OVERRUN:
+		break;
+	default:
+		gsm->state = GSM_SEARCH;
+		break;
+	}
+}
+
+/**
  *	gsm1_receive	-	perform processing for non-transparency
  *	@gsm: gsm data for this ldisc instance
  *	@c: character
@@ -2952,6 +3002,7 @@ static void gsm0_receive(struct gsm_mux
 
 static void gsm1_receive(struct gsm_mux *gsm, u8 c)
 {
+	gsm1_receive_state_check_and_fix(gsm);
 	/* handle XON/XOFF */
 	if ((c & ISO_IEC_646_MASK) == XON) {
 		gsm->constipated = true;
@@ -2964,11 +3015,11 @@ static void gsm1_receive(struct gsm_mux
 	}
 	if (c == GSM1_SOF) {
 		/* EOF is only valid in frame if we have got to the data state */
-		if (gsm->state == GSM_DATA) {
+		if (gsm->state == GSM1_DATA) {
 			if (gsm->count < 1) {
 				/* Missing FSC */
 				gsm->malformed++;
-				gsm->state = GSM_START;
+				gsm->state = GSM1_START;
 				return;
 			}
 			/* Remove the FCS from data */
@@ -2984,14 +3035,14 @@ static void gsm1_receive(struct gsm_mux
 			gsm->fcs = gsm_fcs_add(gsm->fcs, gsm->buf[gsm->count]);
 			gsm->len = gsm->count;
 			gsm_queue(gsm);
-			gsm->state  = GSM_START;
+			gsm->state  = GSM1_START;
 			return;
 		}
 		/* Any partial frame was a runt so go back to start */
-		if (gsm->state != GSM_START) {
+		if (gsm->state != GSM1_START) {
 			if (gsm->state != GSM_SEARCH)
 				gsm->malformed++;
-			gsm->state = GSM_START;
+			gsm->state = GSM1_START;
 		}
 		/* A SOF in GSM_START means we are still reading idling or
 		   framing bytes */
@@ -3012,30 +3063,30 @@ static void gsm1_receive(struct gsm_mux
 		gsm->escape = false;
 	}
 	switch (gsm->state) {
-	case GSM_START:		/* First byte after SOF */
+	case GSM1_START:		/* First byte after SOF */
 		gsm->address = 0;
-		gsm->state = GSM_ADDRESS;
+		gsm->state = GSM1_ADDRESS;
 		gsm->fcs = INIT_FCS;
 		fallthrough;
-	case GSM_ADDRESS:	/* Address continuation */
+	case GSM1_ADDRESS:	/* Address continuation */
 		gsm->fcs = gsm_fcs_add(gsm->fcs, c);
 		if (gsm_read_ea(&gsm->address, c))
-			gsm->state = GSM_CONTROL;
+			gsm->state = GSM1_CONTROL;
 		break;
-	case GSM_CONTROL:	/* Control Byte */
+	case GSM1_CONTROL:	/* Control Byte */
 		gsm->fcs = gsm_fcs_add(gsm->fcs, c);
 		gsm->control = c;
 		gsm->count = 0;
-		gsm->state = GSM_DATA;
+		gsm->state = GSM1_DATA;
 		break;
-	case GSM_DATA:		/* Data */
+	case GSM1_DATA:		/* Data */
 		if (gsm->count > gsm->mru || gsm->count > MAX_MRU) {	/* Allow one for the FCS */
-			gsm->state = GSM_OVERRUN;
+			gsm->state = GSM1_OVERRUN;
 			gsm->bad_size++;
 		} else
 			gsm->buf[gsm->count++] = c;
 		break;
-	case GSM_OVERRUN:	/* Over-long - eg a dropped SOF */
+	case GSM1_OVERRUN:	/* Over-long - eg a dropped SOF */
 		break;
 	default:
 		pr_debug("%s: unhandled state: %d\n", __func__, gsm->state);


