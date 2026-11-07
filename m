Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794063745;
	b=IRrUTrk1GWwoLbHmMBpBGZs/CCly/n3NreXn4E+OCH/chKhYUCMp1VfecoI0f7sxqx+H
	 uNl0ynn07Imeq8VlFjqeUdIbAHL3UNCaEIH+q/GK8Nvnn7yXdfsXBovSdcaz9jf52QUKc
	 Twue4Fk8hKmy97Ll1M3epqBnAtL0kUVlS4unLS+HON9PxmrQFdw+vNaX8kFtpmvfKYW/9
	 klrG+rH8Po0/FfBcTCbdfICqcgNkYQeEw5qAJV1gIomXnpYVtnvTJfU+V7QVwPNes5CIp
	 dmZ62JSdemPC9eLhwRcRQiEewbyWfI1QTD8OSHzCHr1Qdgc7O9C8wFRNqtYNxFTPpSA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794063745;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=F3d57eL15OBT8lCHnyTDA5v4pD9F8vvk+WMA0SfPJC0=;
	b=q+zZcmANzBRNERvoju9LbUzCaz5P9EZsXnaAam/jeyRiz37Y7HUlE+xw6Dv4koMkqAfm
	 evtV2xIcg2hVt61WMi+y1FGU7UKvFjrPKhW+TqBOibLHq1wjnZboQEvvnB4wMFF753JMf
	 hdITLv8k82zO30BwDNb/HzpdsbXpVd+n3KlpwHeTuhkNxEPb5AoE7z+t6hzDOunnVSwBu
	 3Yo43rm4fexTK2PxGx60P4xdV/8oQcJfb8xRwodqn1KfEYR8ZSyQG5Mod90w89/G+1vcU
	 BNOg0ll1B83ZDVM/r8EAcTGqbDPeexpS1ol5LzRaS0i8xBQzC7rI39NzaAlhY1b1d0Q==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=xmH6oqlp;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1CDA4606A32D;
	Sat,  7 Nov 2026 15:02:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=xmH6oqlp
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B58371F0089F;
	Sat,  7 Nov 2026 15:02:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794063745;
	bh=F3d57eL15OBT8lCHnyTDA5v4pD9F8vvk+WMA0SfPJC0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=xmH6oqlpC1YyKOSGGVNmyVDmo+3mpsJT7AEPAwSkdff8tdHD9FGB3tMG35+HH7rHV
	 vKTsIdOGFZREBhJ01gAoSNrFQ5/8uE/Q78vKngaZN6ooEW3PqN9sTOFAAK3KNNbyMe
	 fmtrhcSTvM2kd0S9KYRlXMr11A5S6j4d+AMa4Z0g=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Fang Xieyan <fangxy@xiaopeng.com>,
	Daniel Thompson <daniel@riscstar.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 839/869] kgdb: Fix buffer overflow in the M and X packet handlers
Date: Sat,  7 Nov 2026 08:58:41 -0500
Message-ID: <20261107134921.319266164@linuxfoundation.org>
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

[ Upstream commit 13962ef7021ef2531a4f6650eca87c363e6c9c32 ]

write_mem_msg() passes the length claimed by an 'M' or 'X' packet directly
to kgdb_hex2mem() or kgdb_ebin2mem(). A malformed packet can claim more
data than was actually received, causing the decoders to read past
remcom_in_buffer.

Record the received payload length in get_packet() and use it to bound
the decoders. 'M' carries two hex characters per byte, while 'X' carries
one byte per output byte except that a 0x7d escape consumes an additional
input byte. Pass the packet end to kgdb_ebin2mem() so both reads are
checked against the received data.

Keep zero-length 'X' packets valid, as GDB uses them to probe binary
download support.

Fixes: dc7d55270521 ("kgdb: core")
Cc: stable@vger.kernel.org
Assisted-by: Hawkeye:GLM-5.3-flash
Assisted-by: Qoder:Qwen3.8-Max
Signed-off-by: Fang Xieyan <fangxy@xiaopeng.com>
Link: https://lore.kernel.org/r/20260922154907.90535-1-fangxy@xiaopeng.com
Signed-off-by: Daniel Thompson <daniel@riscstar.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/debug/gdbstub.c | 45 +++++++++++++++++++++++++++++++++++-------
 1 file changed, 38 insertions(+), 7 deletions(-)

diff --git a/kernel/debug/gdbstub.c b/kernel/debug/gdbstub.c
index 75b9cf07ebbe0..dbe48bd53e533 100644
--- a/kernel/debug/gdbstub.c
+++ b/kernel/debug/gdbstub.c
@@ -42,6 +42,8 @@
 /* Our I/O buffers. */
 static char			remcom_in_buffer[BUFMAX];
 static char			remcom_out_buffer[BUFMAX];
+/* Payload bytes get_packet() stored in remcom_in_buffer, excluding the NUL. */
+static int			remcom_in_len;
 static int			gdbstub_use_prev_in_buf;
 static int			gdbstub_prev_in_buf_pos;
 
@@ -86,7 +88,7 @@ static int gdbstub_read_wait(void)
 }
 #endif
 /* scan for the sequence $<data>#<checksum> */
-static void get_packet(char *buffer)
+static int get_packet(char *buffer)
 {
 	unsigned char checksum;
 	unsigned char xmitcsum;
@@ -134,6 +136,8 @@ static void get_packet(char *buffer)
 		}
 		buffer[count] = 0;
 	} while (checksum != xmitcsum);
+
+	return count;
 }
 
 /*
@@ -320,16 +324,26 @@ int kgdb_hex2long(char **ptr, unsigned long *long_val)
  * Copy the binary array pointed to by buf into mem.  Fix $, #, and
  * 0x7d escaped with 0x7d. Return -EFAULT on failure or 0 on success.
  * The input buf is overwritten with the result to write to mem.
+ *
+ * buf_end points one past the last byte received for this packet. Each
+ * 0x7d escape consumes a second input byte, so decoding count bytes can
+ * read up to 2 * count input bytes; stop at buf_end rather than running
+ * off the end of remcom_in_buffer.
  */
-static int kgdb_ebin2mem(char *buf, char *mem, int count)
+static int kgdb_ebin2mem(char *buf, char *mem, int count, char *buf_end)
 {
 	int size = 0;
 	char *c = buf;
 
 	while (count-- > 0) {
+		if (buf >= buf_end)
+			return -EINVAL;
 		c[size] = *buf++;
-		if (c[size] == 0x7d)
+		if (c[size] == 0x7d) {
+			if (buf >= buf_end)
+				return -EINVAL;
 			c[size] = *buf++ ^ 0x20;
+		}
 		size++;
 	}
 
@@ -366,16 +380,33 @@ void gdb_regs_to_pt_regs(unsigned long *gdb_regs, struct pt_regs *regs)
 static int write_mem_msg(int binary)
 {
 	char *ptr = &remcom_in_buffer[1];
+	char *buf_end = &remcom_in_buffer[remcom_in_len];
 	unsigned long addr;
 	unsigned long length;
 	int err;
 
 	if (kgdb_hex2long(&ptr, &addr) > 0 && *(ptr++) == ',' &&
 	    kgdb_hex2long(&ptr, &length) > 0 && *(ptr++) == ':') {
-		if (binary)
-			err = kgdb_ebin2mem(ptr, (char *)addr, length);
-		else
+		/*
+		 * Trust only the bytes actually received, not length: the
+		 * client can claim more payload than it sent. 'M' decodes two
+		 * hex chars per byte in place, so it needs 2 * length bytes at
+		 * ptr; 'X' decodes one byte per byte, and kgdb_ebin2mem() bounds
+		 * its extra 0x7d-escape reads against buf_end itself.
+		 */
+		if (ptr >= buf_end)
+			return -EINVAL;
+
+		if (binary) {
+			if (length > (unsigned long)(buf_end - ptr))
+				return -EINVAL;
+			err = kgdb_ebin2mem(ptr, (char *)addr, length, buf_end);
+		} else {
+			if (length > (unsigned long)(buf_end - ptr) / 2)
+				return -EINVAL;
 			err = kgdb_hex2mem(ptr, (char *)addr, length);
+		}
+
 		if (err)
 			return err;
 		if (CACHE_FLUSH_IS_SAFE)
@@ -992,7 +1023,7 @@ int gdb_serial_stub(struct kgdb_state *ks)
 		/* Clear the out buffer. */
 		memset(remcom_out_buffer, 0, sizeof(remcom_out_buffer));
 
-		get_packet(remcom_in_buffer);
+		remcom_in_len = get_packet(remcom_in_buffer);
 
 		switch (remcom_in_buffer[0]) {
 		case '?': /* gdbserial status */
-- 
2.53.0



