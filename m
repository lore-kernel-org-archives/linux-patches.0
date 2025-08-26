Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0E444352FDA;
	Tue, 26 Aug 2025 14:06:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756217161; cv=none; b=VG2YjqIpEAZd49v2/qgrsxFHzm+1AnjWER4/KZundUGh2us/RLsohn00dsIvxknoFwp2NZZZfa/cYmqiXWLdHb6ffA7+2YnKib3ihPNm/WfnP+X/ZJrUL9AKe6+C5DXslYE5GXUa+Blfdvs1oMo8tj3BKXpT4BHkRyChImbbBW4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756217161; c=relaxed/simple;
	bh=F5fT6j/G4W7s/4ZYBxnnqhcREE8OyNY2+Vt7LqUkXo4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=PVMek8eEHj/Mwy9d7rzAPzFPZTZNNgnkgCtikIr3dSnWM2sxMwzdhcFNkc6tIkNw6G2m1n1a5LFxqQ6b8SP/DTRYsftsxGjevj76FLn9olmpRwMb5AyG4LBBzoTACgxhRt3ydl4BNAcTh0BoIDqMob5mciJH5P676H+nUCmO/4w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=BJIARO+w; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="BJIARO+w"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 997AEC4CEF1;
	Tue, 26 Aug 2025 14:06:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1756217160;
	bh=F5fT6j/G4W7s/4ZYBxnnqhcREE8OyNY2+Vt7LqUkXo4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=BJIARO+w1/manJpp7yuJd1uJI0ziNtijRIkTN1n52jb+BlKEcdykpgWHwWIDzHToX
	 YEFX/UySFn++PqhV0dJZp8EBbChUJ5WLoOcFc46ZPmMkoMwjrXfcyM/ylIpx7IUJWz
	 cev6E2fljEW/+KUzX9vkmvDcsphJf3hnyJr30kwU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ian Abbott <abbotti@mev.co.uk>
Subject: [PATCH 5.10 031/523] comedi: Fix some signed shift left operations
Date: Tue, 26 Aug 2025 13:04:01 +0200
Message-ID: <20250826110925.367159507@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250826110924.562212281@linuxfoundation.org>
References: <20250826110924.562212281@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Ian Abbott <abbotti@mev.co.uk>

commit ab705c8c35e18652abc6239c07cf3441f03e2cda upstream.

Correct some left shifts of the signed integer constant 1 by some
unsigned number less than 32.  Change the constant to 1U to avoid
shifting a 1 into the sign bit.

The corrected functions are comedi_dio_insn_config(),
comedi_dio_update_state(), and __comedi_device_postconfig().

Fixes: e523c6c86232 ("staging: comedi: drivers: introduce comedi_dio_insn_config()")
Fixes: 05e60b13a36b ("staging: comedi: drivers: introduce comedi_dio_update_state()")
Fixes: 09567cb4373e ("staging: comedi: initialize subdevice s->io_bits in postconfig")
Cc: stable@vger.kernel.org # 5.13+
Signed-off-by: Ian Abbott <abbotti@mev.co.uk>
Link: https://lore.kernel.org/r/20250707121555.65424-1-abbotti@mev.co.uk
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/staging/comedi/drivers.c |   14 +++++++-------
 1 file changed, 7 insertions(+), 7 deletions(-)

--- a/drivers/staging/comedi/drivers.c
+++ b/drivers/staging/comedi/drivers.c
@@ -339,10 +339,10 @@ int comedi_dio_insn_config(struct comedi
 			   unsigned int *data,
 			   unsigned int mask)
 {
-	unsigned int chan_mask = 1 << CR_CHAN(insn->chanspec);
+	unsigned int chan = CR_CHAN(insn->chanspec);
 
-	if (!mask)
-		mask = chan_mask;
+	if (!mask && chan < 32)
+		mask = 1U << chan;
 
 	switch (data[0]) {
 	case INSN_CONFIG_DIO_INPUT:
@@ -382,7 +382,7 @@ EXPORT_SYMBOL_GPL(comedi_dio_insn_config
 unsigned int comedi_dio_update_state(struct comedi_subdevice *s,
 				     unsigned int *data)
 {
-	unsigned int chanmask = (s->n_chan < 32) ? ((1 << s->n_chan) - 1)
+	unsigned int chanmask = (s->n_chan < 32) ? ((1U << s->n_chan) - 1)
 						 : 0xffffffff;
 	unsigned int mask = data[0] & chanmask;
 	unsigned int bits = data[1];
@@ -625,8 +625,8 @@ static int insn_rw_emulate_bits(struct c
 	if (insn->insn == INSN_WRITE) {
 		if (!(s->subdev_flags & SDF_WRITABLE))
 			return -EINVAL;
-		_data[0] = 1 << (chan - base_chan);		    /* mask */
-		_data[1] = data[0] ? (1 << (chan - base_chan)) : 0; /* bits */
+		_data[0] = 1U << (chan - base_chan);		     /* mask */
+		_data[1] = data[0] ? (1U << (chan - base_chan)) : 0; /* bits */
 	}
 
 	ret = s->insn_bits(dev, s, &_insn, _data);
@@ -709,7 +709,7 @@ static int __comedi_device_postconfig(st
 
 		if (s->type == COMEDI_SUBD_DO) {
 			if (s->n_chan < 32)
-				s->io_bits = (1 << s->n_chan) - 1;
+				s->io_bits = (1U << s->n_chan) - 1;
 			else
 				s->io_bits = 0xffffffff;
 		}


