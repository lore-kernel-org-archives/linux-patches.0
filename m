Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795026869;
	b=zdAEBz/KMxsDJP39eXWj6r/oFFGlau9ZrmWLfMyEYQGZCwg32a7dtX5V6UVfxZNLzq5E
	 N/KpZhOUEQmuT3+GzQBUCEwSsO+jsoKdEjpB7ENx3nR677nBhn4XSdSjQoWGIWDNkaVz1
	 /0SLO9Tic1DhjESg399TPv8LJ5y48A6FpxSyvQWyI8p1nwpMK3JDLoF3D/ZV5U/digfkR
	 gItUrWtZgVc8FztB9qtYszTqEtkx81YeK46GspfGYefHXW71VxW/S1huHIsWj11josM26
	 ObpyNnXgeiddy97ZE5sMtHeyApLMIlZn3Q3cISTxVvwadjkp9vwqjwVIR5Mw/ATKf+Q==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795026869;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=+VRI6o6OVc9FW6LcpGfTHl/DcA5TNCl1Jtt0viILHx0=;
	b=ilmMaocLO0mYg1Hoo2AWyRdFdPeMnkfFZ235X3VUituZB3JedZqDegeJzK7rssEVqgtK
	 R22vV05Y/vWWKJN1HFpK6XNlOkBDC0djDJ5UCQPg3wsPxmktUerhwLz3pQyyKtR/g7AOg
	 Yw2GBRPRf7gJ3W/U40OyNVswxPsMGkfOAE2sPeLDkeWaFFC6yi0tMSlpe1t+NMgeQzlZC
	 1hjUT+DqExTZEIW+T4An7GJyXC+ycAc9RSlAnBOnReN2QxlWMl/b7BB7+H6PZV9r7Pc1f
	 l/WbYUx5S7OJs3VqqUqmq7Inhsu2wbgsBYeQRb3hColAnFJqwfvn+8jOG4apUj4RS7A==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=DhZGvksm;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4673F606A31C;
	Wed, 18 Nov 2026 18:34:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=DhZGvksm
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4E53D1F000C8;
	Wed, 18 Nov 2026 18:34:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795026868;
	bh=+VRI6o6OVc9FW6LcpGfTHl/DcA5TNCl1Jtt0viILHx0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=DhZGvksmLA2PMMu0L3TzpQz+oKbS8EB+58Nm4SP3Ii2lV5pckOE4A492YYdH7ls1e
	 Zix/ZlK/3ot1zY4vHPIylKpu48tntoX5g3YnyMe15LELEb4SLv4MUJIW1p1EBjei6l
	 Toe7rGpuEV0QN2hmoe2eOtpusG2q2VvteYJ1Bs54=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Fuad Tabba <fuad.tabba@linux.dev>,
	Thomas Gleixner <tglx@kernel.org>,
	Marc Zyngier <maz@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 1587/2151] irqchip/gic-v3: Dont register a redistributor that was never counted
Date: Wed, 18 Nov 2026 15:55:22 +0100
Message-ID: <20261118150219.693287901@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150121.603863898@linuxfoundation.org>
References: <20261118150121.603863898@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Fuad Tabba <fuad.tabba@linux.dev>

[ Upstream commit 6a21693b97ee5cb0a21d04bfd051a05dde5aa783 ]

gic_acpi_match_gicc() counts only the enabled GICCs with a non-zero
gicr_base_address, and that count sizes redist_regs[], but
gic_acpi_parse_madt_gicc() registers every enabled one. On a MADT with
no GICR entries, an enabled GICC with a zero GICR base therefore makes
gic_acpi_register_redist() write a struct redist_region past the end of
the array.

Commit fa2dabe57220e ("irqchip/gic-v3: Don't return errors from
gic_acpi_match_gicc()") removed the check that kept the two consistent.
Its message says such entries are still caught by gic_populate_rdist(),
but that runs from gic_cpu_init(), after the write.

Skip the entry instead, and mark the CPU's redistributor broken as the
online-capable path does, so that gic_check_rdist() rejects the CPU.
gic_starting_cpu() runs past cpuhp's last failure point, so without the
mark the CPU would come online with its redistributor and CPU interface
unconfigured. With an ITS, its_cpu_init() would then dereference a NULL
rd_base.

Fixes: fa2dabe57220e ("irqchip/gic-v3: Don't return errors from gic_acpi_match_gicc()")
Signed-off-by: Fuad Tabba <fuad.tabba@linux.dev>
Signed-off-by: Thomas Gleixner <tglx@kernel.org>
Reviewed-by: Marc Zyngier <maz@kernel.org>
Link: https://patch.msgid.link/20260925085000.753400-4-fuad.tabba@linux.dev
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/irqchip/irq-gic-v3.c | 11 +++++++++++
 1 file changed, 11 insertions(+)

diff --git a/drivers/irqchip/irq-gic-v3.c b/drivers/irqchip/irq-gic-v3.c
index 3de351e66ee84..d6b499968f181 100644
--- a/drivers/irqchip/irq-gic-v3.c
+++ b/drivers/irqchip/irq-gic-v3.c
@@ -2454,6 +2454,17 @@ gic_acpi_parse_madt_gicc(union acpi_subtable_headers *header,
 		return 0;
 	}
 
+	/* Not counted by gic_acpi_match_gicc(), so there is no slot for it */
+	if (!gicc->gicr_base_address) {
+		int cpu = get_cpu_for_acpi_id(gicc->uid);
+
+		pr_warn(FW_BUG "GICC entry with ACPI UID %u has no GICR base address, CPU kept offline\n",
+			gicc->uid);
+		if (cpu >= 0)
+			cpumask_set_cpu(cpu, &broken_rdists);
+		return 0;
+	}
+
 	redist_base = ioremap(gicc->gicr_base_address, size);
 	if (!redist_base)
 		return -ENOMEM;
-- 
2.53.0



