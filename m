Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 20ADE84A52;
	Wed,  7 Aug 2024 15:03:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723043000; cv=none; b=CYCB10QKsRtTUBmXPU+/DMQCISi4dNHnqvCkPaHUkpsOM3eKfA0zyxAKTTob3r+5YWw+5S+vVlzBme1YQ2G7M00YZDfm1acDep5BCnZaR59DJbSXugQoHsM1TqGj7hG/FwTRrdvAxRWm2o+LbcpJOalNA8oCoQWS+a0Dl1zaYyw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723043000; c=relaxed/simple;
	bh=DpeRoJdUxfFsN+W7ELSotj9jTxPxqGwQc9o+ZEcJ+V8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=AoKW+Kx2+FcBclBlmxW6ywWd9bs/z1cohcXMVKCs1FQHG+r1fdkKSzSMkz/UE8M3/dfBYqpJoI9xDrc70Yp3h36veXCajuNi29Xc7q7tmvUV67DNi2O7IYWBqDS/vIsuqpBVUtL0Qlsu4xE29N9tZkPQoi+vyt+6e2kOj33EUFg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=uA7POpBR; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="uA7POpBR"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A64D9C32781;
	Wed,  7 Aug 2024 15:03:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1723043000;
	bh=DpeRoJdUxfFsN+W7ELSotj9jTxPxqGwQc9o+ZEcJ+V8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=uA7POpBRKmLNeff+FasakwIzlwi9pDc48B7P95eaOxQ3JD9klI6zHP9DqBeGB7KSD
	 YaeZ+v6WeYX7/Pm7WPrBNPIl8OBtAwHw1V96KYNVFMSqI0JCeHrjmDa9mHl+baRNvV
	 mY5G2PSbWFqsY2s3dH86tUq42iy+AYwNmqiXFtIE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Alexander Gordeev <agordeev@linux.ibm.com>,
	Heiko Carstens <hca@linux.ibm.com>,
	Vasily Gorbik <gor@linux.ibm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.10 053/123] s390/mm/ptdump: Fix handling of identity mapping area
Date: Wed,  7 Aug 2024 16:59:32 +0200
Message-ID: <20240807150022.529474699@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240807150020.790615758@linuxfoundation.org>
References: <20240807150020.790615758@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Heiko Carstens <hca@linux.ibm.com>

[ Upstream commit 373953444ce542db43535861fb8ebf3a1e05669c ]

Since virtual and real addresses are not the same anymore the
assumption that the kernel image is contained within the identity
mapping is also not true anymore.

Fix this by adding two explicit areas and at the correct locations: one
for the 8kb lowcore area, and one for the identity mapping.

Fixes: c98d2ecae08f ("s390/mm: Uncouple physical vs virtual address spaces")
Reviewed-by: Alexander Gordeev <agordeev@linux.ibm.com>
Signed-off-by: Heiko Carstens <hca@linux.ibm.com>
Signed-off-by: Vasily Gorbik <gor@linux.ibm.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/s390/mm/dump_pagetables.c | 21 ++++++++++++---------
 1 file changed, 12 insertions(+), 9 deletions(-)

diff --git a/arch/s390/mm/dump_pagetables.c b/arch/s390/mm/dump_pagetables.c
index ffd07ed7b4af8..9d0805d6dc1b2 100644
--- a/arch/s390/mm/dump_pagetables.c
+++ b/arch/s390/mm/dump_pagetables.c
@@ -20,8 +20,8 @@ struct addr_marker {
 };
 
 enum address_markers_idx {
-	IDENTITY_BEFORE_NR = 0,
-	IDENTITY_BEFORE_END_NR,
+	LOWCORE_START_NR = 0,
+	LOWCORE_END_NR,
 	AMODE31_START_NR,
 	AMODE31_END_NR,
 	KERNEL_START_NR,
@@ -30,8 +30,8 @@ enum address_markers_idx {
 	KFENCE_START_NR,
 	KFENCE_END_NR,
 #endif
-	IDENTITY_AFTER_NR,
-	IDENTITY_AFTER_END_NR,
+	IDENTITY_START_NR,
+	IDENTITY_END_NR,
 	VMEMMAP_NR,
 	VMEMMAP_END_NR,
 	VMALLOC_NR,
@@ -49,8 +49,10 @@ enum address_markers_idx {
 };
 
 static struct addr_marker address_markers[] = {
-	[IDENTITY_BEFORE_NR]	= {0, "Identity Mapping Start"},
-	[IDENTITY_BEFORE_END_NR] = {(unsigned long)_stext, "Identity Mapping End"},
+	[LOWCORE_START_NR]	= {0, "Lowcore Start"},
+	[LOWCORE_END_NR]	= {0, "Lowcore End"},
+	[IDENTITY_START_NR]	= {0, "Identity Mapping Start"},
+	[IDENTITY_END_NR]	= {0, "Identity Mapping End"},
 	[AMODE31_START_NR]	= {0, "Amode31 Area Start"},
 	[AMODE31_END_NR]	= {0, "Amode31 Area End"},
 	[KERNEL_START_NR]	= {(unsigned long)_stext, "Kernel Image Start"},
@@ -59,8 +61,6 @@ static struct addr_marker address_markers[] = {
 	[KFENCE_START_NR]	= {0, "KFence Pool Start"},
 	[KFENCE_END_NR]		= {0, "KFence Pool End"},
 #endif
-	[IDENTITY_AFTER_NR]	= {(unsigned long)_end, "Identity Mapping Start"},
-	[IDENTITY_AFTER_END_NR]	= {0, "Identity Mapping End"},
 	[VMEMMAP_NR]		= {0, "vmemmap Area Start"},
 	[VMEMMAP_END_NR]	= {0, "vmemmap Area End"},
 	[VMALLOC_NR]		= {0, "vmalloc Area Start"},
@@ -290,7 +290,10 @@ static int pt_dump_init(void)
 	 */
 	max_addr = (S390_lowcore.kernel_asce.val & _REGION_ENTRY_TYPE_MASK) >> 2;
 	max_addr = 1UL << (max_addr * 11 + 31);
-	address_markers[IDENTITY_AFTER_END_NR].start_address = ident_map_size;
+	address_markers[LOWCORE_START_NR].start_address = 0;
+	address_markers[LOWCORE_END_NR].start_address = sizeof(struct lowcore);
+	address_markers[IDENTITY_START_NR].start_address = __identity_base;
+	address_markers[IDENTITY_END_NR].start_address = __identity_base + ident_map_size;
 	address_markers[AMODE31_START_NR].start_address = (unsigned long)__samode31;
 	address_markers[AMODE31_END_NR].start_address = (unsigned long)__eamode31;
 	address_markers[MODULES_NR].start_address = MODULES_VADDR;
-- 
2.43.0



