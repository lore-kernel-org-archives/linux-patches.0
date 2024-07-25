Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 22DE019D068;
	Thu, 25 Jul 2024 14:41:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1721918470; cv=none; b=W/wGhleQiYMpSXTdp7MbLmk8yW+iT9uBSh9ENct29/8rWXe/WLNCq9W0245tBIw+IS/5wQdiyWR9j/9XLfrcFWGK8KtZzqe8kP60UoRxZeRWVB/BitXA/bAoArw+OX4oEgFT59uNM4URI6t5qy7xaKW1LUz1b6FHcCDXKiAjDy4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1721918470; c=relaxed/simple;
	bh=lVWOQFQu9YzXBzq0Cg7ECBKzQBYLpqMRD7VlztZy9M8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=qT8ZZGKPK12kS++EELJyBuWlDqZuRaLnKObUwW/mExLC0lfLnMicWWOOEmG7pGlPqDfRwi0JhjhVfmeuJe5mnTJRJinH1jjz1QU5qZSqsXiCgQkzUITGIVf7x2UpENLeDn12KF4gJSJb14SCttDPo6ZII7/cRFMx+vNGFw/JnrI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=uU0sY/wD; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="uU0sY/wD"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9DEC1C116B1;
	Thu, 25 Jul 2024 14:41:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1721918470;
	bh=lVWOQFQu9YzXBzq0Cg7ECBKzQBYLpqMRD7VlztZy9M8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=uU0sY/wDqi5EzV6yP7QoszeINQ+MJpuAuxstB5s2pqFC+Zb9UfEM7ak/4rgnShCra
	 1R2Xl1V4x+zfXr+xTKIF9isedA49xCrDtcG3uoULyqunX5KcFX8xVgVn99zpoFMu+J
	 sg1uNm0J0kYWlSHX/rAhfhhmJB10eR/VtdfFTCwE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Julian Sikorski <belegdol@gmail.com>,
	Kuan-Wei Chiu <visitorckw@gmail.com>,
	"Rafael J. Wysocki" <rafael.j.wysocki@intel.com>
Subject: [PATCH 4.19 29/33] ACPI: processor_idle: Fix invalid comparison with insertion sort for latency
Date: Thu, 25 Jul 2024 16:36:52 +0200
Message-ID: <20240725142729.609971804@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240725142728.511303502@linuxfoundation.org>
References: <20240725142728.511303502@linuxfoundation.org>
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

4.19-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Kuan-Wei Chiu <visitorckw@gmail.com>

commit 233323f9b9f828cd7cd5145ad811c1990b692542 upstream.

The acpi_cst_latency_cmp() comparison function currently used for
sorting C-state latencies does not satisfy transitivity, causing
incorrect sorting results.

Specifically, if there are two valid acpi_processor_cx elements A and B
and one invalid element C, it may occur that A < B, A = C, and B = C.
Sorting algorithms assume that if A < B and A = C, then C < B, leading
to incorrect ordering.

Given the small size of the array (<=8), we replace the library sort
function with a simple insertion sort that properly ignores invalid
elements and sorts valid ones based on latency. This change ensures
correct ordering of the C-state latencies.

Fixes: 65ea8f2c6e23 ("ACPI: processor idle: Fix up C-state latency if not ordered")
Reported-by: Julian Sikorski <belegdol@gmail.com>
Closes: https://lore.kernel.org/lkml/70674dc7-5586-4183-8953-8095567e73df@gmail.com
Signed-off-by: Kuan-Wei Chiu <visitorckw@gmail.com>
Tested-by: Julian Sikorski <belegdol@gmail.com>
Cc: All applicable <stable@vger.kernel.org>
Link: https://patch.msgid.link/20240701205639.117194-1-visitorckw@gmail.com
Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
Signed-off-by: Kuan-Wei Chiu <visitorckw@gmail.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/acpi/processor_idle.c |   40 ++++++++++++++++------------------------
 1 file changed, 16 insertions(+), 24 deletions(-)

--- a/drivers/acpi/processor_idle.c
+++ b/drivers/acpi/processor_idle.c
@@ -29,7 +29,6 @@
 #include <linux/acpi.h>
 #include <linux/dmi.h>
 #include <linux/sched.h>       /* need_resched() */
-#include <linux/sort.h>
 #include <linux/tick.h>
 #include <linux/cpuidle.h>
 #include <linux/cpu.h>
@@ -545,28 +544,24 @@ static void acpi_processor_power_verify_
 	return;
 }
 
-static int acpi_cst_latency_cmp(const void *a, const void *b)
+static void acpi_cst_latency_sort(struct acpi_processor_cx *states, size_t length)
 {
-	const struct acpi_processor_cx *x = a, *y = b;
+	int i, j, k;
 
-	if (!(x->valid && y->valid))
-		return 0;
-	if (x->latency > y->latency)
-		return 1;
-	if (x->latency < y->latency)
-		return -1;
-	return 0;
-}
-static void acpi_cst_latency_swap(void *a, void *b, int n)
-{
-	struct acpi_processor_cx *x = a, *y = b;
-	u32 tmp;
+	for (i = 1; i < length; i++) {
+		if (!states[i].valid)
+			continue;
 
-	if (!(x->valid && y->valid))
-		return;
-	tmp = x->latency;
-	x->latency = y->latency;
-	y->latency = tmp;
+		for (j = i - 1, k = i; j >= 0; j--) {
+			if (!states[j].valid)
+				continue;
+
+			if (states[j].latency > states[k].latency)
+				swap(states[j].latency, states[k].latency);
+
+			k = j;
+		}
+	}
 }
 
 static int acpi_processor_power_verify(struct acpi_processor *pr)
@@ -611,10 +606,7 @@ static int acpi_processor_power_verify(s
 
 	if (buggy_latency) {
 		pr_notice("FW issue: working around C-state latencies out of order\n");
-		sort(&pr->power.states[1], max_cstate,
-		     sizeof(struct acpi_processor_cx),
-		     acpi_cst_latency_cmp,
-		     acpi_cst_latency_swap);
+		acpi_cst_latency_sort(&pr->power.states[1], max_cstate);
 	}
 
 	lapic_timer_propagate_broadcast(pr);


