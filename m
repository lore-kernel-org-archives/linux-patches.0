Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4124E2BEC2D;
	Wed, 23 Apr 2025 15:22:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745421763; cv=none; b=TjsztHRs2rQyhwYo4Vk9wrkeFJjabJPTzLv7onpQb7+E8uyvzeVWEdUuDvCaoubNYoA2aCDBTIfZ/XLMUFVk9uXt7eAbn3ksi9WB0UMihw2GFud2R8QYDh5a55OnQubjDeZaTOoeZGupzbMf96EIKkdOeozVaOWdE7ViCkcnmEA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745421763; c=relaxed/simple;
	bh=fDQ1r4EbCsjvNROSrqQa5w53BZw/ndnno1DmiuQ70XM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=l8xsGYjzVI/vzv88KNN3iLAvyF1v44/R/R6giaMao0sFdX+6Y4PMSdOzUtVzcoG3t7jETdUKEhZYk6jXvpgbYNHJ12+CNks4f9XtJBEWQ5LUdxI/TdhWtXROG73XI8Z+WMp3meW+1byezQZO5HPatoOD/P9Ax1st4jWhgig1RS4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Ta29G8XY; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Ta29G8XY"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BE69EC4CEE2;
	Wed, 23 Apr 2025 15:22:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1745421763;
	bh=fDQ1r4EbCsjvNROSrqQa5w53BZw/ndnno1DmiuQ70XM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Ta29G8XYYNdlcXFaVmQMZp+f8Ms95u9jKiePLXTu+kNd12Szae5nhn5Jk30Vf94CK
	 V1WYmFDj8LIDQQy0wfdfiXiTjlYf3e2U+Nrlv+Xq5jW/EbTxplVjUJiVmPrwKpEcu3
	 ZuGGoLu1K2FWs+VaKwDPmVx1YJZBRr+tYEtte+DI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Zijun Hu <quic_zijuhu@quicinc.com>,
	"Rob Herring (Arm)" <robh@kernel.org>
Subject: [PATCH 6.6 221/393] of/irq: Fix device node refcount leakage in API of_irq_parse_one()
Date: Wed, 23 Apr 2025 16:41:57 +0200
Message-ID: <20250423142652.514289219@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250423142643.246005366@linuxfoundation.org>
References: <20250423142643.246005366@linuxfoundation.org>
User-Agent: quilt/0.68
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

From: Zijun Hu <quic_zijuhu@quicinc.com>

commit 0cb58d6c7b558a69957fabe159bfb184196e1e8d upstream.

of_irq_parse_one(@int_gen_dev, i, ...) will leak refcount of @i_th_phandle

int_gen_dev {
    ...
    interrupts-extended = ..., <&i_th_phandle ...>, ...;
    ...
};

Refcount of @i_th_phandle is increased by of_parse_phandle_with_args()
but is not decreased by API of_irq_parse_one() before return, so causes
refcount leakage.

Rework the refcounting to use __free() cleanup and simplify the code to
have a single call to of_irq_parse_raw().

Also add comments about refcount of node @out_irq->np got by the API.

Fixes: 79d9701559a9 ("of/irq: create interrupts-extended property")
Cc: stable@vger.kernel.org
Signed-off-by: Zijun Hu <quic_zijuhu@quicinc.com>
Link: https://lore.kernel.org/r/20250209-of_irq_fix-v2-2-93e3a2659aa7@quicinc.com
[robh: Use __free() to do puts]
Signed-off-by: Rob Herring (Arm) <robh@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/of/irq.c |   59 +++++++++++++++++++++++++------------------------------
 1 file changed, 27 insertions(+), 32 deletions(-)

--- a/drivers/of/irq.c
+++ b/drivers/of/irq.c
@@ -16,6 +16,7 @@
 
 #define pr_fmt(fmt)	"OF: " fmt
 
+#include <linux/cleanup.h>
 #include <linux/device.h>
 #include <linux/errno.h>
 #include <linux/list.h>
@@ -339,10 +340,12 @@ EXPORT_SYMBOL_GPL(of_irq_parse_raw);
  * This function resolves an interrupt for a node by walking the interrupt tree,
  * finding which interrupt controller node it is attached to, and returning the
  * interrupt specifier that can be used to retrieve a Linux IRQ number.
+ *
+ * Note: refcount of node @out_irq->np is increased by 1 on success.
  */
 int of_irq_parse_one(struct device_node *device, int index, struct of_phandle_args *out_irq)
 {
-	struct device_node *p;
+	struct device_node __free(device_node) *p = NULL;
 	const __be32 *addr;
 	u32 intsize;
 	int i, res, addr_len;
@@ -367,41 +370,33 @@ int of_irq_parse_one(struct device_node
 	/* Try the new-style interrupts-extended first */
 	res = of_parse_phandle_with_args(device, "interrupts-extended",
 					"#interrupt-cells", index, out_irq);
-	if (!res)
-		return of_irq_parse_raw(addr_buf, out_irq);
-
-	/* Look for the interrupt parent. */
-	p = of_irq_find_parent(device);
-	if (p == NULL)
-		return -EINVAL;
-
-	/* Get size of interrupt specifier */
-	if (of_property_read_u32(p, "#interrupt-cells", &intsize)) {
-		res = -EINVAL;
-		goto out;
-	}
-
-	pr_debug(" parent=%pOF, intsize=%d\n", p, intsize);
+	if (!res) {
+		p = out_irq->np;
+	} else {
+		/* Look for the interrupt parent. */
+		p = of_irq_find_parent(device);
+		/* Get size of interrupt specifier */
+		if (!p || of_property_read_u32(p, "#interrupt-cells", &intsize))
+			return -EINVAL;
+
+		pr_debug(" parent=%pOF, intsize=%d\n", p, intsize);
+
+		/* Copy intspec into irq structure */
+		out_irq->np = p;
+		out_irq->args_count = intsize;
+		for (i = 0; i < intsize; i++) {
+			res = of_property_read_u32_index(device, "interrupts",
+							(index * intsize) + i,
+							out_irq->args + i);
+			if (res)
+				return res;
+		}
 
-	/* Copy intspec into irq structure */
-	out_irq->np = p;
-	out_irq->args_count = intsize;
-	for (i = 0; i < intsize; i++) {
-		res = of_property_read_u32_index(device, "interrupts",
-						 (index * intsize) + i,
-						 out_irq->args + i);
-		if (res)
-			goto out;
+		pr_debug(" intspec=%d\n", *out_irq->args);
 	}
 
-	pr_debug(" intspec=%d\n", *out_irq->args);
-
-
 	/* Check if there are any interrupt-map translations to process */
-	res = of_irq_parse_raw(addr_buf, out_irq);
- out:
-	of_node_put(p);
-	return res;
+	return of_irq_parse_raw(addr_buf, out_irq);
 }
 EXPORT_SYMBOL_GPL(of_irq_parse_one);
 


