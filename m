Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C10972FAC02;
	Tue, 26 Aug 2025 11:29:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756207775; cv=none; b=aCyc4bfNgBrUGAx2Fi61o+AaaUvd/EyyKtIfp4shqfbG3gRnY1BqNpVYOITdee1KYg8SvhN9HiEtPjwYggwKPvInuhjXcOhy49nfTwBPb6TCTPbj6a9H0DmUGRZKjD9UiqBSz0w3aLmFQAQVlLqyO5Sx36wZxzgoRvqgZLnXRdI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756207775; c=relaxed/simple;
	bh=DZL0ZvCuFC5jjLgSJ6UC4p7SwPkpyRmQETh9+VnFa+g=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=jCAyu2RtqrgpnaZrjxI1Mu1LGEsjnk0Uw8SpU22iohqmd2O1boSM+KAn3huB0GXwjWVZgqpx7d7SE+dBIETCW/Yxt6D+7Xnj/jYEGUuz2kc8e0fVg5j98tW8O+x4x+TJBqeRuLVya4J2FCrE8NIrETYsgHNHCe6LAbLiUAsbNaw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=qiY8Fge2; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="qiY8Fge2"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5130DC4CEF1;
	Tue, 26 Aug 2025 11:29:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1756207775;
	bh=DZL0ZvCuFC5jjLgSJ6UC4p7SwPkpyRmQETh9+VnFa+g=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=qiY8Fge2wh/iaCh1TmIrkAyC8a5tRnpqzgp2wWIv6dmCpUj0eTsdfje458/6cwB32
	 VN3ZoQptI4sOqIsPn0VJDnTmo5G0wB3E+/yQLDNAk3Kfe3LsHuU/teZPDNVI0zHK7d
	 gBZmXWVE3sP5vrqA4KcyoQB0R3dYX0YKDzAykJoA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ian Abbott <abbotti@mev.co.uk>,
	stable <stable@kernel.org>
Subject: [PATCH 6.16 311/457] comedi: Make insn_rw_emulate_bits() do insn->n samples
Date: Tue, 26 Aug 2025 13:09:55 +0200
Message-ID: <20250826110945.047154969@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250826110937.289866482@linuxfoundation.org>
References: <20250826110937.289866482@linuxfoundation.org>
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

6.16-stable review patch.  If anyone has any objections, please let me know.

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


