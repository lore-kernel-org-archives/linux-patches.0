Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8DC803D6664;
	Fri,  4 Sep 2026 05:24:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788499500; cv=none; b=pf7N22xpsOSf3kBLbcRGKthLYaQAQ42laYROVQjsIe/YZ302nTRw4/UVsnxAVCECyVHHQTYzk4tnKqabrthpTxaN9fpEyyRVTbKYJZheeqU1VOOZr4WgJikub3G0jq6vEchKI4tFJyiwOzfVaaxKdOokThMYjZo7e+mj4fa45Dg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788499500; c=relaxed/simple;
	bh=txU+OEbz0fgyi4d6Qq2NkmJsDRxsf58MZUR3vL4gKdo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ubKCGa3TMLerh7pFBI4Q5THPH70Q09teiWsUbRM5LJJCCUY1N1lEYTmV/qCuIHOlvBOyxIOOaFQcTgL+tjbwvf7c/ZAJYmvPXxnw+0mCvdhvvC3SGFDxYeZKnGntq6leYF6m7U+1YaQfky+gFYGO0yxzGPYxdwY+VzFzWnMcSvQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=YS56Jd9n; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="YS56Jd9n"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E8A711F00A3D;
	Fri,  4 Sep 2026 05:24:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1788499499;
	bh=kzEI6PZzd2OBkI/whccCUVcIKQU4Nguf784YT8p6AeU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=YS56Jd9nYqewHgZbR9elo4ch3zr5dfy0Hic4hunnM0B2eTSf8+R1JRZZmNKSOwpt0
	 wNy35bXHxmkLz61iaTXVgQiIs2Ec5wW70d6keBKfhggIpNAH+NgfgjtGfYVoUz7Pe1
	 CckWSjsBI/mXC4sPVGVe4qKkG2zBxUX3u5xZHnI8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Anirudh Srinivasan <asrinivasan@oss.tenstorrent.com>,
	Nam Cao <namcao@linutronix.de>,
	Jesse Taube <jtaubepe@redhat.com>,
	Paul Walmsley <pjw@kernel.org>
Subject: [PATCH 7.2 438/713] riscv: unaligned: stop using kthread for check_vector_unaligned_access()
Date: Fri,  4 Sep 2026 06:56:46 +0200
Message-ID: <20260904045813.648997326@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260904045803.810145556@linuxfoundation.org>
References: <20260904045803.810145556@linuxfoundation.org>
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

7.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Nam Cao <namcao@linutronix.de>

commit 34c9cfcde29b938c416924ee6ec3519270bc2238 upstream.

A kthread is used to run check_vector_unaligned_access() to optimize boot
time, allowing the kernel to continue booting without waiting for the
unaligned vector speed probe to finish.

However, this asynchronous approach introduces several complications.
First, the kthread may not complete before a user reads vDSO data,
resulting in incorrect values. This was previously addressed by
commit 5d15d2ad36b0 ("riscv: hwprobe: Fix stale vDSO data for
late-initialized keys at boot"), which added complex synchronization
between the kthread and vDSO reads.

Second, it was discovered that the kthread may not finish before
vec_check_unaligned_access_speed_all_cpus() (marked with __init) is freed,
triggering a page fault.

These issues raise the question of whether the kthread is worth the added
complexity. A past boot time regression report was actually unrelated to
synchronous probing; it was caused by the probe running serially. Since
switching to a parallel probe, no further complaints have been made.
Furthermore, the unaligned scalar access speed probe takes the same amount
of time, runs synchronously, and has caused no issues.

Testing shows no noticeable boot time slowdown when running the vector
probe synchronously (0.464474s with kthread vs. 0.457991s without).

Remove the kthread usage and run the probe synchronously. This simplifies
the boot flow and allows for the revert of commit 5d15d2ad36b0 ("riscv:
hwprobe: Fix stale vDSO data for late-initialized keys at boot")

Reported-by: Anirudh Srinivasan <asrinivasan@oss.tenstorrent.com>
Closes: https://lore.kernel.org/linux-riscv/20260612-vec_unaligned_drop_init-v1-1-df969210ae34@oss.tenstorrent.com/
Fixes: e7c9d66e313b ("RISC-V: Report vector unaligned access speed hwprobe")
Cc: stable@vger.kernel.org
Signed-off-by: Nam Cao <namcao@linutronix.de>
Acked-by: Jesse Taube <jtaubepe@redhat.com>
Tested-by: Anirudh Srinivasan <asrinivasan@oss.tenstorrent.com>
Link: https://patch.msgid.link/1c378963f27c5960e8a57c50b8b444d30954cb54.1781666867.git.namcao@linutronix.de
[pjw@kernel.org: updated to apply; adjusted Fixes: tag; fixed my own manual patch application error]
Signed-off-by: Paul Walmsley <pjw@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/riscv/kernel/unaligned_access_speed.c |   19 ++-----------------
 1 file changed, 2 insertions(+), 17 deletions(-)

--- a/arch/riscv/kernel/unaligned_access_speed.c
+++ b/arch/riscv/kernel/unaligned_access_speed.c
@@ -6,7 +6,6 @@
 #include <linux/cpu.h>
 #include <linux/cpumask.h>
 #include <linux/jump_label.h>
-#include <linux/kthread.h>
 #include <linux/mm.h>
 #include <linux/smp.h>
 #include <linux/types.h>
@@ -288,18 +287,9 @@ free:
 	__free_pages(page, MISALIGNED_BUFFER_ORDER);
 }
 
-/* Measure unaligned access speed on all CPUs present at boot in parallel. */
-static int vec_check_unaligned_access_speed_all_cpus(void *unused __always_unused)
-{
-	schedule_on_each_cpu(check_vector_unaligned_access);
-	riscv_hwprobe_complete_async_probe();
-
-	return 0;
-}
 #else /* CONFIG_RISCV_PROBE_VECTOR_UNALIGNED_ACCESS */
-static int vec_check_unaligned_access_speed_all_cpus(void *unused __always_unused)
+static void check_vector_unaligned_access(struct work_struct *work __always_unused)
 {
-	return 0;
 }
 #endif
 
@@ -387,12 +377,7 @@ static int __init check_unaligned_access
 			per_cpu(vector_misaligned_access, cpu) = unaligned_vector_speed_param;
 	} else if (!check_vector_unaligned_access_emulated_all_cpus() &&
 		   IS_ENABLED(CONFIG_RISCV_PROBE_VECTOR_UNALIGNED_ACCESS)) {
-		riscv_hwprobe_register_async_probe();
-		if (IS_ERR(kthread_run(vec_check_unaligned_access_speed_all_cpus,
-				       NULL, "vec_check_unaligned_access_speed_all_cpus"))) {
-			pr_warn("Failed to create vec_unalign_check kthread\n");
-			riscv_hwprobe_complete_async_probe();
-		}
+		schedule_on_each_cpu(check_vector_unaligned_access);
 	}
 
 	/*


