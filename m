Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2E8F65226AB;
	Wed, 30 Sep 2026 18:31:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790793112; cv=none; b=IN3Q0Xn1sDI/hf2LWSsdomhWQUm3GqV/6DiB7BjiRu6hbhr2OuFWVTaCow3HvbLsKe/YRZiZI8rkJVYgR7bKldBC+0rNPx0iuPauOECxzw5+MV0Mgpx0/8rqYIQVW5JkJ5zytvQ9q/52zWm5gH2r5Hw02kR/NU8Jo4sUyWMhvbk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790793112; c=relaxed/simple;
	bh=pxjVyP2Mqiueid2LLCGCI7+alsZLOqMn+TRSukOYvFc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=H/tHLwfkyvVz0EC9w/Xfkb+OcEp7DS8Ci6JpGC3Uzfhy0SK6tQWhsdBEUWGX0FRTiQasVThsgVlP0fPL+CviYCoCsB/fpqVieCUdBZkO3a484Or8GbZJbEa7T4GLgl3i/NpU1VozNyZkVAtJxVDUW3jntNQvZ1y+9dGzbPPuuNA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Q7+gvf/D; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Q7+gvf/D"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 843621F000FF;
	Wed, 30 Sep 2026 18:31:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790793110;
	bh=urb6kGThVsTynWge3D0masBK4vF7E3jjkypIpP5UF4E=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Q7+gvf/DQ1vxNMUeHZZR08BmzbD5PBE3BNkhs1qsy86v0K4zrr1g2QWNpzDWCm+hq
	 nbD90VFoO9IFsmd6S3LuPqV7B0M9/d9Fbwu+qIaap3Zd/y3Ql/9vF/WUfrXM9M2f7Z
	 7TVwXzOyv6jjUyywYrhKtAHS9vuOfaAxfogFg/bM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	co+ac0a8c41de69121d@bugs.sh,
	Weiming Shi <bestswngs@gmail.com>,
	Alexei Starovoitov <ast@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 140/395] bpf: Reject dev-bound-only programs on other devices
Date: Wed, 30 Sep 2026 17:26:42 +0200
Message-ID: <20260930152343.681401499@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260930152340.591469096@linuxfoundation.org>
References: <20260930152340.591469096@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Weiming Shi <bestswngs@gmail.com>

[ Upstream commit 6db1ce73e9853f533eb7f413f14ba00f8ec6f80d ]

__bpf_offload_dev_match() falls back to comparing offdev pointers after an
exact netdev mismatch. Bound-only programs normally have NULL offdevs, so
unrelated netdevs compare equal. A bound-only program on an
offload-registered netdev can instead inherit a real offdev and match a
sibling port. With CAP_BPF and CAP_NET_ADMIN, a caller can use
bpf(BPF_LINK_CREATE) with a different target ifindex to run metadata kfuncs
specialized for the bound driver on the target driver's xdp_buff. Running a
veth-bound program on tun reads beyond tun's bare stack xdp_buff as a
veth_xdp_buff.

  Oops: general protection fault, probably for non-canonical address
  KASAN: null-ptr-deref in range [0x0000000000000010-0x0000000000000017]
  RIP: 0010:veth_xdp_rx_timestamp (drivers/net/veth.c:1673)
  Call Trace:
   ...
   tun_build_skb (drivers/net/tun.c:1739)
   tun_get_user (drivers/net/tun.c:1856)
   tun_chr_write_iter (drivers/net/tun.c:2091)
   vfs_write (fs/read_write.c:595 fs/read_write.c:687)
   ksys_write (fs/read_write.c:739)
   do_syscall_64 (arch/x86/entry/syscall_64.c:84)
   entry_SYSCALL_64_after_hwframe (arch/x86/entry/entry_64.S:121)
  Kernel panic - not syncing: Fatal exception in interrupt

Restrict non-offloaded programs to exact netdev matches and retain the
shared-offdev fallback only for genuinely offloaded multi-port programs.

Fixes: 2b3486bc2d23 ("bpf: Introduce device-bound XDP programs")
Reported-by: <co+ac0a8c41de69121d@bugs.sh>
Signed-off-by: Weiming Shi <bestswngs@gmail.com>
Signed-off-by: Alexei Starovoitov <ast@kernel.org>
Link: https://lore.kernel.org/bpf/20260917161335.1020405-2-bestswngs@gmail.com/
Link: https://patch.msgid.link/20260920132303.4109240-3-bestswngs@gmail.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/bpf/offload.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/kernel/bpf/offload.c b/kernel/bpf/offload.c
index a9a036547c960..884f1eeaba2ef 100644
--- a/kernel/bpf/offload.c
+++ b/kernel/bpf/offload.c
@@ -708,6 +708,8 @@ static bool __bpf_offload_dev_match(struct bpf_prog *prog,
 		return false;
 	if (offload->netdev == netdev)
 		return true;
+	if (!bpf_prog_is_offloaded(prog->aux))
+		return false;
 
 	ondev1 = bpf_offload_find_netdev(offload->netdev);
 	ondev2 = bpf_offload_find_netdev(netdev);
-- 
2.53.0



