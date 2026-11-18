Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795029953;
	b=glV/qwURn9VWhBJ1psb0LS6PGdlj/yhG+cM5pL0Biedxo8meHFtw65xq49vnFEDEUixm
	 i0onyeZvlTc89GudFKAxff+SRyDpH/ekpNXKIfbVLHB5NbM5pDq1+L6ltRCwbshOX4HrW
	 gawLmG1q5a/SPAtlEyI2Ai1uyTX8C6cRWxxlmkc3zT2mZ/3HGnkeATfgqW+yRAU5F8WZK
	 GjujfQELDHTFuV2ioIY6nFb8yPGLvjQZPEw39zVKgbnqFxC2wLDyL6bf3izJ1EanPWXIr
	 urkMPvH1Cv4TIuHf+LLdH6ByVsf/wydph4ohHXMtegVsb0+zruG7x6itXoWCk6ObDXA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795029953;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=hWELkP5YD3O73p3L1767lhORnykoSFC2hWvjIUk9pQY=;
	b=ftz6pNT1IQ7OfQLaAFkWcPngT8AGRI3SS3NN3FNy+kK3g/70RKdyILfxxGY7i+FIBR3F
	 7lAadtqllnG4xSp5bEsOmnikZKi7GBxTQVuxRLE0glCZgF6XXdTw/iCJl8jsJpXnQfokm
	 e7RkJlnt2EzGLziJhuHheBO1eNDj9eTzDZ7cv3lG4YWJjgQfyP8eaoDC4rhbJhblVxKgm
	 j+x9CjiKeRXweBfsZlvZak5kOXoWs6Od/D9VIkT2v8Noyy3J8l5ciILTDWDSNx54miE2b
	 GkHTP0vD5JX/+X85LXIv1HmO5cMs/slQ6m/Eq7cbKLB+9MgY7YlTXUeyh9p8C0cXI4A==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=1IuLFon3;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D4BFB606A320;
	Wed, 18 Nov 2026 19:25:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=1IuLFon3
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 34C281F000C6;
	Wed, 18 Nov 2026 19:25:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795029953;
	bh=hWELkP5YD3O73p3L1767lhORnykoSFC2hWvjIUk9pQY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=1IuLFon3c66bGuWydiokeFDifHNSptExSSo6s/CQ1zvkgTPmWywGnmbS00TzU1IEq
	 6VV9hZ19FLijGlQ/irqg8hyYVvQk60mx6kYtHy3kImZlK8jdet4bSEsv97grySXyDm
	 jz2+AS6eKYvytoUEwElCVqvlIYaaYnjDqpw/Sq88=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Finn Thain <fthain@linux-m68k.org>,
	Stan Johnson <userm57@yahoo.com>,
	Jens Axboe <axboe@kernel.dk>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 0533/1756] swim: Fix buffer overflow
Date: Wed, 18 Nov 2026 15:44:20 +0100
Message-ID: <20261118150030.319966095@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150007.957976754@linuxfoundation.org>
References: <20261118150007.957976754@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Finn Thain <fthain@linux-m68k.org>

[ Upstream commit a54870a4ae4962acf341eb6ca010cae02af1a6ea ]

The effect of this bug can be observed as swim_read_sector_data()
inexplicably returning -5, or an error flag indicating that a mark byte
was read from the data register, or other odd behviour.

When copying bytes from the chip FIFO to the read buffer, the driver
keeps count of the remaining buffer space using register %d4. A counter
in register %d2 serves as a timeout. The driver polls (%a2), the handshake
register, until flags indicate that byte(s) have arrived in the FIFO.

        movel   #sector_size-1, %d4
read_new_data:
        movew   #max_retry, %d2
read_data_loop:
        moveb   %a2@, %d5
        andb    #0xc0, %d5
        dbne    %d2, read_data_loop
        beq     data_exit
        moveb   %a5@, %a4@+
        andb    #0x40, %d5
        dbne    %d4, read_new_data
        beq     exit_loop

Note that the exit_loop branch depends upon a flag in the handshake
register and not on the remaining buffer space. Hence there may be no
branch to exit_loop after %d4 is decremented to -1 (i.e. full buffer).

        moveb   %a5@, %a4@+
        dbra    %d4, read_new_data
exit_loop:

Here is a second decrement of %d4 which can now reach -2. But the buffer
bounds check is a comparison with -1, which is now ineffective. Hence the
loop will continue copying until %d2 eventually reaches -1.

Fix this bug by terminating the loop as soon as %d4 or %d2 reach -1.
Reset the timeout whenever a byte is copied.

Fixes: 8852ecd97488 ("m68k: mac - Add SWIM floppy support")
Signed-off-by: Finn Thain <fthain@linux-m68k.org>
Tested-by: Stan Johnson <userm57@yahoo.com>
Link: https://patch.msgid.link/d8fceda197b840f892d9b511175e824ca2549f01.1788513997.git.fthain@linux-m68k.org
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/block/swim_asm.S | 16 +++++++++-------
 1 file changed, 9 insertions(+), 7 deletions(-)

diff --git a/drivers/block/swim_asm.S b/drivers/block/swim_asm.S
index 699f7c90dd1c0..e06aadb411a14 100644
--- a/drivers/block/swim_asm.S
+++ b/drivers/block/swim_asm.S
@@ -43,6 +43,8 @@
 	.equ	sector_size, 512
 
 	.equ	.Lhr_crc_error,		0x02
+	.equ	.Lhr_fifo_2bytes,	0x40
+	.equ	.Lhr_fifo_1byte,	0x80
 
 	.global swim_read_sector_header
 swim_read_sector_header:
@@ -189,20 +191,20 @@ wait_data_mark_byte:
 	/* read data */
 
 	movel	#sector_size-1, %d4		/* sector size */
-read_new_data:
 	movew	#max_retry, %d2
 read_data_loop:
 	moveb	%a2@, %d5
-	andb	#0xc0, %d5
+	andb	#(.Lhr_fifo_1byte + .Lhr_fifo_2bytes), %d5
 	dbne	%d2, read_data_loop
 	beq	data_exit
+	moveq	#max_retry, %d2
 	moveb	%a5@, %a4@+
-	andb	#0x40, %d5
-	dbne	%d4, read_new_data
-	beq	exit_loop
+	dbra	%d4, 1f
+	bra	data_crc0
+1:	andb	#.Lhr_fifo_2bytes, %d5
+	beq	read_data_loop
 	moveb	%a5@, %a4@+
-	dbra	%d4, read_new_data
-exit_loop:
+	dbra	%d4, read_data_loop
 
 	/* read CRC */
 
-- 
2.53.0



