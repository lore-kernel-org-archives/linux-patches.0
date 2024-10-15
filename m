Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B71EE1D90CD;
	Tue, 15 Oct 2024 11:57:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728993463; cv=none; b=VApa9hDO1GMGEEoZj6MpSoHH0LSqGoooxfO76qf5922W8PAt/CXjnIpr7e029BzTEwEeyN8VLr8QNencdnSrGhNaIp0hSQUFOmY54vT/OgtT7AgqH96gOulRME9QU2F4ySvwqlDJnXU7Uy2FOblk/jfY1j+REhSPdyzh6Sx+dcE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728993463; c=relaxed/simple;
	bh=V0+eXFyb9Tfj5h2SsN0rsiLgpUtpMtV6uV/c2yKZQVk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Dr60eSrkrVTTG/Q7I16AlfokXeWzuiFmn1SxoHDyVFTJRsbKfF/6cVpPy7tiIqlKK0VG5iM+8N4UwvE3VvrS4Sph1+PrEjIQe8raEh8GQEndDRo9HjkxT0pc+voeCMoXyn2LauRcvxuEHSUZFn63zMS0a9pJr6ftIHT3hI3OFCg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Hy2WfNGD; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Hy2WfNGD"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3BB1EC4CEC6;
	Tue, 15 Oct 2024 11:57:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1728993463;
	bh=V0+eXFyb9Tfj5h2SsN0rsiLgpUtpMtV6uV/c2yKZQVk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Hy2WfNGD8VQ4vJbmFVi9ephE962ykEMluCERx/E8zlxInfSrOyy2EsVIXGGcWGz4n
	 jcenlKZx+1dBk8UrI7qxBappjDW7gj9NiBPeGG4kvs/lPLw4JP3yIf6r5353FzQgMi
	 AqIR+QO8tEZgjqy0Q/Ok2c1c/sQfGhyVbBOsuNwc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Brendan Dolan-Gavitt <brendandg@nyu.edu>,
	Zekun Shen <bruceshenzk@gmail.com>,
	"David S. Miller" <davem@davemloft.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 388/691] stmmac_pci: Fix underflow size in stmmac_rx
Date: Tue, 15 Oct 2024 13:25:36 +0200
Message-ID: <20241015112455.740872510@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241015112440.309539031@linuxfoundation.org>
References: <20241015112440.309539031@linuxfoundation.org>
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

From: Zekun Shen <bruceshenzk@gmail.com>

[ Upstream commit 0f296e782f21dc1c55475a3c107ac68ab09cc1cf ]

This bug report came up when we were testing the device driver
by fuzzing. It shows that buf1_len can get underflowed and be
0xfffffffc (4294967292).

This bug is triggerable with a compromised/malfunctioning device.
We found the bug through QEMU emulation tested the patch with
emulation. We did NOT test it on real hardware.

Attached is the bug report by fuzzing.

BUG: KASAN: use-after-free in stmmac_napi_poll_rx+0x1c08/0x36e0 [stmmac]
Read of size 4294967292 at addr ffff888016358000 by task ksoftirqd/0/9

CPU: 0 PID: 9 Comm: ksoftirqd/0 Tainted: G        W         5.6.0 #1
Call Trace:
 dump_stack+0x76/0xa0
 print_address_description.constprop.0+0x16/0x200
 ? stmmac_napi_poll_rx+0x1c08/0x36e0 [stmmac]
 ? stmmac_napi_poll_rx+0x1c08/0x36e0 [stmmac]
 __kasan_report.cold+0x37/0x7c
 ? stmmac_napi_poll_rx+0x1c08/0x36e0 [stmmac]
 kasan_report+0xe/0x20
 check_memory_region+0x15a/0x1d0
 memcpy+0x20/0x50
 stmmac_napi_poll_rx+0x1c08/0x36e0 [stmmac]
 ? stmmac_suspend+0x850/0x850 [stmmac]
 ? __next_timer_interrupt+0xba/0xf0
 net_rx_action+0x363/0xbd0
 ? call_timer_fn+0x240/0x240
 ? __switch_to_asm+0x40/0x70
 ? napi_busy_loop+0x520/0x520
 ? __schedule+0x839/0x15a0
 __do_softirq+0x18c/0x634
 ? takeover_tasklets+0x5f0/0x5f0
 run_ksoftirqd+0x15/0x20
 smpboot_thread_fn+0x2f1/0x6b0
 ? smpboot_unregister_percpu_thread+0x160/0x160
 ? __kthread_parkme+0x80/0x100
 ? smpboot_unregister_percpu_thread+0x160/0x160
 kthread+0x2b5/0x3b0
 ? kthread_create_on_node+0xd0/0xd0
 ret_from_fork+0x22/0x40

Reported-by: Brendan Dolan-Gavitt <brendandg@nyu.edu>
Signed-off-by: Zekun Shen <bruceshenzk@gmail.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Stable-dep-of: 4c1b56671b68 ("net: stmmac: dwmac4: extend timeout for VLAN Tag register busy bit check")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/stmicro/stmmac/stmmac_main.c | 9 +++++----
 1 file changed, 5 insertions(+), 4 deletions(-)

diff --git a/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c b/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
index cd92b8e03a9a1..23c0355c13c18 100644
--- a/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
+++ b/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
@@ -5241,12 +5241,13 @@ static int stmmac_rx(struct stmmac_priv *priv, int limit, u32 queue)
 		if (likely(!(status & rx_not_ls)) &&
 		    (likely(priv->synopsys_id >= DWMAC_CORE_4_00) ||
 		     unlikely(status != llc_snap))) {
-			if (buf2_len)
+			if (buf2_len) {
 				buf2_len -= ETH_FCS_LEN;
-			else
+				len -= ETH_FCS_LEN;
+			} else if (buf1_len) {
 				buf1_len -= ETH_FCS_LEN;
-
-			len -= ETH_FCS_LEN;
+				len -= ETH_FCS_LEN;
+			}
 		}
 
 		if (!skb) {
-- 
2.43.0



