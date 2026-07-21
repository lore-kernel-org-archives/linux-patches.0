Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3D0DF46EC9E;
	Tue, 21 Jul 2026 18:50:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784659806; cv=none; b=b3ytcgtSn4ZJ0B1m1J8WFWfikCPvGw775Ijl12ik2JMsP/Q8Xcgi6+Amdn5Ayx12ISzpsU7AHeObBIoTN2yFTpC2EnJuWcqP6aGRc5SOkYe0s9snExfUlGj8br89yYVsDBrN+fhFmpPjVoZGMay5/3iPZ/7dHNT+4XeI6WIb28M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784659806; c=relaxed/simple;
	bh=JIZmUsu6q+cGx+04X2o/uIMS6AfUppGMzwSeRcYdOoQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=iq7O2rYs8AywK6MmVIHLFSRNPcciQxQ4RMapTnbdIypj17xYINxZsyn/wfWkeCLxecSYODH4NijmNHfEuyIzaC6WA5ctMgRe1lPnMz9K39ALTzqlhxVK8Qe4RAh3MQ3Qssj+fX5ydh/nq9YA6sxlBG2a/+UdBPS24dd69DKD9yY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=VQCO9VQs; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="VQCO9VQs"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3C8F31F000E9;
	Tue, 21 Jul 2026 18:50:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784659804;
	bh=p/yFNP1kYTq9sh23lJAM0DiBC8P7RItHxXKrpB0S3OI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=VQCO9VQsiFsJdq6zUW6/ado88decUYeKYO1omjm8b2nWfOL901bsZl1moENmxqJWx
	 bOqgrhZ6ppSRpS30LHgzGp8xp0M9h38fiWz7FpiXmBhrvc0lt3KW5E+2CwlU6iqLlM
	 wfapcw8VR3prJKS6FXPV72KPySZ/xHecKnSWDFRg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Alison Schofield <alison.schofield@intel.com>,
	Li Ming <ming.li@zohomail.com>,
	Dave Jiang <dave.jiang@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.1 0733/2077] cxl/region: Fill first free targets[] slot during auto-discovery
Date: Tue, 21 Jul 2026 17:06:46 +0200
Message-ID: <20260721152610.086197357@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152552.646164743@linuxfoundation.org>
References: <20260721152552.646164743@linuxfoundation.org>
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

7.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Li Ming <ming.li@zohomail.com>

[ Upstream commit aa8a76711c15041ec1e42c3a74c15c2df0bd31f6 ]

Any invalid endpoint decoder pointer in the target array of an active
region is not allowed by cxl driver. This means cxl driver always
assumes the first p->nr_targets entries of the target array in an
auto-assembly region are valid. However, there are scenarios that could
leave NULL endpoint decoder pointer holes in the target array.

1. When cxl_cancel_auto_attach() removes an endpoint decoder from a
   target array, the target slot is set to NULL. If the removed endpoint
   decoder is not the last element in the target array, the target array
   will contain a NULL hole.

2. When a auto-assembly region removes an assigned endpoint decoder, if
   the removed endpoint decoder is not the last element in the target
   array, always remains a NULL hole in the target array.

When a NULL pointer hole exists in a region's target array, it
introduces two potential problems:
1. Access an endpoint decoder via a NULL pointer. it always trigger
   calltrace like that.
    Oops: general protection fault, probably for non-canonical address 0xdffffc0000000008: 0000 [#1] SMP KASAN PTI
    RIP: 0010:cxl_calc_interleave_pos+0x26/0x810 [cxl_core]
    Call Trace:
      <TASK>
      cxl_region_attach+0xc50/0x2140 [cxl_core]
      cxl_add_to_region+0x321/0x2330 [cxl_core]
      discover_region+0x92/0x150 [cxl_port]
      device_for_each_child+0xf3/0x170
      cxl_port_probe+0x150/0x200 [cxl_port]
      cxl_bus_probe+0x4f/0xa0 [cxl_core]
      really_probe+0x1c8/0x960
      __driver_probe_device+0x323/0x450
      driver_probe_device+0x45/0x120
      __device_attach_driver+0x15d/0x280
      bus_for_each_drv+0x10f/0x190

2. Not having enough valid endpoint decoders attached to an
   auto-assembly region. if an auto-assembly region is created with lock
   flag or assigned endpoint decoder with lock flag, which means
   assigned endpoint decoder will not be reset during detaching, they
   could re-attach to the auto-assembly region again. But cxl region
   driver relies on p->nr_targets to verify whether the required number
   of endpoint decoders has been attached, and NULL endpoint decoder
   pointers are still counted in that case.

To fix above issues, adjust cxl_region_attach_auto() logic to find the
first free target slot for endpoint decoder attachment, this ensures
NULL holes in the target array are filled, rather than adding new
endpoint decoders at the tail of the target array.

Fixes: 87805c32e6ad ("cxl/region: Fix use-after-free from auto assembly failure")
Fixes: 2230c4bdc412 ("cxl: Add handling of locked CXL decoder")
Suggested-by: Alison Schofield <alison.schofield@intel.com>
Signed-off-by: Li Ming <ming.li@zohomail.com>
Reviewed-by: Alison Schofield <alison.schofield@intel.com>
Link: https://patch.msgid.link/20260606-fix_two_issues_introduced_by_cxl_cancel_auto_attach-v1-2-5d94ca06c4e4@zohomail.com
Signed-off-by: Dave Jiang <dave.jiang@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/cxl/core/region.c | 15 ++++++++++++++-
 1 file changed, 14 insertions(+), 1 deletion(-)

diff --git a/drivers/cxl/core/region.c b/drivers/cxl/core/region.c
index 8956b049c4620c..174876e0475f1d 100644
--- a/drivers/cxl/core/region.c
+++ b/drivers/cxl/core/region.c
@@ -1848,8 +1848,21 @@ static int cxl_region_attach_auto(struct cxl_region *cxlr,
 	 * this means that userspace can view devices in the wrong position
 	 * before the region activates, and must be careful to understand when
 	 * it might be racing region autodiscovery.
+	 *
+	 * The endpoint decoder will be recorded into the first free slot of
+	 * the target array.
 	 */
-	pos = p->nr_targets;
+	for (pos = 0; pos < p->interleave_ways; pos++) {
+		if (!p->targets[pos])
+			break;
+	}
+
+	if (pos == p->interleave_ways) {
+		dev_err(&cxlr->dev, "%s: unable to find a free target slot\n",
+			dev_name(&cxled->cxld.dev));
+		return -ENXIO;
+	}
+
 	p->targets[pos] = cxled;
 	cxled->pos = pos;
 	cxled->state = CXL_DECODER_STATE_AUTO_STAGED;
-- 
2.53.0



