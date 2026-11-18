Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795055637;
	b=o4HrUrTpgvZp6W+u3NpPazNwuaLZ06TqrmwEDnwURlnSr48vXTal9zerxmROt8G7eX3Y
	 6s+erwxRn5FcMis4Olyqm+AB/x+293aCD9ANS0+L9beWFmvIS4zzHw03udf4sDyZfdnNd
	 eg/h6Zkl+8PJP/AW/gm5KAjMRf2bdyZCF2qjAvOuRQrN4poDW5BJw/ANmDsSbHXyJbotd
	 QDlWm0JU7iWt2/fUaKrbxA61CLCf+OrFHYTDHoDnudv2m170qMxBWi77AM9plsgBxva0S
	 d4sSjdOZL8d+PbVyfOKkSOv+smqRqv0szfgaeM/b8LNSkbcvo/TuFTaxPkHeVws1Cwg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795055637;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=1HERqQKpnnzh8FhpQ2hxbu8qDLmeC7GaufEfMOurCdo=;
	b=HlJsbBBRITTOxIzTQ4sotVosKTjFR6Nl3p4Xc4ivjfQ0HV2j0YGM5CfOFMhRgp+E/Rzh
	 xIWd0VQ8GIEVOLhqcHurDER0un9rJ569tXt++YAuNweSF+uQ+Oxz5VtlZsyhjtRxDC+rH
	 4lpFB0sCXKXehwwSOmQ66mqCZT4Ji4MyUcBr/Osa81Cxd+N0qC8Uau2PJ4WC2LE7nIpwh
	 OFoP/nPNOOkZ6TC4MTXdpMFZ3Gix8q2GoYxuUR+/lNxyyhlv88bv55O1TN5WxCRJ24sc0
	 1tNl6hJir3valS5D8SSJj+EQgtGx4ldQYE8JvZmFYrA/i1ozooK3b/3j+fpTPdXHgyQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=d0zSP1FH;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E4C5D606A336;
	Thu, 19 Nov 2026 02:33:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=d0zSP1FH
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 04C1E1F000C4;
	Thu, 19 Nov 2026 02:33:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795055636;
	bh=1HERqQKpnnzh8FhpQ2hxbu8qDLmeC7GaufEfMOurCdo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=d0zSP1FH/61r33e47t9f7OI8v6RIMhBVXf6tASCOU3UC4NpF5t/XRJFhjpQ7ZwSGg
	 hmvMibE1KFQUfNCbAToL7j0/oJIHVjvGyhr+iL3ZwyXWm7HtrDwiqsMwPYOR4l4wS2
	 S2+KDNhA7cb7/vjHszcLCkxaTarloatREzokptng=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Hemanth Selam <hemanth.selam@gmail.com>,
	Dave Jiang <dave.jiang@intel.com>,
	Alison Schofield <alison.schofield@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 1702/2214] nvdimm/pmem: Release gendisk on probe failure
Date: Wed, 18 Nov 2026 15:56:18 +0100
Message-ID: <20261118150119.881754160@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150009.797899913@linuxfoundation.org>
References: <20261118150009.797899913@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Hemanth Selam <hemanth.selam@gmail.com>

[ Upstream commit 855a46681e0ba601952c346e5b62d867e51ecb23 ]

pmem_attach_disk() allocates the gendisk with blk_alloc_disk() and hands
it to devres only once device_add_disk() has succeeded.  Until that
point the probe path owns the disk itself, which is why every failure
after the allocation jumps to the out: label and puts it there.

The devm_init_badblocks() failure returns directly instead, so the disk
allocated a few lines earlier is never released.  Nothing releases it
afterwards either: the devres action that would have done so has not
been registered yet, so unbinding the namespace or destroying it does
not reach the disk, and it stays allocated along with its queue and its
bdev inode until the machine is rebooted.

devm_init_badblocks() only fails when a single page allocation fails, so
reaching this at all needs memory exhaustion during namespace probe, and
because device_add_disk() has not run there is nothing user visible left
behind: no device node, no sysfs entry, only the leaked memory.

Release the gendisk through the existing cleanup path on this failure.

Fixes: 3dd60fb9d95d ("nvdimm/pmem: stop using q_usage_count as external pgmap refcount")
Signed-off-by: Hemanth Selam <hemanth.selam@gmail.com>
Reviewed-by: Dave Jiang <dave.jiang@intel.com>
Link: https://patch.msgid.link/20260911082543.473670-1-hemanth.selam@gmail.com
Signed-off-by: Alison Schofield <alison.schofield@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/nvdimm/pmem.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/drivers/nvdimm/pmem.c b/drivers/nvdimm/pmem.c
index 2721dd2ead0a7..d96c24166d4d3 100644
--- a/drivers/nvdimm/pmem.c
+++ b/drivers/nvdimm/pmem.c
@@ -448,8 +448,10 @@ static int pmem_attach_disk(struct device *dev,
 	nvdimm_namespace_disk_name(ndns, disk->disk_name);
 	set_capacity(disk, (pmem->size - pmem->pfn_pad - pmem->data_offset)
 			/ 512);
-	if (devm_init_badblocks(dev, &pmem->bb))
-		return -ENOMEM;
+	if (devm_init_badblocks(dev, &pmem->bb)) {
+		rc = -ENOMEM;
+		goto out;
+	}
 	nvdimm_badblocks_populate(nd_region, &pmem->bb, &bb_range);
 	disk->bb = &pmem->bb;
 
-- 
2.53.0



