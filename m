Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795060756;
	b=Qwx6WjJeK0zryR5ny+Ifbw3fEjY1wFkAhxynUE6kkK8EhBJb1xZt5IUrSBeizvON7Xev
	 P/2Xrhu687SXsJA1U5Go/vrsbbQZqzXgICjIq3/dzJArpmFFlaCO6JDcXlaEJYYlO8Btg
	 Qj2p5LylIl7KSs+81o0XiSz4XYgkB4rQqt2mA3HIHJPF2KgVaV+ToisMWYWi4/loNnmDu
	 d1zAkE5OI/4VQUSuQmesXMjMhOt5Wg93yNKUkVHgCV5FOQcaHG7mOo5jWExP0yAAx+dpg
	 E7EaMzK+iVx7TrBdwc03oSIKJBQuQqhaTkZCCVTnsiulJqJH61660WC6JeQtvmt7vcw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795060756;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=k7OI175m6H7OL263NTgRLmMVkDrRQdF1OF6lbaUjreo=;
	b=LmAHsgWFbXYfowLO0Slf/1e1Hi97v4yw7vk3VcLpQItd26w+vMGe/35Jqiejr3GR5eKZ
	 ASDkrznn1oJ7bjbcT7X9TvX+d+Oy7CzjlMHvwle4jg0ZT4oZosli5oR8kT/Fjn20haX1o
	 Cqv932OyUXqJsrvtXmJytNLKvl1L7bD3zeULhdWijLiqYt2rSkjS6a11D1Sio0ILKQSCo
	 HJHZd6DWm16LWhc5eKBs3cMrkCdBYQMgW13HEH4bMUE2BrA30EQRZDY4d5LjJ0sDUd1Xs
	 7xWr+mXz+aSoKED9hciSPGr2G0KdVB5koV/o1ZsiOvn4B2+rS1/gZB3ig7W1t7KcxEg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=dFtFXS2x;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EE7C8606A320;
	Thu, 19 Nov 2026 03:59:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=dFtFXS2x
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 74FC11F000C4;
	Thu, 19 Nov 2026 03:59:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795060755;
	bh=k7OI175m6H7OL263NTgRLmMVkDrRQdF1OF6lbaUjreo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=dFtFXS2xkeySz/c+FOG0VnGQTWtsrbpaf28oEGOt11UlgBuOeBDzinfMC59tUyn97
	 JxQ4YpOkwwXH9nLuE6v/2+ZIRt6vQlWiQ7BVOmmfo5r9lcBq3E8ZVzUgc7NI4h6SGh
	 h7nQcJHuKbfkyyREbV2HnBdV4pCeKIABs6T5F8Nc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Finn Thain <fthain@linux-m68k.org>,
	Stan Johnson <userm57@yahoo.com>,
	Jens Axboe <axboe@kernel.dk>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 1313/1848] swim: Check for CRC errors
Date: Wed, 18 Nov 2026 15:55:51 +0100
Message-ID: <20261118150014.423179605@linuxfoundation.org>
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

[ Upstream commit 01bff87152e6748fbac9ccd645d3d5f490d75ddc ]

After reading either the sector header or sector data, examine that flag
in the handshake register which holds the result of the CRC calculation.
CRC validation has to take place with the last byte still in the FIFO.
This flag can't be checked by the caller because by then all bytes will
have been retrieved from the FIFO. Return an error code when appropriate.

Fixes: 8852ecd97488 ("m68k: mac - Add SWIM floppy support")
Signed-off-by: Finn Thain <fthain@linux-m68k.org>
Tested-by: Stan Johnson <userm57@yahoo.com>
Link: https://patch.msgid.link/9bfcd0414192d1b95803c16701d62732ff6e8f3f.1788513997.git.fthain@linux-m68k.org
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/block/swim_asm.S | 10 ++++++++++
 1 file changed, 10 insertions(+)

diff --git a/drivers/block/swim_asm.S b/drivers/block/swim_asm.S
index 208622ac4aeb9..250e408060e8b 100644
--- a/drivers/block/swim_asm.S
+++ b/drivers/block/swim_asm.S
@@ -42,6 +42,8 @@
 	.equ	max_retry, 40
 	.equ	sector_size, 512
 
+	.equ	.Lhr_crc_error,		0x02
+
 	.global swim_read_sector_header
 swim_read_sector_header:
 	link	%a6, #0
@@ -134,6 +136,10 @@ crc1:	tstb	%a2@
 
 	moveb	%a3@, %a4@(o_crc1)
 
+	moveb	%a2@, %d5
+	andb	#.Lhr_crc_error, %d5
+	bne	signal_nonyb
+
 	tstb	%a3@(read_error - read_mark)
 
 	moveq	#0, %d0
@@ -226,6 +232,10 @@ data_crc1:
 
 	moveb	%a3@, %d5
 
+	moveb	%a2@, %d5
+	andb	#.Lhr_crc_error, %d5
+	bne	data_exit
+
 	tstb	%a3@(read_error - read_mark)
 
 	moveb	#0x18, %a3@(write_mode0 - read_mark)
-- 
2.53.0



