Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0167929BDAC;
	Tue, 26 Aug 2025 11:45:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756208726; cv=none; b=WLeSLC5sGBvw9q2mVoXHINbJWxlfc0iUT89IDbcHOgDkizn31hzWh7SJo5r062+vHz7wK4OOCOF5KwDx4Q5vLEogH3Sq+PCv9zoL+N4F8OX9Hf3B6ML56v3LH3IwF0VtYouHwZ++XrhOqxySxbwcGIQT7+NKJ1eMGbzKMsmVAOY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756208726; c=relaxed/simple;
	bh=HdwTyxcTnyQdYMrkltnFm7kmodadxvLKtk1yCpTDhEo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=LHE6iBwe0hpPr3tahQdZVHk2JJyXzFwIX4Ax8SNt8Y1CDNfDn7rLnqPOmfbGP+A2GfhbJfc+GUxHbQYCCkp6LbPc4ts2mMe8h9BemtBg01usNqC8kg2XHLbfERk/4HLIrfDIKscDajbs+F2oSfRfLwqpK+THgXui1G6sGYPRDqQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=k6KQhLDj; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="k6KQhLDj"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8F4E5C4CEF1;
	Tue, 26 Aug 2025 11:45:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1756208725;
	bh=HdwTyxcTnyQdYMrkltnFm7kmodadxvLKtk1yCpTDhEo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=k6KQhLDj90waOdtMYOX1w6fI9QpwuCwFPYYjLbh/Vo6DAMULPADKusAN22OApQprr
	 Ju0a4+KDjQh418iAt/JJBuyZSulrELdMF7vpwcpkPh7dieRbePRIfQcKvWqnKSpi/H
	 XwX29DyyVblMWqUX44fv1UroUPvii/26MjfML9Js=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ian Abbott <abbotti@mev.co.uk>,
	stable <stable@kernel.org>
Subject: [PATCH 6.12 222/322] comedi: Make insn_rw_emulate_bits() do insn->n samples
Date: Tue, 26 Aug 2025 13:10:37 +0200
Message-ID: <20250826110921.372955990@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250826110915.169062587@linuxfoundation.org>
References: <20250826110915.169062587@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Ian Abbott <abbotti@mev.co.uk>

commit 7afba9221f70d4cbce0f417c558879cba0eb5e66 upstream.

The `insn_rw_emulate_bits()` function is used as a default handler for
`INSN_READ` instructions for subdevices that have a handler for
`INSN_BITS` but not for `INSN_READ`.  Similarly, it is used as a default
handler for `INSN_WRITE` instructions for subdevices that have a handler
for `INSN_BITS` but not for `INSN_WRITE`. It works by emulating the
`INSN_READ` or `INSN_WRITE` instruction handling with a constructed
`INSN_BITS` instruction.  However, `INSN_READ` and `INSN_WRITE`
instructions are supposed to be able read or write multiple samples,
indicated by the `insn->n` value, but `insn_rw_emulate_bits()` currently
only handles a single sample.  For `INSN_READ`, the comedi core will
copy `insn->n` samples back to user-space.  (That triggered KASAN
kernel-infoleak errors when `insn->n` was greater than 1, but that is
being fixed more generally elsewhere in the comedi core.)

Make `insn_rw_emulate_bits()` either handle `insn->n` samples, or return
an error, to conform to the general expectation for `INSN_READ` and
`INSN_WRITE` handlers.

Fixes: ed9eccbe8970 ("Staging: add comedi core")
Cc: stable <stable@kernel.org> # 5.13+
Signed-off-by: Ian Abbott <abbotti@mev.co.uk>
Link: https://lore.kernel.org/r/20250725141034.87297-1-abbotti@mev.co.uk
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/comedi/drivers.c |   25 +++++++++++++------------
 1 file changed, 13 insertions(+), 12 deletions(-)

--- a/drivers/comedi/drivers.c
+++ b/drivers/comedi/drivers.c
@@ -620,11 +620,9 @@ static int insn_rw_emulate_bits(struct c
 	unsigned int chan = CR_CHAN(insn->chanspec);
 	unsigned int base_chan = (chan < 32) ? 0 : chan;
 	unsigned int _data[2];
+	unsigned int i;
 	int ret;
 
-	if (insn->n == 0)
-		return 0;
-
 	memset(_data, 0, sizeof(_data));
 	memset(&_insn, 0, sizeof(_insn));
 	_insn.insn = INSN_BITS;
@@ -635,18 +633,21 @@ static int insn_rw_emulate_bits(struct c
 	if (insn->insn == INSN_WRITE) {
 		if (!(s->subdev_flags & SDF_WRITABLE))
 			return -EINVAL;
-		_data[0] = 1U << (chan - base_chan);		     /* mask */
-		_data[1] = data[0] ? (1U << (chan - base_chan)) : 0; /* bits */
+		_data[0] = 1U << (chan - base_chan);		/* mask */
 	}
+	for (i = 0; i < insn->n; i++) {
+		if (insn->insn == INSN_WRITE)
+			_data[1] = data[i] ? _data[0] : 0;	/* bits */
+
+		ret = s->insn_bits(dev, s, &_insn, _data);
+		if (ret < 0)
+			return ret;
 
-	ret = s->insn_bits(dev, s, &_insn, _data);
-	if (ret < 0)
-		return ret;
-
-	if (insn->insn == INSN_READ)
-		data[0] = (_data[1] >> (chan - base_chan)) & 1;
+		if (insn->insn == INSN_READ)
+			data[i] = (_data[1] >> (chan - base_chan)) & 1;
+	}
 
-	return 1;
+	return insn->n;
 }
 
 static int __comedi_device_postconfig_async(struct comedi_device *dev,


