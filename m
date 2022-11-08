Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E968215CAE
	for <patches@lists.linux.dev>; Tue,  8 Nov 2022 14:13:12 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 53FEAC433D6;
	Tue,  8 Nov 2022 14:13:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1667916792;
	bh=xchOmP2xv+3mv2Qx/+vqDP5ZWPUF9miybSB7npJONn8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=gf7E+7+L35bDgMoD3+jcHRM3BwNpVSXuAMJ4CTpZfVhzqieKUkcMCxegaDdFcr4tL
	 GTpgmwACEWKa3JiNHtNIXoRuzR38zw0Oo1MGxh0XaBynxyy+EQPUkVGiXp0tfIvquo
	 TBbCosSsL+EHmJFB7cebCyTy+OgawUrzgytWeY30=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Vishal Verma <vishal.l.verma@intel.com>,
	Dave Jiang <dave.jiang@intel.com>,
	Dan Williams <dan.j.williams@intel.com>
Subject: [PATCH 6.0 135/197] cxl/region: Fix region HPA ordering validation
Date: Tue,  8 Nov 2022 14:39:33 +0100
Message-Id: <20221108133401.078138700@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221108133354.787209461@linuxfoundation.org>
References: <20221108133354.787209461@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Dan Williams <dan.j.williams@intel.com>

commit a90accb358ae33ea982a35595573f7a045993f8b upstream.

Some regions may not have any address space allocated. Skip them when
validating HPA order otherwise a crash like the following may result:

 devm_cxl_add_region: cxl_acpi cxl_acpi.0: decoder3.4: created region9
 BUG: kernel NULL pointer dereference, address: 0000000000000000
 [..]
 RIP: 0010:store_targetN+0x655/0x1740 [cxl_core]
 [..]
 Call Trace:
  <TASK>
  kernfs_fop_write_iter+0x144/0x200
  vfs_write+0x24a/0x4d0
  ksys_write+0x69/0xf0
  do_syscall_64+0x3a/0x90

store_targetN+0x655/0x1740:
alloc_region_ref at drivers/cxl/core/region.c:676
(inlined by) cxl_port_attach_region at drivers/cxl/core/region.c:850
(inlined by) cxl_region_attach at drivers/cxl/core/region.c:1290
(inlined by) attach_target at drivers/cxl/core/region.c:1410
(inlined by) store_targetN at drivers/cxl/core/region.c:1453

Cc: <stable@vger.kernel.org>
Fixes: 384e624bb211 ("cxl/region: Attach endpoint decoders")
Reviewed-by: Vishal Verma <vishal.l.verma@intel.com>
Reviewed-by: Dave Jiang <dave.jiang@intel.com>
Link: https://lore.kernel.org/r/166752182461.947915.497032805239915067.stgit@dwillia2-xfh.jf.intel.com
Signed-off-by: Dan Williams <dan.j.williams@intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/cxl/core/region.c |    3 +++
 1 file changed, 3 insertions(+)

--- a/drivers/cxl/core/region.c
+++ b/drivers/cxl/core/region.c
@@ -657,6 +657,9 @@ static struct cxl_region_ref *alloc_regi
 	xa_for_each(&port->regions, index, iter) {
 		struct cxl_region_params *ip = &iter->region->params;
 
+		if (!ip->res)
+			continue;
+
 		if (ip->res->start > p->res->start) {
 			dev_dbg(&cxlr->dev,
 				"%s: HPA order violation %s:%pr vs %pr\n",


