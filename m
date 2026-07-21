Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6D71C326D44;
	Tue, 21 Jul 2026 17:38:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784655503; cv=none; b=aI8Me1td126YSCNxXs+ihvEnzdDvQqsYj1KkS3roYabdi466Q8QwMq6y8yZS5gBTRH+uYxu9HwnHoPId+LszHANOBAEZ0xaVkJZxi8zDwE3JqHKNo5eRFyuiY03lbMdA2cX86Ns2GWodwPUc4CmB/x1Vfk7h54BEN44rL9tQszg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784655503; c=relaxed/simple;
	bh=UXRbn0LzLO422/LkU9rKFjJ4TDAKwXKsrtZyH3HKYCI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=M9DnAiVBEyOYwi3eFVEq/16Ksc0pFijs2pRmC5woEURivCkOxWoxbB4N+jw5tlCiu8uzMNMdgxIgzZz4csblK+syfhQiWRfG+o59FZ4GGMqMpLKBci0WbXzfAtwPEjrGqWi5M5C3ES544x8GeoHSd/vqu4f2w1uKrNSicMaxyfw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=d7wQVFBC; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="d7wQVFBC"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9BE221F000E9;
	Tue, 21 Jul 2026 17:38:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784655502;
	bh=Jy3wE7XkS7tVl8Oaanyc/avu14Yts5lHsq3NV1lenZg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=d7wQVFBC4yG7ZWQOOfwnizOpl83yL+seihZLejdY6ccZPnklGGx8EKnSosY9cnsy6
	 XB+glRCNRPxcDZ2kfRp2/O4LhNFRQFiywrrrb8yesA1oABbpEaiI9+L+mVkQITPo/V
	 auKnB7zP1FNTQmi9o7HkKwCC1dz1MjULkN2ehQB0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Michael Bommarito <michael.bommarito@gmail.com>,
	Lu Baolu <baolu.lu@linux.intel.com>,
	Joerg Roedel <joerg.roedel@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0006/1611] iommu/vt-d: Clear Present bit before tearing down scalable-mode context entry
Date: Tue, 21 Jul 2026 17:02:02 +0200
Message-ID: <20260721152514.918530064@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152514.750365251@linuxfoundation.org>
References: <20260721152514.750365251@linuxfoundation.org>
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

From: Michael Bommarito <michael.bommarito@gmail.com>

[ Upstream commit f46452c3df7a8d8a5addc0926e76ef19ea7da0a0 ]

device_pasid_table_teardown() zeroes the 128-bit scalable-mode context
entry with context_clear_entry() while the Present bit is still set. This
creates a window where the hardware can fetch a torn entry, with some
fields already zeroed while Present is still set, leading to unpredictable
behavior or spurious faults. The context-cache invalidation is issued only
after the entry has been zeroed, and intel_pasid_free_table() then frees
the PASID directory pages, so the IOMMU can keep walking a stale Present=1
entry that points at freed memory.

While x86 provides strong write ordering, the compiler may reorder the two
64-bit writes to the entry, and the hardware fetch is not guaranteed to be
atomic with respect to multiple CPU writes.

Commit c1e4f1dccbe9d ("iommu/vt-d: Clear Present bit before tearing down
context entry") fixed this exact pattern in domain_context_clear_one() and
the copied-context path, but device_pasid_table_teardown() was not
converted.

Align it with the "Guidance to Software for Invalidations" in the VT-d
spec, Section 6.5.3.3, using the same ownership handshake as the sibling
fix: clear only the Present bit, flush it to the IOMMU, perform the
context-cache invalidation, and only then zero the rest of the entry.

Fixes: 81e921fd32161 ("iommu/vt-d: Fix NULL domain on device release")
Signed-off-by: Michael Bommarito <michael.bommarito@gmail.com>
Assisted-by: Claude:claude-opus-4-7
Link: https://lore.kernel.org/r/20260528025557.3209367-1-michael.bommarito@gmail.com
Signed-off-by: Lu Baolu <baolu.lu@linux.intel.com>
Signed-off-by: Joerg Roedel <joerg.roedel@amd.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/iommu/intel/pasid.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/iommu/intel/pasid.c b/drivers/iommu/intel/pasid.c
index 787897e61efa37..85c3116e351c60 100644
--- a/drivers/iommu/intel/pasid.c
+++ b/drivers/iommu/intel/pasid.c
@@ -746,10 +746,12 @@ static void device_pasid_table_teardown(struct device *dev, u8 bus, u8 devfn)
 	}
 
 	did = context_domain_id(context);
-	context_clear_entry(context);
+	context_clear_present(context);
 	__iommu_flush_cache(iommu, context, sizeof(*context));
 	spin_unlock(&iommu->lock);
 	intel_context_flush_no_pasid(info, context, did);
+	context_clear_entry(context);
+	__iommu_flush_cache(iommu, context, sizeof(*context));
 }
 
 static int pci_pasid_table_teardown(struct pci_dev *pdev, u16 alias, void *data)
-- 
2.53.0



