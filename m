Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795020424;
	b=La7nPchql3X/AxL468NPnGqt1ChjCUBDtsl6jBgRUF1C1YES+xzbkmS4YmZ7ARhEFfxX
	 MZuRm5fLMACoDAgocPiI5Eq/sdGMnYGoLf8bv+FN+ZhXciQ2tHFURkNSqHz7ZNy8+/Q1o
	 OA23dpb2BLR18YYuDm3rnbEqZriXFmKVgMAN9i9Miwq7LoDVcCDCEIT3syibccAcKnfQF
	 UED5O5Qo9xqTVtg50erTJQW/3IqsX4t3YbyL5zvZtT1FdFPjVbot+CFnNIrJAS7PH1gAv
	 9iBu3DFYrsK2hIdjLkNoBA+Tbg9ELwGFhUZUJ1nIr5u4wocZin2GGSQqbcNcHNkhNNA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795020424;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=kq7JLxwCpAsjIxxr9PX2IInsCG1VSI0QV7LR+UmsE0Q=;
	b=AsdhO/U0Yfss3siXov90+L5Gw37Qd6FGcFaeZVQY/jvwysaFi2wN4QLKglqU2S96ysuL
	 S21mzQpOa0zTdPBNkZAvaJg30Y5sQ5oxnLR7D3bd2x3wiy3MooBAeRZ5YPEzwX3tpZ1Po
	 uWcxtXvY/jd/FeJLqRdkS6mvgqF834Jn14iBXRsgOkYIKl1knYoYjj1S3PWUDxgeAICOC
	 seV8zs8vMuXaNRXqUaFLNjV5toEn4mb3aSaj/qPNRuyL9dQKbcsMTWoLNFNHOkmjxQeIu
	 P053eJuwjBnxm4WJLuYhnGNfbDPLPaBAdc/ZRo1FeQOOXAquue8NXkUdhGOtPVxoECA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=tt8s9oHr;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D835F606A32F;
	Wed, 18 Nov 2026 16:47:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=tt8s9oHr
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3714D1F000C4;
	Wed, 18 Nov 2026 16:47:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795020424;
	bh=kq7JLxwCpAsjIxxr9PX2IInsCG1VSI0QV7LR+UmsE0Q=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=tt8s9oHrBRh9Iijy7XUWj+o0M7g6W2qIOkZy+XACv0t0etD3BMUxrtu8NTi6btVKp
	 dZDIcI5vYCw8Q/W/tdqpci5RznXzNSeXwxqbuMLHoIKKsR3C1eXkyPfdm2YbNWeqPX
	 tpxov8Ol+GKFKwwnW/WfTokHThHHON6LmKvcYV9E=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Fuad Tabba <fuad.tabba@linux.dev>,
	Thomas Gleixner <tglx@kernel.org>,
	Marc Zyngier <maz@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 1947/2651] irqchip/gic-v3: Dont register a redistributor that was never counted
Date: Wed, 18 Nov 2026 15:53:07 +0100
Message-ID: <20261118150356.689198686@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150247.972732815@linuxfoundation.org>
References: <20261118150247.972732815@linuxfoundation.org>
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

7.3-stable review patch.  If anyone has any objections, please let me know.

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
index b0142b0a93fa4..93d7364352317 100644
--- a/drivers/irqchip/irq-gic-v3.c
+++ b/drivers/irqchip/irq-gic-v3.c
@@ -2345,6 +2345,17 @@ gic_acpi_parse_madt_gicc(union acpi_subtable_headers *header,
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



