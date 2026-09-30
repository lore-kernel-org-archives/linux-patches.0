Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9FEAB403B1B;
	Wed, 30 Sep 2026 19:33:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790796792; cv=none; b=KwgIUZezgCO74h0PduVoMrhrgj5X1A9/YzUcABMF91uJOfb26TycwYq91I69ZiXaNiUyCZuJSY0jt+NeThKmABIVo/ldkBISX4kXo5y/lQoa9fd9SNivBLzZ/1IcSBBc1OHuaGAJyWuwVSU/+eJJSjmsT+/+5xPqndkGR2bLGd8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790796792; c=relaxed/simple;
	bh=YAyBjApauWMwJHw66QymB7zNTmqus3qK0LS+J8vxP40=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=qRPEqcvnze+dPoapo+y1uasroA0oL3bWyMTADutCH9oGyxFdvazCuqZ6Nz0Eoe+crKBq5RhG3AQ9RqAoW5v3vp8lXulk8JDg7+0qO4oCnFqwaHI8gcwfUUW6VFQdMQz01GFdMkHbxnSkDTqbRfWHsF1HnCN86DGaYPk6g9tXvgA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=pvgsQM7O; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="pvgsQM7O"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 05C0A1F000FF;
	Wed, 30 Sep 2026 19:33:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790796791;
	bh=Pm5wMF09TUlsc/zFytiQy8TFhVf3UkPQQIWHmAiw61o=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=pvgsQM7O454Uj41vniAwO/SJgmdWOZi2fmim+htWsdkS277SPfi/Wi1xGQeRBc7Xr
	 h1+/q1SPYx+lEgvx/3DJkzMA1FeMxcqo8n1GWECb9JTrvQWUw4Sa43rWSQ3Qupxz1q
	 hwa/4iX761o792025MKtE66BTHaopqnRqYeA75ZY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	co+ac0a8c41de69121d@bugs.sh,
	Weiming Shi <bestswngs@gmail.com>,
	Alexei Starovoitov <ast@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 1036/1193] bpf: Reject dev-bound-only programs on other devices
Date: Wed, 30 Sep 2026 17:28:40 +0200
Message-ID: <20260930152457.242773956@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260930152434.301151190@linuxfoundation.org>
References: <20260930152434.301151190@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
index 60c82c328d42a..3345de2da15dd 100644
--- a/kernel/bpf/offload.c
+++ b/kernel/bpf/offload.c
@@ -696,6 +696,8 @@ static bool __bpf_offload_dev_match(struct bpf_prog *prog,
 		return false;
 	if (offload->netdev == netdev)
 		return true;
+	if (!bpf_prog_is_offloaded(prog->aux))
+		return false;
 
 	ondev1 = bpf_offload_find_netdev(offload->netdev);
 	ondev2 = bpf_offload_find_netdev(netdev);
-- 
2.53.0



