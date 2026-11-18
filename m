Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795040121;
	b=tXFM1eMxq12JkhwO45Zi0wQu/jNRpMzmV9eJnVZs1dS1WA/VggWDaeX9xBfC/UbiUzn3
	 CV7h4/myE7l1WNITol4ZTTLYGsqdXGdnhOcOp9LgLj1McMEKRlQeKr9m0roiBY1ZHBWTO
	 qp8n+sY5LSivcSJkhyJFmh6tyHy8gVeP111T3vw3fQ9k8QEfB+Q5SDBBoHVaOhJRJjyqC
	 K6BUXvXA0NMladVTBzOz8N5zW7yJ8i7fCKKz3GvgqOkXxpWX0yxZSrgZA9Qa3gBDy9ZzT
	 N/IGzqCwntCCo3VuJ0PesegUKZSy/RR64q8I/dafcJuvWJwUh+VqmN8tXY7xhQy+5Zw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795040121;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=zSgFz33JStTa+0/C2LQfI/wz60zwCWbU9lr/1lW/tG8=;
	b=VfrQbJ4hyGSKJj5eYwU8QQnNb0KwgP28iFrcxR1cpnlf+70JXWtct4QRhjMIxUNlrLiw
	 18+Wq3mla9mETuVudk1l8QEzsxatEduH6USchcN3JVkZuwSebiUxqJHg+i6wLbgSvgGM1
	 9P/wZffjy2Oc54Bo6VRx00n2NSion6GoR2yerKWzHYaRMsULh8CtaDwjm+y3USUSFkKqO
	 e6dhsYpsugVpDZ7yds1cooaaylTYGMcbEz6CYiwXhxCJrS0X32y6yg44RWeaje7K9h8SF
	 9sykd7sU0qa0G1WnMmQTAHka+xvQu03LVfGA3rZ/nsiGZOJOo3vEJRuCsKvN4I2QgPw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b="EUpV8jp/";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E78CF606A325;
	Wed, 18 Nov 2026 22:15:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=EUpV8jp/
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4BE4E1F000C4;
	Wed, 18 Nov 2026 22:15:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795040120;
	bh=zSgFz33JStTa+0/C2LQfI/wz60zwCWbU9lr/1lW/tG8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=EUpV8jp/GeoTJkU8P1aASAmBziuhIB83Mwuc1es2ShJ/neUTHYxuN0UyWzmH98m1j
	 cOKKpfKJxBPHkaVbyvbwQ4BpEkW7PXKmB197SO4OlV9cTvUcttoWyQTYbN1628Qab3
	 2eHoyLbI6wtdtxTW/uGrkJUTQ4v4lqKtCdHYb72k=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Finn Thain <fthain@linux-m68k.org>,
	Stan Johnson <userm57@yahoo.com>,
	Jens Axboe <axboe@kernel.dk>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 2317/3318] swim: Check for CRC errors
Date: Wed, 18 Nov 2026 15:48:59 +0100
Message-ID: <20261118150431.194069796@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150313.527275416@linuxfoundation.org>
References: <20261118150313.527275416@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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



