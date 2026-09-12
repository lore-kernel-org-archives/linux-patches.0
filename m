Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B9FD52F7F17;
	Sat, 12 Sep 2026 16:08:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789229326; cv=none; b=YLGi9s71jMFN5rzrHppmHil4tevLZ3TR4VANtfxm6C1NrMRbZwLJ49ZQv6qCF3+a4jbEqCFg8eujmC3E7l7W7125Ua1DAG/yJhmN+ca5F1OT6OVSxn08tU5GfsDNjwoyRMs1n3iPKtsIzr+7XN99+WgoG03opmzU/lpuoQQmcWw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789229326; c=relaxed/simple;
	bh=nkySTq1S2bLpN61FRfJiRvUwWzmZRjx1vDhPsuYhgM0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ASV2dKcOvcUmjxXbsSegxu6Ajg1mw/s6PSeci1KU+SJsNxSDYcMKKQD/1RnXSCtuw2qHS0YewHf0x5zJu7fbfdSXRJxBXsOqXkJ5aamiCjONyLNmPCA3M/wb3S1n9Ta0RSUPJIBlGp1sdt6Lz0RZYS1aMBk6cy5q09wFCzhaeT4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=joMH78GZ; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="joMH78GZ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 205111F000FF;
	Sat, 12 Sep 2026 16:08:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789229325;
	bh=rJP/mANnAMur16A+7eHpAeDbusPRwua2QUQ8k7usmmE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=joMH78GZrdPLu90Stp7NDXPBP/jQNF255e8L7YQsm4UyXYpQ15JjUHdEly/H7pPxw
	 7mLkjx1bahqqjPEQNpDANHnL/aEJ+HdyllCQo5de2mueADAn8fJuTrgK6kUUGzkgsc
	 cz15RdoexUr+cqfs2FiFiQ/9edVu5FzZ77FB0B5Q=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Wei Wang <wei.w.wang@hotmail.com>,
	Yongwei Xu <xuyongwei@open-hieco.net>,
	Vasant Hegde <vasant.hegde@amd.com>,
	Joerg Roedel <joerg.roedel@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 0568/1191] iommu/amd: Prevent SB IOAPIC from overriding IVRS validation errors
Date: Sat, 12 Sep 2026 08:54:56 +0200
Message-ID: <20260912065601.004480426@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065548.086904252@linuxfoundation.org>
References: <20260912065548.086904252@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
index a0342682c01d2..a6808eaa48d49 100644
--- a/drivers/iommu/amd/init.c
+++ b/drivers/iommu/amd/init.c
@@ -2967,7 +2967,7 @@ static bool __init check_ioapic_information(void)
 	int idx;
 
 	has_sb_ioapic = false;
-	ret           = false;
+	ret           = true;
 
 	/*
 	 * If we have map overrides on the kernel command line the
@@ -2987,7 +2987,6 @@ static bool __init check_ioapic_information(void)
 			ret = false;
 		} else if (devid == IOAPIC_SB_DEVID) {
 			has_sb_ioapic = true;
-			ret           = true;
 		}
 	}
 
@@ -3001,6 +3000,7 @@ static bool __init check_ioapic_information(void)
 		 * device id for the IOAPIC in the system.
 		 */
 		pr_err("%s: No southbridge IOAPIC found\n", fw_bug);
+		ret = false;
 	}
 
 	if (!ret)
-- 
2.53.0



