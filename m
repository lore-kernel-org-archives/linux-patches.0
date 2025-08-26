Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DB52229D29B;
	Tue, 26 Aug 2025 11:48:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756208929; cv=none; b=lSuxQwq2kI7ebI3DHlU0YPUsLbdFYAToQstkdz+Qdfi4d5hxqAoYWjWyQFAYCqFtwWBf46PWxTUAmU2e1elLmm+Gdtt3pLTc7TcIXkQH1/faLymriAENQZnhZk6EKcgghz8BDnBvhrxYtVodwEWI9MTZcvYQiqdVG7hrJ4F188g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756208929; c=relaxed/simple;
	bh=LK9YftM8ksE4x1ydQELjrdnHLQZbvr3YVIl5WyaePQM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=DvHPjEmgRTOCkL7tQ3wnfLNG8Vr/7O03e/tYufr2UQwDlCYmT7mjCoEBl2wnh081UY4TX3EyzrlpnHxeKDnn48vlL7XPVn4QUWnTFL8SYYSWynMiiVF9w8S0VP3T6K7n4dp+59/ZZJI/362zXKg6ko9S/Cwa3Suc5mbrqbB6Apw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=WprGDHaH; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="WprGDHaH"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 174F6C4CEF4;
	Tue, 26 Aug 2025 11:48:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1756208929;
	bh=LK9YftM8ksE4x1ydQELjrdnHLQZbvr3YVIl5WyaePQM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=WprGDHaHcq+yyOi/jCcwGUZazoNrIg1MnHz7Z6PGETeRFVxkZnvxUMLsdEez9GwlS
	 b2FL7oox/5ijSrZ4CAnbLtDY5sUu/6YOVOyw+DLDbVPBWNz0dNZ9RdpXou8okjRm7Q
	 BSUxsD1fk0gDkgbVsWC3Ki9/nqNxBci7ZYUpeUXs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"D. Wythe" <alibuda@linux.alibaba.com>,
	Guangguan Wang <guangguan.wang@linux.alibaba.com>,
	Alexandra Winter <wintera@linux.ibm.com>,
	Dust Li <dust.li@linux.alibaba.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 299/322] net/smc: fix UAF on smcsk after smc_listen_out()
Date: Tue, 26 Aug 2025 13:11:54 +0200
Message-ID: <20250826110923.279052263@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250826110915.169062587@linuxfoundation.org>
References: <20250826110915.169062587@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: D. Wythe <alibuda@linux.alibaba.com>

[ Upstream commit d9cef55ed49117bd63695446fb84b4b91815c0b4 ]

BPF CI testing report a UAF issue:

  [   16.446633] BUG: kernel NULL pointer dereference, address: 000000000000003  0
  [   16.447134] #PF: supervisor read access in kernel mod  e
  [   16.447516] #PF: error_code(0x0000) - not-present pag  e
  [   16.447878] PGD 0 P4D   0
  [   16.448063] Oops: Oops: 0000 [#1] PREEMPT SMP NOPT  I
  [   16.448409] CPU: 0 UID: 0 PID: 9 Comm: kworker/0:1 Tainted: G           OE      6.13.0-rc3-g89e8a75fda73-dirty #4  2
  [   16.449124] Tainted: [O]=OOT_MODULE, [E]=UNSIGNED_MODUL  E
  [   16.449502] Hardware name: QEMU Ubuntu 24.04 PC (i440FX + PIIX, 1996), BIOS 1.16.3-debian-1.16.3-2 04/01/201  4
  [   16.450201] Workqueue: smc_hs_wq smc_listen_wor  k
  [   16.450531] RIP: 0010:smc_listen_work+0xc02/0x159  0
  [   16.452158] RSP: 0018:ffffb5ab40053d98 EFLAGS: 0001024  6
  [   16.452526] RAX: 0000000000000001 RBX: 0000000000000002 RCX: 000000000000030  0
  [   16.452994] RDX: 0000000000000280 RSI: 00003513840053f0 RDI: 000000000000000  0
  [   16.453492] RBP: ffffa097808e3800 R08: ffffa09782dba1e0 R09: 000000000000000  5
  [   16.453987] R10: 0000000000000000 R11: 0000000000000000 R12: ffffa0978274640  0
  [   16.454497] R13: 0000000000000000 R14: 0000000000000000 R15: ffffa09782d4092  0
  [   16.454996] FS:  0000000000000000(0000) GS:ffffa097bbc00000(0000) knlGS:000000000000000  0
  [   16.455557] CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003  3
  [   16.455961] CR2: 0000000000000030 CR3: 0000000102788004 CR4: 0000000000770ef  0
  [   16.456459] PKRU: 5555555  4
  [   16.456654] Call Trace  :
  [   16.456832]  <TASK  >
  [   16.456989]  ? __die+0x23/0x7  0
  [   16.457215]  ? page_fault_oops+0x180/0x4c  0
  [   16.457508]  ? __lock_acquire+0x3e6/0x249  0
  [   16.457801]  ? exc_page_fault+0x68/0x20  0
  [   16.458080]  ? asm_exc_page_fault+0x26/0x3  0
  [   16.458389]  ? smc_listen_work+0xc02/0x159  0
  [   16.458689]  ? smc_listen_work+0xc02/0x159  0
  [   16.458987]  ? lock_is_held_type+0x8f/0x10  0
  [   16.459284]  process_one_work+0x1ea/0x6d  0
  [   16.459570]  worker_thread+0x1c3/0x38  0
  [   16.459839]  ? __pfx_worker_thread+0x10/0x1  0
  [   16.460144]  kthread+0xe0/0x11  0
  [   16.460372]  ? __pfx_kthread+0x10/0x1  0
  [   16.460640]  ret_from_fork+0x31/0x5  0
  [   16.460896]  ? __pfx_kthread+0x10/0x1  0
  [   16.461166]  ret_from_fork_asm+0x1a/0x3  0
  [   16.461453]  </TASK  >
  [   16.461616] Modules linked in: bpf_testmod(OE) [last unloaded: bpf_testmod(OE)  ]
  [   16.462134] CR2: 000000000000003  0
  [   16.462380] ---[ end trace 0000000000000000 ]---
  [   16.462710] RIP: 0010:smc_listen_work+0xc02/0x1590

The direct cause of this issue is that after smc_listen_out_connected(),
newclcsock->sk may be NULL since it will releases the smcsk. Therefore,
if the application closes the socket immediately after accept,
newclcsock->sk can be NULL. A possible execution order could be as
follows:

smc_listen_work                                 | userspace
-----------------------------------------------------------------
lock_sock(sk)                                   |
smc_listen_out_connected()                      |
| \- smc_listen_out                             |
|    | \- release_sock                          |
     | |- sk->sk_data_ready()                   |
                                                | fd = accept();
                                                | close(fd);
                                                |  \- socket->sk = NULL;
/* newclcsock->sk is NULL now */
SMC_STAT_SERV_SUCC_INC(sock_net(newclcsock->sk))

Since smc_listen_out_connected() will not fail, simply swapping the order
of the code can easily fix this issue.

Fixes: 3b2dec2603d5 ("net/smc: restructure client and server code in af_smc")
Signed-off-by: D. Wythe <alibuda@linux.alibaba.com>
Reviewed-by: Guangguan Wang <guangguan.wang@linux.alibaba.com>
Reviewed-by: Alexandra Winter <wintera@linux.ibm.com>
Reviewed-by: Dust Li <dust.li@linux.alibaba.com>
Link: https://patch.msgid.link/20250818054618.41615-1-alibuda@linux.alibaba.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/smc/af_smc.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/net/smc/af_smc.c b/net/smc/af_smc.c
index cdd445d40b94..02e08ac1da3a 100644
--- a/net/smc/af_smc.c
+++ b/net/smc/af_smc.c
@@ -2565,8 +2565,9 @@ static void smc_listen_work(struct work_struct *work)
 			goto out_decl;
 	}
 
-	smc_listen_out_connected(new_smc);
 	SMC_STAT_SERV_SUCC_INC(sock_net(newclcsock->sk), ini);
+	/* smc_listen_out() will release smcsk */
+	smc_listen_out_connected(new_smc);
 	goto out_free;
 
 out_unlock:
-- 
2.50.1



