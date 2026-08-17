Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E081C43CEC1;
	Mon, 17 Aug 2026 15:15:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786979718; cv=none; b=X2ATKmf3p2DHLw0eIvEnClWlSc++L/0dtfbsJ6CaR8I5tWk8XvwqWx7yTMyBrn51Dxqv5XKX4eeOr+OGnzrP6AymmdpBHfmRn1WiEhXHhUcS8m/bhtc0Qivnp7+CT1McH1mfLT4l+dwkVy2LSFTk01E9DJQ7/BM4Dus8k/VUBvo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786979718; c=relaxed/simple;
	bh=em0cX4IQ86HVKq3S0tREvo0OR1ZHfuJ9e4ef20HFeZM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Q4+wdijReZO1vE48kfjrfbns7fkh4/3tDEWvrwar94pM2vggO/pVFbSWkyz/1CcJMbBxyKikXQxpWBR5DP4PyLPSKScJ/52wnwCFqal7VYdolcqRpStYnOvvgo1pnd6IxVrjMlw1sdmVy9T9ORrri9kh5mccRU402vum0ec0BPU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=klvxRBFP; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="klvxRBFP"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 444A81F000E9;
	Mon, 17 Aug 2026 15:15:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1786979716;
	bh=M8g9nRIWVchPSZiaK9RKBjyA3gXT/zmABipfADa11t8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=klvxRBFPCA0mYxj9380zlM7T7/R6/J3OHF2PBAdwkfZHRgaeZDimN65vJABy4vKT/
	 49nwvU8upHdCyZOL0+xa0twobQcdssvHAnUSmpHJFhRXPgkGB2BqLxBmU1uQFcQ9y6
	 KDti8Ir6KCi1POgTknnzsr6o8IB2EHJYm8XVCvy0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jeremy Kerr <jk@codeconstruct.com.au>,
	Doruk Tan Ozturk <doruk@0sec.ai>,
	Simon Horman <horms@kernel.org>,
	Paolo Abeni <pabeni@redhat.com>
Subject: [PATCH 6.1 275/609] mctp: serial: handle zero-length frames to prevent rx buffer overflow
Date: Mon, 17 Aug 2026 15:29:31 +0200
Message-ID: <20260817132553.349974490@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260817132543.039278408@linuxfoundation.org>
References: <20260817132543.039278408@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
@@ -316,7 +316,7 @@ static void mctp_serial_push_header(stru
 		} else {
 			dev->rxlen = c;
 			dev->rxpos = 0;
-			dev->rxstate = STATE_DATA;
+			dev->rxstate = c > 0 ? STATE_DATA : STATE_TRAILER;
 			dev->rxfcs = crc_ccitt_byte(dev->rxfcs, c);
 		}
 		break;


