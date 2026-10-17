Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7622323394D;
	Sat, 17 Oct 2026 17:02:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792256566; cv=none; b=gmCfCyqA77HreSupRbcTR3DDbGmvO4RqgmhOXtly4FIgQz49tHDA7tsuvl5Zb6Q9alElPy4Ypd9teEhHol0mAAOsCpkQNGrmKSIcK7QTsAVTlehQF+fev2VcSyLLiptRKdpZWnBRa1JkuPT1fH5BVCcp6jyHS/HETad9fUEKAxM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792256566; c=relaxed/simple;
	bh=x37JfaLtz4Tk1vFhYgmq2n4m0rl9IYdE82wRL4VhbT8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ihHRVdwnER+nG7O5CqugEQPbjb7C319Iu5BbeTFl5oGlOiv6Y7nL+KDxmvl8zZ+6rnYVV1d4/4qSyT6ybI6DJco5Ey6wrG2gVqRbjlfKyWIBcU7t++iY3rg3uhbrnpd9eAz/2moTTgaDIKKb8bW9ov0ZlQYp/EeCejgQiRPueXI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=E14fhyr5; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="E14fhyr5"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C2A691F000C4;
	Sat, 17 Oct 2026 17:02:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1792256565;
	bh=YY5KHfT2jNppgj/ON72lXkxkv0o5NV+lZsMSeqVtecw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=E14fhyr5vb105zG8lE1w6aSUXNIMDDLiXjXtEJ1Rahggz1m3/y3wNS0Hyd2zRmaq/
	 43+5bKYJmmuY4ebGiLkaqBKFn4rIxcvym33rczjems/PSIK4ce3yFllLO5Pt3mhP79
	 r7p1POlKpb2Yf4cnw9DNzf7a29I5glCUhPbbx93k=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	stable <stable@kernel.org>,
	Jie Deng <dengjie03@kylinos.cn>,
	Peter Chen <peter.chen@kernel.org>
Subject: [PATCH 6.6 0278/1674] usb: cdns3: Fix NULL pointer dereference in cdns3_pci_probe
Date: Sat, 17 Oct 2026 17:42:30 +0200
Message-ID: <20261017160438.253481723@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261017160431.119607952@linuxfoundation.org>
References: <20261017160431.119607952@linuxfoundation.org>
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

From: Jie Deng <dengjie03@kylinos.cn>

commit e5052f2c5c73c1dcca42bafc0bc737af2b2af059 upstream.

The Cadence USBSS controller is a two-function PCI device. The first
probed function allocates the driver data and stores it with
pci_set_drvdata(), while the second function reuses it via
pci_get_drvdata() when pci_is_enabled() reports that the first
function has already been probed.

When the second function is probed while the first one has been
enabled but has not yet set its driver data, pci_get_drvdata()
returns NULL, and the subsequent wrap->devfn assignment dereferences
a NULL pointer and crashes the kernel.
logs:
Call trace:
  cdns3_pci_probe+0xa4/0x300
  local_pci_probe+0x44/0xa8
  pci_call_probe+0x54/0x158
  pci_device_probe+0x84/0x100
  really_probe+0x184/0x3d0
  __driver_probe_device+0x80/0x178
  driver_probe_device+0x44/0xe8
  __driver_attach+0xec/0x1f8
  bus_for_each_dev+0x7c/0xe0
  driver_attach+0x28/0x38
  bus_add_driver+0x110/0x238
  driver_register+0x64/0x128
  __pci_register_driver+0x50/0x60
  cdns3_pci_driver_init+0x28/0x38
  do_one_initcall+0x5c/0x280
  do_initcalls+0x104/0x1d8
  kernel_init_freeable+0x140/0x218
  kernel_init+0x28/0x1f8
  ret_from_fork+0x10/0x20

Return -EPROBE_DEFER in this case so that probing is retried after
the first function has completed its probe.

Fixes: 7733f6c32e36 ("usb: cdns3: Add Cadence USB3 DRD Driver")
Cc: stable <stable@kernel.org>
Signed-off-by: Jie Deng <dengjie03@kylinos.cn>
Acked-by: Peter Chen <peter.chen@kernel.org>
Link: https://patch.msgid.link/20260810023626.70669-1-dengjie03@kylinos.cn
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/usb/cdns3/cdns3-pci-wrap.c |    5 +++++
 1 file changed, 5 insertions(+)

--- a/drivers/usb/cdns3/cdns3-pci-wrap.c
+++ b/drivers/usb/cdns3/cdns3-pci-wrap.c
@@ -99,6 +99,11 @@ static int cdns3_pci_probe(struct pci_de
 
 	if (pci_is_enabled(func)) {
 		wrap = pci_get_drvdata(func);
+		if (!wrap) {
+			dev_err(&pdev->dev,
+				"second function not initialized, retrying\n");
+			return -EPROBE_DEFER;
+		}
 	} else {
 		wrap = kzalloc(sizeof(*wrap), GFP_KERNEL);
 		if (!wrap)


