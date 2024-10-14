Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 865D7610B;
	Mon, 14 Oct 2024 14:31:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728916319; cv=none; b=heIlv2el9VJLknSZSip27jfMRXxTmkypuoEoAydNmDx609Fj4b11C6flgHA6NffeKRmN9BtTojPksvEBxor7dAZOpKrr868tvLNZAFcjNk4YyAq4m0sHdv1Kf3HtaqP50L28bRJ0QGum/lp9+Z2dWZUylnPy1+Bs0NtMjF4fqt0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728916319; c=relaxed/simple;
	bh=bGnWvBN44XyssaBiPBP81p5sBPaIq/IuD96lOUa3U60=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=fuPFX+mrg+0q445Ar10m1pw1ba3HSd/hJylV7R5E/FIo5FAxvluG1Gerlj9k0Hy+SH5B1tXJNvskPAnO1VmQPtYMBdilIz1K52JS6mK/zbGQ7O+XSFvdQ3O4kD7G2r7Q2jPnNlEDD9YdjPytAo67Ub/RdMbuQhOhD37+nKBpe3w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=CrHbmqB8; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="CrHbmqB8"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 10727C4CEC3;
	Mon, 14 Oct 2024 14:31:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1728916319;
	bh=bGnWvBN44XyssaBiPBP81p5sBPaIq/IuD96lOUa3U60=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=CrHbmqB8fSrTxIE9hT+MsE3gEKtfFcD+3TYEMsnt+9Iy8OwjONh7HUWZRypl1OF+r
	 aKLpHP5Er7+UQjBItanyGwzy/XeITHPJEIJRZ+uFTUfp+7vVTWrDTdZycB9eIV6sv9
	 GSaFrRZ5l5UDeC39+0ah/rvylx+FymVzdH92t27g=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Eric Dumazet <edumazet@google.com>,
	"D. Wythe" <alibuda@linux.alibaba.com>,
	Wenjia Zhang <wenjia@linux.ibm.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.11 148/214] net/smc: fix lacks of icsk_syn_mss with IPPROTO_SMC
Date: Mon, 14 Oct 2024 16:20:11 +0200
Message-ID: <20241014141050.763814480@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241014141044.974962104@linuxfoundation.org>
References: <20241014141044.974962104@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.11-stable review patch.  If anyone has any objections, please let me know.

------------------

From: D. Wythe <alibuda@linux.alibaba.com>

[ Upstream commit 6fd27ea183c208e478129a85e11d880fc70040f2 ]

Eric report a panic on IPPROTO_SMC, and give the facts
that when INET_PROTOSW_ICSK was set, icsk->icsk_sync_mss must be set too.

Bug: Unable to handle kernel NULL pointer dereference at virtual address
0000000000000000
Mem abort info:
ESR = 0x0000000086000005
EC = 0x21: IABT (current EL), IL = 32 bits
SET = 0, FnV = 0
EA = 0, S1PTW = 0
FSC = 0x05: level 1 translation fault
user pgtable: 4k pages, 48-bit VAs, pgdp=00000001195d1000
[0000000000000000] pgd=0800000109c46003, p4d=0800000109c46003,
pud=0000000000000000
Internal error: Oops: 0000000086000005 [#1] PREEMPT SMP
Modules linked in:
CPU: 1 UID: 0 PID: 8037 Comm: syz.3.265 Not tainted
6.11.0-rc7-syzkaller-g5f5673607153 #0
Hardware name: Google Google Compute Engine/Google Compute Engine,
BIOS Google 08/06/2024
pstate: 80400005 (Nzcv daif +PAN -UAO -TCO -DIT -SSBS BTYPE=--)
pc : 0x0
lr : cipso_v4_sock_setattr+0x2a8/0x3c0 net/ipv4/cipso_ipv4.c:1910
sp : ffff80009b887a90
x29: ffff80009b887aa0 x28: ffff80008db94050 x27: 0000000000000000
x26: 1fffe0001aa6f5b3 x25: dfff800000000000 x24: ffff0000db75da00
x23: 0000000000000000 x22: ffff0000d8b78518 x21: 0000000000000000
x20: ffff0000d537ad80 x19: ffff0000d8b78000 x18: 1fffe000366d79ee
x17: ffff8000800614a8 x16: ffff800080569b84 x15: 0000000000000001
x14: 000000008b336894 x13: 00000000cd96feaa x12: 0000000000000003
x11: 0000000000040000 x10: 00000000000020a3 x9 : 1fffe0001b16f0f1
x8 : 0000000000000000 x7 : 0000000000000000 x6 : 000000000000003f
x5 : 0000000000000040 x4 : 0000000000000001 x3 : 0000000000000000
x2 : 0000000000000002 x1 : 0000000000000000 x0 : ffff0000d8b78000
Call trace:
0x0
netlbl_sock_setattr+0x2e4/0x338 net/netlabel/netlabel_kapi.c:1000
smack_netlbl_add+0xa4/0x154 security/smack/smack_lsm.c:2593
smack_socket_post_create+0xa8/0x14c security/smack/smack_lsm.c:2973
security_socket_post_create+0x94/0xd4 security/security.c:4425
__sock_create+0x4c8/0x884 net/socket.c:1587
sock_create net/socket.c:1622 [inline]
__sys_socket_create net/socket.c:1659 [inline]
__sys_socket+0x134/0x340 net/socket.c:1706
__do_sys_socket net/socket.c:1720 [inline]
__se_sys_socket net/socket.c:1718 [inline]
__arm64_sys_socket+0x7c/0x94 net/socket.c:1718
__invoke_syscall arch/arm64/kernel/syscall.c:35 [inline]
invoke_syscall+0x98/0x2b8 arch/arm64/kernel/syscall.c:49
el0_svc_common+0x130/0x23c arch/arm64/kernel/syscall.c:132
do_el0_svc+0x48/0x58 arch/arm64/kernel/syscall.c:151
el0_svc+0x54/0x168 arch/arm64/kernel/entry-common.c:712
el0t_64_sync_handler+0x84/0xfc arch/arm64/kernel/entry-common.c:730
el0t_64_sync+0x190/0x194 arch/arm64/kernel/entry.S:598
Code: ???????? ???????? ???????? ???????? (????????)
---[ end trace 0000000000000000 ]---

This patch add a toy implementation that performs a simple return to
prevent such panic. This is because MSS can be set in sock_create_kern
or smc_setsockopt, similar to how it's done in AF_SMC. However, for
AF_SMC, there is currently no way to synchronize MSS within
__sys_connect_file. This toy implementation lays the groundwork for us
to support such feature for IPPROTO_SMC in the future.

Fixes: d25a92ccae6b ("net/smc: Introduce IPPROTO_SMC")
Reported-by: Eric Dumazet <edumazet@google.com>
Signed-off-by: D. Wythe <alibuda@linux.alibaba.com>
Reviewed-by: Eric Dumazet <edumazet@google.com>
Reviewed-by: Wenjia Zhang <wenjia@linux.ibm.com>
Link: https://patch.msgid.link/1728456916-67035-1-git-send-email-alibuda@linux.alibaba.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/smc/smc_inet.c | 11 +++++++++++
 1 file changed, 11 insertions(+)

diff --git a/net/smc/smc_inet.c b/net/smc/smc_inet.c
index a5b2041600f95..a944e7dcb8b96 100644
--- a/net/smc/smc_inet.c
+++ b/net/smc/smc_inet.c
@@ -108,12 +108,23 @@ static struct inet_protosw smc_inet6_protosw = {
 };
 #endif /* CONFIG_IPV6 */
 
+static unsigned int smc_sync_mss(struct sock *sk, u32 pmtu)
+{
+	/* No need pass it through to clcsock, mss can always be set by
+	 * sock_create_kern or smc_setsockopt.
+	 */
+	return 0;
+}
+
 static int smc_inet_init_sock(struct sock *sk)
 {
 	struct net *net = sock_net(sk);
 
 	/* init common smc sock */
 	smc_sk_init(net, sk, IPPROTO_SMC);
+
+	inet_csk(sk)->icsk_sync_mss = smc_sync_mss;
+
 	/* create clcsock */
 	return smc_create_clcsk(net, sk, sk->sk_family);
 }
-- 
2.43.0



