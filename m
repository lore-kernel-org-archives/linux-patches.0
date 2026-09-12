Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6C97941F5D5;
	Sat, 12 Sep 2026 15:29:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789227000; cv=none; b=ff3DOzRBZh+q6vPHsGBau/roK4wzR32rnxlhnrguMrMr9bcVn1abybCCROy38VpvGK5KgGjsoViXTvgojd4FioZYzb5avrnu8wJWtOYgXrMDW8pceouo0/eIc/H+r0Ys4CfLyO53rG+0Dqum7FkHQuyjQmXQe8h+Z1er1cQLMjQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789227000; c=relaxed/simple;
	bh=LWIbAQ52drcTto/n0g+JsaHLGbbuIkH17I2jxJMq14k=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=X7FOrRexqb7XVfWvOoOgly0+50Bym23xKCgJaoy9moJkbcnonXWU1hStwkGt0G0QKpiJCe+DsWoPKXjYNQbIbdnaX7uOVKwSudfD2yx9GS/rU+d167a5UD4IhlBNt3ToZoviC562yvRx/H2yz0AGl0zS2WjWAdHV37bt0h4tWfs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=FohYionR; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="FohYionR"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EE7121F00893;
	Sat, 12 Sep 2026 15:29:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789226998;
	bh=m1oAVPfwFEq2+lA6ACyrIwxk8tH7R7+ApVj93EqHcg0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=FohYionRC0Dfz1P4qsIWNzYjFqW1wyQcBvoofGs5WayHZaHapX5L7Aw6KI1yPhilJ
	 P5pfbbmXrGVbtMzP+RKWx4mdP9Zkuz4hC59fngv6emyzsl1oh+A61iRl1EkJt0co51
	 XlvKhcqYwJ39y7zUjRqIoBPRisNPZGvb7mnPTrIg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Marek Czernohous <marek@czernohous.de>,
	Simon Horman <horms@kernel.org>,
	Zhu Yanjun <yanjun.zhu@linux.dev>,
	Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 6.1 0090/1191] forcedeth: fix off-by-one when saving/restoring non-PCI config space
Date: Sat, 12 Sep 2026 08:46:58 +0200
Message-ID: <20260912065550.200131755@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065548.086904252@linuxfoundation.org>
References: <20260912065548.086904252@linuxfoundation.org>
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

From: Marek Czernohous <marek@czernohous.de>

commit 9393f1d656a79693e0c123ff7bc7c5c0f708046d upstream.

nv_suspend() and nv_resume() walk the non-PCI configuration space with

	for (i = 0; i <= np->register_size/sizeof(u32); i++)

which runs one iteration too many. saved_config_space is declared as

	u32 saved_config_space[NV_PCI_REGSZ_MAX/4];

and NV_PCI_REGSZ_VER3 is equal to NV_PCI_REGSZ_MAX (0x604), so on a VER3
device register_size/sizeof(u32) is exactly the array length and the last
iteration addresses one element past the end.

The element it lands on is np->name_rx[0..3]: saved_config_space[] is
followed immediately by char name_rx[IFNAMSIZ + 3], and char needs no
padding. Nothing observable is corrupted by that, because nv_request_irq()
rewrites name_rx with sprintf() before it is ever passed to request_irq().
The bug is the out-of-bounds access itself, which UBSAN reports and which
CONFIG_UBSAN_TRAP=y turns into a trap that aborts the running kernel code,
plus an MMIO read and, on resume, an MMIO writel() to base + 0x604, one
dword past the range the driver mapped:

	np->base = ioremap(addr, np->register_size);

VER1 and VER2 devices stay inside the array, but they too get the stray
read and the stray write one dword past their own window.

Caught by UBSAN on an Apple Macmini3,1 (MCP79) during a deep S3 cycle.
The splat below is trimmed: the build path in the file name, the CPU
and taint lines, the Workqueue line, the "?" hint frames, and the
frames below device_suspend are all cut. The kernel was tainted, with
an out-of-tree nouveau and CPU_OUT_OF_SPEC; forcedeth itself was the
stock module.

  UBSAN: array-index-out-of-bounds in drivers/net/ethernet/nvidia/forcedeth.c:6225:25
  index 385 is out of range for type 'u32 [385]'
  Call Trace:
   dump_stack_lvl+0x5d/0x80
   ubsan_epilogue+0x5/0x2b
   __ubsan_handle_out_of_bounds.cold+0x54/0x59
   __this_module+0xe398c/0xe9010 [forcedeth]
   pci_pm_suspend+0x80/0x170
   dpm_run_callback+0x51/0x160
   device_suspend+0x1a2/0x4a0
   ...

Both loops are hit. UBSAN reports each source location only once per module
load (__ubsan_handle_out_of_bounds() calls suppress_report(), which does
test_and_set_bit(REPORTED_BIT, ...) on the struct source_location), so the
two splats land in the first S3 cycle after the module is loaded and later
cycles are silent even though the access still runs off the end every time.
In that first cycle line 6225 is reported from pci_pm_suspend and line 6240
from pci_pm_resume.

The same off-by-one was fixed in nv_get_regs() by commit ba9aa134287f
("forcedeth: fix buffer overflow") in 2012; these two loops were missed.
The suspend and resume side was reported on LKML in September 2013 by Marc
Weber, with the same analysis and the same one-character fix, but the patch
was attached rather than sent inline and the thread ended there.

Use < instead of <=, which saves and restores exactly register_size bytes.

Fixes: 1a1ca86158ee ("[netdrvr] forcedeth: save/restore device configuration space")
Cc: stable@vger.kernel.org
Signed-off-by: Marek Czernohous <marek@czernohous.de>
Reviewed-by: Simon Horman <horms@kernel.org>
Reviewed-by: Zhu Yanjun <yanjun.zhu@linux.dev>
Link: https://patch.msgid.link/178682367885.3748309.10595890901761762683@gmail.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/ethernet/nvidia/forcedeth.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/drivers/net/ethernet/nvidia/forcedeth.c
+++ b/drivers/net/ethernet/nvidia/forcedeth.c
@@ -6233,7 +6233,7 @@ static int nv_suspend(struct device *dev
 	netif_device_detach(dev);
 
 	/* save non-pci configuration space */
-	for (i = 0; i <= np->register_size/sizeof(u32); i++)
+	for (i = 0; i < np->register_size/sizeof(u32); i++)
 		np->saved_config_space[i] = readl(base + i*sizeof(u32));
 
 	return 0;
@@ -6248,7 +6248,7 @@ static int nv_resume(struct device *devi
 	int i, rc = 0;
 
 	/* restore non-pci configuration space */
-	for (i = 0; i <= np->register_size/sizeof(u32); i++)
+	for (i = 0; i < np->register_size/sizeof(u32); i++)
 		writel(np->saved_config_space[i], base+i*sizeof(u32));
 
 	if (np->driver_data & DEV_NEED_MSI_FIX)


