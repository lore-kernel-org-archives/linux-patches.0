Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A9FF42DC76C;
	Wed, 20 May 2026 17:21:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779297683; cv=none; b=fDYgEDrP2QmXpJ5GdRXzmf8RKbS9kiQb0qlsb+Vou8H/t/794wsibhryHAtpbcuOXEdZbNRCYzc0WzSGDNhvQ0YvtL//HlTOVAwfcAr2oSn2JC+3sdpgQjmIfikxu923OYKfyjFnjqtskgXuGIIc3Hxm+riewJvyZb0fB3m7Kc8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779297683; c=relaxed/simple;
	bh=0MxombyVQxDkid9JkTz540AOEiExFKz1K2abTH7YBA0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=bSXkF51+R5Nptr9zbZYAGFA4n5Jh0wCF4glvrKEzvyH/041BkQLEjTXaY/MRUjuhWS013Lv6p0MBh+QQjxvz/eGM4dlhDlgyMLhL/L62riDpua3ycvA+cwexEw9jjCWJ2J0sIdbaSDDqJg31p0DmR5okAmXmoElWWBohiIqSXUo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=bO0eJwz7; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="bO0eJwz7"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1B4771F000E9;
	Wed, 20 May 2026 17:21:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1779297682;
	bh=5yDQDCF8ifZEKNN6IoPrwRpRUuaoHD2KLh/328PUBK8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=bO0eJwz7YLSOhUzPR3ryZw7QGjOl4hTVaAhMY5TdtraWzwg72J3pbo2WOO+47rcIy
	 dD8Ybr/+JmCQEEHQ8Rrr8DGu0l0kzaZum8cJmYmo4PB+QPFM3oi+5W2FSGNvhLF2cq
	 Vtn9Xz0uMRbSIq17ZR9Ir6Rfo6vbAPno5aoqU12w=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	MingTao Huang <mintaohuang@tencent.com>,
	Alexei Starovoitov <ast@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 122/957] bpf: Fix stale offload->prog pointer after constant blinding
Date: Wed, 20 May 2026 18:10:05 +0200
Message-ID: <20260520162137.204961618@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260520162134.554764788@linuxfoundation.org>
References: <20260520162134.554764788@linuxfoundation.org>
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

From: MingTao Huang <mintaohuang@tencent.com>

[ Upstream commit a1aa9ef47c299c5bbc30594d3c2f0589edf908e6 ]

When a dev-bound-only BPF program (BPF_F_XDP_DEV_BOUND_ONLY) undergoes
JIT compilation with constant blinding enabled (bpf_jit_harden >= 2),
bpf_jit_blind_constants() clones the program. The original prog is then
freed in bpf_jit_prog_release_other(), which updates aux->prog to point
to the surviving clone, but fails to update offload->prog.

This leaves offload->prog pointing to the freed original program. When
the network namespace is subsequently destroyed, cleanup_net() triggers
bpf_dev_bound_netdev_unregister(), which iterates ondev->progs and calls
__bpf_prog_offload_destroy(offload->prog). Accessing the freed prog
causes a page fault:

BUG: unable to handle page fault for address: ffffc900085f1038
Workqueue: netns cleanup_net
RIP: 0010:__bpf_prog_offload_destroy+0xc/0x80
Call Trace:
__bpf_offload_dev_netdev_unregister+0x257/0x350
bpf_dev_bound_netdev_unregister+0x4a/0x90
unregister_netdevice_many_notify+0x2a2/0x660
...
cleanup_net+0x21a/0x320

The test sequence that triggers this reliably is:

1. Set net.core.bpf_jit_harden=2 (echo 2 > /proc/sys/net/core/bpf_jit_harden)
2. Run xdp_metadata selftest, which creates a dev-bound-only XDP
   program on a veth inside a netns (./test_progs -t xdp_metadata)
3. cleanup_net -> page fault in __bpf_prog_offload_destroy

Dev-bound-only programs are unique in that they have an offload structure
but go through the normal JIT path instead of bpf_prog_offload_compile().
This means they are subject to constant blinding's prog clone-and-replace,
while also having offload->prog that must stay in sync.

Fix this by updating offload->prog in bpf_jit_prog_release_other(),
alongside the existing aux->prog update. Both are back-pointers to
the prog that must be kept in sync when the prog is replaced.

Fixes: 2b3486bc2d23 ("bpf: Introduce device-bound XDP programs")
Signed-off-by: MingTao Huang <mintaohuang@tencent.com>
Link: https://lore.kernel.org/r/tencent_BCF692F45859CCE6C22B7B0B64827947D406@qq.com
Signed-off-by: Alexei Starovoitov <ast@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/bpf/core.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/kernel/bpf/core.c b/kernel/bpf/core.c
index 8de006d388f67..931a4ddd8530c 100644
--- a/kernel/bpf/core.c
+++ b/kernel/bpf/core.c
@@ -1468,6 +1468,8 @@ void bpf_jit_prog_release_other(struct bpf_prog *fp, struct bpf_prog *fp_other)
 	 * know whether fp here is the clone or the original.
 	 */
 	fp->aux->prog = fp;
+	if (fp->aux->offload)
+		fp->aux->offload->prog = fp;
 	bpf_prog_clone_free(fp_other);
 }
 
-- 
2.53.0



