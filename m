Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A41E11465A8;
	Tue, 25 Jun 2024 09:47:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719308824; cv=none; b=dtqrjR4Q0GUMAm6BSHYh9bfgTKPTYOh3xprBG/qZNeNTD/PQtUIkjFhWj2BkifNEhdFWcgpF6+uUg8pFIRb/IrpRjq61OBz86wSh3RdcOBjSPS1Y/T65WN7xrNtzHV6Yz2QHCx2XnH7CC3ohms9rI+MDoHtlxyFGIbq+1ehWjSA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719308824; c=relaxed/simple;
	bh=m25ANpDiZoECPY3B8Ea0AzWrea8TiZbWKM1gqin4tR0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ZHxUj5ZG7ZhV2r+VU0Vfh8lqA7MpY/iJQh0eIxV5gJQqm+6T0d1BZsWBqNAwNgOFhtCV+4xwd7arMBSbY89wLCYNsEsgQUlbTITo5MTz7B0pe0FNrc2MM4fquUQG8KLtIbFEQEmH+LCQ0Zy00GzsK3rlnn0l4bg0ueCwedbaRWQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=v05DDFjD; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="v05DDFjD"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 27D24C32781;
	Tue, 25 Jun 2024 09:47:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1719308824;
	bh=m25ANpDiZoECPY3B8Ea0AzWrea8TiZbWKM1gqin4tR0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=v05DDFjDXrhytOGwJGzY2ijgOmgoSdrAVV/XUB7qbLF2z5P0qwUSR+FyHZDEySp+t
	 ODNZgRheOauWNz8XOeSvWkUUoxEGreO83nSfDHeI5VoygMfo6cm4xjAZxXdNgmZf42
	 mJkFpzkjwNxSWEO/JjL0msp0n7JHL+AMumw5ale0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Srinivas Pandruvada <srinivas.pandruvada@linux.intel.com>,
	"Rafael J. Wysocki" <rafael.j.wysocki@intel.com>
Subject: [PATCH 6.9 233/250] thermal: int340x: processor_thermal: Support shared interrupts
Date: Tue, 25 Jun 2024 11:33:11 +0200
Message-ID: <20240625085556.996458138@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240625085548.033507125@linuxfoundation.org>
References: <20240625085548.033507125@linuxfoundation.org>
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

6.9-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Srinivas Pandruvada <srinivas.pandruvada@linux.intel.com>

commit 096597cfe4ea08b1830e775436d76d7c9d6d3037 upstream.

On some systems the processor thermal device interrupt is shared with
other PCI devices. In this case return IRQ_NONE from the interrupt
handler when the interrupt is not for the processor thermal device.

Signed-off-by: Srinivas Pandruvada <srinivas.pandruvada@linux.intel.com>
Fixes: f0658708e863 ("thermal: int340x: processor_thermal: Use non MSI interrupts by default")
Cc: 6.7+ <stable@vger.kernel.org> # 6.7+
Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 .../intel/int340x_thermal/processor_thermal_device_pci.c       | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/thermal/intel/int340x_thermal/processor_thermal_device_pci.c b/drivers/thermal/intel/int340x_thermal/processor_thermal_device_pci.c
index 14e34eabc419..4a1bfebb1b8e 100644
--- a/drivers/thermal/intel/int340x_thermal/processor_thermal_device_pci.c
+++ b/drivers/thermal/intel/int340x_thermal/processor_thermal_device_pci.c
@@ -150,7 +150,7 @@ static irqreturn_t proc_thermal_irq_handler(int irq, void *devid)
 {
 	struct proc_thermal_pci *pci_info = devid;
 	struct proc_thermal_device *proc_priv;
-	int ret = IRQ_HANDLED;
+	int ret = IRQ_NONE;
 	u32 status;
 
 	proc_priv = pci_info->proc_priv;
@@ -175,6 +175,7 @@ static irqreturn_t proc_thermal_irq_handler(int irq, void *devid)
 		/* Disable enable interrupt flag */
 		proc_thermal_mmio_write(pci_info, PROC_THERMAL_MMIO_INT_ENABLE_0, 0);
 		pkg_thermal_schedule_work(&pci_info->work);
+		ret = IRQ_HANDLED;
 	}
 
 	pci_write_config_byte(pci_info->pdev, 0xdc, 0x01);
-- 
2.45.2



