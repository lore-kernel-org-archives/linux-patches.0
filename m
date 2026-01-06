Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6E4EF346A18;
	Tue,  6 Jan 2026 17:21:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767720111; cv=none; b=Th0bY/KBK5h/qQMlgUQjkHzJ5TGNIOSYJTLZnNr4yxFC5n2XdRV5n6zm9nyYXprzKiTLY8qrAKl/iJFkru2rybJLN0loHutcBIp6O+iaa8vsQ3RvNWW9RO413tvHJd42JGKtBZ0rN6W5L3NJZe8a9fel/aCtILOZy0aEDIBWwkM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767720111; c=relaxed/simple;
	bh=BhcEhRnWRieEb7tSSduaiDmW6BoPXJ0u1DLDdE0B8BI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=MZZRbW/I/cmZYP34yI9INkY1sz+5vHfs2vt1B8ueqFgtVd4bl47CjQ7Amz+YjGwYalTBFfCkdqIMOUYOx5WnJcSIQu0qm5ZCOSuW+oQ6iWlQvIjSaN2wDHpPgq3uW7GeGJfbVeCDGjBESe9R3RrsaEPsAmEqrClZJMMmCLZMhx0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=RAsH2CMn; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="RAsH2CMn"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D3B0CC16AAE;
	Tue,  6 Jan 2026 17:21:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1767720111;
	bh=BhcEhRnWRieEb7tSSduaiDmW6BoPXJ0u1DLDdE0B8BI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=RAsH2CMnF4CRV+FGG8xKhWkSBF7FKJMq9d8ZPqaGpA/fLfc9arX0AwC3b8d6fv2FY
	 ST7jHnzZ5cU2juqTaCj8ricvL3v2saf3vqo3stxfsWS5DfjdY4Pu6a9hNLu2ScKE07
	 hlWKRRGcf0wOnIHmAIUx6r85s5JIN0n6xHvJJMEU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Pengjie Zhang <zhangpengjie2@huawei.com>,
	"Rafael J. Wysocki" <rafael.j.wysocki@intel.com>
Subject: [PATCH 6.12 105/567] ACPI: CPPC: Fix missing PCC check for guaranteed_perf
Date: Tue,  6 Jan 2026 17:58:07 +0100
Message-ID: <20260106170455.213677837@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260106170451.332875001@linuxfoundation.org>
References: <20260106170451.332875001@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Pengjie Zhang <zhangpengjie2@huawei.com>

commit 6ea3a44cef28add2d93b1ef119d84886cb1e3c9b upstream.

The current implementation overlooks the 'guaranteed_perf'
register in this check.

If the Guaranteed Performance register is located in the PCC
subspace, the function currently attempts to read it without
acquiring the lock and without sending the CMD_READ doorbell
to the firmware. This can result in reading stale data.

Fixes: 29523f095397 ("ACPI / CPPC: Add support for guaranteed performance")
Signed-off-by: Pengjie Zhang <zhangpengjie2@huawei.com>
Cc: 4.20+ <stable@vger.kernel.org> # 4.20+
[ rjw: Subject and changelog edits ]
Link: https://patch.msgid.link/20251210132227.1988380-1-zhangpengjie2@huawei.com
Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/acpi/cppc_acpi.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/drivers/acpi/cppc_acpi.c
+++ b/drivers/acpi/cppc_acpi.c
@@ -1297,7 +1297,8 @@ int cppc_get_perf_caps(int cpunum, struc
 	/* Are any of the regs PCC ?*/
 	if (CPC_IN_PCC(highest_reg) || CPC_IN_PCC(lowest_reg) ||
 		CPC_IN_PCC(lowest_non_linear_reg) || CPC_IN_PCC(nominal_reg) ||
-		CPC_IN_PCC(low_freq_reg) || CPC_IN_PCC(nom_freq_reg)) {
+		CPC_IN_PCC(low_freq_reg) || CPC_IN_PCC(nom_freq_reg) ||
+		CPC_IN_PCC(guaranteed_reg)) {
 		if (pcc_ss_id < 0) {
 			pr_debug("Invalid pcc_ss_id\n");
 			return -ENODEV;


