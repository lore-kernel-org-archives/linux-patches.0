Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 17A1E39EF1F;
	Sat, 12 Sep 2026 18:42:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789238539; cv=none; b=btpjZu94N6yU+nZ4cd5Za43JKvRguGWvKZPCJZGcuPUtJ2sg9KDVHmpKm09y+RiKZvZdj6s/IfMEzhxAMSy3T09s3yBmzoWw7jKBb8uE4+Q5Vw/q7Ciulrh+cD8k0hg/YSrKPAoScPYgnGGr8F1okjMJt6bzdyM2Ix7TOv4Gnj8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789238539; c=relaxed/simple;
	bh=OAZ1f5Wbv7KPNepGEdu2RE5Q2ypl7FUrak/z7lpYVSk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=d4IQaLNGjljk5Il7ElEElZk6htH/kpPX81vhAt7u6ciYhXRXcQN4MHAIdV2KWHiQgahlwcn9fcYqcQf6bLWwn+heKCL1h2OesjkXY4K7PkEPKfF51jta/p3GomjPZ6GRpyvJjJiDmZE7KWm3+juEQGvzfwqbqhVVfTCZVIQurRM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=dMXtI4SG; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="dMXtI4SG"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C50771F000FF;
	Sat, 12 Sep 2026 18:42:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789238538;
	bh=BTn99bnExfTWfYueRqqBlY4F7eDcjxJBvtQF1bluWVY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=dMXtI4SG1q86ZWv2/jKL9e02FPEezECnzOMvk1cxr9QwsDE/nQd4dJSP0LUqhZvAA
	 XgIjSItOfta8tBHAMuU40JkjW/MDlG/4aNb6XUAJEEuBwg1CgCXhU1liefrGEyZRVh
	 WyFrFpfwWOhHTPXE4j8WZIJT7O0K4nyv6ypKMb8I=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Wei Wang <wei.w.wang@hotmail.com>,
	Yongwei Xu <xuyongwei@open-hieco.net>,
	Vasant Hegde <vasant.hegde@amd.com>,
	Joerg Roedel <joerg.roedel@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 481/935] iommu/amd: Prevent SB IOAPIC from overriding IVRS validation errors
Date: Sat, 12 Sep 2026 08:58:31 +0200
Message-ID: <20260912065537.854084676@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065526.833703348@linuxfoundation.org>
References: <20260912065526.833703348@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
index b9754219e5d9d..b8ee6157592e6 100644
--- a/drivers/iommu/amd/init.c
+++ b/drivers/iommu/amd/init.c
@@ -2669,7 +2669,7 @@ static bool __init check_ioapic_information(void)
 	int idx;
 
 	has_sb_ioapic = false;
-	ret           = false;
+	ret           = true;
 
 	/*
 	 * If we have map overrides on the kernel command line the
@@ -2689,7 +2689,6 @@ static bool __init check_ioapic_information(void)
 			ret = false;
 		} else if (devid == IOAPIC_SB_DEVID) {
 			has_sb_ioapic = true;
-			ret           = true;
 		}
 	}
 
@@ -2703,6 +2702,7 @@ static bool __init check_ioapic_information(void)
 		 * device id for the IOAPIC in the system.
 		 */
 		pr_err("%s: No southbridge IOAPIC found\n", fw_bug);
+		ret = false;
 	}
 
 	if (!ret)
-- 
2.53.0



