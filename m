Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4569A1EE00E;
	Tue,  3 Dec 2024 16:15:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733242529; cv=none; b=GxV+fUGnl5LC/Z6MyTJ8kOihtG0heM012AUe4eYg2gKB7c7x85FsJd7O4Fpaos7eEDGUjwpphNuLafzmYgo2Di6QyBtip9hez32EC7Jly5W1Hv9tHOgfSMB3GWhDHRLP1X65/KOnk9g8QfRds5OoCoK8qwjYmcv5te2nermLR54=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733242529; c=relaxed/simple;
	bh=X8BtJ7VlSpkXstcrTNTZeDxhcxjePdWe4nXfxFGvW+g=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=KkrYcjnuy/b8RwtgMfN1gD1iPUjiYFmQmzGJYgfCLXj8++CMPZNWgMDFCR5mLz945VBCrrKf5jjU5cZ9xszsW0Hcl6bJ2SvmjOdirlkvuacCMq0VHxaFubZ6gSpaRfjUGieyhfTtzl5uSD8wloxckFZsQ8YOVPcyZgC+l29aa6I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=1/pe+sxI; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="1/pe+sxI"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 52649C4CECF;
	Tue,  3 Dec 2024 16:15:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1733242528;
	bh=X8BtJ7VlSpkXstcrTNTZeDxhcxjePdWe4nXfxFGvW+g=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=1/pe+sxIoNrqZywtv+LTCg+wSrBxOPM57ummP0dpP516x7z5WuO1vr/u1fdTet5SB
	 WWbJIv+7WrlQZcZrTXKTT6+A2TbTF1ILVHgFUg+mPd7pgYnI5IiByxVzqPHIebIlN/
	 EQoCwjPkMPTypt6oOwv91Mn/sbvGqFR/RdfBY5bE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Stanislaw Gruszka <stanislaw.gruszka@linux.intel.com>,
	Hans de Goede <hdegoede@redhat.com>,
	Sakari Ailus <sakari.ailus@linux.intel.com>,
	Hans Verkuil <hverkuil@xs4all.nl>
Subject: [PATCH 6.12 732/826] media: intel/ipu6: do not handle interrupts when device is disabled
Date: Tue,  3 Dec 2024 15:47:39 +0100
Message-ID: <20241203144812.319673635@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241203144743.428732212@linuxfoundation.org>
References: <20241203144743.428732212@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Stanislaw Gruszka <stanislaw.gruszka@linux.intel.com>

commit 1429826883bb18847092b2e04c6598ef34bae1d4 upstream.

Some IPU6 devices have shared interrupts. We need to handle properly
case when interrupt is triggered from other device on shared irq line
and IPU6 itself disabled. In such case we get 0xffffffff from
ISR_STATUS register and handle all irq's cases, for what we are not
not prepared and usually hang the whole system.

To avoid the issue use pm_runtime_get_if_active() to check if
the device is enabled and prevent suspending it when we handle irq
until the end of irq. Additionally use synchronize_irq() in suspend

Fixes: ab29a2478e70 ("media: intel/ipu6: add IPU6 buttress interface driver")
Cc: stable@vger.kernel.org
Signed-off-by: Stanislaw Gruszka <stanislaw.gruszka@linux.intel.com>
Reviewed-by: Hans de Goede <hdegoede@redhat.com>
Tested-by: Hans de Goede <hdegoede@redhat.com> # ThinkPad X1 Yoga Gen 8, ov2740
Signed-off-by: Sakari Ailus <sakari.ailus@linux.intel.com>
Signed-off-by: Hans Verkuil <hverkuil@xs4all.nl>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/media/pci/intel/ipu6/ipu6-buttress.c |   13 +++++++++----
 drivers/media/pci/intel/ipu6/ipu6.c          |    3 +++
 2 files changed, 12 insertions(+), 4 deletions(-)

--- a/drivers/media/pci/intel/ipu6/ipu6-buttress.c
+++ b/drivers/media/pci/intel/ipu6/ipu6-buttress.c
@@ -346,12 +346,16 @@ irqreturn_t ipu6_buttress_isr(int irq, v
 	u32 disable_irqs = 0;
 	u32 irq_status;
 	u32 i, count = 0;
+	int active;
 
-	pm_runtime_get_noresume(&isp->pdev->dev);
+	active = pm_runtime_get_if_active(&isp->pdev->dev);
+	if (!active)
+		return IRQ_NONE;
 
 	irq_status = readl(isp->base + reg_irq_sts);
-	if (!irq_status) {
-		pm_runtime_put_noidle(&isp->pdev->dev);
+	if (irq_status == 0 || WARN_ON_ONCE(irq_status == 0xffffffffu)) {
+		if (active > 0)
+			pm_runtime_put_noidle(&isp->pdev->dev);
 		return IRQ_NONE;
 	}
 
@@ -427,7 +431,8 @@ irqreturn_t ipu6_buttress_isr(int irq, v
 		writel(BUTTRESS_IRQS & ~disable_irqs,
 		       isp->base + BUTTRESS_REG_ISR_ENABLE);
 
-	pm_runtime_put(&isp->pdev->dev);
+	if (active > 0)
+		pm_runtime_put(&isp->pdev->dev);
 
 	return ret;
 }
--- a/drivers/media/pci/intel/ipu6/ipu6.c
+++ b/drivers/media/pci/intel/ipu6/ipu6.c
@@ -752,6 +752,9 @@ static void ipu6_pci_reset_done(struct p
  */
 static int ipu6_suspend(struct device *dev)
 {
+	struct pci_dev *pdev = to_pci_dev(dev);
+
+	synchronize_irq(pdev->irq);
 	return 0;
 }
 


