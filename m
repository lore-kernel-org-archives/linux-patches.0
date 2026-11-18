Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795055278;
	b=MUp/OY/QIcjOhzQEWwXVDadEHhrQYhPSvjFhkR4KAXuGODk0haQwcXy4g4eOtjMa4Zmw
	 Egj6jU4KqVhk8tQBSU/HS0jhw2+/TD2jWYXGwsiet/uawymGXNouVCPxVHHHujTX1Bw7A
	 kFAsVuIzC9so6TQmxOcBgPQlj8VhiG+WRlsR6riVOnWQ0eJXBe+y5PjDfPfpqEWvhsz7c
	 F5a95QMPUrxVr4seM9zcRvtSQxIREgEIQOX51TbigKZANdklzKp6ZHBIF9RCqvvPsx9kf
	 R6lKdMlIw/DLaGij4GgVWggafSI4qmYcNqIUCH0gyHoTtY1Z5PLMHcc/ogX6c3uLEQQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795055278;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=hbBimIjt5U9DrdDVeQLvZYDkDAbWnDLMAaG+wzuou1c=;
	b=W33UEFi8T9GVGu9gpJnI6yzg4t04Kp8CpQIvVMQc5s9GvwfdHxw1wEHzX3Ok94tw+qYe
	 4Iiv40lGRAHDQUAZz0FJzkfL/f69EW4tBeq5cO8nXqt5h2UQoK4gIGojUlFA2gE/fCWRQ
	 3bb6sVTLV5v3gOdPCAU9HbH0DqmE2KVkXX4AQj3z65vkboL1nHrQr+vDTIRwuUbwPIg4e
	 4VZh65F7T2TJLXhKHuoEsBs2x4Vdhb3GK0jzvkgz17C1Ru333lX90cGzOBSjCZZptAqls
	 UFvrYidP531X2dpS8I223DhNA+fcq5Ural8gd+5U6WCdLeaFZUrmQCQbDARl5NFbKcQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=ftAOczEB;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5783A606A332;
	Thu, 19 Nov 2026 02:27:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=ftAOczEB
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B1CAF1F000C6;
	Thu, 19 Nov 2026 02:27:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795055278;
	bh=hbBimIjt5U9DrdDVeQLvZYDkDAbWnDLMAaG+wzuou1c=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ftAOczEBSQDGibG37fo9+7fJW9pcDBs6A9EYuQ1aJ+fQD1QHdm6V95xqcKQHiPuip
	 A9ALVWrv1wAod+yGwspzCKvnbr+oMPOkX+q/EqvA0z/eyD7QK3cgiyFJm4ijOmJ5Rx
	 Pm/rBoiGT6qFhjsdIzc6rJGGVY+4w48sIwuKnwP0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Finn Thain <fthain@linux-m68k.org>,
	Stan Johnson <userm57@yahoo.com>,
	Jens Axboe <axboe@kernel.dk>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 1574/2214] swim: Check for CRC errors
Date: Wed, 18 Nov 2026 15:54:10 +0100
Message-ID: <20261118150115.010697052@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150009.797899913@linuxfoundation.org>
References: <20261118150009.797899913@linuxfoundation.org>
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



