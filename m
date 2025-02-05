Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 698A41993B2;
	Wed,  5 Feb 2025 15:10:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738768247; cv=none; b=Ql8hDiIMf54cMWIu5zEXDsP7MZB7kL5hGj9Qt7JMaiYm+SIH9PXPBbPtXDRsxruAvH3kHhHHvFbX0UQEwbfzYCGyuupGlDJZ8u6tSHYd1ydnKPpSL+VFDZRx8qKfaceEPWaagmtdAienfqdHjSaJmrm56E1ub/BIyLRdCD8HhfQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738768247; c=relaxed/simple;
	bh=gTEqlYK9F/JjPUSom/A3F3D/w49OEhLEqejCjBN6R/8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=iXn4KOTz+Cs+n8WsHdP2iJ/KHZ9ykYudiR7R9F6qTlhm0epfc9ukicclCXs0m7oe/Ew45pUsVwODQf0rvOE2K3ZpikA9UL9TXgzRkT1UBU9aqHR5MFSD+EDiwAcKXTgZ83wzZ9aRDAenUHYCeG2C+5ykAFaN+zpoUpSPBU6M65U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=NC0wsI8o; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="NC0wsI8o"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4E10AC4CEE3;
	Wed,  5 Feb 2025 15:10:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1738768246;
	bh=gTEqlYK9F/JjPUSom/A3F3D/w49OEhLEqejCjBN6R/8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=NC0wsI8oGunZJVVHZyYxQWrBA4T4mrSPD9MVFjKo08SFXXek8PpEb9f3AI76mqZ1l
	 cRp83zkIN4sX2XIZphP2kqmVtLOC2FR9cQIcdUYie1A+AECWGi2UO7ablerNpRhn0K
	 oetQdd8XQbdzzfZ6xc0y3sywg9qhgj1ixLjQDHpY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Vaishnavi Bhat <vaish123@in.ibm.com>,
	Shivaprasad G Bhat <sbhat@linux.ibm.com>,
	Madhavan Srinivasan <maddy@linux.ibm.com>
Subject: [PATCH 6.12 573/590] powerpc/pseries/iommu: Dont unset window if it was never set
Date: Wed,  5 Feb 2025 14:45:28 +0100
Message-ID: <20250205134517.188795415@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250205134455.220373560@linuxfoundation.org>
References: <20250205134455.220373560@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Shivaprasad G Bhat <sbhat@linux.ibm.com>

commit 17391cb2613b82f8c405570fea605af3255ff8d2 upstream.

On pSeries, when user attempts to use the same vfio container used by
different iommu group, the spapr_tce_set_window() returns -EPERM
and the subsequent cleanup leads to the below crash.

   Kernel attempted to read user page (308) - exploit attempt?
   BUG: Kernel NULL pointer dereference on read at 0x00000308
   Faulting instruction address: 0xc0000000001ce358
   Oops: Kernel access of bad area, sig: 11 [#1]
   NIP:  c0000000001ce358 LR: c0000000001ce05c CTR: c00000000005add0
   <snip>
   NIP [c0000000001ce358] spapr_tce_unset_window+0x3b8/0x510
   LR [c0000000001ce05c] spapr_tce_unset_window+0xbc/0x510
   Call Trace:
     spapr_tce_unset_window+0xbc/0x510 (unreliable)
     tce_iommu_attach_group+0x24c/0x340 [vfio_iommu_spapr_tce]
     vfio_container_attach_group+0xec/0x240 [vfio]
     vfio_group_fops_unl_ioctl+0x548/0xb00 [vfio]
     sys_ioctl+0x754/0x1580
     system_call_exception+0x13c/0x330
     system_call_vectored_common+0x15c/0x2ec
   <snip>
   --- interrupt: 3000

Fix this by having null check for the tbl passed to the
spapr_tce_unset_window().

Fixes: f431a8cde7f1 ("powerpc/iommu: Reimplement the iommu_table_group_ops for pSeries")
Cc: stable@vger.kernel.org
Reported-by: Vaishnavi Bhat <vaish123@in.ibm.com>
Signed-off-by: Shivaprasad G Bhat <sbhat@linux.ibm.com>
Signed-off-by: Madhavan Srinivasan <maddy@linux.ibm.com>
Link: https://patch.msgid.link/173674009556.1559.12487885286848752833.stgit@linux.ibm.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/powerpc/platforms/pseries/iommu.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/arch/powerpc/platforms/pseries/iommu.c b/arch/powerpc/platforms/pseries/iommu.c
index 29f1a0cc59cd..ae6f7a235d8b 100644
--- a/arch/powerpc/platforms/pseries/iommu.c
+++ b/arch/powerpc/platforms/pseries/iommu.c
@@ -2208,6 +2208,9 @@ static long spapr_tce_unset_window(struct iommu_table_group *table_group, int nu
 	const char *win_name;
 	int ret = -ENODEV;
 
+	if (!tbl) /* The table was never created OR window was never opened */
+		return 0;
+
 	mutex_lock(&dma_win_init_mutex);
 
 	if ((num == 0) && is_default_window_table(table_group, tbl))
-- 
2.48.1



