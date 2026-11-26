Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795704739;
	b=sEokRUhEUFbvItoBXtk/YfJKZQULHF6LuL3rDtT2cWLMTtlFTK5VDHFNHBdRANbcjWXF
	 0A+SS6iEUtV9pmwn0tgCbsieyqNLzSnxOvEdTlbwD+duY46GT4/h8PYhLTq1JlVZPouZF
	 OvsTn2SSxwJW15GnX4YSo5qIKq7aLUuB+UUGa8Dpc4hsLBNG7zJLwhFoY5uEYvDJMnIln
	 9gGq11XxGfv3UjR6HeRSQAuNogWh0gPnToo4mV7AdEv9nx1qoPCo5yzDemklyXfIDqF8/
	 XlWMsD2XGFZWit1BhdX4kH4xa+nViBAmNfpSAaX2ewry7uowm9ikVV2xt7CjNg0UQ8Q==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795704739;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=WwWCL2ExirB3FRjDVJO5mE9tP39TqzW2Et05ibDdHfQ=;
	b=Bb+K1iQFGPyUMPyUnmikba1VmoCo1gnB32cmyY/CG72xSlY2Zlcerpo2C7Vaq391xHpQ
	 RLwQSncMkvObb2BHagfJXMm0AsuixGucxwIahpdwOfo/zIJHxRumWE8jq+ReFAWH5un+x
	 g28hlM4tMC9lY9noNW0RkLxSUg5oqqvFN9pCohAWPApeJEl8d9ojdSC1m0Oa49qKgtbG7
	 a34i9fawZCv4WdC5X8spn6s2u+MLvyd/2dBZTI25ARqBcreSdI7gIkWrgrOlM//KSHM5h
	 SySVxbNYgY0H24yMoctABIZA+O5+ejVn7qDKwiSIy+2t5EE+6mZkhHQCmB/s8wtHqSQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=KiNGge6T;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 66E82606A32D;
	Thu, 26 Nov 2026 14:52:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=KiNGge6T
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8DB301F000D8;
	Thu, 26 Nov 2026 14:52:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795704739;
	bh=WwWCL2ExirB3FRjDVJO5mE9tP39TqzW2Et05ibDdHfQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=KiNGge6TK030Dlt820BXwj3cl2Maq/mS0bzQqXFHzflTjkRQKuLm2d5MUfGqzVUp9
	 c3wkWrtOfkE47PIzdZOvw0MAKbbo7mfMujWfmRs4qaYaealu7X+k+iBq4E/JaKLaJN
	 vZN7/g1RBEAmdpaE7ScxORR6CEWYgOdEN1QQ8SDM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	syzbot+782b2f1063e38ba8fa6e@syzkaller.appspotmail.com,
	stable <stable@kernel.org>,
	Brian Ellis <brianellis@gotenna.com>
Subject: [PATCH 5.10 226/265] usb: gadget: u_serial: fix NULL deref in gs_close() after failed open
Date: Thu, 26 Nov 2026 15:39:16 +0100
Message-ID: <20261126143621.061863472@linuxfoundation.org>
X-Mailer: git-send-email 2.56.1
In-Reply-To: <20261126143605.076581697@linuxfoundation.org>
References: <20261126143605.076581697@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Brian Ellis <brianellis@gotenna.com>

commit ea6cf69ad03c8d85138830c0d2c3b946b5ae231d upstream.

gs_close() opens with

	struct gs_port *port = tty->driver_data;
	...
	spin_lock_irq(&port->port_lock);

and never checks port.  gs_open() assigns tty->driver_data only on the
port.count 0 -> 1 edge, so any failure earlier in gs_open() leaves it NULL,
and tty_open() calls tty_release(), and hence ->close(), when ->open()
fails.

syzbot hit exactly this on arm64.  Fault injection failed the kfifo_alloc()
of the write buffer in gs_open():

   __kfifo_alloc_node+0x10c/0x208 lib/kfifo.c:44
   gs_open+0x144/0x514 drivers/usb/gadget/function/u_serial.c:636
   tty_open+0x404/0x89c drivers/tty/tty_io.c:2137

and the tty core's close of the failed open then took port_lock through
the NULL port:

  BUG: unable to handle kernel paging request in gs_close
  KASAN: null-ptr-deref in range [0x00000000000003a0-0x00000000000003a7]
  Call trace:
   spin_lock_irq include/linux/spinlock.h:372 [inline]
   gs_close+0xac/0x65c drivers/usb/gadget/function/u_serial.c:698
   tty_release+0x2c4/0xffc drivers/tty/tty_io.c:1745
   tty_open+0x46c/0x89c drivers/tty/tty_io.c:2146

Return early instead.  There is nothing to release when the open never got
far enough to claim the port.

Unlike the check reverted by commit f6c7bc4a6823 ("Revert "usb: gadget:
u_serial: Add null pointer check in gs_start_io""), this is not hiding a
race: the tty core calls ->close() for an ->open() that failed by design,
so driver_data is legitimately unset on that path.

Fixes: c1dca562be8a ("usb gadget: split out serial core")
Reported-by: syzbot+782b2f1063e38ba8fa6e@syzkaller.appspotmail.com
Closes: https://syzkaller.appspot.com/bug?extid=782b2f1063e38ba8fa6e
Cc: stable <stable@kernel.org>
Assisted-by: LLM
Signed-off-by: Brian Ellis <brianellis@gotenna.com>
Link: https://patch.msgid.link/20261013-u_serial-gs-close-null-v4-1-9ea038501994@gotenna.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/usb/gadget/function/u_serial.c |    3 +++
 1 file changed, 3 insertions(+)

--- a/drivers/usb/gadget/function/u_serial.c
+++ b/drivers/usb/gadget/function/u_serial.c
@@ -680,6 +680,9 @@ static void gs_close(struct tty_struct *
 	struct gs_port *port = tty->driver_data;
 	struct gserial	*gser;
 
+	if (!port)
+		return;
+
 	spin_lock_irq(&port->port_lock);
 
 	if (port->port.count != 1) {


