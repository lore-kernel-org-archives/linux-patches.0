Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CC61B15704D;
	Mon, 29 Jan 2024 17:12:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706548379; cv=none; b=nhMH7V84k7JBPfxf5/EOoSZXdHoMKzbVX0Fsfnc+v0roDIETWrIN6XPzvjMqrixwbH5JcYqHd+LKfyUYt6X0hGNFU8x35ybpp/9hu3zBjP4vIHqn09Qe0T5UDk3lD2RpPeKhrE4Bt3dPWtGFub7M5TcRvQRVu2ze7uvG9zpA91g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706548379; c=relaxed/simple;
	bh=hqwHO7pyQXdncXk8W6mRNYaMWZCGxS+3Jk0uupmr25M=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=PtIaj8btvyEz5ZZfGRm5ma3N0oKTjwlLAO0jVHYfXrd8s4CkQp45lwqIjvDhdkcJ2RuDaEsNLEriIrF//ZJMWSUxg300KwMedolKDF/iD07Cr+M3LZNnuCv+gce6qachuznL97kIjHpvxYHsuyYQFTgsAEs9H5VU19I9qYUF9Zs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=LNBbp6CM; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="LNBbp6CM"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 955D7C43390;
	Mon, 29 Jan 2024 17:12:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1706548379;
	bh=hqwHO7pyQXdncXk8W6mRNYaMWZCGxS+3Jk0uupmr25M=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=LNBbp6CMCuLYn0VQz5Sx4X5dJI0YSmR2R0s2TgLuCn7osdtgQjtRUUAcGLdIJY9Sa
	 TMcpen1E6uyj/FP1jxB1KXvxDC70y8HrKM3zg069ugWT1glqo09LiUDru+Jx1Pia8A
	 M1/dudX5cq1/7NfiroRzlsG23tDkqqX17Y8DXGPg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ricardo Neri <ricardo.neri-calderon@linux.intel.com>,
	"Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 150/185] thermal: intel: hfi: Add syscore callbacks for system-wide PM
Date: Mon, 29 Jan 2024 09:05:50 -0800
Message-ID: <20240129170003.405217131@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240129165958.589924174@linuxfoundation.org>
References: <20240129165958.589924174@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Ricardo Neri <ricardo.neri-calderon@linux.intel.com>

[ Upstream commit 97566d09fd02d2ab329774bb89a2cdf2267e86d9 ]

The kernel allocates a memory buffer and provides its location to the
hardware, which uses it to update the HFI table. This allocation occurs
during boot and remains constant throughout runtime.

When resuming from hibernation, the restore kernel allocates a second
memory buffer and reprograms the HFI hardware with the new location as
part of a normal boot. The location of the second memory buffer may
differ from the one allocated by the image kernel.

When the restore kernel transfers control to the image kernel, its HFI
buffer becomes invalid, potentially leading to memory corruption if the
hardware writes to it (the hardware continues to use the buffer from the
restore kernel).

It is also possible that the hardware "forgets" the address of the memory
buffer when resuming from "deep" suspend. Memory corruption may also occur
in such a scenario.

To prevent the described memory corruption, disable HFI when preparing to
suspend or hibernate. Enable it when resuming.

Add syscore callbacks to handle the package of the boot CPU (packages of
non-boot CPUs are handled via CPU offline). Syscore ops always run on the
boot CPU. Additionally, HFI only needs to be disabled during "deep" suspend
and hibernation. Syscore ops only run in these cases.

Cc: 6.1+ <stable@vger.kernel.org> # 6.1+
Signed-off-by: Ricardo Neri <ricardo.neri-calderon@linux.intel.com>
[ rjw: Comment adjustment, subject and changelog edits ]
Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/thermal/intel/intel_hfi.c | 28 ++++++++++++++++++++++++++++
 1 file changed, 28 insertions(+)

diff --git a/drivers/thermal/intel/intel_hfi.c b/drivers/thermal/intel/intel_hfi.c
index 5352fcb72ea3..750dab3f259e 100644
--- a/drivers/thermal/intel/intel_hfi.c
+++ b/drivers/thermal/intel/intel_hfi.c
@@ -35,7 +35,9 @@
 #include <linux/processor.h>
 #include <linux/slab.h>
 #include <linux/spinlock.h>
+#include <linux/suspend.h>
 #include <linux/string.h>
+#include <linux/syscore_ops.h>
 #include <linux/topology.h>
 #include <linux/workqueue.h>
 
@@ -559,6 +561,30 @@ static __init int hfi_parse_features(void)
 	return 0;
 }
 
+static void hfi_do_enable(void)
+{
+	/* This code runs only on the boot CPU. */
+	struct hfi_cpu_info *info = &per_cpu(hfi_cpu_info, 0);
+	struct hfi_instance *hfi_instance = info->hfi_instance;
+
+	/* No locking needed. There is no concurrency with CPU online. */
+	hfi_set_hw_table(hfi_instance);
+	hfi_enable();
+}
+
+static int hfi_do_disable(void)
+{
+	/* No locking needed. There is no concurrency with CPU offline. */
+	hfi_disable();
+
+	return 0;
+}
+
+static struct syscore_ops hfi_pm_ops = {
+	.resume = hfi_do_enable,
+	.suspend = hfi_do_disable,
+};
+
 void __init intel_hfi_init(void)
 {
 	struct hfi_instance *hfi_instance;
@@ -590,6 +616,8 @@ void __init intel_hfi_init(void)
 	if (!hfi_updates_wq)
 		goto err_nomem;
 
+	register_syscore_ops(&hfi_pm_ops);
+
 	return;
 
 err_nomem:
-- 
2.43.0



