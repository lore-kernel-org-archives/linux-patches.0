Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9E17412C544;
	Mon, 23 Dec 2024 16:16:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734970614; cv=none; b=NbPq7w9v6DKZ+00XcFEESB/3BoUvqc2G2vl3aKZR54FuxgsUvIey2r7FVQbeuihgfekOFt2L1FZpf9A+HdBdmLCoZ1tIbeQ45rycv7HXjtupzli0B1oEnyYWtJtqOC+3YrWDP9GKP/C2pbmFRYInGSh2NcwFoFdWGcEfw2IfOUc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734970614; c=relaxed/simple;
	bh=C4ZnlSo4TPSsm/nfR7+kIbzx394RKiX8SzDCGaE2dNo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=iMFc8xKEW9OSAEEuOZY7FMhGcGb/wDf2JSk0H4foTclfFV+Cv/BHo9MdB2AA1DQz1C/xbZAm7RtOhKjYJj4rYJf+G21I4K1lEgi94KxfkjJ/Mh99s1RDckvzMqQ6GBDI3/czK34R1nWndM2nb6Xa+Da0CuCLM9KOElqT+enX6eo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=w5+bBTHm; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="w5+bBTHm"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EC24FC4CED3;
	Mon, 23 Dec 2024 16:16:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1734970614;
	bh=C4ZnlSo4TPSsm/nfR7+kIbzx394RKiX8SzDCGaE2dNo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=w5+bBTHmEI5tdacAEvKrEZss2HXTDtQbtg+MCVMmHOg7mRmF5UoIX5De4gzNEPnuA
	 DU3fhfHJD7xbU2oGSZEfk0dQKdrTrcGjvsZL+s7txlsX+suQS5xk7WtFJy98xwZmRF
	 9VxgGztx6wAAfdqIPIZYUFwf/UVjL+4iZ5H6udFg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Huaisheng Ye <huaisheng.ye@intel.com>,
	Li Zhijian <lizhijian@fujitsu.com>,
	Dan Williams <dan.j.williams@intel.com>,
	Dave Jiang <dave.jiang@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 18/83] cxl/region: Fix region creation for greater than x2 switches
Date: Mon, 23 Dec 2024 16:58:57 +0100
Message-ID: <20241223155354.340023461@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241223155353.641267612@linuxfoundation.org>
References: <20241223155353.641267612@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Huaisheng Ye <huaisheng.ye@intel.com>

[ Upstream commit 76467a94810c2aa4dd3096903291ac6df30c399e ]

The cxl_port_setup_targets() algorithm fails to identify valid target list
ordering in the presence of 4-way and above switches resulting in
'cxl create-region' failures of the form:

  $ cxl create-region -d decoder0.0 -g 1024 -s 2G -t ram -w 8 -m mem4 mem1 mem6 mem3 mem2 mem5 mem7 mem0
  cxl region: create_region: region0: failed to set target7 to mem0
  cxl region: cmd_create_region: created 0 regions

  [kernel debug message]
  check_last_peer:1213: cxl region0: pci0000:0c:port1: cannot host mem6:decoder7.0 at 2
  bus_remove_device:574: bus: 'cxl': remove device region0

QEMU can create this failing topology:

                       ACPI0017:00 [root0]
                           |
                         HB_0 [port1]
                        /             \
                     RP_0             RP_1
                      |                 |
                USP [port2]           USP [port3]
            /    /    \    \        /   /    \    \
          DSP   DSP   DSP   DSP   DSP  DSP   DSP  DSP
           |     |     |     |     |    |     |    |
          mem4  mem6  mem2  mem7  mem1 mem3  mem5  mem0
 Pos:      0     2     4     6     1    3     5    7

 HB: Host Bridge
 RP: Root Port
 USP: Upstream Port
 DSP: Downstream Port

...with the following command steps:

$ qemu-system-x86_64 -machine q35,cxl=on,accel=tcg  \
        -smp cpus=8 \
        -m 8G \
        -hda /home/work/vm-images/centos-stream8-02.qcow2 \
        -object memory-backend-ram,size=4G,id=m0 \
        -object memory-backend-ram,size=4G,id=m1 \
        -object memory-backend-ram,size=2G,id=cxl-mem0 \
        -object memory-backend-ram,size=2G,id=cxl-mem1 \
        -object memory-backend-ram,size=2G,id=cxl-mem2 \
        -object memory-backend-ram,size=2G,id=cxl-mem3 \
        -object memory-backend-ram,size=2G,id=cxl-mem4 \
        -object memory-backend-ram,size=2G,id=cxl-mem5 \
        -object memory-backend-ram,size=2G,id=cxl-mem6 \
        -object memory-backend-ram,size=2G,id=cxl-mem7 \
        -numa node,memdev=m0,cpus=0-3,nodeid=0 \
        -numa node,memdev=m1,cpus=4-7,nodeid=1 \
        -netdev user,id=net0,hostfwd=tcp::2222-:22 \
        -device virtio-net-pci,netdev=net0 \
        -device pxb-cxl,bus_nr=12,bus=pcie.0,id=cxl.1 \
        -device cxl-rp,port=0,bus=cxl.1,id=root_port0,chassis=0,slot=0 \
        -device cxl-rp,port=1,bus=cxl.1,id=root_port1,chassis=0,slot=1 \
        -device cxl-upstream,bus=root_port0,id=us0 \
        -device cxl-downstream,port=0,bus=us0,id=swport0,chassis=0,slot=4 \
        -device cxl-type3,bus=swport0,volatile-memdev=cxl-mem0,id=cxl-vmem0 \
        -device cxl-downstream,port=1,bus=us0,id=swport1,chassis=0,slot=5 \
        -device cxl-type3,bus=swport1,volatile-memdev=cxl-mem1,id=cxl-vmem1 \
        -device cxl-downstream,port=2,bus=us0,id=swport2,chassis=0,slot=6 \
        -device cxl-type3,bus=swport2,volatile-memdev=cxl-mem2,id=cxl-vmem2 \
        -device cxl-downstream,port=3,bus=us0,id=swport3,chassis=0,slot=7 \
        -device cxl-type3,bus=swport3,volatile-memdev=cxl-mem3,id=cxl-vmem3 \
        -device cxl-upstream,bus=root_port1,id=us1 \
        -device cxl-downstream,port=4,bus=us1,id=swport4,chassis=0,slot=8 \
        -device cxl-type3,bus=swport4,volatile-memdev=cxl-mem4,id=cxl-vmem4 \
        -device cxl-downstream,port=5,bus=us1,id=swport5,chassis=0,slot=9 \
        -device cxl-type3,bus=swport5,volatile-memdev=cxl-mem5,id=cxl-vmem5 \
        -device cxl-downstream,port=6,bus=us1,id=swport6,chassis=0,slot=10 \
        -device cxl-type3,bus=swport6,volatile-memdev=cxl-mem6,id=cxl-vmem6 \
        -device cxl-downstream,port=7,bus=us1,id=swport7,chassis=0,slot=11 \
        -device cxl-type3,bus=swport7,volatile-memdev=cxl-mem7,id=cxl-vmem7 \
        -M cxl-fmw.0.targets.0=cxl.1,cxl-fmw.0.size=32G &

In Guest OS:
$ cxl create-region -d decoder0.0 -g 1024 -s 2G -t ram -w 8 -m mem4 mem1 mem6 mem3 mem2 mem5 mem7 mem0

Fix the method to calculate @distance by iterativeley multiplying the
number of targets per switch port. This also follows the algorithm
recommended here [1].

Fixes: 27b3f8d13830 ("cxl/region: Program target lists")
Link: http://lore.kernel.org/6538824b52349_7258329466@dwillia2-xfh.jf.intel.com.notmuch [1]
Signed-off-by: Huaisheng Ye <huaisheng.ye@intel.com>
Tested-by: Li Zhijian <lizhijian@fujitsu.com>
[djbw: add a comment explaining 'distance']
Signed-off-by: Dan Williams <dan.j.williams@intel.com>
Link: https://patch.msgid.link/173378716722.1270362.9546805175813426729.stgit@dwillia2-xfh.jf.intel.com
Signed-off-by: Dave Jiang <dave.jiang@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/cxl/core/region.c | 25 ++++++++++++++++++-------
 1 file changed, 18 insertions(+), 7 deletions(-)

diff --git a/drivers/cxl/core/region.c b/drivers/cxl/core/region.c
index 5b7d848a6f01..0e03c4908050 100644
--- a/drivers/cxl/core/region.c
+++ b/drivers/cxl/core/region.c
@@ -974,6 +974,7 @@ static int cxl_port_setup_targets(struct cxl_port *port,
 	struct cxl_region_params *p = &cxlr->params;
 	struct cxl_decoder *cxld = cxl_rr->decoder;
 	struct cxl_switch_decoder *cxlsd;
+	struct cxl_port *iter = port;
 	u16 eig, peig;
 	u8 eiw, peiw;
 
@@ -990,16 +991,26 @@ static int cxl_port_setup_targets(struct cxl_port *port,
 
 	cxlsd = to_cxl_switch_decoder(&cxld->dev);
 	if (cxl_rr->nr_targets_set) {
-		int i, distance;
+		int i, distance = 1;
+		struct cxl_region_ref *cxl_rr_iter;
 
 		/*
-		 * Passthrough decoders impose no distance requirements between
-		 * peers
+		 * The "distance" between peer downstream ports represents which
+		 * endpoint positions in the region interleave a given port can
+		 * host.
+		 *
+		 * For example, at the root of a hierarchy the distance is
+		 * always 1 as every index targets a different host-bridge. At
+		 * each subsequent switch level those ports map every Nth region
+		 * position where N is the width of the switch == distance.
 		 */
-		if (cxl_rr->nr_targets == 1)
-			distance = 0;
-		else
-			distance = p->nr_targets / cxl_rr->nr_targets;
+		do {
+			cxl_rr_iter = cxl_rr_load(iter, cxlr);
+			distance *= cxl_rr_iter->nr_targets;
+			iter = to_cxl_port(iter->dev.parent);
+		} while (!is_cxl_root(iter));
+		distance *= cxlrd->cxlsd.cxld.interleave_ways;
+
 		for (i = 0; i < cxl_rr->nr_targets_set; i++)
 			if (ep->dport == cxlsd->target[i]) {
 				rc = check_last_peer(cxled, ep, cxl_rr,
-- 
2.39.5



