Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795045893;
	b=vePf+mvUgRmOGjUmohYig51gYpDF056Czzg2a6mtJ1JEmbXDQyH6DkCXUNz74tWmRX7i
	 6YIYMvml8/cTSMyjFCpzkKxWaPRsILlXNTzZao5J9bv+GGuvIZWtWuwZzf14ks19OE7E7
	 JAvOkXqMg08eNtk/XG0y81xg38zNpl+VYPjPcVRNt87rofe6k3drYRCrSOyczm7r4Fhqy
	 EVvF6+fuPTcxDsQVtYMwSvaOXNkbCcU+p1Jsa/e5ZLs5arU8Zpe1Jqp9V35LUAOeT5YIn
	 ZOnWQdQVjTcH/R2oTyXRWZ8JsgHNDP3S0R2G8Ii9OomBcXeQfxHu2Ctu+8cUYme+/9A==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795045893;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=68bnVHpf1dSDog0nBlFGavqERw4OJdVzOr2DTO13+Fk=;
	b=Npt7rEPIiY8WiDFKlPDqRtlG9e8tEQ7f027KDer7LQVY3TuTY7tdPd3VN+jE2GLgKBu6
	 mNhbA8gY5JE271hPDRpHtbapffTknl3Dzqc0KxQXQOVPsr8hDSHxo2qLFGMs+fsJ1ZrMQ
	 CIZa+/IIeQ/Gkny5l9uusz3sR9ICEQX+qfCjg6TAJdm8Akqa44DXZ9ie5UjeXcYH1bRCp
	 IrVulPMEuxBEY1789EQMT0b0m//13zwtwSUav9G3D/1olVab5LWyVOVJvACfh9SovgGup
	 VYGaFt2bNX7bmdwo0i6digvhuJ1lD2uHgJykKgCtiua1L5KPaZ+dDcod8J2abF+8pSA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=m3xwdjo+;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 381D060A260C;
	Wed, 18 Nov 2026 23:51:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=m3xwdjo+
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8FB131F000C4;
	Wed, 18 Nov 2026 23:51:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795045893;
	bh=68bnVHpf1dSDog0nBlFGavqERw4OJdVzOr2DTO13+Fk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=m3xwdjo+1xKCCztNB31FKii0XxtZ+3CrVT8bcFh6lvkeOuV6CHqev7MQ0sxKtYmpi
	 G1zbVRpntYJ9LNFNrIY63rvvb8KLQOMQbW37qRiN4QV+ge8khgQkfXX6nLU82pGAld
	 P9cH1TBYwcLxQU5CAg51R7Y0xpwvqtV1IHnf8Hvk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Fang Xieyan <fangxy@xiaopeng.com>,
	Douglas Anderson <dianders@chromium.org>,
	Daniel Thompson <daniel@riscstar.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 1087/2857] kgdb: Fix buffer overflow in the m packet handler
Date: Wed, 18 Nov 2026 15:35:21 +0100
Message-ID: <20261118150240.762574251@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150201.293410965@linuxfoundation.org>
References: <20261118150201.293410965@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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



