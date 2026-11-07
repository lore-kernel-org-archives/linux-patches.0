Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794062653;
	b=EVyMmlJ3CvCsZUsy2n3kNfJEkAqQtXiuLXDXzTOp4YyFE3Ik5ZkQhThIVvTapUgP3r3b
	 53HZ3T1KcSlQt7+ODm4S9FR44M7Pe383Fh3WwfQkUUSrbgURUHgs93q9PycN6Pcuhq5s7
	 Ql5BPmKC0sl824NjebCq7JZLCtVikA8ojQvxnknGqzdnadsx+L/zBFQJdwJWWVRtvZwgK
	 1Mnh3d51yKyAyhRt8zUvfa5RqUo1ILPI8K1C4zvuAxz4qdTTQVjLXnK/nSi7037TEzFsl
	 bLIfE6ljpH6xPaLFQ9Hk5kaZyaHkmePLS29YlFldd8YPu34f8Rz0U3BKfad1g80bOTw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794062653;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=BLjtplCRlKkZ1zCPeMAU1wPT+GnQ5PAuIfd/MWCNIyc=;
	b=ortbHAV4A6SKBQAjOwfp/Uu+3NYPWB9Pde4WDvojaXvKwZ9bbbjAh5kwfAyRTKRgL7eP
	 AVXkFH94sIwMulF5R1K3MPrnGbRA2yC+LqCJ8ryZvyi0+UccpYVwEyU1muT4Keo5W6xBE
	 QKTAC1dh0MwFjYc3v961SBaNKepEl46qFI4yMbBggVl8+1mw4FkgU6xBH9tquZ5gV6SNX
	 eUUaAHJ1N55h/mNsYEHhSq7yjyKcHEOOYy92Znn/UiVhw0U3pkFuNWFvaU5nIc892eHmC
	 RSI223t+IOfBmcTOrXQrpjlVh00lPx/hW7rVbLMg/vk2Ep7XBIiE0zCxtWkSRiNQYrA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=D3pVwQDN;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0290C606A330;
	Sat,  7 Nov 2026 14:44:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=D3pVwQDN
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A57871F0089F;
	Sat,  7 Nov 2026 14:44:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794062652;
	bh=BLjtplCRlKkZ1zCPeMAU1wPT+GnQ5PAuIfd/MWCNIyc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=D3pVwQDNybkCnnB/v55NFBMQqKD2r5DpSDpS0PNdrV1GeIqfmsFyNTvVO0/u+nHdb
	 Fr/raTXt3Ko+S29KS69W+U+pzPlQHQNPz4LiyoQng0N4x8M1QM7B0ZD+NuyrxdJr0l
	 vpWi5m3dx6qHd/Oa3QYd5aoYw2iR68pqmClrts10=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Douglas Anderson <dianders@chromium.org>,
	Fang Xieyan <fangxy@xiaopeng.com>,
	Daniel Thompson <daniel@riscstar.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 1517/1536] kgdb: Fix buffer overflow in the qRcmd packet handler
Date: Sat,  7 Nov 2026 08:58:53 -0500
Message-ID: <20261107135040.479196151@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261107134957.653319350@linuxfoundation.org>
References: <20261107134957.653319350@linuxfoundation.org>
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
index cc3159b0b6ab6..2833c77692096 100644
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



