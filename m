Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795058761;
	b=OF5FIyaSo0mzCe930BvtdRFPU/n+BrEsr1nsLq71JMzx9z1MwHmmo3QdhA5O0kW5PSfe
	 XmTIjFuc+2RvnIpdPdgMgNDE5KXTy9tPfzNcQoMgdFk/oqo6nlOSS2wPbUrogWCTEYfRo
	 VzFBsAvHcRXoCj1azQNiCHVkflH5+Uye+94N5uzD4U7RKqgE38n6vc5+u6Iib4EbwGdz4
	 wk7vqayBgXTk8L34kFfEKII/Lqkv6Je5/wft8cjch4IvXZwa775wBtFOTtUdeBUD53SyN
	 C3P76fmTYJh+hlyEOdrOKSGGFURhhZ8gE4VYFo1GFuyigH7ksT9NoPihMlarxRz7wWg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795058761;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=Y4D34WtsdnylGDNiAFDVZELFzW1VitVQEhR67gLsZ9c=;
	b=BYL+OpGujntQRPLNzzHqAMuc4JCDnuFtpU/5Ud0N+PJGApxzAQlJgqeppageF6M7L/V5
	 odGa/BbojUc0/8h85//0baaZwlLiIFdSssiLDIoByYGUOf+NNFCMUhdovsgw2qNMtXQIM
	 bNAICN1C1dMaWkdA15o4cowSKfeAR8VmDNNGU1m+eUKVykQk6S04bvTVsNqWnTN1FWpAM
	 2KWu8mU35oMK/VVCL9h/nTWyp1DqDllRt8k/lHzeNKqpGY1DznEfzYOsntTtTkz5qnl7u
	 WNKR9h4D8cSsRa0MfIQtnm5RtLp12jEIhRuVowEigEOaYjeU4Wg4tqtep4mL+84IQlw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b="jDl/Qc7X";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 82B48606A325;
	Thu, 19 Nov 2026 03:26:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=jDl/Qc7X
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D07461F000C4;
	Thu, 19 Nov 2026 03:26:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795058761;
	bh=Y4D34WtsdnylGDNiAFDVZELFzW1VitVQEhR67gLsZ9c=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=jDl/Qc7XtbFFKamBoVtoG4Y+9WXz8ZPE7r/B0LTg/+8BkXilegosy35CzHj01zUHT
	 KJa8wf43BuXnWur++SpA/3Epq2XxOZkGVC2BAMLI/lAp3HlljeAB/vDVeryvzaeXmh
	 aReMcfIe7pMqSJmWfHnM3+pRe4Zuxm7MI+CTH6Vg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Fang Xieyan <fangxy@xiaopeng.com>,
	Douglas Anderson <dianders@chromium.org>,
	Daniel Thompson <daniel@riscstar.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 0601/1848] kgdb: Fix buffer overflow in the m packet handler
Date: Wed, 18 Nov 2026 15:43:59 +0100
Message-ID: <20261118145940.489975271@linuxfoundation.org>
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
index a77df59d9ca53..044f7566c341a 100644
--- a/kernel/debug/gdbstub.c
+++ b/kernel/debug/gdbstub.c
@@ -564,6 +564,14 @@ static void gdb_cmd_memread(struct kgdb_state *ks)
 
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



