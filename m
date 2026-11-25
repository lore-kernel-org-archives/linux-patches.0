Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795623607;
	b=Cf28cdJTTinoqe4RgyKEEQJcShCmXJCtvjMg6m3ggI9UvypqZFLQMh1WjSv+QmvRBfTr
	 QsVZr/wl8CGtOdIQRnZAdgYPIvXbXCurXKpUGMMOJsRRCUg3wNSmLLglpO+ooq6N6puH/
	 OKxooMCGJihpCx2cd4RW+HCI/R9N64kegY9Z7Uo4UKEIvjSLd5fOeI/nUqa4lr5o86B+P
	 nmii4l0nB7wjJ5lhEOzF+BaeRroWtIgxsn1QuPGyxSBvqBpv1Q31Sv2IOQQ81NW/LsrCX
	 p4SiKG6fHOIzrGbLJaAdC33AeQhqdpvelKTKsWkRpnXIA4zKyjRUWfSZyVVc+gXrNQA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795623607;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=4vH13kar69Uytf64oikpgoWKXOqdxHHdynMEzZWehCU=;
	b=Lrvo+W5tccoVg1rvkoYf78TkD1MshsqpObrX3Lat9mZY0L5fiZYMTKi9w5zqXNgJ4XYY
	 ZyVzVWwKf+B4CSCvzmre+5CujeWaZ33T5EtwRoD/4poZraMIm7KDoYoT8GOT0CDTmVikO
	 Xsd8Qadsp4hgy8++T4FauAw/+swpQRa8W7mZ17Cd2Zuv0N5LUF/DJKMa2q/SwQG9tIbly
	 nWw2QwI5eG2bLpEPHhBfL19d+icQK3SIG05KSamC6EHFzFHOmBs/bE3URtxpOfkv3dRak
	 64wc4pB/yRPAVxq4RxGNgQGLX8dowjgCzglo6DoynXNdgCbvNV8U+zWUiwiNmuQxR5g==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=1CkXUY7I;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 76A9C606A32A;
	Wed, 25 Nov 2026 16:20:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=1CkXUY7I
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 604231F000F0;
	Wed, 25 Nov 2026 16:20:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795623606;
	bh=4vH13kar69Uytf64oikpgoWKXOqdxHHdynMEzZWehCU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=1CkXUY7I9CqiZQVbgralNfCJrPH7cGcY2lIjmWhHs/VGuXzQ8WaLnHOrewmSu6TXz
	 za2gYSKruNOKzx5woEegOHEesh+Ngqa8sBiNsMDp79V4d8fRXeZJyHbHlkhKYiczOg
	 9zU8mpqQStJHu/R2ltIlN2ZeR25SyHp6Ac3yfZYQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	syzbot+782b2f1063e38ba8fa6e@syzkaller.appspotmail.com,
	stable <stable@kernel.org>,
	Brian Ellis <brianellis@gotenna.com>
Subject: [PATCH 6.18 913/990] usb: gadget: u_serial: fix NULL deref in gs_close() after failed open
Date: Wed, 25 Nov 2026 15:38:00 +0100
Message-ID: <20261125143843.390318332@linuxfoundation.org>
X-Mailer: git-send-email 2.56.1
In-Reply-To: <20261125143822.072087159@linuxfoundation.org>
References: <20261125143822.072087159@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

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
@@ -695,6 +695,9 @@ static void gs_close(struct tty_struct *
 	struct gs_port *port = tty->driver_data;
 	struct gserial	*gser;
 
+	if (!port)
+		return;
+
 	spin_lock_irq(&port->port_lock);
 
 	if (port->port.count != 1) {


