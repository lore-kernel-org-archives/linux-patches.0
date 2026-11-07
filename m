Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794065537;
	b=OpiMed0iBXkIm7sZUf3fmxrUPwZaEn7PzgQ46CaENScwx2Sj56lRtaAakly8maj5rsOY
	 b0HwX1yMVKxft8+9O+SHnYYN0Mxk0XpyB9eR8amA3LmdK2dVjDV0L+lKUceirzOLXrJy4
	 P22wmjhyoGIWL4uAxgxFL9aOd5GnqEahe3x5RuhM7G1TVi1tygKQzSCb5o9a5SWKR2FOD
	 OEB9/QOb0H0cz6BnH90r+CKaUabUN5nIiuvRls2r8Xakr6P0jDw89wIZ2/rwF/bMyf1lb
	 3S8Q9Ud8855wX6+l8x7w94SXsCZlfKVSHudAp9RdP/Cas3tpGfhGxA/yylLDAw1UchA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794065537;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=3bnvhPIbVEa/tHfUfadX5bnwdo7E7R51siz179SqPzg=;
	b=Mq7iGlYateeT4OJeIOrCjQcMPwrjZXjSXSMljvlaTP0vBFJzHbSeVplhNQq8mGpiAwzk
	 X5wYLsgQKpZ7WB4ywov47DF3kX/pjhW27Ivou+BjqC/Ga2L5esxvN215Mq2+jRTavwXnR
	 OqVBSpUVC2AYgTbG35yaWebPcyzqHv13xQUrdUOK4MbH6lF7CvfDihXft2AmOmYk8H2p9
	 PwtdNPZLI+xPixlKloRj+VwyN2mbcyyEjTtjnHo7Qexvc9VPrfh154DZ80MSdVmJMX7tp
	 1L/vXFL4W4j/3lVRBhCeW8jxh/7M1hK/a3P+b5QZazjv9LlqvJXSr/xhdP8Zg4x1rKw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=G7GnWJKo;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CD9C6606A32C;
	Sat,  7 Nov 2026 15:32:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=G7GnWJKo
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 79D3E1F0089F;
	Sat,  7 Nov 2026 15:32:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794065536;
	bh=3bnvhPIbVEa/tHfUfadX5bnwdo7E7R51siz179SqPzg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=G7GnWJKooy2zLpG04KriiXh8rKHNr6W+pzKuaJpBxuvnhg97QkutnuDE6tKf/Cv+Q
	 gJ4PtG9PS8+Hzxf2ehbP/XowtNe7I+gsGu+Gt+w5VvQQfY5mo2QV3TyIHkWaQgg0Kk
	 X+o/x+ojg1FKAIb+HC2M4yvzoj0mk06q5It4aDHY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Fang Xieyan <fangxy@xiaopeng.com>,
	Douglas Anderson <dianders@chromium.org>,
	Daniel Thompson <daniel@riscstar.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 1214/1257] kgdb: Fix buffer overflow in the m packet handler
Date: Sat,  7 Nov 2026 08:58:30 -0500
Message-ID: <20261107135012.898378058@linuxfoundation.org>
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
index e271a436d60e4..5774292c93aec 100644
--- a/kernel/debug/gdbstub.c
+++ b/kernel/debug/gdbstub.c
@@ -563,6 +563,14 @@ static void gdb_cmd_memread(struct kgdb_state *ks)
 
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



