Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 498884E433D;
	Fri,  9 Oct 2026 14:45:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791557102; cv=none; b=HtJpdj+4NE7E+DX/kDuPG/ZAbC5OEWqa6gqkrC8EAisGgUBQa2DXh3TNqHvZh3qWe2J3gtnc3dZLHLDzMGHdz/W8NRGyctHd+C9l/lU1Brr878gHmfVr5Dy82NK/1VbOkUJL0XwXCCdLftVTLRxynlgaUeQK0cYn8a1w8fDzSVo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791557102; c=relaxed/simple;
	bh=hFGbbmfRMq8O4AcJONJ99GciT3JB6bK2xHdkLICcPRo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=OXXbrzQpHsbnzWDYCb8YIzf5cOB/k27G/B9IYZEPiqe+BVu6pXgDI47jTgQ1y9kPGiWoIFYb4e1kzpOVl3FWf2ouPxi3CkMt/v3I9GG+1nbPF3a8/5hU81IQEnpy9QgbPyHw2wZs0r+9T27usTpAbUM/0LRnhVLkEuAwxHRqeGc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ztRi80DO; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ztRi80DO"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CD8331F000FF;
	Fri,  9 Oct 2026 14:45:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1791557101;
	bh=okAVppSNCKca5z/XDXVTJBB86tlsuYLAcH8TiCLdXaA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ztRi80DOZjxWc/3Mbg8zxMjQ4lWjq+/HBMo0V3DaHC289jhPXoJJBICxJEoDtErDy
	 oQucTBcplAN7Xf45UqH2Hoo8lTAZM7Qa1paZSrkQQZhfvp3EbfOxf/QrL1+NNVTOm4
	 zWPbb1Iqo50aoYhZDP0F9MwPFotSCswzxE8T/pmY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Guixin Liu <kanie@linux.alibaba.com>,
	Keith Busch <kbusch@kernel.org>
Subject: [PATCH 7.2 296/428] nvme-multipath: set BLK_FEAT_ZONED only after the zone info is known
Date: Fri,  9 Oct 2026 16:10:33 +0200
Message-ID: <20261009140952.613148993@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261009140946.008206689@linuxfoundation.org>
References: <20261009140946.008206689@linuxfoundation.org>
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

From: Guixin Liu <kanie@linux.alibaba.com>

commit 4a5e49ba0abb8b4328d6318c9aef0c0121f95507 upstream.

The namespace head is marked zoned at allocation time based only on the
command set identifier.  If the zone info query reports a zero zone size,
the path namespace is registered without zoned limits while the head
still advertises the zoned capability with a zone size of zero, and
reporting zones or writing to the head then shifts by ilog2(0).

Drop the zoned feature from the head allocation and let the head limits
refresh stack it in from the path namespace instead.

Fixes: 28982ad73d6a ("nvme: set BLK_FEAT_ZONED for ZNS multipath disks")
Fixes: 3838e80fcfb3 ("nvme: skip the zoned limits update if the zone info query failed")
Cc: stable@vger.kernel.org
Signed-off-by: Guixin Liu <kanie@linux.alibaba.com>
Signed-off-by: Keith Busch <kbusch@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/nvme/host/multipath.c |    2 --
 1 file changed, 2 deletions(-)

--- a/drivers/nvme/host/multipath.c
+++ b/drivers/nvme/host/multipath.c
@@ -737,8 +737,6 @@ int nvme_mpath_alloc_disk(struct nvme_ct
 	lim.dma_alignment = 3;
 	lim.features |= BLK_FEAT_IO_STAT | BLK_FEAT_NOWAIT |
 		BLK_FEAT_POLL | BLK_FEAT_ATOMIC_WRITES | BLK_FEAT_PCI_P2PDMA;
-	if (head->ids.csi == NVME_CSI_ZNS)
-		lim.features |= BLK_FEAT_ZONED;
 
 	head->disk = blk_alloc_disk(&lim, ctrl->numa_node);
 	if (IS_ERR(head->disk))


