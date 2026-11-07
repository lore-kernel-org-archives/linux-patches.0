Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794062651;
	b=UUF53ya1NZX4gMKihzA4nDDIQxOqC6AQmrE9A8+YpO/g0wizaPcMODwgP3wI6e72F2pe
	 f0bDQ8emQ50T2TJbWL6Lg2BHQHWahHSXaW/FT5sV/yTCoo/0cz/TwcdIh+aU8HyZnLMVA
	 D7ducHu1fEkSP2cZ3RN5Tim6YJARLs2TRE+xlggFyVQGsJJdj6y3v01GL58Mh4la8MpPw
	 AoHCicwo1dl3fikUk3vy62mN9A28FZd9hKexTKtoFouSCeh6SUopcg8Ad6FMX+Sje77Z0
	 Vh93ZmYFIySBTeEi1ltzi13G2nSsUfAPCuEY4aVDvVGrv+kauAuiX2axwLe9RtIvNjQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794062651;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=iUoP9TIfV4WNrcT/zlClYeLeo0ivCd1Sr6p1CL2OsWY=;
	b=dG99iho1fXokjJStBy+5wFhjmdHy6LKstWwBMPGIyL0IJpYQr12FCXBBntoV+t1wS11S
	 M3vu1Jxwou4rAMmPV8HhxUc3rr/vVBRuaK2SStRE1M3xxPO74c+U5KspLjBfiVraOY/0l
	 ObKoi3aWaMo9a0Za9GlNJo5rbdXXdLWysC8uZEhARtLBd1iydXK2kPAp2BULjpzCwxt3D
	 KLCsTX999QKcUcTpD7+TGPQ+xUcNw/vpG1Ic5xm+YxuzRvrA/mn4q1vUfDo5DEo+j9cWb
	 LqLHGs5iRs7Z1U09plmaFpCLNI6s58obUXXqAJHwJpUUFhnXAvS7LFw4NUPeuQ/TCvw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=DvTgGLCQ;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E42A3606A332;
	Sat,  7 Nov 2026 14:44:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=DvTgGLCQ
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4E4991F0089F;
	Sat,  7 Nov 2026 14:44:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794062650;
	bh=iUoP9TIfV4WNrcT/zlClYeLeo0ivCd1Sr6p1CL2OsWY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=DvTgGLCQA2b9d98LVIzKk1+dIRaEQQhXP9j1mXKa/3WZKUQCu2Mz+A/L+mJSuNezp
	 by9uaRT7yB3G4EvijgxGXdyzEa5pQNbDfLwiKVE7O3Q34LfoEQ824fxpzLN7Ra4J02
	 W7WZknGFOc6rjArv/QLowm+pUaGMgIxJGq/VHe/s=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Fang Xieyan <fangxy@xiaopeng.com>,
	Douglas Anderson <dianders@chromium.org>,
	Daniel Thompson <daniel@riscstar.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 1515/1536] kgdb: Fix buffer overflow in the m packet handler
Date: Sat,  7 Nov 2026 08:58:51 -0500
Message-ID: <20261107135040.417864634@linuxfoundation.org>
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

[ Upstream commit ac0159129e2cb99a70c4b80cfbf58d03e092dc7b ]

gdb_cmd_memread() passes the length of the 'm' packet straight to
kgdb_mem2hex(), which hex-encodes the reply into
remcom_out_buffer[BUFMAX] without checking that the reply fits. A
client on the KGDB I/O console can ask for a read of any size, and
the hex encoding runs off the end of the buffer. kgdb_mem2hex() takes
that length as an int count, so 2^31 truncates to a negative value
and copy_from_kernel_nofault() is handed buf + count as its
destination.

On x86 BUFMAX is 1024, so a read of 512 bytes overruns by the single
byte that terminates the hex string:

  BUG: KASAN: global-out-of-bounds in kgdb_mem2hex+0x1dd/0x230
  Write of size 1 at addr ffffffff87651780 by task sh/1
  ...
  The buggy address belongs to the variable:
   remcom_out_buffer+0x400/0x420

Bounds check the length before the hex encoding:

		if (length > (BUFMAX - 1) / 2) {
			error_packet(remcom_out_buffer, -EINVAL);
			return;
		}

gdbstub_msg_write() already bounds the count it hex-encodes
against BUFMAX. Reads over the limit never returned valid data,
so an error reply loses nothing.

Fixes: dc7d55270521 ("kgdb: core")
Cc: stable@vger.kernel.org
Assisted-by: Hawkeye:GLM-5.3-flash
Assisted-by: Qoder:Qwen3.8-Max
Signed-off-by: Fang Xieyan <fangxy@xiaopeng.com>
Reviewed-by: Douglas Anderson <dianders@chromium.org>
Link: https://lore.kernel.org/r/20260914180344.15485-1-fangxy@xiaopeng.com
Signed-off-by: Daniel Thompson <daniel@riscstar.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/debug/gdbstub.c | 8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/kernel/debug/gdbstub.c b/kernel/debug/gdbstub.c
index f625172d4b676..4a17b27b3e5b2 100644
--- a/kernel/debug/gdbstub.c
+++ b/kernel/debug/gdbstub.c
@@ -561,6 +561,14 @@ static void gdb_cmd_memread(struct kgdb_state *ks)
 
 	if (kgdb_hex2long(&ptr, &addr) > 0 && *ptr++ == ',' &&
 					kgdb_hex2long(&ptr, &length) > 0) {
+		/*
+		 * The hex-encoded reply needs 2 * length + 1 bytes
+		 * in remcom_out_buffer[BUFMAX].
+		 */
+		if (length > (BUFMAX - 1) / 2) {
+			error_packet(remcom_out_buffer, -EINVAL);
+			return;
+		}
 		err = kgdb_mem2hex((char *)addr, remcom_out_buffer, length);
 		if (!err)
 			error_packet(remcom_out_buffer, -EINVAL);
-- 
2.53.0



