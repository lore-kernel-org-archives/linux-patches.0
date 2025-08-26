Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0004422DF99;
	Tue, 26 Aug 2025 13:13:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756214035; cv=none; b=l/jNIO/Mn+0hipA8qZ2q1a9Wkqzr/kVLkzzarV6u3Xyc6vobX6xkg/rOjnUwn+JnKwYTx8RaSeFi4Yf//bE2t0sSlc8w+xn/Z5b4D8dIxWNaYwQ7nCvkHuv8Y7+suMuiLH+yWIcFV24TmVBkr6iIilfgHjFv3Gcuc5NkGt5suo4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756214035; c=relaxed/simple;
	bh=hoDk8KIrMLWn2MKF+hBzEcshYbZ5D1YjK8Infrlumd0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=FrQ1OmyE9MykuLqnNs1fjgoqkCnfg4I9LpopQxk6sd/xPweAdrQNoQ8hlKeY1rAlASRPN2JVC2ideYLRTleJg8yUgUukOtdGxX5RozYTXPDEUVvSOFPWaYs9DWlroVXUa0JET24N70Arl2QXbEnFf+OgzfY3xBM5Cl2t/FqS66o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=AZyixPhk; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="AZyixPhk"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2438FC4CEF1;
	Tue, 26 Aug 2025 13:13:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1756214034;
	bh=hoDk8KIrMLWn2MKF+hBzEcshYbZ5D1YjK8Infrlumd0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=AZyixPhkd3ax8L3iGILXxNdC7AsHwtqTIWxY/zqy3eDgJivAi1aW9yz88UGfsIgEN
	 HcSGtoFyz3mW7tRdNZ4EOXRoEo1UbFt0fRuwHwHMlacE7A8lmzgx6pXrYgjgehR1rC
	 Fjq+KlAlooggmto2rF7VrzTK2tig0MzbFsjQm5jM=
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
Subject: [PATCH 6.6 572/587] net/smc: fix UAF on smcsk after smc_listen_out()
Date: Tue, 26 Aug 2025 13:12:01 +0200
Message-ID: <20250826111007.586321088@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250826110952.942403671@linuxfoundation.org>
References: <20250826110952.942403671@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
index 8f75bb9d165a..b3bfd0f18d41 100644
--- a/net/smc/af_smc.c
+++ b/net/smc/af_smc.c
@@ -2553,8 +2553,9 @@ static void smc_listen_work(struct work_struct *work)
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



