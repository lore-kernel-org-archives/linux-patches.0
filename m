Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795037062;
	b=q1OPh3U2KpKPeZtjSCS1cgaskzLpXO22m9t8V3JGGXKe23Wt18XTmhVDibJTFQnoOVqf
	 diUM5vGEOIcNcNtr1F3Iob2GepQsxZgMtBeXv5/12llm0fxT9K6SCWdiWZbPKkZFo2p4S
	 9vx2GDPAOeiIQlXfTpJ/22zEIH3xFOmDRWYZ3QEhsodNlNxcRHpP0reNQSzGuvwD/D0He
	 mH8EBakYYNJLtk8bYO6lFLMWZ6BDS+EYhlpNxwIoRqC6Ytrz7ZJGx2HktsP98Jvf4KXPz
	 h99DaXIB18ucKmTeGhp3k8w3kqVRErkVvPtGUcSyZVZprxOD0Ocy6rV14QxbXZaJrtQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795037062;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=IjwZVO+cbEFZC1Cy03OrcziZlQC9rUcE0dHUmOt4+d4=;
	b=XX1RYgJqtlGb5uvfqS2M2IlAeJ25hLYg+o3caIX0C4WDr3d/zqoH4+J7sXFMUt9fFSPs
	 GBAEqqEO6go2sTMfT/mV6u7k7NKKfy5sIDiqnrsK2gzzXV2sJMIQrOIx2Bx9/uBVzuQ4V
	 J6Wlf93GEj2P6e3kAsr88+cUkw5/xuyBvXmfCnd45ztc/KNR2nWHBtQKVX9C08u445BXR
	 ujXI1z1GSxSDYBq7AEIhqB95eE/yMX8q6QSWrnlpiv9ls208GND35ZqGbI1Z6+60s0RMq
	 qgVp3DtbUoHzm53gdGnyfQji8oqKXGGKVhl+m0Gk/SQU5ANLoXyQ0mn74W05LHHNgzg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b="Kvx/ldDN";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 60669606A320;
	Wed, 18 Nov 2026 21:24:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Kvx/ldDN
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B086D1F000C4;
	Wed, 18 Nov 2026 21:24:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795037062;
	bh=IjwZVO+cbEFZC1Cy03OrcziZlQC9rUcE0dHUmOt4+d4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Kvx/ldDN/G7Q+e4DEb01Oq41kDagGOlz5OTg7O7CgG+wYjqDDZgyuqD94URL/IAM4
	 Zy/iqSHi/2/yLca0YPCIxN+SOlFWZA+Ue0ReD4xzab2PCHJIV55sCLrxgMDQQRXBdc
	 5D53fYWTTd5s2oi+TID4PR09+ePQ8h2kUZNBMotw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Fang Xieyan <fangxy@xiaopeng.com>,
	Douglas Anderson <dianders@chromium.org>,
	Daniel Thompson <daniel@riscstar.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 1279/3318] kgdb: Fix buffer overflow in the m packet handler
Date: Wed, 18 Nov 2026 15:31:41 +0100
Message-ID: <20261118150358.614017995@linuxfoundation.org>
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



