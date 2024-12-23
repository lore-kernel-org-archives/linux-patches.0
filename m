Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3220A3D6D;
	Mon, 23 Dec 2024 16:09:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734970156; cv=none; b=oysUAqL7gKx1EbGhQPCB5mGJ7ms5txHdHoymCCpNtnBJ5WfcjhdKrwV8AwhbDNsP0lw6L3ccutnpcqyFddAMZr4qaYpC/JEy6Fy+aetU25Ui7W3j2PdQkCwJ3+M96DWC3BV0iY48AKgT+SDJErJyBg2nkmIwdOqqAYqTgsnmoFE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734970156; c=relaxed/simple;
	bh=Xtb7bF1MqeiBZYur+J3X3i/MEdUoanI0m5B3mklA2uE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=igjcmjzA7v4s+yOgedjdwkrqSAQlsu4vjwLhm1GlFMdKrWEVQGucAXNucTRmj+lw+TT7P95xo55fR4F7WLF0c3WcYaqNaNCeFQ7wvw+odj7Dzo2jEWttVg2jn2nfM3UzhWhFqXH7qsDkzXn/2hJwCyUfZM8vY3nX8OwrCazZJSw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=c6F1j41K; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="c6F1j41K"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 97721C4CED3;
	Mon, 23 Dec 2024 16:09:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1734970156;
	bh=Xtb7bF1MqeiBZYur+J3X3i/MEdUoanI0m5B3mklA2uE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=c6F1j41KQEcC3evt1TFtxa8dR7vlZqDQ2yffvbcz9f3dLKYKVg8+H6XwmlDiBDhm2
	 IriP0fzvwBHh0ZAabgL9CtzrkAhU5hArzK1/lW/aQqakxgWcCNOTe++W8RFLTA0V5c
	 rvSrSdThGHl4BVifrscTPEa7QEwDK5ti5UDgcKMg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Marc Zyngier <maz@kernel.org>,
	Samuel Holland <samuel.holland@sifive.com>,
	"Rob Herring (Arm)" <robh@kernel.org>
Subject: [PATCH 6.12 147/160] of: property: fw_devlink: Do not use interrupt-parent directly
Date: Mon, 23 Dec 2024 16:59:18 +0100
Message-ID: <20241223155414.492883920@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241223155408.598780301@linuxfoundation.org>
References: <20241223155408.598780301@linuxfoundation.org>
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

From: Samuel Holland <samuel.holland@sifive.com>

commit bc7acc0bd0f94c26bc0defc902311794a3d0fae9 upstream.

commit 7f00be96f125 ("of: property: Add device link support for
interrupt-parent, dmas and -gpio(s)") started adding device links for
the interrupt-parent property. commit 4104ca776ba3 ("of: property: Add
fw_devlink support for interrupts") and commit f265f06af194 ("of:
property: Fix fw_devlink handling of interrupts/interrupts-extended")
later added full support for parsing the interrupts and
interrupts-extended properties, which includes looking up the node of
the parent domain. This made the handler for the interrupt-parent
property redundant.

In fact, creating device links based solely on interrupt-parent is
problematic, because it can create spurious cycles. A node may have
this property without itself being an interrupt controller or consumer.
For example, this property is often present in the root node or a /soc
bus node to set the default interrupt parent for child nodes. However,
it is incorrect for the bus to depend on the interrupt controller, as
some of the bus's children may not be interrupt consumers at all or may
have a different interrupt parent.

Resolving these spurious dependency cycles can cause an incorrect probe
order for interrupt controller drivers. This was observed on a RISC-V
system with both an APLIC and IMSIC under /soc, where interrupt-parent
in /soc points to the APLIC, and the APLIC msi-parent points to the
IMSIC. fw_devlink found three dependency cycles and attempted to probe
the APLIC before the IMSIC. After applying this patch, there were no
dependency cycles and the probe order was correct.

Acked-by: Marc Zyngier <maz@kernel.org>
Cc: stable@vger.kernel.org
Fixes: 4104ca776ba3 ("of: property: Add fw_devlink support for interrupts")
Signed-off-by: Samuel Holland <samuel.holland@sifive.com>
Link: https://lore.kernel.org/r/20241120233124.3649382-1-samuel.holland@sifive.com
Signed-off-by: Rob Herring (Arm) <robh@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/of/property.c |    2 --
 1 file changed, 2 deletions(-)

--- a/drivers/of/property.c
+++ b/drivers/of/property.c
@@ -1213,7 +1213,6 @@ DEFINE_SIMPLE_PROP(iommus, "iommus", "#i
 DEFINE_SIMPLE_PROP(mboxes, "mboxes", "#mbox-cells")
 DEFINE_SIMPLE_PROP(io_channels, "io-channels", "#io-channel-cells")
 DEFINE_SIMPLE_PROP(io_backends, "io-backends", "#io-backend-cells")
-DEFINE_SIMPLE_PROP(interrupt_parent, "interrupt-parent", NULL)
 DEFINE_SIMPLE_PROP(dmas, "dmas", "#dma-cells")
 DEFINE_SIMPLE_PROP(power_domains, "power-domains", "#power-domain-cells")
 DEFINE_SIMPLE_PROP(hwlocks, "hwlocks", "#hwlock-cells")
@@ -1359,7 +1358,6 @@ static const struct supplier_bindings of
 	{ .parse_prop = parse_mboxes, },
 	{ .parse_prop = parse_io_channels, },
 	{ .parse_prop = parse_io_backends, },
-	{ .parse_prop = parse_interrupt_parent, },
 	{ .parse_prop = parse_dmas, .optional = true, },
 	{ .parse_prop = parse_power_domains, },
 	{ .parse_prop = parse_hwlocks, },


