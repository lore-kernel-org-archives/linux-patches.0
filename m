Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795052940;
	b=4L8+gHFpnwkDVbI+3gImflgZEhihLj1VjtbA5+Qe6VfHacVvB3IF/1ndpHtHuQYdAnbj
	 fMlpctphS0JXzUbJy4pWeOY7B2F/zf2H7ffv/T6FmCLt7rc0B21xK8Tw6S72t8vKX+132
	 8RgfnKsxV8JfIO88b+vrWjUNW+anRI2KRTMCPxf11ZShqlhMJc+GRj5YmBx61Wihn2x/f
	 fhPbIbZr+iuz3Ul2drhXKxyEzbYXA7lkNf1qxjyYieo8IPXuCVdDggcluljmaJDxqXeHo
	 OAH2sClb3CUz5KSw1fm6TJ/2C4X9o3ldD1wXBv8mXqZ789YaKJdGRAljuJr6zwBl0Qw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795052940;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=IG/tJHYqSILZ9lLXfssFolmFDc1jHcX1edPGBNk5Des=;
	b=YiUHPyGPQwZUt0ZAzxEPsbVFjyGdxl9dLA4rJd/ZholzkKIEOe1bMHUlTwpQSG/ObO9N
	 n51PYXrnHgKzWiaR+q42qPApZlmMbIIlW0PTZ0ksTb944Hae+F52XWCqBD2fwH0UE8+of
	 QBXzdRoxlnklhoLsVoE8X7eeARGMoAa56CV+hRQJj9JyGTEVWRyYCcXvp1qudAa1juJFb
	 OqdM91Q80BYHXpFHWAERCV/dr6X9CV6bg4/vAl4XeJM9rQzXeuQDlo92pO/HJJgKNRdxn
	 6nQK6tfdF3ywHtaWOzm7H3ygGkGawoCxjT3LMp42aldbh7bSTUqeGVoKh20GBF2HhOQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=1PqnHRXb;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7A062606A32C;
	Thu, 19 Nov 2026 01:49:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=1PqnHRXb
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D22361F000C4;
	Thu, 19 Nov 2026 01:48:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795052940;
	bh=IG/tJHYqSILZ9lLXfssFolmFDc1jHcX1edPGBNk5Des=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=1PqnHRXbUq2KyTyyE4GZesfqfIMcJOpkglYb9VapbI0RmLyt2xGGYZCImQMNL43+w
	 y2rqGeq/S65TQ5/8dxb8S7rKdWO8JMnA+A2ZdDO3NnL5ttHneqXwNtEGhU3sQXtMtb
	 1OqDK+WBI0qxRbyIFbRs5oIqxiJchAPM9KooXs6M=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Fang Xieyan <fangxy@xiaopeng.com>,
	Douglas Anderson <dianders@chromium.org>,
	Daniel Thompson <daniel@riscstar.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 0743/2214] kgdb: Fix buffer overflow in the m packet handler
Date: Wed, 18 Nov 2026 15:40:19 +0100
Message-ID: <20261118150041.535322084@linuxfoundation.org>
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
index 9d34d2364b5a5..c83d34c91b037 100644
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



