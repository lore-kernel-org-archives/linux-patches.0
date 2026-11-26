Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795705671;
	b=2w45V41WMwAStrEpzIdJrEedRXKpFgy7ssQj5ng9tr8mvia5blEJMXFyirFHoH8qMmmv
	 8zdr9QlCgZKKNuhXw+CLtDLDl9lWGORjEqcKNkEMY74HCVEx6AiwFhjf5lHhGAIvyOcvU
	 TvYVkRL6C/4StsDwBKunjR/lksCxvClqq29za6isru71wvFAig15nYaBPfQL6VsPgnh+W
	 vDTK4E3cKP0kLzYq6E61ljP46rSetXBBmoiUMx6sEX44PMbroODUE3M2QitBVkWhLLnjk
	 4Y4fTrJ6sGG8vZK9fKXoNfWtqDg5RFXEJdnExmddA9IA7ryXMQ0lLfmxvVrTJvU+TdA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795705671;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=6Uxson0xou3RiKNASvufua8psXrYi+GhIljZe9YZO8c=;
	b=NMfs3R/22KwpZ0LcxoEsuaW2rnL8LGRXXt45+ON7m0chIcvdpKGLoIv37oAWI0fAJLhc
	 W9/Zip6eU8J7YJBHgx46VwoYCsRlo78lhVU7oG6Z9XR0Zn38Krfw7D0SqzJGUppFrrlpj
	 ze5w+Fj4BmYcgZUOKeWD630xzn02cB4Eg/Mp9y/m4IicJg5yk6tCZvY8p0QCjunUTLaeP
	 xtH4BW3E3xXHEZOHxvOQpuxNvz+BfZ/nMsuNRFrdDrr0D794NQYbE0CHLTVZ8zwBiHOQr
	 Mq5K5pHc7UlDjzRZkhKYF1XAzx14k2l4O/jw3N2mEjYLc07VwbJK3VRV2thAb5qKlCQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=kCji4LEt;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2EDA2606A333;
	Thu, 26 Nov 2026 15:07:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=kCji4LEt
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 54FE81F000E0;
	Thu, 26 Nov 2026 15:07:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795705670;
	bh=6Uxson0xou3RiKNASvufua8psXrYi+GhIljZe9YZO8c=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=kCji4LEtzyYvouExR+QC+Th9+cDNrpEVA7/3NJydSilRzfsAsnTV8LqSXho7aupL3
	 f4DW5ofOPmkbQh7P1jeRjCJkFrOB/LVymmPobbclHgmkEVmQxGb0fgW9e/mHHfMzk1
	 9rlbkM+Y/p4b/6qHdefIZSrdr72r961DxWD+5Orc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	syzbot+782b2f1063e38ba8fa6e@syzkaller.appspotmail.com,
	stable <stable@kernel.org>,
	Brian Ellis <brianellis@gotenna.com>
Subject: [PATCH 5.15 277/319] usb: gadget: u_serial: fix NULL deref in gs_close() after failed open
Date: Thu, 26 Nov 2026 15:40:45 +0100
Message-ID: <20261126144013.006459928@linuxfoundation.org>
X-Mailer: git-send-email 2.56.1
In-Reply-To: <20261126144006.732901931@linuxfoundation.org>
References: <20261126144006.732901931@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
@@ -678,6 +678,9 @@ static void gs_close(struct tty_struct *
 	struct gs_port *port = tty->driver_data;
 	struct gserial	*gser;
 
+	if (!port)
+		return;
+
 	spin_lock_irq(&port->port_lock);
 
 	if (port->port.count != 1) {


