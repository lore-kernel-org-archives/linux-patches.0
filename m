Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 32CEE4D5A1;
	Sat, 12 Sep 2026 07:40:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789198822; cv=none; b=LAOtysU1/8H04W3NrkHRZFSIMOBIQzTHg8Fk9ZIyNSPSKr9yXTfvI/PIQYRY4dnE/hiP089kOG/oxU3jumTBzVkiwNeARH/vV5WsevQ3yE13kkslguuROqOe2tqKuU29npiIgSsaLHgkm2lebycDcGo8tWVHc16S+p1xjG15ACQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789198822; c=relaxed/simple;
	bh=ThHTfuscRw5Wi5i6nrolMXWWBQz2fB3gMeqcXI3ElEE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=AcNH5BqR8LXpM1LqeZUNgvbewD3kLwGef95XFiRB4LA+U1eufspEN0fwr0SpbvqnoM+G06twcG0JLdPGH9UMLn5wJYduaDbbXFC/r8MjChm4RU2xHH+HNO+mEVSHQsgaBOr2Wj2CIq5xqOs/t2I0cRESr4z7LIOnWR+XgL7VSQo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=sA98xuCk; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="sA98xuCk"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DF8DC1F000FF;
	Sat, 12 Sep 2026 07:40:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789198821;
	bh=m7d85SwsmhJ4N7XE2Anc1HkScL/aoZQRBwVRs7Mu0pA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=sA98xuCk6THJ/8nJIXqTokDBySkZv1CoOeJSX3hE/ooEX7dH/QHLAPK5tswMS8FMi
	 N40qucAiddoS8SgZgj/kobq3dAB/0zUlm4vqv6B7aZgkrmPSC3eMtQJ/b9zUt0hD5o
	 zaBb50MPKzUytlxC7c8v+CE2pO9Mx0I4B8KCqUZI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dave Jiang <dave.jiang@intel.com>,
	Alison Schofield <alison.schofield@intel.com>,
	John Groves <john@groves.net>,
	Richard Cheng <icheng@nvidia.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.2 0416/1815] dax/fsdev: fix multi-range offset in memory_failure handler
Date: Sat, 12 Sep 2026 08:36:06 +0200
Message-ID: <20260912065658.659209700@linuxfoundation.org>
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

From: John Groves <John@Groves.net>

[ Upstream commit e0cb40c3c676786c92ddb7f891a928ce970d6244 ]

Fix memory_failure offset calculation for multi-range devices. The old
code subtracted ranges[0].range.start from the faulting PFN's physical
address, which produces an incorrect (inflated) logical offset when the
PFN falls in ranges[1] or beyond due to physical gaps between ranges.
Add fsdev_pfn_to_offset() to walk the range list and compute the correct
device-linear byte offset relative to ranges[0].start (the device data
start) -- the base the holder (xfs, famfs) maps from -- for both static
and dynamic devices.

V5 walked the pagemap's immutable pgmap->ranges[] instead, to avoid
reading the mutable dev_dax->ranges[] from this callback. That had a
different problem: it regressed static devices, where pgmap->ranges[0].start
can sit data_offset below the data start, so the reported offset came out
data_offset too high and the holder would act on the wrong blocks. For
dynamic devices the two arrays are identical, so pgmap->ranges[] only ever
helped the dynamic case while breaking the static one. Walk
dev_dax->ranges[] instead. (Richard Cheng spotted the static regression.)

Reading dev_dax->ranges[] here may race a concurrent krealloc() of the
range array via sysfs (mapping_store(), under dax_region_rwsem, which
this ->memory_failure callback does not hold). That exposure is
pre-existing -- the original single-range code read dev_dax->ranges[0]
locklessly as well -- so this patch does not make it worse; a proper fix
(locking or snapshotting) belongs in a separate change.

Fixes: d5406bd458b0a ("dax: add fsdev.c driver for fs-dax on character dax")

Reviewed-by: Dave Jiang <dave.jiang@intel.com>
Reviewed-by: Alison Schofield <alison.schofield@intel.com>
Signed-off-by: John Groves <john@groves.net>
Reviewed-by: Richard Cheng <icheng@nvidia.com>
Link: https://patch.msgid.link/0100019ecc08d74f-ec0d09b8-11e9-4e5b-af48-8c6d382af486-000000@email.amazonses.com
Signed-off-by: Alison Schofield <alison.schofield@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/dax/fsdev.c | 17 ++++++++++++++++-
 1 file changed, 16 insertions(+), 1 deletion(-)

diff --git a/drivers/dax/fsdev.c b/drivers/dax/fsdev.c
index 188b2526bee45..f315533b299e9 100644
--- a/drivers/dax/fsdev.c
+++ b/drivers/dax/fsdev.c
@@ -135,11 +135,26 @@ static void fsdev_clear_ops(void *data)
  * The core mm code in free_zone_device_folio() handles the wake_up_var()
  * directly for this memory type.
  */
+static u64 fsdev_pfn_to_offset(struct dev_dax *dev_dax, unsigned long pfn)
+{
+	phys_addr_t phys = PFN_PHYS(pfn);
+	u64 offset = 0;
+
+	for (int i = 0; i < dev_dax->nr_range; i++) {
+		struct range *range = &dev_dax->ranges[i].range;
+
+		if (phys >= range->start && phys <= range->end)
+			return offset + (phys - range->start);
+		offset += range_len(range);
+	}
+	return -1ULL;
+}
+
 static int fsdev_pagemap_memory_failure(struct dev_pagemap *pgmap,
 		unsigned long pfn, unsigned long nr_pages, int mf_flags)
 {
 	struct dev_dax *dev_dax = pgmap->owner;
-	u64 offset = PFN_PHYS(pfn) - dev_dax->ranges[0].range.start;
+	u64 offset = fsdev_pfn_to_offset(dev_dax, pfn);
 	u64 len = nr_pages << PAGE_SHIFT;
 
 	return dax_holder_notify_failure(dev_dax->dax_dev, offset,
-- 
2.53.0



