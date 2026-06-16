Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 713FB44B681;
	Tue, 16 Jun 2026 15:09:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781622547; cv=none; b=Yp/QN86fVkyWeDYULSNdX7yK8ANBfb+aQdv5x2Qu/M9pl8YY/jpPRiahZbVLSv8cZs+K2mRIB/WpnyUvB1SRA7/qeRe5g6ZesqHLl1IOAxdZHRsNdEfQcRmV2xeDWMhqd8UBm3rEIM97NQkhEOHDwfuhSSqU/pM4IkPi7QUmQtw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781622547; c=relaxed/simple;
	bh=RRGOHYv9PIVGHzKVi3KVttJbq4+Oy1SrfUZCxHarreY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=grvMv2SsZnjK03Sq9xshJYWOPWd6lB+HJp0k1dWm8MqUhaSM+KefkFfZ+Php2a4wPhnBxHWk5fX+2I7L/YihEmP7VQOpASZv2Yz6sozWR4vdu2P1QmRzem8jQvA5BPIxPNx3K5ONjChzZhrt2YLRehN1e9ClkYnir9cMXeLe+uc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=b2aQkOyx; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="b2aQkOyx"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3DAA21F00A3D;
	Tue, 16 Jun 2026 15:09:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1781622546;
	bh=fklTJu+QGlgGPgERtI03nAtxEipNtUthYza0zDXihGs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=b2aQkOyxArvQX3sdwW08oQdf6mVYnlG2FIcDPYxVSLUU7onMnF8PKnXhAygjCxjGX
	 E0Eui+Vz15l7isLxQqt8SS7HvILJWcgOFvFHDpfLhaSH/Byw3E0AhJ9qTr+wweg82Q
	 +P20I+psTREbGU3KutoVboujcH7JJVfMZQDLV6SU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Claudiu Beznea <claudiu.beznea.uj@bp.renesas.com>,
	Sasha Levin <sashal@kernel.org>,
	Nobuhiro Iwamatsu <iwamatsu@nigauri.org>
Subject: [PATCH 5.10 004/342] phy: renesas: rcar-gen3-usb2: Fix the use of msleep during spinlock
Date: Tue, 16 Jun 2026 20:25:00 +0530
Message-ID: <20260616145048.546190636@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260616145048.348037099@linuxfoundation.org>
References: <20260616145048.348037099@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Nobuhiro Iwamatsu <iwamatsu@nigauri.org>

This fixes an issue caused by the use of msleep during spinlock.
In the original commit, msleep was changed to mdelay, but this fix was not
carried over during the backport to 5.10.y tree.

This is a backporting error, so no fix is needed in the upstream.

```
[   62.677594] BUG: scheduling while atomic: kworker/1:2/126/0x00000002
[   62.683957] Modules linked in:
[   62.687014] CPU: 1 PID: 126 Comm: kworker/1:2 Not tainted 5.10.253 #1
[   62.693447] Hardware name: HopeRun HiHope RZ/G2M with sub board (DT)
[   62.699812] Workqueue: events deferred_probe_work_func
[   62.704948] Call trace:
[   62.707397]  dump_backtrace+0x0/0x1c0
[   62.711058]  show_stack+0x18/0x40
[   62.714375]  dump_stack+0xe8/0x124
[   62.717776]  __schedule_bug+0x54/0x70
[   62.721436]  __schedule+0x6b4/0x710
[   62.724920]  schedule+0x70/0x104
[   62.728145]  schedule_timeout+0x80/0xf0
[   62.728153]  msleep+0x30/0x44
[   62.728165]  rcar_gen3_phy_usb2_init+0x180/0x1e0
[   62.736946]  phy_init+0x64/0x100
[   62.736955]  usb_phy_roothub_init+0x48/0xa0
[   62.736962]  usb_add_hcd+0x54/0x6c0
[   62.736974]  ehci_platform_probe+0x1ec/0x4b0
[   62.744541]  platform_drv_probe+0x54/0xac
[   62.744548]  really_probe+0xec/0x4f0
[   62.744552]  driver_probe_device+0x58/0xec
[   62.744556]  __device_attach_driver+0xb8/0x120
[   62.744562]  bus_for_each_drv+0x78/0xd0
[   62.744568]  __device_attach+0xa8/0x1c0
[   62.744575]  device_initial_probe+0x14/0x20
[   62.752315]  bus_probe_device+0x9c/0xa4
[   62.752319]  deferred_probe_work_func+0x88/0xc0
[   62.752327]  process_one_work+0x1cc/0x370
[   62.759977]  worker_thread+0x218/0x480
[   62.759984]  kthread+0x154/0x160
[   62.759990]  ret_from_fork+0x10/0x18
[   62.760115] ehci-platform ee080100.usb: EHCI Host Controller
[   62.839982] ehci-platform ee080100.usb: new USB bus registered, assigned bus number 3
```

Fixes: 0f86a559900f ("phy: renesas: rcar-gen3-usb2: Lock around hardware registers and driver data")
Cc: stable@vger.kernel.org
Cc: Claudiu Beznea <claudiu.beznea.uj@bp.renesas.com>
Cc: Sasha Levin <sashal@kernel.org>
Signed-off-by: Nobuhiro Iwamatsu <iwamatsu@nigauri.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/phy/renesas/phy-rcar-gen3-usb2.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/phy/renesas/phy-rcar-gen3-usb2.c b/drivers/phy/renesas/phy-rcar-gen3-usb2.c
index 5166a115879ea1..90f2a0e5b2aa05 100644
--- a/drivers/phy/renesas/phy-rcar-gen3-usb2.c
+++ b/drivers/phy/renesas/phy-rcar-gen3-usb2.c
@@ -386,7 +386,7 @@ static void rcar_gen3_init_otg(struct rcar_gen3_chan *ch)
 	val = readl(usb2_base + USB2_ADPCTRL);
 	writel(val | USB2_ADPCTRL_IDPULLUP, usb2_base + USB2_ADPCTRL);
 
-	msleep(20);
+	mdelay(20);
 
 	writel(0xffffffff, usb2_base + USB2_OBINTSTA);
 	writel(USB2_OBINT_BITS, usb2_base + USB2_OBINTEN);
-- 
2.53.0



