Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795705707;
	b=vUEyanekJfpyk/5AGGH/hXPEXm51Cj71lNh/pr1L3b/RPd/CzlrQcy7TlvDVafwnypNW
	 iwJoyJquy/DI4J+d/MD1jRhxET5DUEqur6JMKlapSKGgxkuSzqAATqaA+BTu0SR9/bO3L
	 83VfMLbnbzMIxByOOEVpWjQEFyo4tnvQpOXcgJrARFH0GYVRSrSWmQ1ODFEvVBWCfIXZW
	 XY51irVIrlIWiuHDMoIlAbNUm2nia3/hS4thBY99uwbQRR7xgnWA7H5c+AlKdQqzu2Le3
	 6qITndrqw6Rsz9hh1yPTvcb3AUHPhNbIh1JKNTiIa+AOdAqmOvqc3yfGqzOZv5DHAZA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795705707;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=z3M18nBFSWvtIXgL6csGq37hxuD4d0noHUQObovn+ys=;
	b=ZiSoc3CLl6/KqLVgZRl3C99vOK2EBl1lWVQyqra9ZZKnd3GYhS1gq7oRHX21VnaCp13h
	 00y6xKtHM2cvY6/qgJcBnwStCVagn1AJ8UjrdeeI5ojpU4Kvvph8tuek27n7OfTYRLWzK
	 2+E6QJSb1BwAWeeut2euTGh6iDZ6VBp49OYuKns6AMowMfz8ddHsL3eQ885cVsOcUk3zc
	 60IUsPmkBA+wgIvJ2IeXry19QXRr0Aw2a7Gvgi1WM104Nsp13eHNERamIQmDjhFZCUfCk
	 ZAz/EA6dXWOL2VSB4vnWcqnybZyj0xYz/P0IboEt/E4haPrERhw+HvnQV96UtxhBVIg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=bF16MSWb;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 55DDC606A326;
	Thu, 26 Nov 2026 15:08:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=bF16MSWb
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7EC9B1F000EB;
	Thu, 26 Nov 2026 15:08:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795705707;
	bh=z3M18nBFSWvtIXgL6csGq37hxuD4d0noHUQObovn+ys=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=bF16MSWbNwNrBayriOyji6hDzsHtR7NjpQ11758u/0HEmygogpka1eFqlIRS+XmNE
	 a5Nx6CXu//G3Tz1UihRojvWXn9WBtka37CNtdGhfnM3O2721pW0bC/RxVVqYTL750R
	 IoVc1MDJstcVIvbJic1grzAdO0JfkxH29hcqJhqk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Hui Peng <benquike@gmail.com>,
	Johan Hovold <johan@kernel.org>
Subject: [PATCH 5.15 288/319] USB: serial: garmin_gps: validate packet data length in nat_receive()
Date: Thu, 26 Nov 2026 15:40:56 +0100
Message-ID: <20261126144013.259869976@linuxfoundation.org>
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

From: Hui Peng <benquike@gmail.com>

commit ca783a2d55b3361493917ad4a3573715ba902503 upstream.

In nat_receive() (called from garmin_write() when userspace writes to
/dev/ttyUSBn in MODE_NATIVE mode), while garmin_data_p->insize is less
than GARMIN_PKTHDR_LENGTH (12), the loop copies up to 12 bytes into
garmin_data_p->inbuffer. Once garmin_data_p->insize reaches
GARMIN_PKTHDR_LENGTH, nat_receive() computes the total packet size as:

  len = GARMIN_PKTHDR_LENGTH + getDataLength(garmin_data_p->inbuffer);

Because getDataLength() returns a signed int from __le32_to_cpup(), a
12-byte header with a negative 32-bit length field (such as 0xfffffff5,
i.e., -11) causes len to underflow to a small positive value (12 + (-11)
= 1) without any bounds check at that point. Then garmin_data_p->insize
>= len (12 >= 1) evaluates to true and nat_receive() calls
garmin_write_bulk(port, inbuffer, 1, 0), which allocates a 1-byte slab
buffer via kmemdup() and immediately reads 4 bytes from it in
getLayerId(buffer) (and again in garmin_write_bulk_callback() when the
URB completes):

  BUG: KASAN: slab-out-of-bounds in garmin_write_bulk.constprop.0+0x3eb/0x500
  Read of size 4 at addr ffff888002cc0ba0 by task init/1
  Call Trace:
   <TASK>
   dump_stack_lvl+0x70/0xa0
   print_report+0x153/0x4c6
   kasan_report+0xf1/0x120
   garmin_write_bulk.constprop.0+0x3eb/0x500
   garmin_write+0x60f/0x1450
   serial_write+0x123/0x200
   n_tty_write+0x8ea/0xeb0
   file_tty_write.isra.0+0x44f/0x7a0
   vfs_write+0x671/0xd20

Validate the unsigned 32-bit data length (dlen >= GPS_IN_BUFSIZ -
GARMIN_PKTHDR_LENGTH, matching the existing len >= GPS_IN_BUFSIZ bound)
in nat_receive() as soon as the 12-byte header is present, resetting
insize and returning -EINVPKT on invalid lengths so garmin_write_bulk()
is only ever called with a full valid packet header (12 <= len <
GPS_IN_BUFSIZ).

Tested in QEMU against Linux 7.3.0-rc3 by emulating a Garmin USB GPS
device (091e:0003) via dummy_hcd + raw-gadget, switching /dev/ttyUSB0
to MODE_NATIVE via PRIV_PKTID_SET_MODE, and writing a 12-byte native
packet with data length 0xfffffff5: on the unfixed kernel this triggers
KASAN slab-out-of-bounds reads in garmin_write_bulk() and
garmin_write_bulk_callback(), whereas on the fixed kernel nat_receive()
rejects the packet with -EINVPKT and 0 KASAN faults.

Fixes: 1da177e4c3f4 ("Linux-2.6.12-rc2")
Cc: stable@vger.kernel.org
Assisted-by: LLM
Signed-off-by: Hui Peng <benquike@gmail.com>
[ johan: move comment and dev_dbg(); add comment about redundant check ]
Signed-off-by: Johan Hovold <johan@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/usb/serial/garmin_gps.c |   19 ++++++++++++-------
 1 file changed, 12 insertions(+), 7 deletions(-)

--- a/drivers/usb/serial/garmin_gps.c
+++ b/drivers/usb/serial/garmin_gps.c
@@ -750,11 +750,7 @@ static int nat_receive(struct garmin_dat
 			len = GARMIN_PKTHDR_LENGTH;
 
 		if (len >= GPS_IN_BUFSIZ) {
-			/* seems to be an invalid packet, ignore rest
-			   of input */
-			dev_dbg(&garmin_data_p->port->dev,
-				"%s - packet size too large: %d\n",
-				__func__, len);
+			/* should never end up here given the dlen check below */
 			garmin_data_p->insize = 0;
 			count = 0;
 			result = -EINVPKT;
@@ -773,8 +769,17 @@ static int nat_receive(struct garmin_dat
 
 		/* do we have a complete packet ? */
 		if (garmin_data_p->insize >= GARMIN_PKTHDR_LENGTH) {
-			len = GARMIN_PKTHDR_LENGTH+
-			   getDataLength(garmin_data_p->inbuffer);
+			u32 dlen = getDataLength(garmin_data_p->inbuffer);
+
+			if (dlen >= GPS_IN_BUFSIZ - GARMIN_PKTHDR_LENGTH) {
+				/* invalid packet, ignore rest of input */
+				dev_dbg(&garmin_data_p->port->dev, "%s - invalid length: %u\n",
+					__func__, dlen);
+				garmin_data_p->insize = 0;
+				result = -EINVPKT;
+				break;
+			}
+			len = GARMIN_PKTHDR_LENGTH + dlen;
 			if (garmin_data_p->insize >= len) {
 				garmin_write_bulk(garmin_data_p->port,
 						   garmin_data_p->inbuffer,


