Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795032035;
	b=RBgdos4kcOzsAq5+ObvHeoG3TkAvCWaGN8YWX1+chFclA9Tpv5nUukuu9jTW4uaXEYBF
	 pL+5/G8CPieWqWyNL9wqE1HRpPVlnA2tPFWzbL3XHM7sbHz4Tb4ZW9lSYB2mDA7YnZOiu
	 ma+XaT0e164nfYOUeQL4a0oBCDIMp5C+tXB0inEH5ifxDEtvRFi7mWKigJ/HdNwvPIBaX
	 X8DO8I78H4/Mme234i9EF/XFwkTU/yDI9VNv+3c5ElEqPmsqXp9/R9QdpRkv20eylgT+6
	 8a8JGHRqy1om1hIrmjinfkFlqL+Ai9mpFllf1EAxPu+1W4qLvDp4Oi5gL57IlPTr75A==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795032035;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=iCkBLVdfbko1m4VfcOf/uXi34iomsRHMZxi5aNFTYOA=;
	b=r4CJ32k42ur/57HTG8gT1HWDkpwTs3OayEXs9JCp35+4AwgilZZEuRiGcyHFrDSVywog
	 Ony/7setfvpoG/DeuqXvtWCsIqEftC8lBRjpuWUFOItDonAUkzqFjb7YTNPkD80B0LXGV
	 aH55eZFVAj/r74O0CAiWfDiye9l/wg+OoNhWe06o6wXE0JG3ssuxs3sZjvnoat9xUMp75
	 VMOyIkrE1ePX+swUz3FAYIdRRUEA1jrACy4jATffjha6B8QGlqo6mYmtT5Fr174Mg9FtI
	 NZ6MCpVoCoOziqBBcDFnehriDyXgHu6MKVqlsKb47ismezlwbZzBfodk+aMR3w/65Fw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=jOmsy93M;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8578260A2601;
	Wed, 18 Nov 2026 20:00:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=jOmsy93M
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D29631F000C4;
	Wed, 18 Nov 2026 20:00:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795032035;
	bh=iCkBLVdfbko1m4VfcOf/uXi34iomsRHMZxi5aNFTYOA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=jOmsy93MgDi7KJNF2CJCtWXLnhY1r6ytQDKR7T1tCsIp2Q57/RiwV7Ar28g4j87y9
	 eVsxtmukXaASsizcMTCtTrpQqh0j6fP0hY8cQdL++mm1xfnDDAwt3WUR+zhek4KgnX
	 ls3g9nS9iHDCxaOYa6esH124I2F6tdYws94h0WfM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Fuad Tabba <fuad.tabba@linux.dev>,
	Thomas Gleixner <tglx@kernel.org>,
	Marc Zyngier <maz@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 1268/1756] irqchip/gic-v3: Dont register a redistributor that was never counted
Date: Wed, 18 Nov 2026 15:56:35 +0100
Message-ID: <20261118150100.123857638@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150007.957976754@linuxfoundation.org>
References: <20261118150007.957976754@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
index cf469a6724972..11c762010e4b8 100644
--- a/drivers/irqchip/irq-gic-v3.c
+++ b/drivers/irqchip/irq-gic-v3.c
@@ -2453,6 +2453,17 @@ gic_acpi_parse_madt_gicc(union acpi_subtable_headers *header,
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



