Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 57141223323;
	Mon,  2 Jun 2025 14:21:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748874103; cv=none; b=MWZ9atxKb3iTSVwqCHsqrBqn1nHekZO8oo9EF2e8GSCvhU8q/GCEmyr0wkwrM38v96Rey5apOsEqD3TTh3nGfkODTwe7+vueMki+mtF/dWG+yyEWwsUE/XNK1RC3fg6jJB9nnLgV6dtUQHDz/DAHUC2W82ckJY2EVl9KvPdiOCE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748874103; c=relaxed/simple;
	bh=OeNFQToHLiHxmbmuW8xeabQm0Mrx8cT/bZ8vIfgw9PU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=h4rDFRmojpDgWOFmueocTWQDIEd9xfueh1wl1Zer0E16oo6VaaYYbCuTE4UEPwpZl7CnZk8IhtThHsXey6SRJCaZsQw19+RtRoNXLS7kSDAo4+lyqK648llMbn0ep11PPnQmUoosRLfo060+dlOgryiv0EjDhksYA/O1S1zAvhE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=HoTvMfks; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="HoTvMfks"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DAEA9C4CEEB;
	Mon,  2 Jun 2025 14:21:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1748874103;
	bh=OeNFQToHLiHxmbmuW8xeabQm0Mrx8cT/bZ8vIfgw9PU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=HoTvMfksuv7amgfFew6hk6BA8SZ9ZdMDTTvUl2GYR3Sd/pfCv4X7I7SBtzE/hoHx9
	 6R8ugKmKzF+MiL3SuaUXxYCiXiqmgn1G/dGLFkz702KGgTrXKqmMyrFTlbatoKBbdd
	 vdgBK8WNFoVIzCVl5gswf8gfnaU/B42xtlOy2/h8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Carlos Sanchez <carlossanchez@geotab.com>,
	Vincent Mailhol <mailhol.vincent@wanadoo.fr>,
	Marc Kleine-Budde <mkl@pengutronix.de>
Subject: [PATCH 6.6 358/444] can: slcan: allow reception of short error messages
Date: Mon,  2 Jun 2025 15:47:02 +0200
Message-ID: <20250602134355.455139723@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250602134340.906731340@linuxfoundation.org>
References: <20250602134340.906731340@linuxfoundation.org>
User-Agent: quilt/0.68
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

From: Carlos Sanchez <carlossanchez@geotab.com>

commit ef0841e4cb08754be6cb42bf97739fce5d086e5f upstream.

Allows slcan to receive short messages (typically errors) from the serial
interface.

When error support was added to slcan protocol in
b32ff4668544e1333b694fcc7812b2d7397b4d6a ("can: slcan: extend the protocol
with error info") the minimum valid message size changed from 5 (minimum
standard can frame tIII0) to 3 ("e1a" is a valid protocol message, it is
one of the examples given in the comments for slcan_bump_err() ), but the
check for minimum message length prodicating all decoding was not adjusted.
This makes short error messages discarded and error frames not being
generated.

This patch changes the minimum length to the new minimum (3 characters,
excluding terminator, is now a valid message).

Signed-off-by: Carlos Sanchez <carlossanchez@geotab.com>
Fixes: b32ff4668544 ("can: slcan: extend the protocol with error info")
Reviewed-by: Vincent Mailhol <mailhol.vincent@wanadoo.fr>
Link: https://patch.msgid.link/20250520102305.1097494-1-carlossanchez@geotab.com
Cc: stable@vger.kernel.org
Signed-off-by: Marc Kleine-Budde <mkl@pengutronix.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/can/slcan/slcan-core.c |   26 ++++++++++++++++++++------
 1 file changed, 20 insertions(+), 6 deletions(-)

--- a/drivers/net/can/slcan/slcan-core.c
+++ b/drivers/net/can/slcan/slcan-core.c
@@ -71,12 +71,21 @@ MODULE_AUTHOR("Dario Binacchi <dario.bin
 #define SLCAN_CMD_LEN 1
 #define SLCAN_SFF_ID_LEN 3
 #define SLCAN_EFF_ID_LEN 8
+#define SLCAN_DATA_LENGTH_LEN 1
+#define SLCAN_ERROR_LEN 1
 #define SLCAN_STATE_LEN 1
 #define SLCAN_STATE_BE_RXCNT_LEN 3
 #define SLCAN_STATE_BE_TXCNT_LEN 3
-#define SLCAN_STATE_FRAME_LEN       (1 + SLCAN_CMD_LEN + \
-				     SLCAN_STATE_BE_RXCNT_LEN + \
-				     SLCAN_STATE_BE_TXCNT_LEN)
+#define SLCAN_STATE_MSG_LEN     (SLCAN_CMD_LEN +		\
+                                 SLCAN_STATE_LEN +		\
+                                 SLCAN_STATE_BE_RXCNT_LEN +	\
+                                 SLCAN_STATE_BE_TXCNT_LEN)
+#define SLCAN_ERROR_MSG_LEN_MIN (SLCAN_CMD_LEN +	\
+                                 SLCAN_ERROR_LEN +	\
+                                 SLCAN_DATA_LENGTH_LEN)
+#define SLCAN_FRAME_MSG_LEN_MIN (SLCAN_CMD_LEN +	\
+                                 SLCAN_SFF_ID_LEN +	\
+                                 SLCAN_DATA_LENGTH_LEN)
 struct slcan {
 	struct can_priv         can;
 
@@ -176,6 +185,9 @@ static void slcan_bump_frame(struct slca
 	u32 tmpid;
 	char *cmd = sl->rbuff;
 
+	if (sl->rcount < SLCAN_FRAME_MSG_LEN_MIN)
+		return;
+
 	skb = alloc_can_skb(sl->dev, &cf);
 	if (unlikely(!skb)) {
 		sl->dev->stats.rx_dropped++;
@@ -281,7 +293,7 @@ static void slcan_bump_state(struct slca
 		return;
 	}
 
-	if (state == sl->can.state || sl->rcount < SLCAN_STATE_FRAME_LEN)
+	if (state == sl->can.state || sl->rcount != SLCAN_STATE_MSG_LEN)
 		return;
 
 	cmd += SLCAN_STATE_BE_RXCNT_LEN + SLCAN_CMD_LEN + 1;
@@ -328,6 +340,9 @@ static void slcan_bump_err(struct slcan
 	bool rx_errors = false, tx_errors = false, rx_over_errors = false;
 	int i, len;
 
+	if (sl->rcount < SLCAN_ERROR_MSG_LEN_MIN)
+		return;
+
 	/* get len from sanitized ASCII value */
 	len = cmd[1];
 	if (len >= '0' && len < '9')
@@ -456,8 +471,7 @@ static void slcan_bump(struct slcan *sl)
 static void slcan_unesc(struct slcan *sl, unsigned char s)
 {
 	if ((s == '\r') || (s == '\a')) { /* CR or BEL ends the pdu */
-		if (!test_and_clear_bit(SLF_ERROR, &sl->flags) &&
-		    sl->rcount > 4)
+		if (!test_and_clear_bit(SLF_ERROR, &sl->flags))
 			slcan_bump(sl);
 
 		sl->rcount = 0;


