Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6E2E23F9F47;
	Sat, 12 Sep 2026 08:47:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789202859; cv=none; b=nRMT1/5Y5m5lYjGRoztrDPQiakloLPGzJdSDiFW8mysGV8ix8C2fJKnWYk9TojGyrtxAoO1R8E3mplmf1Moq7xx005PV+EN4NCdjnwtvxuUV9ul53b+WFvvv3zFupCy35pweT9tgbKASgtSPhQYdxdGa2UyJwhMYIod+kZ+DQXA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789202859; c=relaxed/simple;
	bh=LMmU9YCDcZJMtxM8IqkX1ZKLAcjwvKJS7Z8E5GWKj8E=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=owR9fbE7EPj2Y2Rjtp6Gi09ot3+/xNg58ZRWYgMmvaisDaJizVKbaJIHltCnizQK8t8weOZmL5QVkcdwNxV4LPTlmgI2TILeUp0sfVp2Nz4TjoPk3e+yDDIxGaxiiJ/FtL6uTeJngG0IVNn5IYXHy2wsZCwkenzgJgCHHWaEoG4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=WLwkvFPx; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="WLwkvFPx"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 72E0E1F000FF;
	Sat, 12 Sep 2026 08:47:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789202858;
	bh=m2Bza8NQT8N6wNn+9uJ2ioLCPv6y6T9+IBOqu2C958E=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=WLwkvFPxgVVO54iECqPQoqI1r0CGqN54XDOgwYKr/QP98bO7hRkHKp3NTRK/6WXEZ
	 hvS/v2zdfCP29oVNP1r2qeeZ94FeY+XPQ8PsnvTsrrSmccaMvIaWENsXlJ68i5pTs5
	 Vl8obWRooVdr7Niv0A0tWfQAgyG+GE+kLrPDZj8I=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sashiko <sashiko-bot@kernel.org>,
	Lu Baolu <baolu.lu@linux.intel.com>,
	Joerg Roedel <joerg.roedel@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.2 1291/1815] iommu/vt-d: Clear Present bit before tearing down copied context entry
Date: Sat, 12 Sep 2026 08:50:41 +0200
Message-ID: <20260912065719.323052285@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065648.999753832@linuxfoundation.org>
References: <20260912065648.999753832@linuxfoundation.org>
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

7.2-stable review patch.  If anyone has any objections, please let me know.

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
index 4d03d9a517dea..6fadba2cf22f9 100644
--- a/drivers/iommu/intel/iommu.c
+++ b/drivers/iommu/intel/iommu.c
@@ -1108,7 +1108,8 @@ static void copied_context_tear_down(struct intel_iommu *iommu,
 	assert_spin_locked(&iommu->lock);
 
 	did_old = context_domain_id(context);
-	context_clear_entry(context);
+	context_clear_present(context);
+	__iommu_flush_cache(iommu, context, sizeof(*context));
 
 	if (did_old < cap_ndoms(iommu->cap)) {
 		iommu->flush.flush_context(iommu, did_old,
@@ -1119,6 +1120,9 @@ static void copied_context_tear_down(struct intel_iommu *iommu,
 					 DMA_TLB_DSI_FLUSH);
 	}
 
+	context_clear_entry(context);
+	__iommu_flush_cache(iommu, context, sizeof(*context));
+
 	clear_context_copied(iommu, bus, devfn);
 }
 
-- 
2.53.0



