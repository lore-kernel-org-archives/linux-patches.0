Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B364B3209;
	Thu, 13 Jun 2024 12:27:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718281659; cv=none; b=jXfJc9rCIh8ngehCM7Sh0t43k6Ibv4rwgX5E96UoXdXAeHcNUuP8hZJwqR3H4GCPJUgS+Z04qe4tkg1m4vKCBl+d5xNLMR2TadhKeTwHmu8JzEV9vqbM+B2ltJLNYDijyVHbCxzTfGT+kynu+Lkw9mvNy5yKvdxCMOlnbmUYW4k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718281659; c=relaxed/simple;
	bh=KpFA9/1QxwI2qVzr/AwYff2Y1rXapmFH/VlFbVWoa5A=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=U7HIFk7C7x+hXeFl5Lppyt8RFxux/qxcz8EU05faj1WUZz2gzKznSQqGi9d9F7dsRDbpkeVCQbyJnzoPaRiDblLBYAd2O9CUoHEUmz1+Wi1ID+gnu37YchnZmVepCxYh/vaDzJ9pZxTgsVn/emk8vZRsFsjkRQ/0qyKsqW1U19c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=VaR2sKA5; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="VaR2sKA5"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3C35CC2BBFC;
	Thu, 13 Jun 2024 12:27:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1718281659;
	bh=KpFA9/1QxwI2qVzr/AwYff2Y1rXapmFH/VlFbVWoa5A=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=VaR2sKA5K778+KKpHC3St4Xk8qor6f5MGG42Ha56/zzA40wZKCgxYizI2i2bRwFbK
	 PShbAuhwNjv5pqinDjkNSKIkYe5XFzVR4U44naZQSU8jCi8/feJ/FCTfYDGRhfAlr2
	 FQsMUWR7ucvMtoms155fh6l5ZMlWLOS8siXK+Yt0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	j51569436@gmail.com,
	Daniel Starke <daniel.starke@siemens.com>
Subject: [PATCH 5.15 002/402] tty: n_gsm: fix possible out-of-bounds in gsm0_receive()
Date: Thu, 13 Jun 2024 13:29:19 +0200
Message-ID: <20240613113302.218306394@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240613113302.116811394@linuxfoundation.org>
References: <20240613113302.116811394@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
@@ -2228,7 +2228,10 @@ static void gsm0_receive(struct gsm_mux
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
@@ -2341,7 +2344,7 @@ static void gsm1_receive(struct gsm_mux
 		gsm->state = GSM_DATA;
 		break;
 	case GSM_DATA:		/* Data */
-		if (gsm->count > gsm->mru) {	/* Allow one for the FCS */
+		if (gsm->count > gsm->mru || gsm->count > MAX_MRU) {	/* Allow one for the FCS */
 			gsm->state = GSM_OVERRUN;
 			gsm->bad_size++;
 		} else


