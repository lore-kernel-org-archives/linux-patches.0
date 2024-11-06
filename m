Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1711A1DFE38;
	Wed,  6 Nov 2024 12:33:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730896382; cv=none; b=bnY6JupFOr5VtbanZiSbx9vm4s0su4jze/vd/lVNH56G8hYycnFs6GdIVI3SciKHJ3bgwh8ovDJkUpI8FA0IaM9ptFRnThxQcq2F5eSXp1sVbFRFpI+JIxXA1dAwSKxtnSraWKEPOrNCWau7XT5E4qkhOpNX3DCdMf+I8zo+KEI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730896382; c=relaxed/simple;
	bh=PNVvr3xbi+Y0lLuQUNLkVeUeA9H+URuhPACqZs2qfQI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=XFc+R3x43msVmHABLcCFygUWPdSF4aqCRJlUYgVvycrd6E8HS1PvudRsi+Rx2w0JeuaXuq+RGeaYm3P5BMxDOeKaWUMr9O5bhmaMzTngQ/lPG9xEAYY5KtjwjNunNNnaZO9xhPUYWJNvaRNoifIP5vG/JaZX7PmjSXCBUhFbxts=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=1dJiKAme; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="1dJiKAme"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 92044C4CECD;
	Wed,  6 Nov 2024 12:33:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1730896382;
	bh=PNVvr3xbi+Y0lLuQUNLkVeUeA9H+URuhPACqZs2qfQI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=1dJiKAme7B4lsx1iVNqyEZTU7uK2L+JtDmYXHghQgAh0XWOSrb4x0KUtuVcORK39e
	 fC+52JrYmGlQ7t4jzAVD9AtQQvetT8j7tZPjUbALX3+8qfi0gDjwbek2lzKke0h5DN
	 /e7uWh6TC+YZUKJA44Ud3nQJ8q6XDdB+LidWKt4k=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Andrzej Kacprowski <Andrzej.Kacprowski@intel.com>,
	Jacek Lawrynowicz <jacek.lawrynowicz@linux.intel.com>,
	Jeffrey Hugo <quic_jhugo@quicinc.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.11 183/245] accel/ivpu: Fix NOC firewall interrupt handling
Date: Wed,  6 Nov 2024 13:03:56 +0100
Message-ID: <20241106120323.744696144@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241106120319.234238499@linuxfoundation.org>
References: <20241106120319.234238499@linuxfoundation.org>
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

6.11-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Andrzej Kacprowski <Andrzej.Kacprowski@intel.com>

[ Upstream commit 72f7e16eccddde99386a10eb2d08833e805917c6 ]

The NOC firewall interrupt means that the HW prevented
unauthorized access to a protected resource, so there
is no need to trigger device reset in such case.

To facilitate security testing add firewall_irq_counter
debugfs file that tracks firewall interrupts.

Fixes: 8a27ad81f7d3 ("accel/ivpu: Split IP and buttress code")
Cc: stable@vger.kernel.org # v6.11+
Signed-off-by: Andrzej Kacprowski <Andrzej.Kacprowski@intel.com>
Reviewed-by: Jacek Lawrynowicz <jacek.lawrynowicz@linux.intel.com>
Reviewed-by: Jeffrey Hugo <quic_jhugo@quicinc.com>
Signed-off-by: Jacek Lawrynowicz <jacek.lawrynowicz@linux.intel.com>
Link: https://patchwork.freedesktop.org/patch/msgid/20241017144958.79327-1-jacek.lawrynowicz@linux.intel.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/accel/ivpu/ivpu_debugfs.c | 9 +++++++++
 drivers/accel/ivpu/ivpu_hw.c      | 1 +
 drivers/accel/ivpu/ivpu_hw.h      | 1 +
 drivers/accel/ivpu/ivpu_hw_ip.c   | 5 ++++-
 4 files changed, 15 insertions(+), 1 deletion(-)

diff --git a/drivers/accel/ivpu/ivpu_debugfs.c b/drivers/accel/ivpu/ivpu_debugfs.c
index 6f86f8df30db0..8d50981594d15 100644
--- a/drivers/accel/ivpu/ivpu_debugfs.c
+++ b/drivers/accel/ivpu/ivpu_debugfs.c
@@ -108,6 +108,14 @@ static int reset_pending_show(struct seq_file *s, void *v)
 	return 0;
 }
 
+static int firewall_irq_counter_show(struct seq_file *s, void *v)
+{
+	struct ivpu_device *vdev = seq_to_ivpu(s);
+
+	seq_printf(s, "%d\n", atomic_read(&vdev->hw->firewall_irq_counter));
+	return 0;
+}
+
 static const struct drm_debugfs_info vdev_debugfs_list[] = {
 	{"bo_list", bo_list_show, 0},
 	{"fw_name", fw_name_show, 0},
@@ -116,6 +124,7 @@ static const struct drm_debugfs_info vdev_debugfs_list[] = {
 	{"last_bootmode", last_bootmode_show, 0},
 	{"reset_counter", reset_counter_show, 0},
 	{"reset_pending", reset_pending_show, 0},
+	{"firewall_irq_counter", firewall_irq_counter_show, 0},
 };
 
 static ssize_t
diff --git a/drivers/accel/ivpu/ivpu_hw.c b/drivers/accel/ivpu/ivpu_hw.c
index 27f0fe4d54e00..e69c0613513f1 100644
--- a/drivers/accel/ivpu/ivpu_hw.c
+++ b/drivers/accel/ivpu/ivpu_hw.c
@@ -249,6 +249,7 @@ int ivpu_hw_init(struct ivpu_device *vdev)
 	platform_init(vdev);
 	wa_init(vdev);
 	timeouts_init(vdev);
+	atomic_set(&vdev->hw->firewall_irq_counter, 0);
 
 	return 0;
 }
diff --git a/drivers/accel/ivpu/ivpu_hw.h b/drivers/accel/ivpu/ivpu_hw.h
index 1c0c98e3afb88..a96a05b2acda9 100644
--- a/drivers/accel/ivpu/ivpu_hw.h
+++ b/drivers/accel/ivpu/ivpu_hw.h
@@ -52,6 +52,7 @@ struct ivpu_hw_info {
 	int dma_bits;
 	ktime_t d0i3_entry_host_ts;
 	u64 d0i3_entry_vpu_ts;
+	atomic_t firewall_irq_counter;
 };
 
 int ivpu_hw_init(struct ivpu_device *vdev);
diff --git a/drivers/accel/ivpu/ivpu_hw_ip.c b/drivers/accel/ivpu/ivpu_hw_ip.c
index dfd2f4a5b5268..60b33fc59d96e 100644
--- a/drivers/accel/ivpu/ivpu_hw_ip.c
+++ b/drivers/accel/ivpu/ivpu_hw_ip.c
@@ -1062,7 +1062,10 @@ static void irq_wdt_mss_handler(struct ivpu_device *vdev)
 
 static void irq_noc_firewall_handler(struct ivpu_device *vdev)
 {
-	ivpu_pm_trigger_recovery(vdev, "NOC Firewall IRQ");
+	atomic_inc(&vdev->hw->firewall_irq_counter);
+
+	ivpu_dbg(vdev, IRQ, "NOC Firewall interrupt detected, counter %d\n",
+		 atomic_read(&vdev->hw->firewall_irq_counter));
 }
 
 /* Handler for IRQs from NPU core */
-- 
2.43.0



