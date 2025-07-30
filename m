Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DC6D220E6;
	Wed, 30 Jul 2025 09:50:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1753869017; cv=none; b=JI6MpLCF9EDc3EdsFTRp6nd9eYafVcx5jT0AwDMsrm9KOoYhk1C7HBgdF/N7+uw/692C1STUwOrOL15S10EodAQWJYi5K7CLWZglC7G4yMkwA3ZYqmIQJNv07PEgVQJAYReVpL25fVBDrpqOWO0vEbg5IV04WInutULLtst6RmQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1753869017; c=relaxed/simple;
	bh=6Iv84eMiBMmn3Qe2pWlw5Yx9ibawhtEPMqvQqNGTNOw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=VQpgjZToZAxt8lsbS2lK9fcMxXSGc9o8E2kCdpQfNo8Uq2o5Pw2dURu3FcZFu6pjmixcSpTaEAAOfTXE3TufgymZ6wQPcfAYdV7oCwbSBHhwLXdWR6ctPP5EmjvFkJ2mnTqSy9tMh/WKxWqOFFCtf0ME9zkbVi/xWMALIM0ZhOo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=N1N6VCc4; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="N1N6VCc4"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A8621C4CEF8;
	Wed, 30 Jul 2025 09:50:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1753869016;
	bh=6Iv84eMiBMmn3Qe2pWlw5Yx9ibawhtEPMqvQqNGTNOw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=N1N6VCc4JzvlUQTdFz6f3z/8P9ohXb6ew28ui9tkKAJ9UTObClxEtF+Jm6jngcKeP
	 of4kT7hPx2V5eCpKA8ToNe5quSI/HG965BU4es9/tagbCgKOiH1eJXdwpyqBnreAmK
	 eMf8jURD3GVWGAa2a903rojYoCxHKhg+XT+umEOg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Michael Kelley <mhklinux@outlook.com>,
	Thomas Gleixner <tglx@linutronix.de>,
	Nuno Das Neves <nunodasneves@linux.microsoft.com>,
	Wei Liu <wei.liu@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.15 17/92] x86/hyperv: Fix usage of cpu_online_mask to get valid cpu
Date: Wed, 30 Jul 2025 11:35:25 +0200
Message-ID: <20250730093231.282637320@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250730093230.629234025@linuxfoundation.org>
References: <20250730093230.629234025@linuxfoundation.org>
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

6.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Nuno Das Neves <nunodasneves@linux.microsoft.com>

[ Upstream commit bb169f80ed5a156ec3405e0e49c6b8e9ae264718 ]

Accessing cpu_online_mask here is problematic because the cpus read lock
is not held in this context.

However, cpu_online_mask isn't needed here since the effective affinity
mask is guaranteed to be valid in this callback. So, just use
cpumask_first() to get the cpu instead of ANDing it with cpus_online_mask
unnecessarily.

Fixes: e39397d1fd68 ("x86/hyperv: implement an MSI domain for root partition")
Reported-by: Michael Kelley <mhklinux@outlook.com>
Closes: https://lore.kernel.org/linux-hyperv/SN6PR02MB4157639630F8AD2D8FD8F52FD475A@SN6PR02MB4157.namprd02.prod.outlook.com/
Suggested-by: Thomas Gleixner <tglx@linutronix.de>
Signed-off-by: Nuno Das Neves <nunodasneves@linux.microsoft.com>
Reviewed-by: Michael Kelley <mhklinux@outlook.com>
Link: https://lore.kernel.org/r/1751582677-30930-4-git-send-email-nunodasneves@linux.microsoft.com
Signed-off-by: Wei Liu <wei.liu@kernel.org>
Message-ID: <1751582677-30930-4-git-send-email-nunodasneves@linux.microsoft.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/x86/hyperv/irqdomain.c | 4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

diff --git a/arch/x86/hyperv/irqdomain.c b/arch/x86/hyperv/irqdomain.c
index 31f0d29cbc5e3..e28c317ac9e81 100644
--- a/arch/x86/hyperv/irqdomain.c
+++ b/arch/x86/hyperv/irqdomain.c
@@ -192,7 +192,6 @@ static void hv_irq_compose_msi_msg(struct irq_data *data, struct msi_msg *msg)
 	struct pci_dev *dev;
 	struct hv_interrupt_entry out_entry, *stored_entry;
 	struct irq_cfg *cfg = irqd_cfg(data);
-	const cpumask_t *affinity;
 	int cpu;
 	u64 status;
 
@@ -204,8 +203,7 @@ static void hv_irq_compose_msi_msg(struct irq_data *data, struct msi_msg *msg)
 		return;
 	}
 
-	affinity = irq_data_get_effective_affinity_mask(data);
-	cpu = cpumask_first_and(affinity, cpu_online_mask);
+	cpu = cpumask_first(irq_data_get_effective_affinity_mask(data));
 
 	if (data->chip_data) {
 		/*
-- 
2.39.5



