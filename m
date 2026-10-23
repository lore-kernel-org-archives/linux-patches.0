Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792774158;
	b=Xzm3hZ5LNFJ52X4m9xBvB4WkX4hndZkG05+cpqDWbBXospYMUlln9zgAwmTJLURrs9ua
	 +uquk3VnZkbYbK/eXNQDgCDYhCv8SSkDaXZp4WXIr1S7DcvCf9BYFaDcS4liGoyTtPp1m
	 JQbfoDgkA59AyKNm72w/xb4gctQd2EIAtgRzTCKiAzkbBgWlC31T9JX4kvyiEkBGNXUch
	 ZogvO+igc27OKHkis5KShDEBNcrUrocXg7Wk4/+AuhhF/pdWl++okSq58vkZ/nOutZ96p
	 gtuNgO3JX3qPWTGdiNgeA/3+59/gHajldU01xrJfcRzpxqJOLDkcZPznAMGNJoFAzww==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792774158;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=aeczG0yzwM4SERtYr6GpJCS/v/0VSI5KKvleqIJZuFs=;
	b=MR1EVkch7LvpK7o62/1QpHhErUIWJyTu9m4qgAYelvOMnqhqLQczWLo/11WfsDZOFqhn
	 bDubi5iqfa67Mg+kwV/syJ4VvPczOaDIXkkF/zP4fgp7UlQmAla182idSlb8MM1XOT+6u
	 sHM3XykIjQF2vw3AbIB5/HCC5SX7ne6IW/zgZQA73vQ2/sJJU52nWN4YX59BJ9QML7B/c
	 oSu7PNWPJF0KjJyHUPnSuMFMu7tplhpJ/e9b28jF9bxhbCYnJjdrnvmvWxgRPtu1k6GRZ
	 93S/nD7yfnnPtozxeRTA52TRd/DP+lp6dA01XIMqYvAFvZBMScgrQ5PGS2LvROkBB6w==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=dGwAOA2f;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CF214606A31A;
	Fri, 23 Oct 2026 16:49:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=dGwAOA2f
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1F86F1F01825;
	Fri, 23 Oct 2026 16:49:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1792774157;
	bh=aeczG0yzwM4SERtYr6GpJCS/v/0VSI5KKvleqIJZuFs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=dGwAOA2ff5mIjDsjLk/hGbJNiysc5mVxZwEAZ0nikSl+2RPqAYYs+g9cXFeLu9JlG
	 t6V/q6rV5ANmZY0vFNdPKvwrtRo1Uevwnv+2tHdp387kpr8sutYcN0cM8zQZsg9DCC
	 J26elbOTwu1KYfxSepctaaUMg2VosaPxL5OAoM+U=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mike Christie <michael.christie@oracle.com>,
	Yehyeong Lee <yhlee@isslab.korea.ac.kr>,
	"Martin K. Petersen (Oracle)" <mkp@kernel.org>
Subject: [PATCH 6.18 102/193] scsi: libiscsi: Validate the task named by a management response
Date: Fri, 23 Oct 2026 18:36:19 +0200
Message-ID: <20261023163716.620765005@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261023163714.201276352@linuxfoundation.org>
References: <20261023163714.201276352@linuxfoundation.org>
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

From: Yehyeong Lee <yhlee@isslab.korea.ac.kr>

commit 11bffcd9cb346732eab2914ef44fe777a3f0b585 upstream.

__iscsi_complete_pdu() fetches the task for five response types from one
place and checks only that the index resolved:

      case ISCSI_OP_LOGOUT_RSP:
      case ISCSI_OP_LOGIN_RSP:
      case ISCSI_OP_TEXT_RSP:
      case ISCSI_OP_SCSI_TMFUNC_RSP:
      case ISCSI_OP_NOOP_IN:
              task = iscsi_itt_to_task(conn, hdr->itt);
              if (!task)
                      return ISCSI_ERR_BAD_ITT;

iscsi_itt_to_task() bounds the index against cmds_max and looks at
nothing else, so a target can name any slot in the pool, including one
that has never been used. task->conn is then NULL, and both
iscsi_nop_out_rsp() and iscsi_complete_task() dereference it. One
unsolicited NOP-In is enough; a Text Response carrying the same ITT
crashes in iscsi_complete_task() instead.

Require the task to be in flight and not a SCSI command, the way
iscsi_itt_to_ctask() does for the command opcodes.

[    6.298634] Oops: general protection fault, probably for non-canonical address 0xdffffc000000000c: 0000 [#1] SMP KASAN NOPTI
[    6.298642] KASAN: null-ptr-deref in range [0x0000000000000060-0x0000000000000067]
[    6.298652] CPU: 1 UID: 0 PID: 111 Comm: iscsistart Not tainted 7.2.0-rc5-ISCSI1-gf5098b6bae76 #1 PREEMPT(lazy)
[    6.298654] Hardware name: QEMU Ubuntu 24.04 PC v2 (i440FX + PIIX, arch_caps fix, 1996), BIOS 1.16.3-debian-1.16.3-2 04/01/2014
[    6.298656] RIP: 0010:iscsi_nop_out_rsp.constprop.0+0x46/0x160
[    6.298691] Code: c1 ea 03 48 83 ec 08 80 3c 02 00 0f 85 f5 00 00 00 48 b8 00 00 00 00 00 fc ff df 48 8b 6b 58 48 8d 7d 60 48 89 fa 48 c1 ea 03 <80> 3c 02 00 0f 85 c0 00 00 00 48 8b 45 60 48 39 c3 74 50 48 b8 00
[    6.298698] RSP: 0018:ffff88806c907be8 EFLAGS: 00010206
[    6.298701] RAX: dffffc0000000000 RBX: ffff888006116800 RCX: 0000000000000020
[    6.298702] RDX: 000000000000000c RSI: ffff88800525d578 RDI: 0000000000000060
[    6.298703] RBP: 0000000000000000 R08: 0000000000000000 R09: 0000000000000000
[    6.298706] R10: 0000000000000020 R11: 0000000000000000 R12: 0000000000000000
[    6.298706] R13: 000000000000002e R14: ffff8880056eb440 R15: ffff888006116800
[    6.298707] FS:  00007fc02d1c2740(0000) GS:ffff8880b29bc000(0000) knlGS:0000000000000000
[    6.298710] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[    6.298711] CR2: 000055fe3b56ddf8 CR3: 00000000053b9004 CR4: 0000000000770ef0
[    6.298712] PKRU: 55555554
[    6.298713] Call Trace:
[    6.298714]  <IRQ>
[    6.298714]  __iscsi_complete_pdu+0x13a8/0x22a0
[    6.298758]  iscsi_complete_pdu+0x54/0xa0
[    6.298759]  iscsi_tcp_hdr_recv_done+0x870/0x2c80
[    6.298778]  iscsi_tcp_recv_skb+0x31e/0xec0
[    6.298800]  iscsi_sw_tcp_recv+0x12f/0x390
[    6.298804]  __tcp_read_sock+0x1ab/0x810
[    6.298812]  iscsi_sw_tcp_data_ready+0x18b/0x510
[    6.298814]  tcp_rcv_established+0x1f56/0x3a00
[    6.298842]  tcp_v4_do_rcv+0x449/0x960
[    6.298847]  tcp_v4_rcv+0x2245/0x3bc0

Fixes: 7996a778ff8c ("[SCSI] iscsi: add libiscsi")
Cc: stable@vger.kernel.org
Reviewed-by: Mike Christie <michael.christie@oracle.com>
Signed-off-by: Yehyeong Lee <yhlee@isslab.korea.ac.kr>
Link: https://patch.msgid.link/20261007015842.634893-4-yhlee@isslab.korea.ac.kr
Signed-off-by: Martin K. Petersen (Oracle) <mkp@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/scsi/libiscsi.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/scsi/libiscsi.c
+++ b/drivers/scsi/libiscsi.c
@@ -1286,7 +1286,7 @@ int __iscsi_complete_pdu(struct iscsi_co
 	case ISCSI_OP_SCSI_TMFUNC_RSP:
 	case ISCSI_OP_NOOP_IN:
 		task = iscsi_itt_to_task(conn, hdr->itt);
-		if (!task)
+		if (!task || task->state == ISCSI_TASK_FREE || task->sc)
 			return ISCSI_ERR_BAD_ITT;
 		break;
 	default:


