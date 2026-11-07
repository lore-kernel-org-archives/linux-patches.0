Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794063746;
	b=1ku5wU8F6CWd7cThFF8CbNiUyqRxEWhd7kPYg0UQ4uPyriISNNVtmNL35IWx/ZWtxoRH
	 ELKgDTJjdq6wkCoYQdgfT9JJrMOMxNygMhSM5IFCXHtY8r5Xzo3UIpHuK7GRandse+EFI
	 jHafPRu4DxzEW5/OEVJ8ImASbqlsM2Q8FIrm374a36gJogcayr/gvuwSPP/6G0nUp//Bi
	 xz0dBp38pQCQcmC3Z39vAGr02ZENmxcVcTzc+y/cNJKXomGwR+vxn4N0HjVlV9mWgwe79
	 LuuQT8w+B+3cvT/kQK9q07YJYKA9rYoA9QKe/OPuvTC7qyGHKRV/aYL8Lni6tAbwy5w==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794063746;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=WytbI84MmeVRHwff3zkoswJT/GMi5Xb93m/TDd6/IK4=;
	b=HWKPWHO8woLEvaPxu72OZNlTydo/6LvVlxec4CoGvY61a1XlmtPLpRTtsXrHM3mM3X9O
	 zJAyIo3WIUJN3IWW7pEKwCqEeA0uV8KrUD2WY69c8txCEjyPrrf/d/q8ddCmfuxdzyUWP
	 zfupZ1p4sG2J3jj6bkJzZDGKr020f+hMYb/MIuAfZzoCxYGOduT2rYRn7Cjz2VBIme3sc
	 UEyym5xRMGxm3Tyzz7I3WXLuAmpHoZQJXGuH/73cbn1PneM3BD7lG3uNqtef+/7rPkzmC
	 2u2EgTVv3REqWTcTRhksMykEq35BU2qPgkZSOBUPA9Bw5Lrva2iPikrGD3tZi67P9og==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=GqHIPEu5;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 71B69606A32D;
	Sat,  7 Nov 2026 15:02:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=GqHIPEu5
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1BBF61F0089F;
	Sat,  7 Nov 2026 15:02:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794063746;
	bh=WytbI84MmeVRHwff3zkoswJT/GMi5Xb93m/TDd6/IK4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=GqHIPEu55lZ0zOtCPwXCo+jRCyfYOojUVlbXWhMtTcbfTDBsZqYQltF238M23E5dQ
	 UWwnCHEWaUIornXm/jA0XmqPmh0C3hpVghbs+GC7b9MXAfCwZostIcbT3bgS5S2X9h
	 ig6qhqj9K39ZkyNcdtMf4zvVNG8BOkwcVfSc9zL8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Douglas Anderson <dianders@chromium.org>,
	Fang Xieyan <fangxy@xiaopeng.com>,
	Daniel Thompson <daniel@riscstar.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 840/869] kgdb: Fix buffer overflow in the qRcmd packet handler
Date: Sat,  7 Nov 2026 08:58:42 -0500
Message-ID: <20261107134921.346517372@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261107134852.069646174@linuxfoundation.org>
References: <20261107134852.069646174@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

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
index dbe48bd53e533..1a917c5bdd1eb 100644
--- a/kernel/debug/gdbstub.c
+++ b/kernel/debug/gdbstub.c
@@ -816,9 +816,9 @@ static void gdb_cmd_query(struct kgdb_state *ks)
 				strscpy(remcom_out_buffer, "E01");
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



