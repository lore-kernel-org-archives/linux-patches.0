Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 727E9FC19;
	Thu, 25 Jul 2024 14:49:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1721918975; cv=none; b=BwQFxC12OOwa7OyNjvictHA5NcJiQ/Y8HQL04gi/p3Cb2hzUPjH+Iu1uG/m/IkD0vtZkB1zlewqKOcGRCXcVyJKSyTBw0MrUcqGXG2db+lcQu1kfTU3QQA4qDK9wzSyrhPaLNlH4MOKicA7+WKYchmoRNbJVqbGBbn04aYxgyUo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1721918975; c=relaxed/simple;
	bh=zyvsEul2POd/gvv2SW5qzc3OIjtv+1XaKdMgfweFXl8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ao1XBSfSuU/HNqNnGRQmlHMbEvw64Pvct0g4hOYPbUZ0x4CUQwv2tSLjw6/2gsqq2IXHpu69oIe8t624K8Xve6sqd1azqB/CZPh5n6o1+WFgVGAxJwLTODCuFeYhxh9kUXKQUND22eOmoyZg8Vei3ZqIaLgjK0RrlvVrmfAByaY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=FlhmkIAI; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="FlhmkIAI"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id ECFEDC116B1;
	Thu, 25 Jul 2024 14:49:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1721918975;
	bh=zyvsEul2POd/gvv2SW5qzc3OIjtv+1XaKdMgfweFXl8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=FlhmkIAIBWm90D/r6LqtXMfGoZbD2COCCWOBJDK35na+x3Kn0FEwIdWTt497nAPXH
	 XkADUxYyxEZIB616AF8smvJP7e8CFPL1sKRQ6hUDZHyGaHyc/Olknknfsgq5p+J0HT
	 QCg1PkAW9blYTQS6ybLvsTnl2fWRXoTWexLlZ458=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Julian Sikorski <belegdol@gmail.com>,
	Kuan-Wei Chiu <visitorckw@gmail.com>,
	"Rafael J. Wysocki" <rafael.j.wysocki@intel.com>
Subject: [PATCH 5.10 45/59] ACPI: processor_idle: Fix invalid comparison with insertion sort for latency
Date: Thu, 25 Jul 2024 16:37:35 +0200
Message-ID: <20240725142734.963582984@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240725142733.262322603@linuxfoundation.org>
References: <20240725142733.262322603@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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
@@ -16,7 +16,6 @@
 #include <linux/acpi.h>
 #include <linux/dmi.h>
 #include <linux/sched.h>       /* need_resched() */
-#include <linux/sort.h>
 #include <linux/tick.h>
 #include <linux/cpuidle.h>
 #include <linux/cpu.h>
@@ -390,28 +389,24 @@ static void acpi_processor_power_verify_
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
@@ -456,10 +451,7 @@ static int acpi_processor_power_verify(s
 
 	if (buggy_latency) {
 		pr_notice("FW issue: working around C-state latencies out of order\n");
-		sort(&pr->power.states[1], max_cstate,
-		     sizeof(struct acpi_processor_cx),
-		     acpi_cst_latency_cmp,
-		     acpi_cst_latency_swap);
+		acpi_cst_latency_sort(&pr->power.states[1], max_cstate);
 	}
 
 	lapic_timer_propagate_broadcast(pr);


