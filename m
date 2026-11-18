Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795058767;
	b=GYMpJKTDU4NIqdVeD787LCxbFLOzzueuytGRlssaU0AWHk1Dt/t9+BOxxu997A+iidjW
	 w/tIsDXCR8DzfTJPNNssj6GrselXOkBs/JH9mDDN4N5rBoVdtZtHlXwnITNX9SevNb2z3
	 Hg3Zbd2AZBEsnLo2ejrmoGdzaup2WJNLdunOqvl9FjaAFHRedRNUAJQu4p+eLWpEgkVXw
	 Qzt7BK9w7GuC5qIHU6o5nV/M1MW2X4LOdp3fGUyyOMg6vVn0IfV2YJS0FMz7OU/QJm+xY
	 rr2p3onxEeMdRoNN1zIANRlBo1fpI0mStLWV42vMD4myL7bMGLgHGfxSfAo3foHriiw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795058767;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=VW1hDviFLt0YCrew+50bG4pmGLxChGer3NosYrCP9Rk=;
	b=FA8TKTyO69ZNxg9MeWJDEpN74uQTmQXIJ98WWmXu8RmXlFBZRJ+Si2FiKbyexKNWn1Kp
	 NmAEa0qZL4IRZFk50CsNjuXZcMaV8R7N9GGpzOfTQfmLm6/c72RveUf7cSUAefI2a7s+O
	 vsU95iKbhqxFlR62fZQz2RBxqiQAL5NuyuKoZ/9vxFmaHThlstA0AT5LXJwB4+dI1rXT5
	 gcAgzV58w2gvl5HYZ4rvAlXuHjtpXXNCADGJPEuVbTPfq9BuMEe5LiMFJxuAJaRPNYTR6
	 JH/kOh6x2p1PVI/2Vu0mkLUfztNt2jgzmN8VVtighFc9hd4VAhi2gLCyvmJfK3EtIkg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Fln9Zz6I;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0DD62606A31C;
	Thu, 19 Nov 2026 03:26:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Fln9Zz6I
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5D4F61F000C4;
	Thu, 19 Nov 2026 03:26:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795058766;
	bh=VW1hDviFLt0YCrew+50bG4pmGLxChGer3NosYrCP9Rk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Fln9Zz6Is0pUYt+RtVAgNDyALWX7sdTC+/Qc6RXSJKDW56z4KM69XKsWr5oPQVmF8
	 maEIUDgn1gw8Kf2yX/axra16sEsFz6BbK5uI8wSg/iyD78Vd3L1F5ErbCNM9SwsR/B
	 tsUSuUCVgmBtv4X3JWID9Dy9HH7QidVXnA76udDo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Douglas Anderson <dianders@chromium.org>,
	Fang Xieyan <fangxy@xiaopeng.com>,
	Daniel Thompson <daniel@riscstar.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 0602/1848] kgdb: Fix buffer overflow in the qRcmd packet handler
Date: Wed, 18 Nov 2026 15:44:00 +0100
Message-ID: <20261118145940.522931120@linuxfoundation.org>
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
index 044f7566c341a..b57e5e338aab2 100644
--- a/kernel/debug/gdbstub.c
+++ b/kernel/debug/gdbstub.c
@@ -787,9 +787,9 @@ static void gdb_cmd_query(struct kgdb_state *ks)
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



