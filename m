Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B20E41AC44C;
	Mon, 14 Oct 2024 15:21:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728919271; cv=none; b=gE+6+tecFJITM2tSJM1iRcRoXfk7BHg2hZJN/JRJLMdKT306qA+HC9odQhggl35R56p7jznMONDLgfMAEfFqK55vh0wDNEshNVzEm505qRP0pJom8CLW3ujxaffL0e8Wb0oibvIKPefTiceuHd/vf+qcsGuO5qDVF9nQpdhMDfA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728919271; c=relaxed/simple;
	bh=VAMaoMEIjL16OA6OEFvucP0TPKCcgTquFWo1msbV1zk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Pse9sJ8H1G7ps0B70E3Kip3vh3+5qhqBnruTXE5Twe2gLW1oVqyM3PTZCbs9gIUvbmBiQsQnTLh5mPKLlWdQD89I79FfJSMSklDZvAwvVhUbNxc0MWxURNQLzNwzlkGoQ40Jk2zLWqMQPApqohIdOz8rZ8UIr3CIcdR50hpicfM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Uj7gzrZc; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Uj7gzrZc"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 22E49C4CEC3;
	Mon, 14 Oct 2024 15:21:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1728919271;
	bh=VAMaoMEIjL16OA6OEFvucP0TPKCcgTquFWo1msbV1zk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Uj7gzrZcOOWqa5yiBuUih8mK6vnwJPkJyTl7Tzl4aXGbSjwLVpB+Tx0ONxTDOv53c
	 bu4I6uzCU4HjeK7aZeqJn+HjwEBxDDp5rVJOHFHaphS6ar9MAfbDcumIFTGdgDazIB
	 osj6mgFcGa87UDs9BEc5eQBrqnbaxi4dCoOd6oho=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Andrew Jones <ajones@ventanamicro.com>,
	"Rob Herring (Arm)" <robh@kernel.org>
Subject: [PATCH 6.1 560/798] of/irq: Support #msi-cells=<0> in of_msi_get_domain
Date: Mon, 14 Oct 2024 16:18:34 +0200
Message-ID: <20241014141239.997376684@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241014141217.941104064@linuxfoundation.org>
References: <20241014141217.941104064@linuxfoundation.org>
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

From: Andrew Jones <ajones@ventanamicro.com>

commit db8e81132cf051843c9a59b46fa5a071c45baeb3 upstream.

An 'msi-parent' property with a single entry and no accompanying
'#msi-cells' property is considered the legacy definition as opposed
to its definition after being expanded with commit 126b16e2ad98
("Docs: dt: add generic MSI bindings"). However, the legacy
definition is completely compatible with the current definition and,
since of_phandle_iterator_next() tolerates missing and present-but-
zero *cells properties since commit e42ee61017f5 ("of: Let
of_for_each_phandle fallback to non-negative cell_count"), there's no
need anymore to special case the legacy definition in
of_msi_get_domain().

Indeed, special casing has turned out to be harmful, because, as of
commit 7c025238b47a ("dt-bindings: irqchip: Describe the IMX MU block
as a MSI controller"), MSI controller DT bindings have started
specifying '#msi-cells' as a required property (even when the value
must be zero) as an effort to make the bindings more explicit. But,
since the special casing of 'msi-parent' only uses the existence of
'#msi-cells' for its heuristic, and not whether or not it's also
nonzero, the legacy path is not taken. Furthermore, the path to
support the new, broader definition isn't taken either since that
path has been restricted to the platform-msi bus.

But, neither the definition of 'msi-parent' nor the definition of
'#msi-cells' is platform-msi-specific (the platform-msi bus was just
the first bus that needed '#msi-cells'), so remove both the special
casing and the restriction. The code removal also requires changing
to of_parse_phandle_with_optional_args() in order to ensure the
legacy (but compatible) use of 'msi-parent' remains supported. This
not only simplifies the code but also resolves an issue with PCI
devices finding their MSI controllers on riscv, as the riscv,imsics
binding requires '#msi-cells=<0>'.

Signed-off-by: Andrew Jones <ajones@ventanamicro.com>
Link: https://lore.kernel.org/r/20240817074107.31153-2-ajones@ventanamicro.com
Cc: stable@vger.kernel.org
Signed-off-by: Rob Herring (Arm) <robh@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/of/irq.c |   34 +++++++---------------------------
 1 file changed, 7 insertions(+), 27 deletions(-)

--- a/drivers/of/irq.c
+++ b/drivers/of/irq.c
@@ -710,8 +710,7 @@ struct irq_domain *of_msi_map_get_device
  * @np: device node for @dev
  * @token: bus type for this domain
  *
- * Parse the msi-parent property (both the simple and the complex
- * versions), and returns the corresponding MSI domain.
+ * Parse the msi-parent property and returns the corresponding MSI domain.
  *
  * Returns: the MSI domain for this device (or NULL on failure).
  */
@@ -719,33 +718,14 @@ struct irq_domain *of_msi_get_domain(str
 				     struct device_node *np,
 				     enum irq_domain_bus_token token)
 {
-	struct device_node *msi_np;
+	struct of_phandle_iterator it;
 	struct irq_domain *d;
+	int err;
 
-	/* Check for a single msi-parent property */
-	msi_np = of_parse_phandle(np, "msi-parent", 0);
-	if (msi_np && !of_property_read_bool(msi_np, "#msi-cells")) {
-		d = irq_find_matching_host(msi_np, token);
-		if (!d)
-			of_node_put(msi_np);
-		return d;
-	}
-
-	if (token == DOMAIN_BUS_PLATFORM_MSI) {
-		/* Check for the complex msi-parent version */
-		struct of_phandle_args args;
-		int index = 0;
-
-		while (!of_parse_phandle_with_args(np, "msi-parent",
-						   "#msi-cells",
-						   index, &args)) {
-			d = irq_find_matching_host(args.np, token);
-			if (d)
-				return d;
-
-			of_node_put(args.np);
-			index++;
-		}
+	of_for_each_phandle(&it, err, np, "msi-parent", "#msi-cells", 0) {
+		d = irq_find_matching_host(it.node, token);
+		if (d)
+			return d;
 	}
 
 	return NULL;


