Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794065539;
	b=wcCXhnjKCZNtZjiQZ3sHF/3FBe+rwj+4ufQ86bPzh81pZfJP2t986JL7mlkFGPyvKBLm
	 oiixnHgVCY9W9Dj7yq2avX3NZI13N/4mck1JngcrVh0ujjs/jnVSx1jS9EvczDVP7MOhG
	 LSeYj9uI3SPYlP0ZbLSUsUxRYhS7Hu62+4UX/XNlc6wxGXAROBxsofT2/k5v9M7HQWGKk
	 b6Ddk9I00lYmuXd4q9frXQaKH8iWltqLub/TgE7cBr+Kck4SE5EDo+t/1t/Nf4TwrhVKd
	 8H0DsecC9Td3hp1xuHBMPL+8kIwF7lQkAlMjCwCn7Rshj/IW/iPJAMRZiKFemRXiTUQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794065539;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=w8Zf1n5QmtjjA8LF8LBhvb/zxAibDLNMzh+RCwK4LGA=;
	b=Cb2SPcHsZO28/O0oIs8e0zVHNZpBUxXOI4Qzmg+OCvf1QvDlmC8nrBkAhRbuK+V2UQrh
	 jmrg3FLzOYdU5BuLzK+dLYEymEsJ8RHGLgjWMyT4kpGJ43cGZojYyAiL8JuAJ5Nxkhh2R
	 ljwqwyG4N8ApeG8itEjciJBerCJhZFZORItXlulYsiSUKehRXlaXrNf2uzhvJ95mCb8ZO
	 iA0ry+PX7E2kWEHPSny9dNxTAksJF7VFk9gv9G0ldx2KfhMLFC71QNad97cnKT7ggwE0x
	 LhTayaBb8J0DWds8OLCuSw9/2GNd4man7lHRIGMGQ2pIjl86lJT/Iay1cpUam5a38Cg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b="O/IKpvif";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 42249606D816;
	Sat,  7 Nov 2026 15:32:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=O/IKpvif
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E4FD01F0089F;
	Sat,  7 Nov 2026 15:32:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794065539;
	bh=w8Zf1n5QmtjjA8LF8LBhvb/zxAibDLNMzh+RCwK4LGA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=O/IKpvif+Hvy9B0rPxMHZB4SfaoA2eElnvjxqIp2IT4wz7sRdPXpQCxE68hF4wlRK
	 j/MkmG+8waHul22bcob3eVj2nzJzB2hJBf3kOccS/+ezBlYCBtT1p4nAmyVEBDhxnN
	 ML1ufYUl8J6AWcYvLllyWKZ5PZ3wS8B6Pjj1dQsA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Douglas Anderson <dianders@chromium.org>,
	Fang Xieyan <fangxy@xiaopeng.com>,
	Daniel Thompson <daniel@riscstar.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 1216/1257] kgdb: Fix buffer overflow in the qRcmd packet handler
Date: Sat,  7 Nov 2026 08:58:32 -0500
Message-ID: <20261107135012.951280571@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261107134939.434104957@linuxfoundation.org>
References: <20261107134939.434104957@linuxfoundation.org>
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

7.3-stable review patch.  If anyone has any objections, please let me know.

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
index 4102e2e68d806..fc6a7a8c1f6e7 100644
--- a/kernel/debug/gdbstub.c
+++ b/kernel/debug/gdbstub.c
@@ -817,9 +817,9 @@ static void gdb_cmd_query(struct kgdb_state *ks)
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



