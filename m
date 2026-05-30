Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8DA1F3148DA;
	Sat, 30 May 2026 17:09:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780160979; cv=none; b=gFPtU9RJWPvD/hm+j9zXmGzJEeXP1LVBS0mWxG6d+GH0GQz9A5hJ85m26haav6Vf3YL1YDgeD5OdOV32a3c6T9C2H+xDUxYI/eBUQ7oHSA043aByXRGfkTn8OAXoQvOinv6Ojt5TZ072bSdD146l8WG4Q6T/XIRID37uvAXkBME=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780160979; c=relaxed/simple;
	bh=Q/GzLjuwxbIZX6soeFaXBCSEU6wzhnaooICD89nNOgo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=sovvZpzdZLZC9PeciC1penWbk1AcjXp1dB5SiiKazFK8LdCpJ8+1Vbc1bELJAXtX1YgSRCK5Cbo4eJ61dsZSc/fYSfjc3Tr9t3Sal03Af/x0UIK31AkOFdY5wM7m3C/Rw7LTiAdMA9xjv6IKs/r6Dqc1fwLvkHAXJEkX9TxoqGk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=k9Zmqi/Y; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="k9Zmqi/Y"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9A9911F00893;
	Sat, 30 May 2026 17:09:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1780160978;
	bh=AClRTyh/4crBDhfeEYy0UkXRJqucJ7nIgntyxdxXQN4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=k9Zmqi/YnVQ3cCb/Wm7G77Op9fOmm1eFJWygZVWLHJH9loq43ZEIwBkpjHXlDvyOz
	 VudJlwG3wmokIaNaO+MNCM9CbwJpOI2XhFuV/Jr3VDKUcl88+Kt7+LLMS9OZryBjyg
	 9UGern1nr9S2AyBRXPe5eFysL5SASbPsTtl9/9A4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	syzbot+80e046b8da2820b6ba73@syzkaller.appspotmail.com,
	Daniel Borkmann <daniel@iogearbox.net>,
	Jiayuan Chen <jiayuan.chen@linux.dev>,
	Paolo Abeni <pabeni@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 490/969] net, bpf: fix null-ptr-deref in xdp_master_redirect() for down master
Date: Sat, 30 May 2026 18:00:14 +0200
Message-ID: <20260530160313.844973640@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260530160300.485627683@linuxfoundation.org>
References: <20260530160300.485627683@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jiayuan Chen <jiayuan.chen@linux.dev>

[ Upstream commit 1921f91298d1388a0bb9db8f83800c998b649cb3 ]

syzkaller reported a kernel panic in bond_rr_gen_slave_id() reached via
xdp_master_redirect(). Full decoded trace:

  https://syzkaller.appspot.com/bug?extid=80e046b8da2820b6ba73

bond_rr_gen_slave_id() dereferences bond->rr_tx_counter, a per-CPU
counter that bonding only allocates in bond_open() when the mode is
round-robin. If the bond device was never brought up, rr_tx_counter
stays NULL.

The XDP redirect path can still reach that code on a bond that was
never opened: bpf_master_redirect_enabled_key is a global static key,
so as soon as any bond device has native XDP attached, the
XDP_TX -> xdp_master_redirect() interception is enabled for every
slave system-wide. The path xdp_master_redirect() ->
bond_xdp_get_xmit_slave() -> bond_xdp_xmit_roundrobin_slave_get() ->
bond_rr_gen_slave_id() then runs against a bond that has no
rr_tx_counter and crashes.

Fix this in the generic xdp_master_redirect() by refusing to call into
the master's ->ndo_xdp_get_xmit_slave() when the master device is not
up. IFF_UP is only set after ->ndo_open() has successfully returned,
so this reliably excludes masters whose XDP state has not been fully
initialized. Drop the frame with XDP_ABORTED so the exception is
visible via trace_xdp_exception() rather than silently falling through.
This is not specific to bonding: any current or future master that
defers XDP state allocation to ->ndo_open() is protected.

Fixes: 879af96ffd72 ("net, core: Add support for XDP redirection to slave device")
Reported-by: syzbot+80e046b8da2820b6ba73@syzkaller.appspotmail.com
Closes: https://lore.kernel.org/all/698f84c6.a70a0220.2c38d7.00cc.GAE@google.com/T/
Suggested-by: Daniel Borkmann <daniel@iogearbox.net>
Acked-by: Daniel Borkmann <daniel@iogearbox.net>
Signed-off-by: Jiayuan Chen <jiayuan.chen@linux.dev>
Link: https://patch.msgid.link/20260411005524.201200-2-jiayuan.chen@linux.dev
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/core/filter.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/net/core/filter.c b/net/core/filter.c
index 271cb6881dbb1..aee85a0062ce6 100644
--- a/net/core/filter.c
+++ b/net/core/filter.c
@@ -4268,6 +4268,8 @@ u32 xdp_master_redirect(struct xdp_buff *xdp)
 	struct bpf_redirect_info *ri = this_cpu_ptr(&bpf_redirect_info);
 
 	master = netdev_master_upper_dev_get_rcu(xdp->rxq->dev);
+	if (unlikely(!(master->flags & IFF_UP)))
+		return XDP_ABORTED;
 	slave = master->netdev_ops->ndo_xdp_get_xmit_slave(master, xdp);
 	if (slave && slave != xdp->rxq->dev) {
 		/* The target device is different from the receiving device, so
-- 
2.53.0



