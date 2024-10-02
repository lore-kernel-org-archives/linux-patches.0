Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 489E81D1E6E;
	Wed,  2 Oct 2024 14:14:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727878476; cv=none; b=KesSsKdS65pl5okrXvI6alokkYhBuNb/kOYMSVsfIL1X43KSmY+K4fsjihAcTi/jlLOAGlJnoiEQQ6+oNotc0naP4L9F2w08U6l3WCWapNBW53Gt4ecpXUwanO8BMXcVAlD7b9DXhUz21t2ywCVlw56CiNhq00COCrRyDr/wCcY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727878476; c=relaxed/simple;
	bh=E3S0mun4hEKotrlZyJys5R8+pPYU86oAn1p+efhSmCs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ppX+ps5TwYytghTRGpKl9mhiwgxOKvm71dYghpEo0tx5cwSdGe6XVpNYDclOFs+F6Pv+a2X6YrlUoY4EvIwqe9DdCjm5U2ayZKl9C2Sc1UbLAVvbSAjdV9xgIozUShq24+qEKF1nC/qy3G2FqF1dUDI2OntKFY31NP40H2D/qx4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=rSXakabb; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="rSXakabb"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7B571C4CEC2;
	Wed,  2 Oct 2024 14:14:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1727878475;
	bh=E3S0mun4hEKotrlZyJys5R8+pPYU86oAn1p+efhSmCs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=rSXakabbyjBfvgK3UR9fcBpJVNrxDWGF6xOZbAoCzibf2PpSPzZbfBGNVJuIHNsTy
	 FF/x5m9Iygwc9CxZ8znpF00LednJolullD6WxI8Zco8usGcEu/DhGKHUtM6OatM7vD
	 TZAqj2yJALrFsh+eQ6zG9KRsUQoOU6daVBSGiGOw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mike Leach <mike.leach@linaro.org>,
	James Clark <james.clark@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Anshuman Khandual <anshuman.khandual@arm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.10 426/634] coresight: tmc: sg: Do not leak sg_table
Date: Wed,  2 Oct 2024 14:58:46 +0200
Message-ID: <20241002125827.917322422@linuxfoundation.org>
X-Mailer: git-send-email 2.46.2
In-Reply-To: <20241002125811.070689334@linuxfoundation.org>
References: <20241002125811.070689334@linuxfoundation.org>
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

6.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Suzuki K Poulose <suzuki.poulose@arm.com>

[ Upstream commit c58dc5a1f886f2fcc1133746d0cbaa1fe7fd44ff ]

Running perf with cs_etm on Juno triggers the following kmemleak warning !

:~# cat /sys/kernel/debug/kmemleak
 unreferenced object 0xffffff8806b6d720 (size 96):
 comm "perf", pid 562, jiffies 4297810960
 hex dump (first 32 bytes):
 38 d8 13 07 88 ff ff ff 00 d0 9e 85 c0 ff ff ff  8...............
 00 10 00 88 c0 ff ff ff 00 f0 ff f7 ff 00 00 00  ................
 backtrace (crc 1dbf6e00):
 [<ffffffc08107381c>] kmemleak_alloc+0xbc/0xd8
 [<ffffffc0802f9798>] kmalloc_trace_noprof+0x220/0x2e8
 [<ffffffc07bb71948>] tmc_alloc_sg_table+0x48/0x208 [coresight_tmc]
 [<ffffffc07bb71cbc>] tmc_etr_alloc_sg_buf+0xac/0x240 [coresight_tmc]
 [<ffffffc07bb72538>] tmc_alloc_etr_buf.constprop.0+0x1f0/0x260 [coresight_tmc]
 [<ffffffc07bb7280c>] alloc_etr_buf.constprop.0.isra.0+0x74/0xa8 [coresight_tmc]
 [<ffffffc07bb72950>] tmc_alloc_etr_buffer+0x110/0x260 [coresight_tmc]
 [<ffffffc07bb38afc>] etm_setup_aux+0x204/0x3b0 [coresight]
 [<ffffffc08025837c>] rb_alloc_aux+0x20c/0x318
 [<ffffffc08024dd84>] perf_mmap+0x2e4/0x7a0
 [<ffffffc0802cceb0>] mmap_region+0x3b0/0xa08
 [<ffffffc0802cd8a8>] do_mmap+0x3a0/0x500
 [<ffffffc080295328>] vm_mmap_pgoff+0x100/0x1d0
 [<ffffffc0802cadf8>] ksys_mmap_pgoff+0xb8/0x110
 [<ffffffc080020688>] __arm64_sys_mmap+0x38/0x58
 [<ffffffc080028fc0>] invoke_syscall.constprop.0+0x58/0x100

This due to the fact that we do not free the "sg_table" itself while
freeing up  the SG table and data pages. Fix this by freeing the sg_table
in tmc_free_sg_table().

Fixes: 99443ea19e8b ("coresight: Add generic TMC sg table framework")
Cc: Mike Leach <mike.leach@linaro.org>
Cc: James Clark <james.clark@arm.com>
Signed-off-by: Suzuki K Poulose <suzuki.poulose@arm.com>
Reviewed-by: Anshuman Khandual <anshuman.khandual@arm.com>
Link: https://lore.kernel.org/r/20240702132846.1677261-1-suzuki.poulose@arm.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/hwtracing/coresight/coresight-tmc-etr.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/hwtracing/coresight/coresight-tmc-etr.c b/drivers/hwtracing/coresight/coresight-tmc-etr.c
index e75428fa1592a..610ad51cda656 100644
--- a/drivers/hwtracing/coresight/coresight-tmc-etr.c
+++ b/drivers/hwtracing/coresight/coresight-tmc-etr.c
@@ -261,6 +261,7 @@ void tmc_free_sg_table(struct tmc_sg_table *sg_table)
 {
 	tmc_free_table_pages(sg_table);
 	tmc_free_data_pages(sg_table);
+	kfree(sg_table);
 }
 EXPORT_SYMBOL_GPL(tmc_free_sg_table);
 
@@ -342,7 +343,6 @@ struct tmc_sg_table *tmc_alloc_sg_table(struct device *dev,
 		rc = tmc_alloc_table_pages(sg_table);
 	if (rc) {
 		tmc_free_sg_table(sg_table);
-		kfree(sg_table);
 		return ERR_PTR(rc);
 	}
 
-- 
2.43.0



