Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7CCFBDDA9;
	Mon, 27 May 2024 19:00:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1716836426; cv=none; b=hVXfDiyQfRky5wDOtC3hww7kMC81dMs4bF0Gm+gKI6qvB1T7bcv9T1GRQvOeKL6FkO8Cv/2+p1LO22HFWadUH1uS7l8dYl9w+EHB53o0RjxJGz6hkaLxAR3t6N9du8Zr1Qjtk6Pun+/9qJ9Sx7+/vqNFeKD26p5+dPrgjz60Kvw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1716836426; c=relaxed/simple;
	bh=5vW1KYp1wCvaBDwogPG4pgTatb2LENQkuqIfkC0yUnY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=fDaz0LlDmAXgvcmncmxyMHgNj6MzZGw0IOqphZDIkVBDJNBFn1TPsfJEdk4TcpzfX0/jsxeHhdBN9sl8g7NPdZmx+wpxME6HAB5e/K1I8v7/sUUgVtuEIW6TYrRRU0vKVswJHM7pWSqdtp174DzqQdxeK/ZGhv/uXgRct7BZ/Yk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=hMwvO+0a; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="hMwvO+0a"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 12F20C2BBFC;
	Mon, 27 May 2024 19:00:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1716836426;
	bh=5vW1KYp1wCvaBDwogPG4pgTatb2LENQkuqIfkC0yUnY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=hMwvO+0aaS5dL2437jiMy0+YcPCz/s/dZx0n4xXaGkRWjlAxiUGAeE7At3/37KCsq
	 9zFfEKsGwV+/IbxxPlmMHMTFpHmGDFmkRK6JVJQVnGRX0JMQo2ZP2t9LPZqghM1hlP
	 FUSW3A7p11h0pY/H7FW5iFkIeIlDtmDHOzmpDXuc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	j51569436@gmail.com,
	Daniel Starke <daniel.starke@siemens.com>
Subject: [PATCH 6.9 008/427] tty: n_gsm: fix possible out-of-bounds in gsm0_receive()
Date: Mon, 27 May 2024 20:50:55 +0200
Message-ID: <20240527185602.591947094@linuxfoundation.org>
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

commit 47388e807f85948eefc403a8a5fdc5b406a65d5a upstream.

Assuming the following:
- side A configures the n_gsm in basic option mode
- side B sends the header of a basic option mode frame with data length 1
- side A switches to advanced option mode
- side B sends 2 data bytes which exceeds gsm->len
  Reason: gsm->len is not used in advanced option mode.
- side A switches to basic option mode
- side B keeps sending until gsm0_receive() writes past gsm->buf
  Reason: Neither gsm->state nor gsm->len have been reset after
  reconfiguration.

Fix this by changing gsm->count to gsm->len comparison from equal to less
than. Also add upper limit checks against the constant MAX_MRU in
gsm0_receive() and gsm1_receive() to harden against memory corruption of
gsm->len and gsm->mru.

All other checks remain as we still need to limit the data according to the
user configuration and actual payload size.

Reported-by: j51569436@gmail.com
Closes: https://bugzilla.kernel.org/show_bug.cgi?id=218708
Tested-by: j51569436@gmail.com
Fixes: e1eaea46bb40 ("tty: n_gsm line discipline")
Cc: stable@vger.kernel.org
Signed-off-by: Daniel Starke <daniel.starke@siemens.com>
Link: https://lore.kernel.org/r/20240424054842.7741-1-daniel.starke@siemens.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/tty/n_gsm.c |    7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)

--- a/drivers/tty/n_gsm.c
+++ b/drivers/tty/n_gsm.c
@@ -2913,7 +2913,10 @@ static void gsm0_receive(struct gsm_mux
 		break;
 	case GSM_DATA:		/* Data */
 		gsm->buf[gsm->count++] = c;
-		if (gsm->count == gsm->len) {
+		if (gsm->count >= MAX_MRU) {
+			gsm->bad_size++;
+			gsm->state = GSM_SEARCH;
+		} else if (gsm->count >= gsm->len) {
 			/* Calculate final FCS for UI frames over all data */
 			if ((gsm->control & ~PF) != UIH) {
 				gsm->fcs = gsm_fcs_add_block(gsm->fcs, gsm->buf,
@@ -3026,7 +3029,7 @@ static void gsm1_receive(struct gsm_mux
 		gsm->state = GSM_DATA;
 		break;
 	case GSM_DATA:		/* Data */
-		if (gsm->count > gsm->mru) {	/* Allow one for the FCS */
+		if (gsm->count > gsm->mru || gsm->count > MAX_MRU) {	/* Allow one for the FCS */
 			gsm->state = GSM_OVERRUN;
 			gsm->bad_size++;
 		} else


