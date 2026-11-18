Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795060772;
	b=gHWU7fth1elJAud6E7BhgSb+jN2P4RQiMX3JXM9yucznEBjQfbyjGB5MFZYq5wehtTy8
	 nYJXCx850dP/uwnt1R+PzNfHp4aD/kHsGO1Zl7zSw3iDytgPUZ6atJYFjeHgYe9wXVgMX
	 wX2ayDQUbs10PRLhLWADZXUGamOq2UnagZpgGOBKcGuYB9uRjvNO1v3bCerc3vytWymsd
	 fIQhfu72bAMSW5z2pMoBhujJbkxYPkFWNbP0xnPUA+5EqRvm7LM3207Jrbmb8S0TBdAFc
	 kW3Vz0JucsvqoGMJ89zZwzg1nEmxZeClm1xRq3zol3enmrJOB9h7Qw5rBVEFxJlAUfA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795060772;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=5lRtfbhIc2AbQYhxIH28NF40P3ESuQh7jKbqRKcjQQI=;
	b=QEF2lIbtrJrmW75je5sFQe2RC/W1UemxKQtyWjkbI+bMw6Wr4r3PAFWGAvowfA4TAkJl
	 FOxBgBaDF+A7ynotp3y9kO5n0pVDYnpmDbhXEUKFUVvwdI/S1neCNj+hDpx9NBnXsB8Mh
	 tt29jF/dQw+vSChKuH1Z2JDapiYtkbo3bbMHpbljU9h0YvkhPrOghxoOIk4iGbISF585o
	 4Un5QAPnDXtpqFRGJ7FvM5f4oZVb6KI8R3X9+IMTYDlEmq/J2aDFFUBIoj/wMh9wJ62a6
	 p0EI2J1H9L9ebajmur/NaaFvMWW9RmRkm/1fOm78DhyXTPBSJfpqL6E1/baXMfld4GA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=vo44NR72;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9EC29606A325;
	Thu, 19 Nov 2026 03:59:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=vo44NR72
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 03A6A1F000C4;
	Thu, 19 Nov 2026 03:59:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795060772;
	bh=5lRtfbhIc2AbQYhxIH28NF40P3ESuQh7jKbqRKcjQQI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=vo44NR729ihw5mfjRFBzti47U+Z2YFC7l9LYlxw2z7LQl75M5plF63p99I+6wDsTj
	 nstzxptKRG4/9SlZeHyXjWoQ2imftVq21juLiePXaZipGYuLErTJgNldWCFsFZ0rGz
	 FUOC3B+38aIJPlc7HGs5RjNw4GQkXoEDopszME/g=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Finn Thain <fthain@linux-m68k.org>,
	Stan Johnson <userm57@yahoo.com>,
	Jens Axboe <axboe@kernel.dk>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 1318/1848] swim: Dont search beyond the first data mark
Date: Wed, 18 Nov 2026 15:55:56 +0100
Message-ID: <20261118150014.734787827@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118145911.150052362@linuxfoundation.org>
References: <20261118145911.150052362@linuxfoundation.org>
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

From: Finn Thain <fthain@linux-m68k.org>

[ Upstream commit 79eafa4ccb74be023fd2cae87d75425d6eb903bb ]

The ISM chip does an automatic MFM gap/sync search when the Action bit
is first set. That search may stop at any of a) post-index gap, b) address
field gap or c) data field gap. To find the next sector header, the
driver need not search at all. It only has to validate the mark bytes.

Once the sector address mark has been validated, swim_read_sector_data()
is called to read the sector contents. Between the sector address and
data fields lies an intra-sector gap followed by a data field mark.
After this mark is validated, the 512-byte data area is read into the
IO request buffer.

Problem is, if any byte in the data field mark is mis-read, the driver
searches the whole sector and then reaches the data field mark in the
following sector. The wrong sector is then read into the buffer, and
swim_read_sector_data() returns success. The request is silently
corrupted.

The existing limit on polling loop iterations does constrain the search
distance but is inherently tied to CPU speed. This is probably the reason
why corruption was only observed on a 68030 system.

Discontinue the mark search when the mark bytes fail validation.

Fixes: 8852ecd97488 ("m68k: mac - Add SWIM floppy support")
Signed-off-by: Finn Thain <fthain@linux-m68k.org>
Tested-by: Stan Johnson <userm57@yahoo.com>
Link: https://patch.msgid.link/f6c97153faa0aceceffd3a61d85c0a82903a6b3e.1788513997.git.fthain@linux-m68k.org
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/block/swim_asm.S | 73 ++++++++++++++++++++++------------------
 1 file changed, 40 insertions(+), 33 deletions(-)

diff --git a/drivers/block/swim_asm.S b/drivers/block/swim_asm.S
index e06aadb411a14..4d6404234bf09 100644
--- a/drivers/block/swim_asm.S
+++ b/drivers/block/swim_asm.S
@@ -41,18 +41,45 @@
 	.equ	seek_time, 30000
 	.equ	max_retry, 40
 	.equ	sector_size, 512
+	.equ	.Lmark_sequence_len,	4
 
 	.equ	.Lhr_crc_error,		0x02
 	.equ	.Lhr_fifo_2bytes,	0x40
 	.equ	.Lhr_fifo_1byte,	0x80
 
+.Lmfm_mark_check:
+	/*
+	 * This subroutine reads and validates a mark byte sequence.
+	 * On entry, %a1 and %d4 shall hold the location and length (resp.)
+	 * of the mark byte array.
+	 * %a2 and %a3 shall hold the locations of the handshake and mark
+	 * registers.
+	 * Returns zero in %d1 for success.
+	 */
+
+	moveq	#-1, %d1
+	subq	#1, %d4
+	movew	#seek_time, %d2
+
+5:	tstb	%a2@
+	dbmi	%d2, 5b
+	bpl	6f
+
+	moveb	%a3@, %d3
+	cmpb	%a1@+, %d3
+	dbne	%d4, 5b
+	bne	6f
+
+	moveq	#0, %d1
+6:	rts
+
 	.global swim_read_sector_header
 swim_read_sector_header:
 	link	%a6, #0
 	moveml	%d1-%d5/%a0-%a5,%sp@-
 	movel	%a6@(0x0c), %a4
 	moveq	#-1, %d0
-	bsr	mfm_read_addrmark
+	bsr	.Lmfm_read_header
 	moveml	%sp@+, %d1-%d5/%a0-%a5
 	unlk	%a6
 	rts
@@ -62,33 +89,25 @@ sector_address_mark:
 sector_data_mark:
 	.byte	0xa1, 0xa1, 0xa1, 0xfb
 
-mfm_read_addrmark:
+.Lmfm_read_header:
 	movel	%a6@(0x08), %a3
 	lea	%a3@(read_handshake), %a2
 	lea	%a3@(read_data), %a5
 	lea	%a3@(read_mark), %a3
-	movew	#seek_time, %d2
 
-wait_header_init:
 	moveb	#0x18, %a3@(write_mode0 - read_mark)
 	moveb	#0x01, %a3@(write_mode1 - read_mark)
 	moveb	#0x01, %a3@(write_mode0 - read_mark)
 	tstb	%a3@(read_error - read_mark)
 	moveb	#0x08, %a3@(write_mode1 - read_mark)
 
-	lea	sector_address_mark, %a0
-	moveq	#3, %d1
-
-wait_addr_mark_byte:
-
-	tstb	%a2@
-	dbmi	%d2, wait_addr_mark_byte
-	bpl	signal_nonyb
+	lea	sector_address_mark, %a1
+	moveq	#.Lmark_sequence_len, %d4
+	bsr	.Lmfm_mark_check
+	tstl	%d1
+	bne	signal_nonyb
 
-	moveb	%a3@, %d3
-	cmpb	%a0@+, %d3
-	dbne	%d1, wait_addr_mark_byte
-	bne	wait_header_init
+	/* read header */
 
 	moveq	#max_retry, %d2
 
@@ -163,30 +182,18 @@ mfm_read_data:
 	lea	%a3@(read_handshake), %a2
 	lea	%a3@(read_data), %a5
 	lea	%a3@(read_mark), %a3
-	movew	#seek_time, %d2
 
-wait_data_init:
 	moveb	#0x18, %a3@(write_mode0 - read_mark)
 	moveb	#0x01, %a3@(write_mode1 - read_mark)
 	moveb	#0x01, %a3@(write_mode0 - read_mark)
 	tstb	%a3@(read_error - read_mark)
 	moveb	#0x08, %a3@(write_mode1 - read_mark)
 
-	lea	sector_data_mark, %a0
-	moveq	#3, %d1
-
-	/* wait data address mark */
-
-wait_data_mark_byte:
-
-	tstb	%a2@
-	dbmi	%d2, wait_data_mark_byte
-	bpl	data_exit
-
-	moveb	%a3@, %d3
-	cmpb	%a0@+, %d3
-	dbne	%d1, wait_data_mark_byte
-	bne	wait_data_init
+	lea	sector_data_mark, %a1
+	moveq	#.Lmark_sequence_len, %d4
+	bsr	.Lmfm_mark_check
+	tstl	%d1
+	bne	data_exit
 
 	/* read data */
 
-- 
2.53.0



