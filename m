Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795045899;
	b=Ooecx90NdFLGxTY0G4njN/n6jrebnZxUzXwy8/mBaCSsjh2KXi38mCJk/ScD2+WaLs25
	 2hS5TRf6AD4BjyvuU/pWdAFqiP61esmghPyX9KmiEH0LkzL1TH/BMTckBGg+oc2HYh8Yz
	 oI4r/zYgUIf7b8sU8F+Bwc852Xfbw7AkPKYDAbJntSFn6FKi7Hr8U310DxDnuGflef3nP
	 AUhhjuDfZU1mryUdfDbjEDVxkvJTVQHgvnL4nvAewcGBG2MeLNc7AG13rJTklZKLFmQ6n
	 MBMZgQelG0jOOMOP3r5VCmqQg6Mh8Ufq2tzvyqbwCmb022rUjyre5qhHtROKZ73XiKg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795045899;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=6oULU4zsTxxAUosJKNKfM1Jqq1726Q6d+OPEby85Ihk=;
	b=jUfL4T8gImyp3rWZx4ttFq6kf+OquVLZR73SnKILBgE/xnKN5ISU5EVNn/aU6VKSOCG7
	 Xr0pefQiyA3Rp03qRwRszVDrxBYcMbivK3l86s3gdn2z7MSVp5j5EFGwD+fKe5coHd3wz
	 U83vwcLjHCmpg1hUypyaQg/Sobc4BRZntWf2UWwVCo9Mt16lOKXTGWLOlPvk13SsFrj/A
	 InnaL4V6TibuLCHT9/suRUrDg1YasT2wq3/D4Uin0KYRdfkzL4BOzOhvmZRUy7tEDxLNy
	 QiG1AY4+zg4yGEzjyqqsdL6/n/2OjxpBK+rU7n9QYa8AOuoUSdsWXfD1QFTN2l5XIsg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b="DmAkwX/7";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 17F3B606A32A;
	Wed, 18 Nov 2026 23:51:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=DmAkwX/7
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2570A1F000C5;
	Wed, 18 Nov 2026 23:51:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795045898;
	bh=6oULU4zsTxxAUosJKNKfM1Jqq1726Q6d+OPEby85Ihk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=DmAkwX/7kUEfZyyNeOgd3dk+Ts0e6igju0ryKbi4PZn3P1YRqLZAuNgsmLWJg2S7u
	 /OzOJiUW9W2ujqM9fH5jtuM+uAL0h4h4c3khpUpshRUVGHGL60I9l+gSFDQfDHu0J9
	 jt7ChZ9xNQKqqpgR9XcDG3oSL8IHgh2iuWO7povs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Douglas Anderson <dianders@chromium.org>,
	Fang Xieyan <fangxy@xiaopeng.com>,
	Daniel Thompson <daniel@riscstar.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 1089/2857] kgdb: Fix buffer overflow in the qRcmd packet handler
Date: Wed, 18 Nov 2026 15:35:23 +0100
Message-ID: <20261118150240.834093913@linuxfoundation.org>
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
index 1f16c0f4258d1..3cba702406683 100644
--- a/kernel/debug/gdbstub.c
+++ b/kernel/debug/gdbstub.c
@@ -815,9 +815,9 @@ static void gdb_cmd_query(struct kgdb_state *ks)
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



