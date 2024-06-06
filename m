Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 64AF119E7E1;
	Thu,  6 Jun 2024 14:11:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717683108; cv=none; b=pSHZd3D4JJ5f1vYpNNSDy3Rk/XnQtf1jFo7yXPAhhXMRlDZRQZipCn8shFmSgwuzau3uOdP2GQ/KTms9RDIpihUX0SJePhTediVX7KZLiuHeE40isAFCGS+4HWCci1XOTj9hgitbg62xmCQGbcAz2KhybZv/gI1ZOxvZepOnfmI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717683108; c=relaxed/simple;
	bh=eJkbrqBJUM/MaejNX+P7lCKdaAG+8p+Sk+KHsBvgSug=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=POLR46524EHST4HypAWU0hYxcG7ZmhEW+bXSjDfTXgJgQn85U4TA7V5vIEzOIUBdBFxnUfOMjzstwU/uwzutTsEiLTVAIq8ZkVgtOHTJ/haoD+b3P/dBc9050h+lXBQ6enUS1XIgvl9/u11LZ6UNjena2gFG3p++008DQBWipdA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=uMRLtgrD; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="uMRLtgrD"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 44505C32781;
	Thu,  6 Jun 2024 14:11:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1717683108;
	bh=eJkbrqBJUM/MaejNX+P7lCKdaAG+8p+Sk+KHsBvgSug=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=uMRLtgrD6I8SfszjMswpL/QFrlFDrfcvowzVE1hz1YW/2+qf4Xc147p9/CLpesxBp
	 5hBz6dIj8R1qAqayyuMk5wReeDDRIX3is+PE9wUM4mjmCVdUanOvFNCSw7uDu6p5Qz
	 alqgatgGy70H7e6cxtpgwxnri8x6HPGjy4J1Jo5E=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	j51569436@gmail.com,
	Daniel Starke <daniel.starke@siemens.com>
Subject: [PATCH 6.6 004/744] tty: n_gsm: fix possible out-of-bounds in gsm0_receive()
Date: Thu,  6 Jun 2024 15:54:36 +0200
Message-ID: <20240606131732.591765605@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240606131732.440653204@linuxfoundation.org>
References: <20240606131732.440653204@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
@@ -2912,7 +2912,10 @@ static void gsm0_receive(struct gsm_mux
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
@@ -3025,7 +3028,7 @@ static void gsm1_receive(struct gsm_mux
 		gsm->state = GSM_DATA;
 		break;
 	case GSM_DATA:		/* Data */
-		if (gsm->count > gsm->mru) {	/* Allow one for the FCS */
+		if (gsm->count > gsm->mru || gsm->count > MAX_MRU) {	/* Allow one for the FCS */
 			gsm->state = GSM_OVERRUN;
 			gsm->bad_size++;
 		} else


