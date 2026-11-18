Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795037068;
	b=M85M+H8S/OYa7MSeawcx5uAkBQMPoiQJfG83SJOf7YCItQhQoAQrFPcjqzfng2YOhORt
	 hWox9w/Tsv1Ue19HLXRq+HfXardfYoNTi+9tPg1esm3/n75at+sgYHrpVIk7BqIq4bv+w
	 yWg1epxDZ/T++AYWazsB5ZNdB0jTBLlQPuxt2LBMOMz5AsKrfpOpMagxuPLOpHci09oSO
	 p9VstInU5S9tlJlv2fn966F1i6iR/GNcIu3p2Mb0+g30vQsOTcbuDmR+xrLqpINLIIz+2
	 JtzH6Oyll0tL+viMIgyJpD9ApqA0x7RG0Kww/gwwb2ij+MCQIf0vItIyzhKyxfdY8ng==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795037068;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=xP1JtJyYe8owv6kQIWbcZoIpODqc0RxMIU185qq1faY=;
	b=poTU9VO/0JxXaBBXpHLysbegGsjlyNV/JTZky5czCUEm/k9xqLKhJK5ggSRRN4ewGniY
	 82iJyU/+Ncwwu32bnhzXz7C0NQP6p8rNwPvAShDpU5c/RKx98fvgoZ89Laz5QAOpAgTBR
	 +R3PeIts0w5isweGZKzZPVkatuKJqn2wF/fa0a1ro8lTc+FPmrOLzp1xMdj832RHSsINz
	 kv8YMdKvylcb3Ad8ZHJ+VqerzoGZ3r/T1uaBDxeD619OQleiJKTCxEYCpzkgyeGZVKxLv
	 UwzjLff+FoHxhivA57kr8wdLicQl0dqsqEprECu0Qkc+TDnGRTnk6M1GWQrkGUpN+tw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Ar3TXm9y;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 78DF7606A325;
	Wed, 18 Nov 2026 21:24:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Ar3TXm9y
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D25AF1F000C4;
	Wed, 18 Nov 2026 21:24:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795037068;
	bh=xP1JtJyYe8owv6kQIWbcZoIpODqc0RxMIU185qq1faY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Ar3TXm9ylnr/MoxPl4ddpJwKch4x4iHKenL10ydWAnwpLzXyQahE4k6jupdMZxV+G
	 lh6GVTqgqc4bMKSl3x8bix9ovJ+2L5s3XqPlC2W0JfaeTDb55zRYwJBlBWVSgUf0e8
	 usGbTOQDD9sMyY0QTlfZs/VkAG74TWUFR757WOnU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Douglas Anderson <dianders@chromium.org>,
	Fang Xieyan <fangxy@xiaopeng.com>,
	Daniel Thompson <daniel@riscstar.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 1281/3318] kgdb: Fix buffer overflow in the qRcmd packet handler
Date: Wed, 18 Nov 2026 15:31:43 +0100
Message-ID: <20261118150358.675622599@linuxfoundation.org>
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



