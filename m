Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9A99615B10D;
	Mon, 28 Oct 2024 06:32:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730097144; cv=none; b=ELQqYUapaWVo+OwELfTtt6Rz9l4JB79CbbCIEp2lhh/d+XR6xyid3h1hZFRzov0YfvEkFi/ckUBnjj57HIScZ1XChySiRXBGZkzYPCZqKF+ybahYRWasc3NZldEsTexDbvGjRXGyZWPKCfPk5TFqsFuQQOyy2JlCKjHE2YuKo4I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730097144; c=relaxed/simple;
	bh=V6LBLNBcIHlbpKOFeutmb/dDuSxnFt8X+qsGaDmyaIQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=RKJM4dRZQzPRxGukqElaExmC3ggtUEqbVkkrAvoG1DXjUXaeKAtHLSoRNt5ZkpzQFsC63ut9VWtelHvjtg29QlEcai/OD5iQ3O7sPBptDrZxs9jCXviOplrvMz+u3kjDyzfjQ8DLBRPIAKtiJrb0HqxjsYRUUznJU/tdV1jba0Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=NDXbVsJM; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="NDXbVsJM"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 33A05C4CEC7;
	Mon, 28 Oct 2024 06:32:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1730097144;
	bh=V6LBLNBcIHlbpKOFeutmb/dDuSxnFt8X+qsGaDmyaIQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=NDXbVsJMaBDZKpJl8qj7TONQ6cPbgtZunhp9gQli7SxEo0q+ql44pUSSl0JSPl/1j
	 1Y9O24as0dcWb4F+9iKfSaip+JJgkCprQahje7qL2OfsCpdLymj+C0vht43zb71+1B
	 qzeOUqMO5APwwWvblsJq5Dn8oJ9AJ4E3x6Y6RHyo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Boris Tonofa <b.tonofa@ideco.ru>,
	Petr Vaganov <p.vaganov@ideco.ru>,
	Steffen Klassert <steffen.klassert@secunet.com>
Subject: [PATCH 5.15 75/80] xfrm: fix one more kernel-infoleak in algo dumping
Date: Mon, 28 Oct 2024 07:25:55 +0100
Message-ID: <20241028062254.692605336@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241028062252.611837461@linuxfoundation.org>
References: <20241028062252.611837461@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Petr Vaganov <p.vaganov@ideco.ru>

commit 6889cd2a93e1e3606b3f6e958aa0924e836de4d2 upstream.

During fuzz testing, the following issue was discovered:

BUG: KMSAN: kernel-infoleak in _copy_to_iter+0x598/0x2a30
 _copy_to_iter+0x598/0x2a30
 __skb_datagram_iter+0x168/0x1060
 skb_copy_datagram_iter+0x5b/0x220
 netlink_recvmsg+0x362/0x1700
 sock_recvmsg+0x2dc/0x390
 __sys_recvfrom+0x381/0x6d0
 __x64_sys_recvfrom+0x130/0x200
 x64_sys_call+0x32c8/0x3cc0
 do_syscall_64+0xd8/0x1c0
 entry_SYSCALL_64_after_hwframe+0x79/0x81

Uninit was stored to memory at:
 copy_to_user_state_extra+0xcc1/0x1e00
 dump_one_state+0x28c/0x5f0
 xfrm_state_walk+0x548/0x11e0
 xfrm_dump_sa+0x1e0/0x840
 netlink_dump+0x943/0x1c40
 __netlink_dump_start+0x746/0xdb0
 xfrm_user_rcv_msg+0x429/0xc00
 netlink_rcv_skb+0x613/0x780
 xfrm_netlink_rcv+0x77/0xc0
 netlink_unicast+0xe90/0x1280
 netlink_sendmsg+0x126d/0x1490
 __sock_sendmsg+0x332/0x3d0
 ____sys_sendmsg+0x863/0xc30
 ___sys_sendmsg+0x285/0x3e0
 __x64_sys_sendmsg+0x2d6/0x560
 x64_sys_call+0x1316/0x3cc0
 do_syscall_64+0xd8/0x1c0
 entry_SYSCALL_64_after_hwframe+0x79/0x81

Uninit was created at:
 __kmalloc+0x571/0xd30
 attach_auth+0x106/0x3e0
 xfrm_add_sa+0x2aa0/0x4230
 xfrm_user_rcv_msg+0x832/0xc00
 netlink_rcv_skb+0x613/0x780
 xfrm_netlink_rcv+0x77/0xc0
 netlink_unicast+0xe90/0x1280
 netlink_sendmsg+0x126d/0x1490
 __sock_sendmsg+0x332/0x3d0
 ____sys_sendmsg+0x863/0xc30
 ___sys_sendmsg+0x285/0x3e0
 __x64_sys_sendmsg+0x2d6/0x560
 x64_sys_call+0x1316/0x3cc0
 do_syscall_64+0xd8/0x1c0
 entry_SYSCALL_64_after_hwframe+0x79/0x81

Bytes 328-379 of 732 are uninitialized
Memory access of size 732 starts at ffff88800e18e000
Data copied to user address 00007ff30f48aff0

CPU: 2 PID: 18167 Comm: syz-executor.0 Not tainted 6.8.11 #1
Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS 1.15.0-1 04/01/2014

Fixes copying of xfrm algorithms where some random
data of the structure fields can end up in userspace.
Padding in structures may be filled with random (possibly sensitve)
data and should never be given directly to user-space.

A similar issue was resolved in the commit
8222d5910dae ("xfrm: Zero padding when dumping algos and encap")

Found by Linux Verification Center (linuxtesting.org) with Syzkaller.

Fixes: c7a5899eb26e ("xfrm: redact SA secret with lockdown confidentiality")
Cc: stable@vger.kernel.org
Co-developed-by: Boris Tonofa <b.tonofa@ideco.ru>
Signed-off-by: Boris Tonofa <b.tonofa@ideco.ru>
Signed-off-by: Petr Vaganov <p.vaganov@ideco.ru>
Signed-off-by: Steffen Klassert <steffen.klassert@secunet.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/xfrm/xfrm_user.c |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

--- a/net/xfrm/xfrm_user.c
+++ b/net/xfrm/xfrm_user.c
@@ -887,7 +887,9 @@ static int copy_to_user_auth(struct xfrm
 	if (!nla)
 		return -EMSGSIZE;
 	ap = nla_data(nla);
-	memcpy(ap, auth, sizeof(struct xfrm_algo_auth));
+	strscpy_pad(ap->alg_name, auth->alg_name, sizeof(ap->alg_name));
+	ap->alg_key_len = auth->alg_key_len;
+	ap->alg_trunc_len = auth->alg_trunc_len;
 	if (redact_secret && auth->alg_key_len)
 		memset(ap->alg_key, 0, (auth->alg_key_len + 7) / 8);
 	else


