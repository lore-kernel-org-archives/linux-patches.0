Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A2A611EB1BF;
	Thu, 17 Apr 2025 18:14:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744913682; cv=none; b=NGjgpdOy49oP8n4dCv/GTGVNh/6WT17K66fElgMouKTNzXFsNEzNYWeffQxundK77L6MurBKJVbKgPMZBYVo860/GCswFX4IkG8Hi/QtOfMr+E8cowxwUX9adfg/ziOqge4lUh/qJwYlZ5IVxC85HFSSRaJXoLWR0gSH9pJ4+ts=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744913682; c=relaxed/simple;
	bh=rIy8xo5YPmbFVl1qkOnUE9jBoPZlTjSjJKTB62tfwMY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=CY5ao1UxfyNb/L3VudIxfYMrrl8m41q4cujE+QSBHtj1VJgb1VGRjalZrHQOl9wPXRes9TQHM0mLD5kBdwQ4dKG6R168cA5P7gwYsAr9sX/hm9HB9kFvVluxdH6pK/+liS1ZnEFVYAxAgp9ea9KofA1I0eJtTClK6uC6MyfTt7A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=r4MrzTLJ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="r4MrzTLJ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 347B9C4CEE4;
	Thu, 17 Apr 2025 18:14:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1744913682;
	bh=rIy8xo5YPmbFVl1qkOnUE9jBoPZlTjSjJKTB62tfwMY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=r4MrzTLJgs23VRBN5glrBeYG/JehLm4cuDiYDKjE/tyCtSUkm9laaj4SmyF5cMYbm
	 uSHJCbU1rsnZPp2xyH9odwqYWjLIJfZeOTF+Szcjuo/zghnQSY6/2f3/Wp/gzsDHtO
	 0e1ccptXB/c5/1QOMNZ3VRm1gKX5gIOdw6BKRP9c=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Zijun Hu <quic_zijuhu@quicinc.com>,
	"Rob Herring (Arm)" <robh@kernel.org>
Subject: [PATCH 6.14 418/449] of/irq: Fix device node refcount leakage in API of_irq_parse_one()
Date: Thu, 17 Apr 2025 19:51:46 +0200
Message-ID: <20250417175135.118358139@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250417175117.964400335@linuxfoundation.org>
References: <20250417175117.964400335@linuxfoundation.org>
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

6.14-stable review patch.  If anyone has any objections, please let me know.

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
 


