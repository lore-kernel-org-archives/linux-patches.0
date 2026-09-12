Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 59C56331203;
	Sat, 12 Sep 2026 19:47:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789242454; cv=none; b=GxWjWHAcDZJML00u4qxi+73iH+NFxgI2cSz9gjsssOFvC870N+MCTymFCRkoMv8jj9DpFtHMWGx++rL7y/cl5IrYSxl3n6xWVGjrMAaxT+tx4IXAlPf/4IpGoKoM3p9nEO6ya4xI6L67ucH8lMyhxG0xl8JFcksK4l/KMcv3aTo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789242454; c=relaxed/simple;
	bh=GloRmFd5uKHodugmuhfa7I+M2SR3NYM2qYYMaOyKsnQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=coW/qyJJbyBl6kzfWUY+krVdhXhtW0anU40Z+c2rWLONJP1elsbm/GRsp6BmDoVKzOTVnuuii6nXQXxF4VYC+eCMZOpIHfaesENmEwFXtL7TeQUjGGf6MDBdUh3Zl6KpwiffQGm6maSnP/GnZQp74emNzD5Thsej7h+XrDDhHrI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=j5Z22TOH; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="j5Z22TOH"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B61CA1F000FF;
	Sat, 12 Sep 2026 19:47:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789242453;
	bh=UFjxeaXn/09CjdMFOUQGkzxmugE73Gp0sMWSzle9jGY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=j5Z22TOHkr4HLUY2BzAO55QGRSa8zsasD+UGJxfPoGYNAss0eRlfKrIvb7yrKV5/b
	 Nhw1XsV6b/lWh8V3AqraVku18T2YXS8SfyYvCwVQXU3ujCdvHE52a3G8UAzJK9VBVP
	 ISZHnilYm3Cml0I+mgV2dMTNgGEQ3IAjwjDTlvSk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Fu Hao <fuhao@open-hieco.net>,
	Tingyin Duan <tingyin.duan@gmail.com>,
	Joerg Roedel <joerg.roedel@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 408/798] iommu/amd: Add support for Hygon family 18h model 4h IOAPIC
Date: Sat, 12 Sep 2026 09:00:36 +0200
Message-ID: <20260912065526.501885110@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065516.948645775@linuxfoundation.org>
References: <20260912065516.948645775@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Fu Hao <fuhao@open-hieco.net>

[ Upstream commit 5beda8cadb1f072140e58b1edb7604444a42d955 ]

The SB IOAPIC is on the device 0xb from Hygon family 18h model 4h.

Signed-off-by: Fu Hao <fuhao@open-hieco.net>
Tested-by: Tingyin Duan <tingyin.duan@gmail.com>
Signed-off-by: Joerg Roedel <joerg.roedel@amd.com>
Stable-dep-of: 04fee302fac7 ("iommu/amd: Fix false positive in SB IOAPIC IVRS validation")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/iommu/amd/init.c | 10 +++++++++-
 1 file changed, 9 insertions(+), 1 deletion(-)

diff --git a/drivers/iommu/amd/init.c b/drivers/iommu/amd/init.c
index 9b99994c97943..098bec555ea52 100644
--- a/drivers/iommu/amd/init.c
+++ b/drivers/iommu/amd/init.c
@@ -2569,6 +2569,9 @@ static void __init free_iommu_resources(void)
 /* SB IOAPIC is always on this device in AMD systems */
 #define IOAPIC_SB_DEVID		((0x00 << 8) | PCI_DEVFN(0x14, 0))
 
+/* SB IOAPIC for Hygon family 18h model 4h is on the device 0xb */
+#define IOAPIC_SB_DEVID_FAM18H_M4H	((0x00 << 8) | PCI_DEVFN(0xb, 0))
+
 static bool __init check_ioapic_information(void)
 {
 	const char *fw_bug = FW_BUG;
@@ -2594,7 +2597,12 @@ static bool __init check_ioapic_information(void)
 			pr_err("%s: IOAPIC[%d] not in IVRS table\n",
 				fw_bug, id);
 			ret = false;
-		} else if (devid == IOAPIC_SB_DEVID) {
+		} else if (devid == IOAPIC_SB_DEVID ||
+			   (boot_cpu_data.x86_vendor == X86_VENDOR_HYGON &&
+			    boot_cpu_data.x86 == 0x18 &&
+			    boot_cpu_data.x86_model >= 0x4 &&
+			    boot_cpu_data.x86_model <= 0xf &&
+			    devid == IOAPIC_SB_DEVID_FAM18H_M4H)) {
 			has_sb_ioapic = true;
 		}
 	}
-- 
2.53.0



