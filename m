Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6FEFF635;
	Wed, 30 Jul 2025 09:38:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1753868302; cv=none; b=TjqaobfnmKN+EtT/qMMoIz00wFEe+qxAuZNqs8mReHZf18XzMuzwJ80Zes2JJ/jVZjjU0725c/R76O4dxUQqDTdg1kbOr+h5hEgWs3fMm+PDCsuBLfULHbCawbYpEPRYjivuwc+xUIdr7yVDFDj8UZ2r+Xq6yERsxD+EAL4ndH0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1753868302; c=relaxed/simple;
	bh=7yApHBvo59AI2mGMWu79MbZKVXz3WsF1iYm7ohhFLVI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=K68r3721DaIqnBHrw7IDNVHUi35Kyo/M9voycWGFJGuHFTPOwuVEJ4VzEkrOpPJXyjitvsUgaUNWYWz3F6yZwUmjVm1ZB2pMT1TPDoGPVRFBhkl+IP2tkoLguV53OZ1777Irx2afGgonn0lSz/56ql/YGZu33Ar1aBDElOR3A0Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=wpSO6mMi; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="wpSO6mMi"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DD8F7C4CEE7;
	Wed, 30 Jul 2025 09:38:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1753868302;
	bh=7yApHBvo59AI2mGMWu79MbZKVXz3WsF1iYm7ohhFLVI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=wpSO6mMiAZtDFP5b5OSEpMdkw0SsyU34Hft0JLyn01y0m9MyylnIoBPoBAHWmdGeF
	 5Ok1nGIQ2TloJMlDrxvQ2asty32/qKCtjqe3OQ8DDjbB8vN0k9kV6Nm1LVpemeCKjF
	 +PzfS8uuE18o4EcX6XMAu2znZX1IfFO4R76+be3s=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Michael Kelley <mhklinux@outlook.com>,
	Thomas Gleixner <tglx@linutronix.de>,
	Nuno Das Neves <nunodasneves@linux.microsoft.com>,
	Wei Liu <wei.liu@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 08/76] x86/hyperv: Fix usage of cpu_online_mask to get valid cpu
Date: Wed, 30 Jul 2025 11:35:01 +0200
Message-ID: <20250730093227.176076126@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250730093226.854413920@linuxfoundation.org>
References: <20250730093226.854413920@linuxfoundation.org>
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
index 42c70d28ef272..865ae4be233b3 100644
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



