Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795052946;
	b=R8IoFds2406u9p+aclaU8AMCrFRnStpnEX4vKugVP82SarMR6z2t9inLs1e6gbIggkkL
	 Y233iqESq1LLTjyK8Uvk1zHb0Pu3WF3ezCEgkoBalypsz6S9tRc8a7x8emBCXOyKneYOp
	 Rm9XmsIr2N3VQxTKtq0JeK9Syk9TVancMPcH40k6liauiBNlxjFtzbV+dnsaYgNjyfheI
	 UjHlXSZNKUVkR2wi4Qv6IEzoigjb0SkqzNreItVD1YhKkAlodTTJWVN2xfm05166U5Lzs
	 2Xn8M34HN7rwQWBaYQT76OSpD7YPvzIbLW6LdLfRAaopxKgyR922yEXoeOfo3VaDEDw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795052946;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=GxSkhoMc2/souiOtx1n3ihvR/BqSOAGiJ02OHo7RngQ=;
	b=CyCglMC3hBrqlK6E0JNIr/WVZOJ0LMr7Pyro0uLsjch+TWCCwywhtgoXrVcsL6BUA/lZ
	 OzgQx4CHbKmAi08greiJUucf8vwwBj6qjaSqOfRsCvW1WBhfFNvURYHdJZVvvxbgH7Fn9
	 N1j3oon8jmPRB0Zb/XM+jKrt4tpaae/Q15xYRMyh/fd1cEdOSACN1PDj2Cs6Mz2KbDMKk
	 gFzw3SoAPtrKAIEukSMP1OzUY31zjBM/ohTnYytAhUbJhbqwyXpUHBy4ZQamkrR9kSLpj
	 dCP5V5rH6jfPULjppwGZu/jxQUOG7tL5RcvDcXH3pl8tisVu/UQWd5v4sojct+Cr0cw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=nIWLbt9P;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F2E1F606A320;
	Thu, 19 Nov 2026 01:49:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=nIWLbt9P
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 519FA1F000C4;
	Thu, 19 Nov 2026 01:49:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795052945;
	bh=GxSkhoMc2/souiOtx1n3ihvR/BqSOAGiJ02OHo7RngQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=nIWLbt9PcJ1imKOowmbSd7Me9KsgJSPvV1xdnh2dq0yWL44gqMuVhE6Dk32gmrvFM
	 F2AUzMF+YM+DXm3+Y6OQIcDQSfaoAJ1ClEpupSQ1SoVVidHFkhR1PKTwD4eF0xd+/3
	 WA/iTriBDNYUKc3jCHBSfELUdBzerxgVAuh6EJeo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Douglas Anderson <dianders@chromium.org>,
	Fang Xieyan <fangxy@xiaopeng.com>,
	Daniel Thompson <daniel@riscstar.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 0745/2214] kgdb: Fix buffer overflow in the qRcmd packet handler
Date: Wed, 18 Nov 2026 15:40:21 +0100
Message-ID: <20261118150041.607735490@linuxfoundation.org>
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

From: Fang Xieyan <fangxy@xiaopeng.com>

[ Upstream commit 9ca9e8c857b55a081d5a1f8039b27cbb4d646b49 ]

gdb_cmd_query() decodes the hex payload of a qRcmd packet (the GDB
"monitor" command passthrough to kdb) into remcom_out_buffer and hands
it to kdb_parse(). It sizes the decode with strlen() of the payload:

	int len = strlen(remcom_in_buffer + 6);
	...
	kgdb_hex2mem(remcom_in_buffer + 6,
		     remcom_out_buffer, len);
	len = len / 2;

kgdb_hex2mem() takes count as the number of bytes to produce and
decodes them in place at buf, reading and writing 2 * count bytes
there. len here is the hex character count, twice the decoded size,
so the decode runs over 2 * len bytes at remcom_in_buffer + 6, off
the end of the buffer. On x86 BUFMAX is 1024, so a 256-byte monitor
command (512 hex characters) overruns remcom_in_buffer during the
in-place decode:

  BUG: KASAN: global-out-of-bounds in kgdb_hex2mem+0x131/0x160
  Read of size 1 at addr ffffffff8765ef05 by task sh/1
  ...
  kgdb_hex2mem+0x131/0x160
  gdb_serial_stub+0x16d4/0x3170
  kgdb_cpu_enter+0xb68/0x1520
  ...
  The buggy address belongs to the variable:
   remcom_in_buffer+0x405/0x420

Halve len before the call so kgdb_hex2mem() gets the decoded byte count.
It then reads the len hex characters already in remcom_in_buffer and
writes len / 2 bytes, all inside the buffer, and remcom_out_buffer holds
the same command as before.

Fixes: a0de055cf613 ("kgdb: gdb "monitor" -> kdb passthrough")
Cc: stable@vger.kernel.org
Suggested-by: Douglas Anderson <dianders@chromium.org>
Link: https://lore.kernel.org/all/CAD=FV=V1-gNZ8yTsC+D8inePWv=A+9H09hWJojQf5NRpcNvK+Q@mail.gmail.com/
Assisted-by: Qoder:Qwen3.8-Max
Signed-off-by: Fang Xieyan <fangxy@xiaopeng.com>
Reviewed-by: Douglas Anderson <dianders@chromium.org>
Link: https://lore.kernel.org/r/20260916151753.6722-1-fangxy@xiaopeng.com
Signed-off-by: Daniel Thompson <daniel@riscstar.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/debug/gdbstub.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/kernel/debug/gdbstub.c b/kernel/debug/gdbstub.c
index 1f16c0f4258d1..3cba702406683 100644
--- a/kernel/debug/gdbstub.c
+++ b/kernel/debug/gdbstub.c
@@ -815,9 +815,9 @@ static void gdb_cmd_query(struct kgdb_state *ks)
 				strcpy(remcom_out_buffer, "E01");
 				break;
 			}
+			len = len / 2;
 			kgdb_hex2mem(remcom_in_buffer + 6,
 				     remcom_out_buffer, len);
-			len = len / 2;
 			remcom_out_buffer[len++] = 0;
 
 			kdb_common_init_state(ks);
-- 
2.53.0



