Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1103F4078E8;
	Sat, 12 Sep 2026 09:56:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789207015; cv=none; b=UUP9QZKTHGDGN9qFwD+rxCMZokbottnRD4LM/4ZLisC0hYwKjDRqPp57wIESrqcinrGBcy23bqGIL/ELo+33yfy56Ln5Mpa+TMJOlmtlWBOwH4WCfWJ0bJfYGnC7Bt507ut2R4nFbZf7ZGU6rTU3u8EDpBlHtxmDNo8U8CJkk+o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789207015; c=relaxed/simple;
	bh=azRvoqV+Ba5Av49pMHsjDEg6pxpCmIJc+hebZEXBZzQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=QzOruc28HrddBIFbTINrusjhu0INt0A7P3Kpi26/2xuKfj6BH711L1VxwR5Fdqz17p85fNU1xQPY1eiNjuguyKUiz/zNonHPWFmMv1nXLH1cW2R1bBWhS4dk9MmXjYzmtshOQD07FPiMSnUGAq48nFj1fp/0ZYgPJKAvAUdgjXg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=bro0i7l9; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="bro0i7l9"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 55E9A1F000FF;
	Sat, 12 Sep 2026 09:56:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789207012;
	bh=e3VYoiDO9scwIl5/PkFOvft9Nb98maoknfXN2qXmxuQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=bro0i7l90IXoFjw1MzWPpowVgh9x2QRbxFV+3YtP4LswrTsiV5VVaHvxhY4Zz6oCO
	 7Pek0ykO4EFEXFl/YvMhd0ZBHOnU2tx3WlVfuiUOpAXHYcJcLpvmrSA9Ki9yEfC1mg
	 ef7EzcCXo+V+gT+IeUoQ/yyu8+pUzHmR2BjY6Cus=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Wei Wang <wei.w.wang@hotmail.com>,
	Yongwei Xu <xuyongwei@open-hieco.net>,
	Vasant Hegde <vasant.hegde@amd.com>,
	Joerg Roedel <joerg.roedel@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0282/1518] iommu/amd: Prevent SB IOAPIC from overriding IVRS validation errors
Date: Sat, 12 Sep 2026 08:40:51 +0200
Message-ID: <20260912065629.861480312@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065623.398859879@linuxfoundation.org>
References: <20260912065623.398859879@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Wei Wang <wei.w.wang@hotmail.com>

[ Upstream commit 854056480f9217568e3ab5edd81a9347a173ea79 ]

The check_ioapic_information() function validates IOAPICs against the
IVRS table to safely disable Interrupt Remapping (IR) if the BIOS provides
a broken topology.

Currently, the validation loop contains a bug: If an unmapped secondary
IOAPIC is encountered, 'ret' is set to false. But if the Southbridge (SB)
IOAPIC is enumerated after it in the MADT, the loop overwrites 'ret' to
true.

This bypasses the validation failure and leaves IR enabled. When devices
attached to the unmapped secondary IOAPIC fire interrupts, the IOMMU drops
them due to the missing Requestor ID, leading to localized device hangs.

Fix this by initializing 'ret' to true and only toggling it to false
upon encountering a validation error, ensuring failures are never erased.

Fixes: c2ff5cf5294b ("iommu/amd: Work around wrong IOAPIC device-id in IVRS table")
Signed-off-by: Wei Wang <wei.w.wang@hotmail.com>
Tested-by: Yongwei Xu <xuyongwei@open-hieco.net>
Reviewed-by: Vasant Hegde <vasant.hegde@amd.com>
Signed-off-by: Joerg Roedel <joerg.roedel@amd.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/iommu/amd/init.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/iommu/amd/init.c b/drivers/iommu/amd/init.c
index 69170146d4421..20b1cc2159332 100644
--- a/drivers/iommu/amd/init.c
+++ b/drivers/iommu/amd/init.c
@@ -3103,7 +3103,7 @@ static bool __init check_ioapic_information(void)
 	int idx;
 
 	has_sb_ioapic = false;
-	ret           = false;
+	ret           = true;
 
 	/*
 	 * If we have map overrides on the kernel command line the
@@ -3123,7 +3123,6 @@ static bool __init check_ioapic_information(void)
 			ret = false;
 		} else if (devid == IOAPIC_SB_DEVID) {
 			has_sb_ioapic = true;
-			ret           = true;
 		}
 	}
 
@@ -3137,6 +3136,7 @@ static bool __init check_ioapic_information(void)
 		 * device id for the IOAPIC in the system.
 		 */
 		pr_err("%s: No southbridge IOAPIC found\n", fw_bug);
+		ret = false;
 	}
 
 	if (!ret)
-- 
2.53.0



