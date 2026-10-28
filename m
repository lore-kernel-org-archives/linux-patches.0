Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793214360;
	b=rhCLd0fIn7By/yKYODy8sJrMbKGOyMR/MZC5NQWU2JNZG1OolKxhXF1rSJivmS3cZZWl
	 CdLqldw/mw1YMdMq/fFvfrFiMjfJJ+rnw1IMVepodDbkhRuk5Hk/JwBcWoWQ4prCgNBLC
	 ir8N60PsfXUwCGubufaIMT5lOgj4qAnjdqbSsZpVZMmEjEuCoz39knr8uSHrvU78XdYp4
	 jOaQLkGKhzXENl+P1AYyDyUNaZePcHn5rWzcVy6Yvcw8x3DIU6HyspOFNbrs+wIwQVswU
	 NeS5rpB7fMAjmiKgdnUOpCbvC2LzhCc6RTjKhPiTuhfuZBq4gV7btHbZPk4LhW2daZg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793214360;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=cDpMDpXMAhH7+qoKfwbzIq0uuTF4qVh5vHmAblW2j/s=;
	b=KTOA+J7n3Q/5E/X72VMKoCLpUgblTfvIhFahLn0y5wjGUafHsV0oeZPryO3/nRKoBSae
	 +v86YpZAcVYnP/rYctmFU/C+8DeprWSI7v83OvixPSwLyEZGmzyQsfaPuAq+G66v2HFy+
	 hUlifUTv8c5pgKrXhf708BxETqToq6ZDE+BC7U4DjwqT0lYo/agKDqfWDwykFL/Hwg5g4
	 TCc1pmPsZ3o//Kqa0TfnxwFOZzqMNy+wZsKkNxJWzuq9Ph8wcNLUN16trgM0gsKx+5nUW
	 Kkr82DClBBCPtxQDei2HidoE+JZ8h5CkJ7EazFDEeEzSTR99Ka3Pv4LLY7OOCorS0VA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=0qMGZlBy;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6138B606A335;
	Wed, 28 Oct 2026 19:06:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=0qMGZlBy
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 843901F01825;
	Wed, 28 Oct 2026 19:05:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793214360;
	bh=cDpMDpXMAhH7+qoKfwbzIq0uuTF4qVh5vHmAblW2j/s=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=0qMGZlBy3wZoVVIGvN4TlOn4L6WyqyHUQ4ElpPZ+TnqEWRklH94w1vAgom8+xNPI2
	 h8VypzJm/ppdEhY7V16pnCv8YIbi0aCf2lVaultWR5rKAdIcpctFvhjC2ad5pJUKlM
	 EzXcWBrKGFs86bqgk3Y3oIv4+m+tmkbMbKzEUBYI=
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
Subject: [PATCH 6.1 0831/1887] net/smc: fix UAF on smcsk after smc_listen_out()
Date: Wed, 28 Oct 2026 17:48:47 +0100
Message-ID: <20261028170518.334597609@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261028170459.200466217@linuxfoundation.org>
References: <20261028170459.200466217@linuxfoundation.org>
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
index 71ceaab9b6dd3..75d9036282298 100644
--- a/net/smc/af_smc.c
+++ b/net/smc/af_smc.c
@@ -2468,8 +2468,9 @@ static void smc_listen_work(struct work_struct *work)
 		mutex_unlock(&smc_server_lgr_pending);
 	}
 	smc_conn_save_peer_info(new_smc, cclc);
-	smc_listen_out_connected(new_smc);
 	SMC_STAT_SERV_SUCC_INC(sock_net(newclcsock->sk), ini);
+	/* smc_listen_out() will release smcsk */
+	smc_listen_out_connected(new_smc);
 	goto out_free;
 
 out_unlock:
-- 
2.53.0



