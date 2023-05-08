Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 229E6168CB
	for <patches@lists.linux.dev>; Mon,  8 May 2023 10:58:25 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 61A6FC433EF;
	Mon,  8 May 2023 10:58:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1683543505;
	bh=RLyEh+OIJXirIzvpUveRz37c6ipnLgLD4hpss99/e7M=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=SpVnM+l1QiMFoc89i4Nf9mEJjW2LwXDEvaZcMUHe73ZrJCbhMVMKeqFNGZWPrRZx6
	 noCzHWfv6sjGIqObArS6hVVavDYkEgnL0fcRh6O4y+XbpOeXyPe/PA+87oq/2Sa540
	 4VF/oSmiDKoTH+6erWFRyDl+C1c3H/uVwyCd5PWk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Alejandro Jimenez <alejandro.j.jimenez@oracle.com>,
	Suravee Suthikulpanit <suravee.suthikulpanit@amd.com>,
	Kishon Vijay Abraham I <kvijayab@amd.com>,
	Joerg Roedel <jroedel@suse.de>
Subject: [PATCH 6.3 083/694] iommu/amd: Fix "Guest Virtual APIC Table Root Pointer" configuration in IRTE
Date: Mon,  8 May 2023 11:38:38 +0200
Message-Id: <20230508094435.222660394@linuxfoundation.org>
X-Mailer: git-send-email 2.40.1
In-Reply-To: <20230508094432.603705160@linuxfoundation.org>
References: <20230508094432.603705160@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Kishon Vijay Abraham I <kvijayab@amd.com>

commit ccc62b827775915a9b82db42a29813d04f92df7a upstream.

commit b9c6ff94e43a ("iommu/amd: Re-factor guest virtual APIC
(de-)activation code") while refactoring guest virtual APIC
activation/de-activation code, stored information for activate/de-activate
in "struct amd_ir_data". It used 32-bit integer data type for storing the
"Guest Virtual APIC Table Root Pointer" (ga_root_ptr), though the
"ga_root_ptr" is actually a 40-bit field in IRTE (Interrupt Remapping
Table Entry).

This causes interrupts from PCIe devices to not reach the guest in the case
of PCIe passthrough with SME (Secure Memory Encryption) enabled as _SME_
bit in the "ga_root_ptr" is lost before writing it to the IRTE.

Fix it by using 64-bit data type for storing the "ga_root_ptr". While at
that also change the data type of "ga_tag" to u32 in order to match
the IOMMU spec.

Fixes: b9c6ff94e43a ("iommu/amd: Re-factor guest virtual APIC (de-)activation code")
Cc: stable@vger.kernel.org # v5.4+
Reported-by: Alejandro Jimenez <alejandro.j.jimenez@oracle.com>
Reviewed-by: Suravee Suthikulpanit <suravee.suthikulpanit@amd.com>
Signed-off-by: Kishon Vijay Abraham I <kvijayab@amd.com>
Link: https://lore.kernel.org/r/20230405130317.9351-1-kvijayab@amd.com
Signed-off-by: Joerg Roedel <jroedel@suse.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/iommu/amd/amd_iommu_types.h |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/drivers/iommu/amd/amd_iommu_types.h
+++ b/drivers/iommu/amd/amd_iommu_types.h
@@ -1001,8 +1001,8 @@ struct amd_ir_data {
 	 */
 	struct irq_cfg *cfg;
 	int ga_vector;
-	int ga_root_ptr;
-	int ga_tag;
+	u64 ga_root_ptr;
+	u32 ga_tag;
 };
 
 struct amd_irte_ops {


