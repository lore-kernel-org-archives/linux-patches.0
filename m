Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 465F5358373;
	Thu, 30 Jul 2026 15:49:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785426588; cv=none; b=QaFYNHydWplH2bIgAqn9tLiq/+emrl4sTpfsS81U1D6O7BIOKXqy/srsEt62HEANV0HTIW2iPYN3wyrCF1gfeM8lev6038+pIVSjDySRzc/wxXGWXsocFqAdGJrFTYYHe1siEIz+Ky1ILmgglkEGV4mKa1EojREkVGcYcD0KgnI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785426588; c=relaxed/simple;
	bh=wF5SkHfesrb/6Fvr0jOcuAvnH1N7M0tYED6ZNGXd4JI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=oJ7aC54I8GDd1z1ngiphB9FxoChl136gsJBBid/DUkjYkRzkdNnOQlKrhQW92h1ww+mEbWfLsSlhnVc75dZ0xYT8k9/sTY05x/jFrssXHnZNyxOfySYPVBnqmwbbSkW8wdm2rIqJ2j9Hp0fxDdSz11lOWaFOM/p5l9AzMawCpr4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Net6EwUA; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Net6EwUA"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9735B1F000E9;
	Thu, 30 Jul 2026 15:49:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1785426587;
	bh=f1Y4BmZC8uzyK5w0COws/9EXj+V59/ELpPEMlk1wifw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Net6EwUAWRmKTszmfjR9ZHtFEaQiesv950NPiZOxZaMSCEUY+fDTUnpPj40wZTVMC
	 6gC+yb6hzXAvobDasj6Jxk1GzN4fF3IVYv815i4g/WlJsCV8fN9Mjy8FYL7+hwngW+
	 hfPwcMTq9P9wc/HI0m8rFNYf5rZ2YWVNkRR+k2wA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jeremy Kerr <jk@codeconstruct.com.au>,
	Doruk Tan Ozturk <doruk@0sec.ai>,
	Simon Horman <horms@kernel.org>,
	Paolo Abeni <pabeni@redhat.com>
Subject: [PATCH 6.12 427/602] mctp: serial: handle zero-length frames to prevent rx buffer overflow
Date: Thu, 30 Jul 2026 16:13:39 +0200
Message-ID: <20260730141444.938047042@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260730141435.976815864@linuxfoundation.org>
References: <20260730141435.976815864@linuxfoundation.org>
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

From: Doruk Tan Ozturk <doruk@0sec.ai>

commit 793b9b729f1e8de57be8c8daf1a9838be96cabed upstream.

The MCTP serial receive state machine reads a frame length byte in
mctp_serial_push_header() case 2 and validates it upper-bound-only:

	if (c > MCTP_SERIAL_FRAME_MTU) {
		dev->rxstate = STATE_ERR;
	} else {
		dev->rxlen = c;
		dev->rxpos = 0;
		dev->rxstate = STATE_DATA;
		...
	}

A length of zero passes this check, so rxlen is set to 0 and the state
machine advances to STATE_DATA. In mctp_serial_push() STATE_DATA, the
incoming byte is stored and rxpos incremented before the terminator is
tested:

	dev->rxbuf[dev->rxpos] = c;
	dev->rxpos++;
	dev->rxstate = STATE_DATA;
	if (dev->rxpos == dev->rxlen) {
		dev->rxpos = 0;
		dev->rxstate = STATE_TRAILER;
	}

With rxlen == 0 the "rxpos == rxlen" terminator can never fire (rxpos is
already 1 on the first data byte), so subsequent bytes are written past
the end of the fixed 74-byte rxbuf, which is the last member of the
netdev private area. Every following data byte is an attacker-controlled
1-byte out-of-bounds heap write, and the overflow continues until a
frame (0x7e) or escape byte resets the parser -- effectively unbounded.

Reaching this requires CAP_NET_ADMIN to attach the N_MCTP line
discipline and bring the resulting mctpserialN netdev up, after which
the bytes arrive via the tty receive path.

Route a zero-length frame straight to STATE_TRAILER instead of
STATE_DATA. The trailer/framing bytes are still consumed, and the frame
resolves to a zero-length skb that the MCTP core rejects; the parser
never enters STATE_DATA with rxlen == 0, so the out-of-bounds write can
no longer occur.

KASAN, on a frame of 0x7e 0x01 0x00 followed by data bytes (before this
change):

  UBSAN: array-index-out-of-bounds in drivers/net/mctp/mctp-serial.c:370
  index 74 is out of range for type 'u8 [74]'
  BUG: KASAN: slab-out-of-bounds in mctp_serial_tty_receive_buf
  Write of size 1 at addr ... by task kworker/u16:0
   mctp_serial_tty_receive_buf
   tty_ldisc_receive_buf
   flush_to_ldisc
  Allocated by task 152:
   alloc_netdev_mqs
   mctp_serial_open

v2: route zero-length frames to STATE_TRAILER instead of STATE_ERR so
    the trailer/framing bytes are still consumed (Jeremy Kerr).

Found by 0sec automated security-research tooling (https://0sec.ai).
Fixes: a0c2ccd9b5ad ("mctp: Add MCTP-over-serial transport binding")
Cc: stable@vger.kernel.org
Suggested-by: Jeremy Kerr <jk@codeconstruct.com.au>
Assisted-by: 0sec:multi-model
Signed-off-by: Doruk Tan Ozturk <doruk@0sec.ai>
Reviewed-by: Simon Horman <horms@kernel.org>
Link: https://patch.msgid.link/20260715082021.46315-1-doruk@0sec.ai
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/mctp/mctp-serial.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/net/mctp/mctp-serial.c
+++ b/drivers/net/mctp/mctp-serial.c
@@ -317,7 +317,7 @@ static void mctp_serial_push_header(stru
 		} else {
 			dev->rxlen = c;
 			dev->rxpos = 0;
-			dev->rxstate = STATE_DATA;
+			dev->rxstate = c > 0 ? STATE_DATA : STATE_TRAILER;
 			dev->rxfcs = crc_ccitt_byte(dev->rxfcs, c);
 		}
 		break;


