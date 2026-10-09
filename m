Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3E5C34E532A;
	Fri,  9 Oct 2026 14:49:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791557396; cv=none; b=t5BDNAdGBMLrQcvGI8GpuBUotwuXTWgqnQe6V6MCLM64V9mxTkBa3AiJoqJSXt1il0DDmwYKjVS5llwuYF4iatdWVCfMg9TRDLUt0E+ACQDj93YWcU2a4blYndIR8vFmGIQVwIq/GguILhi5jeTMA1LjT+H5a9rRbtTkwTTQopE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791557396; c=relaxed/simple;
	bh=2zfn/6hyyK6CWi6sBSpfSMC7RCUOgaQz1BPAnL4r35o=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Jjh6fodvHke3TsOLA2gzaqvY0K7Ja8w6LeIHfNZI1m3XP+e0KuDEgK6SjTilxLwhclLOcif4DWmzNeL+q4JupyhzZE5dcpKEoeQBTBoc90nYpLqHL30NhoXNFW7B7cGoyvc+ogg3TJNkUapd25BVPUJ/6fYJg7b21ZgA9qSbIbg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=HwnpEDSW; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="HwnpEDSW"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9D6BE1F000FF;
	Fri,  9 Oct 2026 14:49:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1791557395;
	bh=EKbHbqoPmPnsXW/1mLym+nDiQaUHgjGCLDX2U+Woud8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=HwnpEDSWLDcz4FC2Iti7W/0BrA70K2iGkDWseiwrlLFxMQqywN0D/KenZMTYyenLx
	 D1nZ1RuXBD8fT2SeDZ+QJhM0SZ6Fw3VtnFlyhH1DNLBXak2pGp27lL4vda5q2Beh4M
	 pKU19Vd5BvSAKuJHFQ5tbgY3KOG7DGpyzD4P9HeE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Guixin Liu <kanie@linux.alibaba.com>,
	Keith Busch <kbusch@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 358/403] nvme-multipath: set BLK_FEAT_ZONED only after the zone info is known
Date: Fri,  9 Oct 2026 16:11:59 +0200
Message-ID: <20261009141000.656151041@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261009140952.119038291@linuxfoundation.org>
References: <20261009140952.119038291@linuxfoundation.org>
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

From: Guixin Liu <kanie@linux.alibaba.com>

[ Upstream commit 4a5e49ba0abb8b4328d6318c9aef0c0121f95507 ]

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
[ sashal: Adjusted context for the feature list lacking BLK_FEAT_PCI_P2PDMA. ]
Signed-off-by: Sasha Levin <sashal@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/nvme/host/multipath.c |    2 --
 1 file changed, 2 deletions(-)

--- a/drivers/nvme/host/multipath.c
+++ b/drivers/nvme/host/multipath.c
@@ -754,8 +754,6 @@ int nvme_mpath_alloc_disk(struct nvme_ct
 	lim.dma_alignment = 3;
 	lim.features |= BLK_FEAT_IO_STAT | BLK_FEAT_NOWAIT |
 		BLK_FEAT_POLL | BLK_FEAT_ATOMIC_WRITES;
-	if (head->ids.csi == NVME_CSI_ZNS)
-		lim.features |= BLK_FEAT_ZONED;
 
 	head->disk = blk_alloc_disk(&lim, ctrl->numa_node);
 	if (IS_ERR(head->disk))


