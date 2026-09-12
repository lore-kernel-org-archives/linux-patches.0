Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 73EB64749D4;
	Sat, 12 Sep 2026 11:00:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789210836; cv=none; b=C2J75dZu9MfK5gX+pt2il0sOORaoeZ4LOaUX5FcplIinz5GY8CjQDWB12x2c1+0E5XLf/vPsRUKCV78C3wGCSeQu9z52wTU6BvUnQEZ/fq5Wh/hr5F0PJbrN0y/uE1rhvkiYJgbI6Ev/hZLC4/3bETIHhFz+ghSegvsi3De6HHs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789210836; c=relaxed/simple;
	bh=xElZPbsC0/JNEOx24di2ycIsv3H/4PVITrjHgUO1fl8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=L2xc2L4aB6H5QMRfzwwIsSq+UFUqLC8s1xKlDNcvqPMA/J6EAcI3aHpcAxZdkt1S3Ia5zlun9dl6W9yZ1l+lHYtETs/CmEs1C5eau7kYrcAYuSjqlgyyJL3p5YBC6vkBxEeJMOiCfNrsjpA/CxkgYfHB5MRwt8Qsl7YI1aLISC8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=vYgtUgH3; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="vYgtUgH3"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EAE821F000FF;
	Sat, 12 Sep 2026 11:00:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789210835;
	bh=0ruK4ZPhED4n/bjNhWs7sXxgV0tYSOIaQGhjTzjkAYc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=vYgtUgH304ls0xM1T6WeU413aZe25hf9e87DJr6qVEc2Jny/tC5oMVQeQag2eWr6g
	 5LQ9y5TRv71t7kzVdQKcaTw7WivIcr4BWlMy/Je07wLjIk32609rdNtpmRusszfaoQ
	 S3FHdLx0eZMhb1w0ynP0/4MAzCHTca+VMo9/R+tI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sashiko <sashiko-bot@kernel.org>,
	Lu Baolu <baolu.lu@linux.intel.com>,
	Joerg Roedel <joerg.roedel@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 1064/1518] iommu/vt-d: Clear Present bit before tearing down copied context entry
Date: Sat, 12 Sep 2026 08:53:53 +0200
Message-ID: <20260912065647.519307215@linuxfoundation.org>
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

From: Lu Baolu <baolu.lu@linux.intel.com>

[ Upstream commit f532c57985b1a7d6b7e37e05506b46d413e5cca4 ]

copied_context_tear_down() zeroes the 128-bit context entry with
context_clear_entry() while the Present bit is still set, and only then
issues the context-cache and IOTLB invalidations.  This leaves a window
in which hardware can fetch a torn entry, with some fields already zeroed
while Present is still set, leading to unpredictable behaviour or
spurious faults.  While x86 provides strong write ordering, the compiler
may reorder the writes to the two 64-bit halves of the entry, and the
hardware fetch is not guaranteed to be atomic with respect to multiple
CPU writes.

There is no cacheline flush before the invalidation either, so on an
IOMMU without coherent access to the context table the zeroed entry may
not be visible to hardware at the point the invalidation is submitted.

Apply the same ownership handshake described in the VT-d spec, Section
6.5.3.3 ("Guidance to Software for Invalidations"): clear only the Present
bit, flush it out to the IOMMU, perform the invalidations, and only then
zero the remainder of the entry.

Fixes: c7191984e5aad ("iommu/vt-d: Factor out helpers from domain_context_mapping_one()")
Reported-by: Sashiko <sashiko-bot@kernel.org>
Closes: https://sashiko.dev/#/patchset/20260602233426.357499-1-baolu.lu%40linux.intel.com
Assisted-by: Claude:claude-opus-5
Signed-off-by: Lu Baolu <baolu.lu@linux.intel.com>
Signed-off-by: Joerg Roedel <joerg.roedel@amd.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/iommu/intel/iommu.c | 6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

diff --git a/drivers/iommu/intel/iommu.c b/drivers/iommu/intel/iommu.c
index 633c8053df05f..21d124aadc635 100644
--- a/drivers/iommu/intel/iommu.c
+++ b/drivers/iommu/intel/iommu.c
@@ -1421,7 +1421,8 @@ static void copied_context_tear_down(struct intel_iommu *iommu,
 	assert_spin_locked(&iommu->lock);
 
 	did_old = context_domain_id(context);
-	context_clear_entry(context);
+	context_clear_present(context);
+	__iommu_flush_cache(iommu, context, sizeof(*context));
 
 	if (did_old < cap_ndoms(iommu->cap)) {
 		iommu->flush.flush_context(iommu, did_old,
@@ -1432,6 +1433,9 @@ static void copied_context_tear_down(struct intel_iommu *iommu,
 					 DMA_TLB_DSI_FLUSH);
 	}
 
+	context_clear_entry(context);
+	__iommu_flush_cache(iommu, context, sizeof(*context));
+
 	clear_context_copied(iommu, bus, devfn);
 }
 
-- 
2.53.0



