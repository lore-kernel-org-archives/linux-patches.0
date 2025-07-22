Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 910202ED855;
	Tue, 22 Jul 2025 14:10:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1753193446; cv=none; b=AmBR0aYPMUrZXST1J7dpSaomwz4w0QOqt/54rb8XTzGfdkWYA8LI79DfALLqSvjfJ1pZAxrAm/FxHo9zMPUBeH8Q9qauahLJN1CyCGALZWdSv5KofRkAc77IZQKkdO3h2WwixIIh3S9DaObkfmbKs3Yp4qpKP2smIKG7IKsGr5g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1753193446; c=relaxed/simple;
	bh=Gw3cyZjbukaHlFflL/dcQbKscGKRpvIgsYciTep5vzA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=tPE3XHgEcbDz9Wdgk9NFKD+iSeTZMmIYi1u+H1o9gAHQGi4E6WixWu9ytyTxLQfnf6fvQ1fW6mls7FI0B/fLUQDSqS7xhCyacwfSxryW1tZXg1MVbj4Fz5E3YYu5bQh8JnT36MGkLIV4Msz6wjCBoyG/s3Zu7tb9S7Dtj9WM5n8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=fsZOJUVd; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="fsZOJUVd"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B4795C4CEEB;
	Tue, 22 Jul 2025 14:10:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1753193446;
	bh=Gw3cyZjbukaHlFflL/dcQbKscGKRpvIgsYciTep5vzA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=fsZOJUVdc8AaDl75zXSg9/INL8PfeFmha9OzRVsbEQoI/zjmLlwEN+9QAoFWsp5NK
	 qasp+wis6mqYakAzrr6dquCkTXAx0dC70oMCM1Iq/JbjvBuMnisDFdkGs0n4EX0MX2
	 NxnYTfiGYuUJLS6D2Ax+nRm74Z9PrMt/AK1M/yUg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ian Abbott <abbotti@mev.co.uk>
Subject: [PATCH 6.15 094/187] comedi: Fix some signed shift left operations
Date: Tue, 22 Jul 2025 15:44:24 +0200
Message-ID: <20250722134349.262312376@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250722134345.761035548@linuxfoundation.org>
References: <20250722134345.761035548@linuxfoundation.org>
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

6.15-stable review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/comedi/drivers.c |   14 +++++++-------
 1 file changed, 7 insertions(+), 7 deletions(-)

--- a/drivers/comedi/drivers.c
+++ b/drivers/comedi/drivers.c
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


