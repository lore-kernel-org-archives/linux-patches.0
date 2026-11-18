Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795056946;
	b=WZYAyO5BJ7n75AmOaFkxJ2keze2/kPdpVZ4Rje8N2ncyDotg7lqsCdD7L7QW2J2bvHI0
	 1YSFGUBrWg0fAtWYnVKup9aTQ4heSJ5GI2uFP7IVJw/Ye9/74Pe4ju5r/pDaZ9MuBGF9S
	 wAOeV+xnV+cyOdmKhOOpJaLBb4ooH32bpQVBqB9Bv8roalMNvCDaM1bYY7+C7csjujUmD
	 76ProNxEZgFYxb9K4eszpyAvAgfmdTWF8minA+H0aRxS7QgjfZbmLN6NuW79kDFYImhXR
	 NkUsAAOA8vBLeSaFLvwe6CpKSMhhf0ZI5D9K26MJpQvVrK25UisDLavBKcxGs8P8+vg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795056946;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=mprcanLn5jHEAzKAKeynWf/6pLc45uWaHoZB/ZUPK4k=;
	b=sBKRtctPeI1y+i3CDMYAzHk7cnw40DrTSvP06DdRlcPR8eIrsr+C1YHFe5k3dgLr0B/y
	 cz63+OsgtTBOhLUHtL4RePkCKoIMFsnt/27ttUlOLJaCO1kXKDm6mL3mph+JiP4hFLMUz
	 /88LHUyY7x14lJ1TYN3BbdMu3Xxxe9tDc+PY/s4H7gbDfgOU07kBgbuIZ3y8EYlfNhvKV
	 4o5Y1UjXqOMCgglfBxdMQ67SNJFzo5ieEwfdU7oZAQKZlLmu+nCxPV+cjJLOHsG9+vNvE
	 dKOyg0CO6L3NtqwSPWr95KWLrB++cyFvu8YEypUs7KBJOjRmBaqkIcUWH8DlbkAAZWA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=HjLi33Yi;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B4F02606A32A;
	Thu, 19 Nov 2026 02:55:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=HjLi33Yi
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1BFB31F000C4;
	Thu, 19 Nov 2026 02:55:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795056946;
	bh=mprcanLn5jHEAzKAKeynWf/6pLc45uWaHoZB/ZUPK4k=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=HjLi33Yi6EZKpy+vSVyr8Swhf9+zE87rIbF+UIBV2pvJLXGtYhpoWFod1P0eJFKu7
	 LXWftQOjzYeK19ZjlikAxtuX45oSF+OQF10QIDUnD7+ApsNN0pfYmC1So/ZcQWKztH
	 VVCgO8fSVUSylIH4G80Vx2dX05hhNS3n8QNzeHIg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dudu Lu <phx0fer@gmail.com>,
	Simon Horman <horms@kernel.org>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 2128/2214] net/sched: taprio: unwind the netdevice notifier if register_qdisc() fails
Date: Wed, 18 Nov 2026 16:03:24 +0100
Message-ID: <20261118150135.678548426@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150009.797899913@linuxfoundation.org>
References: <20261118150009.797899913@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Dudu Lu <phx0fer@gmail.com>

[ Upstream commit c5234f89d7cb311880ef218cb7a969794a106678 ]

taprio_module_init() registers taprio_device_notifier and then returns
register_qdisc()'s error directly.  When register_qdisc() fails the
notifier stays registered, but the loader's failure path frees the module
image without ever calling the __exit function, so netdev_chain is left
pointing at taprio_device_notifier.notifier_call -- a function pointer
that lives in text that has just been freed.

register_qdisc() has two failure returns: -EEXIST (duplicate .id) and
-EINVAL (malformed cl_ops).  taprio_class_ops satisfies every checked
implication, so -EINVAL is unreachable and -EEXIST is the only reachable
failure; it needs a pre-existing "taprio" entry in qdisc_base.  In-tree
that is reachable only through bpf_qdisc_reg() (CONFIG_NET_SCH_BPF); a
module calling the exported register_qdisc() reaches it as well.

Once the notifier is left dangling, the next netdevice event that walks
netdev_chain calls through the stale pointer:

  BUG: KASAN: vmalloc-out-of-bounds in notifier_call_chain+0x650/0xb5c
  Read of size 8 at addr ffff80001fc5ab08 by task ip/110
   notifier_call_chain+0x650/0xb5c
   raw_notifier_call_chain+0x34/0x64
   call_netdevice_notifiers_info+0xa8/0x198
   __dev_close_many+0xe0/0x800
   ...
  >ffff80001fc5ab00: f8 f8 f8 f8 f8 f8 f8 f8 f8 f8 f8 f8 f8 f8 f8 f8

The shadow row is all f8 (KASAN_VMALLOC_INVALID): the read lands in
vmalloc memory that was poisoned when the module image was freed, and the
indirect call is unguarded because the only check, func_ptr_is_kernel_text(),
is compiled out unless CONFIG_DEBUG_NOTIFIERS.

Mirror the sibling sch_cbs.c and act_mirred.c, which unwind the notifier
on this failure path.

Fixes: 7b9eba7ba0c1 ("net/sched: taprio: fix picos_per_byte miscalculation")
Signed-off-by: Dudu Lu <phx0fer@gmail.com>
Reviewed-by: Simon Horman <horms@kernel.org>
Link: https://patch.msgid.link/20261021155417.66254-1-phx0fer@gmail.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/sched/sch_taprio.c | 6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

diff --git a/net/sched/sch_taprio.c b/net/sched/sch_taprio.c
index 6c7f4ceeadcb2..391de5338fa0f 100644
--- a/net/sched/sch_taprio.c
+++ b/net/sched/sch_taprio.c
@@ -2032,7 +2032,11 @@ static int __init taprio_module_init(void)
 	if (err)
 		return err;
 
-	return register_qdisc(&taprio_qdisc_ops);
+	err = register_qdisc(&taprio_qdisc_ops);
+	if (err)
+		unregister_netdevice_notifier(&taprio_device_notifier);
+
+	return err;
 }
 
 static void __exit taprio_module_exit(void)
-- 
2.53.0



